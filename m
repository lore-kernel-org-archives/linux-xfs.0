Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8L7FdcJ183968 for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 02:15:39 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id B3uFLi0CDBnxEwOP
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 21 Sep 2012 00:16:52 -0700 (PDT)
Received: by pbbrp16 with SMTP id rp16so7879903pbb.26
	for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 00:16:51 -0700 (PDT)
Date: Fri, 21 Sep 2012 12:46:44 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re: Re: [PATCH 3/3] XFS: Print error when unable to allocate inodes
	or out of free inodes.
Message-ID: <20120921071644.GA20650@Archie>
References: <cover.1347396641.git.rprabhu@wnohang.net>
	<93d9b37ce9ad720e14e2f9311e623a8e3e3139f5.1347396641.git.rprabhu@wnohang.net>
	<20120911232144.GH11511@dastard>
MIME-Version: 1.0
In-Reply-To: <20120911232144.GH11511@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8737285214134156598=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com


--===============8737285214134156598==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


* On Wed, Sep 12, 2012 at 09:21:44AM +1000, Dave Chinner <david@fromorbit.c=
om> wrote:
>On Wed, Sep 12, 2012 at 03:43:24AM +0530, raghu.prabhu13@gmail.com wrote:
>> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
>>
>> When xfs_dialloc is unable to allocate required number of inodes or ther=
e are no
>> AGs with free inodes, printk the error in ratelimited manner.
>>
>> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>> ---
>>  fs/xfs/xfs_ialloc.c | 19 +++++++++++++++----
>>  1 file changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
>> index e75a39d..034131b 100644
>> --- a/fs/xfs/xfs_ialloc.c
>> +++ b/fs/xfs/xfs_ialloc.c
>> @@ -990,8 +990,11 @@ xfs_dialloc(
>>  				goto out_error;
>>
>>  			xfs_perag_put(pag);
>> -			*inop =3D NULLFSINO;
>> -			return 0;
>> +
>> +			xfs_err_ratelimited(mp,
>> +				"Unable to allocate inodes in AG %d: Required %d, Current %llu, Max=
imum %llu",
>> +				agno, XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
>> +			goto out_spc;
>
>This changes the error to be returned from 0 to ENOSPC. Adding error
>messages shouldn't change the logic of the code.

1) Yes, there is a confusion regarding that. =20

>
>Also, you might want tolook at how ENOSPC is returned from
>xfs_ialloc_ag_alloc(). it only occurs when:
>
>	if (mp->m_maxicount &&
>            mp->m_sb.sb_icount + newlen > mp->m_maxicount) {
>
>i.e. it is exactly the same error case as the "noroom" error below.
>It has nothing to do with being unable to allocate inodes in the
>specific AG - the global inode count is too high. IOWs, the error
>message is not correct.

Now, in xfs_dialloc=20


	if (mp->m_maxicount &&
	    mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
		noroom =3D 1;
		okalloc =3D 0;
	}

why does it not make sense to bail out with ENOSPC then itself? I=20
mean, what is the point of the loop when there is no room=20
(noroom=3D1) and no allocations are allowed (okalloc =3D 0), also=20
since the xfs_ialloc_ag_alloc in the loop uses same global logic=20
to return.



>
>Also, 80 columns.
>
>>  		}
>>
>>  		if (ialloced) {
>> @@ -1016,11 +1019,19 @@ nextag:
>>  		if (++agno =3D=3D mp->m_sb.sb_agcount)
>>  			agno =3D 0;
>>  		if (agno =3D=3D start_agno) {
>> -			*inop =3D NULLFSINO;
>> -			return noroom ? ENOSPC : 0;
>> +			if (noroom) {
>> +				xfs_err_ratelimited(mp,
>> +					"Out of AGs with free inodes: Required %d, Current %llu, Maximum %=
llu",
>> +					 XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
>
>The error message here is misleading - the error is that we've
>exceeded the maximum inode count for the filesystem (same as the
>above error message case), so no further allocations are allowed.
>
>What about the !noroom case? Isn't that a real ENOSPC condition?
>i.e. we've tried to allocate inodes in every AG and yet we've failed
>in all of them because there is no aligned, contiguous free space in
>any of the AGs. Shouldn't that emit an appropriate warning?

The warning is already emitted in call to xfs_ialloc_ag_select.=20

Now, what does inop =3D NULLFSINO, noroom =3D 0 and return value of 0 mean,=
=20

=66rom the call chain of xfs_dir_ialloc -> xfs_ialloc ->=20
xfs_dialloc=20

I see that, it is a true ENOSPC only if both the buffer pointed=20
by ialloc_context and the inode are NULL or there is an error=20
returned, in former case (noroom=3D0)  xfs_dir_ialloc retries the=20
allocation (ie.  when AGI buffer is non-NULL).

Now, in case of global inode exhaustion, it is hard error which=20
can be fixed only by remounting with inode64 and nothing else=20
will do, hence, I think ENOSPC must be returned as error instead=20
of 0. (also in case of point #1 above)

So, are the assumptions made above correct?

>
>> +				goto out_spc;
>> +			}
>> +			return 0;
>>  		}
>>  	}
>>
>> +out_spc:
>> +	*inop =3D NULLFSINO;
>> +	return ENOSPC;
>>  out_alloc:
>>  	*IO_agbp =3D NULL;
>>  	return xfs_dialloc_ag(tp, agbp, parent, inop);
>
>Default behaviour on a loop break is to allocate inodes, not return
>ENOSPC.
>
>BTW, there's no need to cc LKML for XFS specific patches. LKML is
>noisy enough as it is without unnecessary cross-posts....
>
>Cheers,
>
>Dave.
>--=20
>Dave Chinner
>david@fromorbit.com
>




Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJQXBRcAAoJEKYW3KHXK+l3tWgIALJwOy5vXU8YC8r9K4cfuHVQ
KtDNVgEYI/gbEHNhSzl21KuYvQes4fE1qwH/orx+IvSv7zZJDvRBVBVrPeQaL0UE
Tlz5PASy8sqv/OvaoBhq/JpUzNw5vDMFbc8x4k0FPzqg7dmvVWQPi04m/a8Gkb4H
4n1pTCKK1T/s2TOwuqMyI/CCjaCUz1Jpvup55B3aD+CZxHdDnEmwrpQgmh/e2kmq
SywZTEwzxgnhX8YwvRzpq+WMSnj30ISAKA4eBTSi7ifpYXlJj5CEjX5ELc2WXYul
wOhk13n2oiYP8OQAfx6NH/tdl864oYvo4XSdwi9t1TMNBlDApy1N22mF8LHXBd8=
=EAyN
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--


--===============8737285214134156598==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8737285214134156598==--
