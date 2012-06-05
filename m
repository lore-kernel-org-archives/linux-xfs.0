Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q556Z5T0050950 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 01:35:06 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id dXUcIdCCZnjJR8Zp
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jun 2012 23:35:04 -0700 (PDT)
Received: by dadg9 with SMTP id g9so8683453dad.26
	for <xfs@oss.sgi.com>; Mon, 04 Jun 2012 23:35:03 -0700 (PDT)
Date: Tue, 5 Jun 2012 12:04:57 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re:  Re: [PATCH v4] Stop periodic syncing if filesystem is already
	shutdown.
Message-ID: <20120605063457.GA1758@Xye.local>
References: <d585aa328fc296e20bd3a180c2c3dbc4c77c45df.1338487073.git.rprabhu@wnohang.net>
	<20120605060617.GG4347@dastard>
MIME-Version: 1.0
In-Reply-To: <20120605060617.GG4347@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9043969743192732446=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============9043969743192732446==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


* On Tue, Jun 05, 2012 at 04:06:17PM +1000, Dave Chinner <david@fromorbit.c=
om> wrote:
>On Thu, May 31, 2012 at 11:37:34PM +0530, raghu.prabhu13@gmail.com wrote:
>> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
>>
>> This is to prevent xfs_log_force from running ad-infinitum (due to xfs_s=
ync)
>> till umount if the disk has been forcefully unplugged.
>
>I'm not sure where versions 2 and 3 went - I haven't seen them....

Actually I hadn't numbered them, but they are here http://oss.sgi.com/archi=
ves/xfs/2012-05/msg00065.html (starting from that thread). Sorry for that.

>
>>
>> This is also to prevent messages like these from being displayed repeate=
dly.
>>
>> [ 3873.009329] XFS (sdb3): xfs_log_force: error 5 returned.
>>
>> Note, that even after xfs_do_force_shutdown has been called, xfs_log_for=
ce
>> doesn't stop till the filesystem has been unmounted (and it keeps printi=
ng
>> "error 5 returned" to kernel log).
>>
>> To fix it, added return statements to xfs_log_force and xfs_fs_sync_fs i=
f the
>> filesystem is already shutdown -- based on XFS_FORCED_SHUTDOWN.
>>
>> To simulate it, mount an xfs filesystem located on external disk, and th=
en pull
>> the power to the disk.
>>
>> Tested it on latest linus tree.
>>
>> Now, the dmesg looks,
>>
>> [  268.307303] XFS (sdb2): xfs_do_force_shutdown(0x1) called from line 1=
031 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
>> [  268.307318] XFS (sdb2): I/O Error Detected. Shutting down filesystem
>> [  268.307323] XFS (sdb2): Please umount the filesystem and rectify the =
problem(s)
>>
>> ---
>>
>> Version 1: Removed calling xfs_syncd_stop from xfs_sync_worker.
>> Version 2: Removed calling xfs_fs_writable in xfs_sync_worker and xfs_fl=
ush_worker.
>> Version 3: Removed calling xfs_syncd_stop in xfs_bwrite.
>> Version 4: Added return statements to xfs_log_force and xfs_fs_sync_fs.
>>
>> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>> Tested-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>>   ---
>> ---
>>  fs/xfs/xfs_log.c   |    7 +++++++
>>  fs/xfs/xfs_super.c |    7 +++++++
>>  2 files changed, 14 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 6db1fef..e4192b2 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -2932,6 +2932,13 @@ xfs_log_force(
>>  {
>>  	int	error;
>>
>> +	/*
>> +	 * No need to printk here since xfs_bwrite already printks about xfs
>> +	 * shutdown if it has shutdown already.
>> +	 */
>> +	if (XFS_FORCED_SHUTDOWN(mp))
>> +		return;
>> +
>>  	error =3D _xfs_log_force(mp, flags, NULL);
>>  	if (error)
>>  		xfs_warn(mp, "%s: error %d returned.", __func__, error);
>
>I don't think this is the right place for the check. Depending on
>the type of error that caused the shutdown, the log may still be
>functioning and we need to be able to force the log so we don't lose
>all the changes in memory. The internal log implementation has all
>the checks necessary to avoid writing to the log if the log has
>already been shut down, which is why you keep seeing the error
>message.
I went through the function now and noticed a couple of EIOs=20
returned, makes sense.
>
>What it appears to me is that you want to stop the error message
>from being emitted when the log is shut down. The way to do that is
>this:
>
> 	error =3D _xfs_log_force(mp, flags, NULL);
>-	if (error)
>+	if (error && !XFS_FORCED_SHUTDOWN(mp))
> 		xfs_warn(mp, "%s: error %d returned.", __func__, error);
>
>Rather than avoining calling _xfs_log_force() altogether.
Yes, this should do.
>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index dab9a5f..b0f6041 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1010,6 +1010,13 @@ xfs_fs_sync_fs(
>>  	int			error;
>>
>>  	/*
>> +	 * No need to printk here since xfs_bwrite already printks about xfs
>> +	 * shutdown if it has shutdown already.
>> +	 */
>> +	if (XFS_FORCED_SHUTDOWN(mp))
>> +		return XFS_ERROR(EIO);
>
>
>I think if someone runs sync or calls syncfs() we should emit an
>error message indicating that it failed. We can't return an error to
>sync(), so we are limited to writing to the syslog.  This is not
>called periodically, so I don't see any problem with emitting an
>error message here. Being verbose in error states is desirable - you
>can never have too much information in the logs when something goes
>wrong....
Thanks, I look into this.

>
>Cheers,
>
>Dave.
>--=20
>Dave Chinner
>david@fromorbit.com
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

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPzaiRAAoJEKYW3KHXK+l33PIH/16Dvls53VF0NQw4CrZT5/MM
366G5C798PJnLzG9KDCGY8zM96q1MWD7YR6vviXL0xYAbLDSAGB01Q2kgU3C5npK
aF5TS7mIIy+GHq/yBfVe6UMH5txCxFi+jnxdTtMq1XwgLF79S+PyiQE5ywFZJA0J
begncBV7iTqu10TPP41qMB17C4yF3l8htVtQrihYLC48+AkL9jwaVDA88Xgcbapz
+exCWxEPIg1CIFifdkD0DhG1zH/OgwYhhbe/uffNq/2bRszUy2HDl/w/B3R60ko5
0Mj8DRy9Kmkrri0H+m/IlrGDksFMcPdzwetWN+dHt/zlwDJzUlkBWMfmvt3Rj4k=
=eELr
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--


--===============9043969743192732446==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9043969743192732446==--
