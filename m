Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8F2GMsN253757 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 21:16:22 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id YzfoWDNZL9PRiEB3
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 14 Sep 2012 19:17:29 -0700 (PDT)
Received: by dadg9 with SMTP id g9so3980436dad.26
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 19:17:28 -0700 (PDT)
Date: Sat, 15 Sep 2012 07:47:23 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re:  Re: [PATCH v5] Stop xfs_do_force_shutdown / messages fron
	xfs_log_force if filesystem is already shutdown.
Message-ID: <20120915021723.GA58426@Archie.local>
References: <76577fa31ab2aa750994c1bc6a1b6f44beb03116.1347002369.git.rprabhu@wnohang.net>
	<20120911210512.GE11511@dastard>
MIME-Version: 1.0
In-Reply-To: <20120911210512.GE11511@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4056814384227440089=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============4056814384227440089==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


* On Wed, Sep 12, 2012 at 07:05:12AM +1000, Dave Chinner <david@fromorbit.c=
om> wrote:
>On Sat, Sep 08, 2012 at 03:28:11AM +0530, raghu.prabhu13@gmail.com wrote:
>> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
=2E....
=2E...
=2E..

>>
>> Version 1: Removed calling xfs_syncd_stop from xfs_sync_worker.
>> Version 2: Removed calling xfs_fs_writable in xfs_sync_worker and xfs_fl=
ush_worker.
>> Version 3: Removed calling xfs_syncd_stop in xfs_bwrite.
>> Version 4: Added return statements to xfs_log_force and xfs_fs_sync_fs.
>> Version 5: As per suggestion, added xfs_warn to xfs_fs_sync_fs and remov=
ed EIO
>> return in xfs_log_force
>>
>>  Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>>  Tested-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>
>Signed-off-by implies you tested it. Tested-by is used to
>acknowledge third party testers, usually in the case to acknowledge
>the fix was Tested-by the Reported-by...
Sorry about that, I meant to add only the Signed-off part.

>
>And the signed-off-by belongs in the commit message (i.e. about the
>first ---) not in the section after the commit message that is
>stripped by the git tools.

I will fix that.

>
>> ---
>>  fs/xfs/xfs_log.c   | 5 ++++-
>>  fs/xfs/xfs_super.c | 5 +++++
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 7f4f937..161c925 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -3002,7 +3002,10 @@ xfs_log_force(
>>
>>  	trace_xfs_log_force(mp, 0);
>>  	error =3D _xfs_log_force(mp, flags, NULL);
>> -	if (error)
>> +	/*
>> +	 * Avoid warning when the filesystem has already shutdown.
>> +	 */
>> +	if (error && !XFS_FORCED_SHUTDOWN(mp))
>>  		xfs_warn(mp, "%s: error %d returned.", __func__, error);
>>  }
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index bdaf4cb..ebafc99 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -943,6 +943,11 @@ xfs_fs_sync_fs(
>>  	if (!wait)
>>  		return 0;
>>
>> +	if (XFS_FORCED_SHUTDOWN(mp)) {
>> +		xfs_warn(mp, "Sync called: filesystem already shutdown");
>> +		return XFS_ERROR(EIO);
>> +	}
>
>Why should we emit a warning here? There's already information in the
>log to indicate the filesystem is shut down...

Actually in a previous review, you had suggested to add=20
information about it since 'sync' is called manually/less=20
often, so better to have more verbosity about it and user gets=20
feedback on it. So, is this fine?

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

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJQU+UzAAoJEKYW3KHXK+l3Gz0H/1NTy3T5VE1LEcJC9n5aLqXU
2Om+wg9ogw8yJFOSTRStOj3G758yheQk3ldQs0PS5OxHN0oZvmRdpDjSZJmAK8we
jG+uZ8de6BdrfkiHvvYkd9r58AEqUz4EyI3r54mzQYG36UOhzbl1ayK9o59ITmQQ
WynYywVqkc09/xcAvltmHaHLtCSchrlpEaRZfi1rSjjw1NUXoxP9uz9pDNo7HRC1
syWSXXvlPazM8vVkkgWbvFAwzWenwnerlb0EGDpPNtsO3DDpOo0shzkINt3P6JsB
DH5CrmDgJeqfcJOzC/258kp42GZyygGdEOejcCuQe5iQ5B6KyVA7vgRpB44p+TY=
=vbE/
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--


--===============4056814384227440089==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4056814384227440089==--
