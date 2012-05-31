Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4VJaPiS067169 for <xfs@oss.sgi.com>; Thu, 31 May 2012 14:36:26 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id fmAOeDB9NNU3veGY
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 May 2012 12:36:24 -0700 (PDT)
Received: by dadg9 with SMTP id g9so2101801dad.26
	for <xfs@oss.sgi.com>; Thu, 31 May 2012 12:36:23 -0700 (PDT)
Date: Fri, 1 Jun 2012 01:06:16 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re:  Re: [PATCH] Printk for ENOSPC due to lack of inodes
Message-ID: <20120531193616.GA3953@Xye.local>
References: <20120227003733.GA28162@Xye>
 <4F579D4C.4040208@sandeen.net>
MIME-Version: 1.0
In-Reply-To: <4F579D4C.4040208@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2409576007291185784=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


--===============2409576007291185784==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for the review. I have now moved it inside xfs_dialloc.=20
Along with adding the message, I noticed that the loop=20


	while (!agi->agi_freecount) {
	}

is redundant when noroom=3D1 and okalloc=3D0.

Also, xfs_ialloc_ag_alloc function in the loop calls =20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
	if (mp->m_maxicount &&
	    mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

condition again.

So I have moved xfs_tran_brelse etc. into the condition along=20
with message.

Is this logic valid? If it is, then I will look into=20
rate-limiting the message etc.=20

* On Wed, Mar 07, 2012 at 11:39:24AM -0600, Eric Sandeen <sandeen@sandeen.n=
et> wrote:
>On 2/26/12 6:37 PM, Raghavendra D Prabhu wrote:
>> Hi,
>>
>> While diagnosing a MySQL crash (on a Centos 5.7 box), I noticed that
>> it had failed with ENOSPC earlier; it was rebooted after that; now
>> after reboot, even though space was there, ENOSPC was showing up, I
>> also did df -i and it showed inodes available. At this point,
>> mounting with inode64 option was tried, which fixed it.
>> http://oss.sgi.com/archives/xfs/2011-03/msg00299.html helped me
>> here.
>
>Yeah, that's kind of a bummer.  And given the semi-ugly situation
>we're in with inode32, maybe a syslog message would be good.
>
>But a few things; I don't think we want to warn on every inode-allocation
>ENOSPC.  Ideally I'd probably do a WARN_ON_ONCE or a ratelimited printk.
>xfs_warn_once_per_fs()?  :)
>
>I'd probably also want to only do it in the case where the ENOSPC was due
>to either inode32, or due to fragmented freespace.
>
>Without looking very hard yet; could this be done in xfs_dialloc() so that
>the exact reason for the ENOSPC can be issued?  (maxicount, inode32, or
>no free contiguous space...)
>
>-Eric
>
>>
>> So, I have attached a patch here.
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>
>> When a ENOSPC is encountered and it is due to lack of inodes (particular=
ly
>> without inode64), it is not possible to detect this (df -i doesn't help =
here),
>> so adding a printk which can aid in detecting this.
>>
>> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>> ---
>>  fs/xfs/xfs_qm.c       |    3 +++
>>  fs/xfs/xfs_vnodeops.c |   10 ++++++++--
>>  2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
>> index c872fea..fbefa87 100644
>> --- a/fs/xfs/xfs_qm.c
>> +++ b/fs/xfs/xfs_qm.c
>> @@ -987,6 +987,9 @@ xfs_qm_qino_alloc(
>>
>>      error =3D xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip, &commi=
tted);
>>      if (error) {
>> +        if (error =3D=3D ENOSPC)
>> +            xfs_err(mp, "Out of inodes: Required %d, Current %llu, Maxi=
mum %llu",
>> +                    XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_ma=
xicount);
>>          xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
>>                   XFS_TRANS_ABORT);
>>          return error;
>> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
>> index ebdb888..7542c36 100644
>> --- a/fs/xfs/xfs_vnodeops.c
>> +++ b/fs/xfs/xfs_vnodeops.c
>> @@ -946,8 +946,11 @@ xfs_create(
>>      error =3D xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev,
>>                     prid, resblks > 0, &ip, &committed);
>>      if (error) {
>> -        if (error =3D=3D ENOSPC)
>> +        if (error =3D=3D ENOSPC) {
>> +            xfs_err(mp, "Out of inodes: Required %d, Current %llu, Maxi=
mum %llu",
>> +                    XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_ma=
xicount);
>>              goto out_trans_cancel;
>> +        }
>>          goto out_trans_abort;
>>      }
>>
>> @@ -1610,8 +1613,11 @@ xfs_symlink(
>>      error =3D xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
>>                     prid, resblks > 0, &ip, NULL);
>>      if (error) {
>> -        if (error =3D=3D ENOSPC)
>> +        if (error =3D=3D ENOSPC) {
>> +            xfs_err(mp, "Out of inodes: Required %d, Current %llu, Maxi=
mum %llu",
>> +                    XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_ma=
xicount);
>>              goto error_return;
>> +        }
>>          goto error1;
>>      }
>>
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
>_______________________________________________
>xfs mailing list
>xfs@oss.sgi.com
>http://oss.sgi.com/mailman/listinfo/xfs
>




Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPx8gwAAoJEKYW3KHXK+l3iIYH/3dkwkjDnRz+CIdxWqugB70Y
NUtw8rexJ7sCtjhTnu1Pxe9Q+6UG2IH0THhiJqTe52dPd63IxFl4ogRTMXWhwfPp
omZ6a0EeDTAO3VdZP6xgwqmZsP0kNoxUua6X8UvYQbaEs88B2Y6gIzTGx4OBVdze
H0Iy1daAkgO+mpSjx3+cfaIqG+uvSL3wnIq4+1Cp5AKml6azngqegeKfOA8FMGqD
BJ52Da/WedC8d4nA1031vTq2qUteuM+kt08/X0E7TNpDIIXdYD7eCZdI972l+9jG
ZgOJfS+NB5QSICKKugq1WlLxIJFYnFR/xEVgaPFWzXxkE6t7ot/0izqsWnwKJQA=
=9rbm
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--


--===============2409576007291185784==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2409576007291185784==--
