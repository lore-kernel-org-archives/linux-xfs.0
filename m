Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 06F167F5F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 04:23:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DAA2D30405F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 02:23:36 -0700 (PDT)
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id tk5mA4pTb0Xs2OD5
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Jun 2014 02:23:35 -0700 (PDT)
Received: by mail-la0-f53.google.com with SMTP id ty20so3327951lab.12
	for <xfs@oss.sgi.com>; Tue, 03 Jun 2014 02:23:33 -0700 (PDT)
Message-ID: <538D9412.3040009@gmail.com>
Date: Tue, 03 Jun 2014 12:23:30 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363B4C9.4000900@sandeen.net> <5363CB5E.3090008@gmail.com>
	<5363CD70.3000006@sandeen.net> <5363DBD7.4060002@gmail.com>
	<5363E65C.6010006@sandeen.net> <5363ECE8.6030706@gmail.com>
	<20140502233512.GE26353@dastard> <536432A0.6000405@gmail.com>
	<20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard>
In-Reply-To: <20140602234135.GO6677@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512


> lsof reports such things as belonging to / because it can't find
> the correct path for them. Indeed, you can't find them by filtering
> on mount point, file or anything else. But they are there.

I didn't know that, sorry. I'll let you know how it works out when it
craps out next time.

But I noticed something interesting when I was playing around with it.
There were 5 processes in the kernel doing something with the defunct
xfs mount, which is no surprise, and when I tried to run xfs_repair
and straced it and there was nothing that looked like a scan of kernel
objects (e.g. via /sys). But I've noticed a call to ustat on the newly
connected device, which had a different ID, the disconnected one was
/dev/sde103 and the new device (the one ustat-ed) was /dev/sdd103, but
ustat reported it mounted. Does XFS do this?

Martin
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTjZP8AAoJELsEaSRwbVYr1coP/i4hjHUg7qEKvlLaTlgE7l3t
wruzcEKagipiHDBXryDWCFoinJiIZ5CIXdektN4t/TQbQ+nbO5/OtkB/d/4QKvV/
MQVsmZfCmF3WU74QZ3+mzI9aQ/eJ6Sbq3GUUIGDylsBP9UKJHkxgHdUZ7zNligQm
hzsslSgOuV+Yyiv/4MwIBWeFQswM7y3/5PMP5QnTHv6diUVtqiBvJvFDmE1MXxD0
FHm52+W0WxsqF2dJ3nCGfYhAeO9uiNIjXHJZKs8dcYQKaONpxpUYFaol/qa8EFCK
abw8atF0oSaGS3VgjDPj+LRudTz308M7VWZPxfCmzXtfepg4SnBXadAyJCAg584L
Huhu9GhU+yKwkuQiMSOYu46SECp/O0JcqvLB197gQPWqFQFoEuOH6dmnCnldNgId
8LXzBlsjo6dSq5ryF4D9CFi1gh3a8+Kcb7BjurQ5EksKkds9W5sYoDSytbNWmKS8
b3vY23XKq6iSe8155lPSvwot2VqFd56PQSURYXWFOu1tFK4yO9754uzlgKVyHYvm
OhMwa3GdcYat/ArFbOewvFupElpTSsWdtD1nbaZ+OFTorzMCtN5nBIGM47eaTlFf
ZwMQ5FvJGIBpb+sCwa4SdHOGuH1+uGoYIBO79Hbuyp0iMjhVPpuTSlq/ovytbvHl
Bw9D4KbQAeHT4YGnnR5q
=akH0
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
