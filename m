Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q49K7uXH125482 for <xfs@oss.sgi.com>; Wed, 9 May 2012 15:07:56 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id MrQMjw04Q4RP806B
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 May 2012 13:07:55 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so1088829pbb.26
	for <xfs@oss.sgi.com>; Wed, 09 May 2012 13:07:55 -0700 (PDT)
Date: Thu, 10 May 2012 01:37:46 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re:  Re: [PATCH] [PATCH] Stop periodic syncing if filesystem is
	already shutdown.
Message-ID: <20120509200746.GA29360@Xye>
References: <a27cbce4f4b35c2a8aee1b58d88c22381fe70ccf.1336378182.git.rprabhu@wnohang.net>
	<20120507235321.GD5091@dastard>
MIME-Version: 1.0
In-Reply-To: <20120507235321.GD5091@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1189179857829327103=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============1189179857829327103==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=20
Hi,


* On Tue, May 08, 2012 at 09:53:21AM +1000, Dave Chinner <david@fromorbit.c=
om> wrote:
>On Mon, May 07, 2012 at 02:44:07PM +0530, raghu.prabhu13@gmail.com wrote:
>> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
>>
>> This is to prevent syncing from running ad-infinitum till umount if the =
disk has been forcefully unplugged.
>>
>> This is to prevent messages like these from being displayed.
>.....
>> ---
>>  fs/xfs/xfs_sync.c |   12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
>> index 205ebcb..7ec412c 100644
>> --- a/fs/xfs/xfs_sync.c
>> +++ b/fs/xfs/xfs_sync.c
>> @@ -460,6 +460,12 @@ xfs_sync_worker(
>>  					struct xfs_mount, m_sync_work);
>>  	int		error;
>>
>> +	if (!xfs_fs_writable(mp)) {
>> +		xfs_err(mp, "Filesystem not writable / already shutdown.");
>> +		xfs_syncd_stop(mp);
>> +		return;
>> +	}
>> +
>
>That is going to kill the xfssyncd on read only and frozen
>filesystems as well as shutdowns, so this is certainly not correct.
>The xfs_sync_worker should continue to run until the filesystem is
>unmounted, even if it does nothing when it runs.

Yes, in the next patch I had sent --=20
http://article.gmane.org/gmane.comp.file-systems.xfs.general/45568=20
-- I removed xfs_syncd_stop from there and added it under=20
xfs_bwrite.=20

(PS: Adding xfs_syncd_stop in xfs_sync_worker was a very=20
bad decision - it sent few of my kworkers to 'D' state and nearly=20
corrupted that fs)


>
>Indeed, all that is needed in xfs_sync_worker() is this:
>
>-	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
>+	if (!xfs_fs_writable(mp)) {
>
>and the error message won't appear. It fixes the problem for the
>shutdown case, as well as handles frozen and read-only filesystems
>correctly.
        =20
         I realized from your earlier comment that, calling=20
         xfs_syncd_stop under xfs_bwrite won't be good either;
         so I was thinking of just checking for=20

         XFS_FORCED_SHUTDOWN(mp) in xfs_log_force and bailing out=20
         if already shutdown.

         which should take care of xfs_sync_worker,=20
         xfs_flush_worker, xfs_iflush and xfs_unmountfs


     Does this sound good?

>
>>  		/* dgc: errors ignored here */
>>  		if (mp->m_super->s_frozen =3D=3D SB_UNFROZEN &&
>> @@ -551,6 +557,12 @@ xfs_flush_worker(
>>  	struct xfs_mount *mp =3D container_of(work,
>>  					struct xfs_mount, m_flush_work);
>>
>> +	if (!xfs_fs_writable(mp)) {
>> +		xfs_err(mp, "Filesystem not writable / already shutdown.");
>> +		xfs_syncd_stop(mp);
>> +		return;
>> +	}
>> +
>>  	xfs_sync_data(mp, SYNC_TRYLOCK);
>>  	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
>
>This is not necessary, either, because xfs_sync_data() has shutdown
>checks and xfs_flush_worker() should never be called on a shutdown
>filesystem....
Yeah, I realized that (sent a patch after this=20
http://article.gmane.org/gmane.comp.file-systems.xfs.general/45568).
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

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPqs6SAAoJEKYW3KHXK+l3peQH/A6T/EvBHu/KyrMAFboe1m6F
SkwgZEWJfQbyVyTbp+jMzRfcZJQnb78vpuAF0RlG0CEJO4OD+uJ8lyyBjw21umwn
C5uzkEr1r7gikTK+e+DwdFdumaPbS+Ptr88/KvFa+c5syw+cbcL+NaTUJOZkuY+X
h2mL0dRWhmMnpMEuLxgv7P9Dnw7lWGiGMoHHSwMcTo9x+sZ/hnlSKis8eSDp9kWu
0sf3SQ9gRqG2kdquv0o04x0AP6VzY8CLwMBm1QFbKpTTOUcZ44oxLDRUyo4GPfan
dm/9BDrvSxj8m7lCVgwrrSAjjBA9l8qEygkhjE0E45jRyHiPOgfg0gk+L/Dj43U=
=8uwp
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--


--===============1189179857829327103==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1189179857829327103==--
