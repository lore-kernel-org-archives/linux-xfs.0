Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B76637F6F
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 17:27:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35546AC00C
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 15:27:47 -0700 (PDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
	[209.85.212.171]) by cuda.sgi.com with ESMTP id
	dgZKAhIiuqmiixZm (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Sep 2014 15:27:36 -0700 (PDT)
Received: by mail-wi0-f171.google.com with SMTP id ho1so110586wib.4
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 15:27:35 -0700 (PDT)
Received: from minas-tirith.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177]) by mx.google.com with ESMTPSA id
	ll20sm16557825wic.14.2014.09.30.15.27.34 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Tue, 30 Sep 2014 15:27:34 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id 68289182453
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 00:27:30 +0200 (CEST)
Date: Wed, 1 Oct 2014 00:27:20 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Happened again,
	20140930 -- Got "Internal error XFS_WANT_CORRUPTED_GOTO".
	Filesystem needs reformatting to correct issue.
In-Reply-To: <alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
Message-ID: <alpine.LSU.2.11.1410010001350.17407@minas-tirith.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256



> Subject: Subject : Happened again,
>     20140811 -- Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
>      reformatting to correct issue.
> Date: Mon, 11 Aug 2014 16:23:01 +0200 (CEST)

> Happened again, I'm on middle of recovery procedures, and using my laptop
> to post.

And again.

Well, after I recover the system I'm going to migrate my /home to a small 
ext4 partition, leaving Documents and the big directories in the current 
xfs home, renamed to something else. I hope this way to avoid the crashes 
and corruption on restore from hibernation.

SUSE and openSUSE (12 and 13.2) are switching to use, on new installs by 
default, btrfs for their root filesystem, and xfs for home. I hope that 
this will cause more crashes on laptops on return from hibernation, 
producing more reports, and finally solving the root cause of this.

Or perhaps it does not happen on 13.2, and I'm the only one left having 
the issue...

Anyway, as I'm using 13.1, and will be for some time, the solution for me 
is to move the core of /home to ext4, at least temporarily.



If someone wants me to get some data from the partition, I'm willing. I 
made a full 'dd' of it before attempting mount or repair on it (still 
pending), it will be possible for some days or more. Time permitting. :-)

- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlQrLlIACgkQja8UbcUWM1z5nAD8DSoMv0LXUZQSbDcuVpmpH96g
zSnNcVKFRuZdBp6WY6gA/j9LzOmEy0a5MD5h++wnkKLk2z9RsnuJVc6PYW4RLyG8
=rZgI
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
