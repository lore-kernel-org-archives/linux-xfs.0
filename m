Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0SIr11K144675 for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 12:53:02 -0600
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48A68C43C1
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 10:52:19 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com
	[208.42.117.202]) by cuda.sgi.com with ESMTP id
	U0ZBtEY5Fu71Jcwe for <xfs@oss.sgi.com>;
	Wed, 28 Jan 2009 10:52:19 -0800 (PST)
Message-ID: <4980A4BB.9050502@thebarn.com>
Date: Wed, 28 Jan 2009 12:32:27 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: XFS trouble: task xfssyncd blocked for more than 120 seconds.
References: <A22069E0-B39A-41CF-9467-4524055B1970@hal-9k.de>
In-Reply-To: <A22069E0-B39A-41CF-9467-4524055B1970@hal-9k.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3813669555047342748=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Julian Einwag <julian@hal-9k.de>
Cc: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============3813669555047342748==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig90542657B7197C8294A6B9D5"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig90542657B7197C8294A6B9D5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Could get a call trace of all process the next time this happens?

srq-t

That would help us to see what else is going on and what might be
holding things up.


Julian Einwag wrote:
> Hi,
>
> we're currently using XFS on our POP/IMAP server for storage of the
> user's mailboxes (Linux kernel version 2.6.27.10, x86_64).
> Howevere, we're experencing some seemingly random filesystem lockups
> during which the filesystem can still be read, but not written. The
> following error messages show in in the system logs:
>
> Jan 27 17:03:01 postman-64b kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jan 27 17:03:01 postman-64b kernel: xfssyncd      D
> 0000000100921c06     0  3090      2
> Jan 27 17:03:01 postman-64b kernel:  ffff88067b1cbd70 0000000000000046
> 0000000000000000 0000000000000001
> Jan 27 17:03:01 postman-64b kernel:  ffff88067a6124c0 ffff88067cc7c980
> ffff88067a612718 00000002a8421200
> Jan 27 17:03:01 postman-64b kernel:  00000000fffffffd 0000000000001000
> 0000000000000000 0000000000000001
> Jan 27 17:03:01 postman-64b kernel: Call Trace:
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8041d432>]
> schedule_timeout+0x1e/0xad
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01ce88e>]
> xfs_buf_iorequest+0x5d/0x61 [xfs]
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01d2352>]
> xfs_bdstrat_cb+0x36/0x3a [xfs]
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8041c9e4>]
> wait_for_common+0xc8/0x132
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8022b373>]
> default_wake_function+0x0/0xe
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01c70ba>]
> xfs_finish_reclaim+0x110/0x13b [xfs]
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01c7169>]
> xfs_finish_reclaim_all+0x84/0xc9 [xfs]
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01c634b>]
> xfs_syncsub+0x4c/0x226 [xfs]
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01d3d54>]
> xfs_sync_worker+0x17/0x36 [xfs]
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01d4cb3>]
> xfssyncd+0x133/0x182 [xfs]
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01d4b80>]
> xfssyncd+0x0/0x182 [xfs]
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffff80244a68>]
> kthread+0x47/0x73
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8022f77f>]
> schedule_tail+0x27/0x5f
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8020ccf9>]
> child_rip+0xa/0x11
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffff802f9395>]
> generic_unplug_device+0x0/0x2d
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffff80244a21>]
> kthread+0x0/0x73
> Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8020ccef>]
> child_rip+0x0/0x11
>
> Only rebooting helps.
>
> The filesystem is hosted on a hardware-based RAID5 array.
>
> We're currently out of ideas on what might be causing this, so any
> hints would be greately appreciated.
>
> Best regards,
> Julian Einwag
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



--------------enig90542657B7197C8294A6B9D5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJgKS/NRmM+OaGhBgRApb7AJwO2SZfRQtCBeWXbCfAZqpglDhYEQCfbJpy
tTMndI8koWNhat/asyx5nGo=
=2+TN
-----END PGP SIGNATURE-----

--------------enig90542657B7197C8294A6B9D5--


--===============3813669555047342748==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3813669555047342748==--
