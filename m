Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EAD329DF8
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 22:12:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 359198F8049
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 20:12:15 -0700 (PDT)
Received: from mail-wg0-f42.google.com (mail-wg0-f42.google.com
	[74.125.82.42]) by cuda.sgi.com with ESMTP id avjWs4HLQGI9SThZ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Jul 2014 20:12:13 -0700 (PDT)
Received: by mail-wg0-f42.google.com with SMTP id z12so1037920wgg.25
	for <xfs@oss.sgi.com>; Thu, 03 Jul 2014 20:12:12 -0700 (PDT)
Received: from Telcontar.valinor (90.Red-79-150-228.dynamicIP.rima-tde.net.
	[79.150.228.90]) by mx.google.com with ESMTPSA id
	do5sm73954169wib.16.2014.07.03.20.12.10 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 03 Jul 2014 20:12:11 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id ED25B60E0E
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 05:12:08 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id vxCaF4Yg-PIn for <xfs@oss.sgi.com>;
	Fri,  4 Jul 2014 05:12:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id C72AC60D9B
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 05:12:08 +0200 (CEST)
Date: Fri, 4 Jul 2014 05:12:00 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
In-Reply-To: <alpine.LSU.2.11.1407040415400.9881@Telcontar.valinor>
Message-ID: <alpine.LSU.2.11.1407040506380.9881@Telcontar.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703094347.GU4453@dastard>
	<alpine.LSU.2.11.1407040113340.9881@Telcontar.valinor>
	<20140704000426.GX4453@dastard>
	<alpine.LSU.2.11.1407040317120.9881@Telcontar.valinor>
	<20140704014008.GI9508@dastard>
	<alpine.LSU.2.11.1407040415400.9881@Telcontar.valinor>
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
Hash: SHA1



On Friday, 2014-07-04 at 04:42 +0200, Carlos E. R. wrote:
> On Friday, 2014-07-04 at 11:40 +1000, Dave Chinner wrote:

>> So, until we have kernel fixes, you'd do best to turn off
>> hibernation. If you can't live with leaving your machine powered up
>> or switching it off, then use suspend-to-ram rather than
>> suspend-to-disk to avoid the problematic snapshot/restore
>> situation....

Forgot to mention:

I have been working the same way for years on this same machine, and with 
the same software versions for some months. Only when I replaced the hard 
disk that contains home, mail, and some other things, the problem started.

The partitions not cloned; I partitioned and formatted fresh (much bigger 
partitions), with gparted, and copied files over with rsync.

- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlO2G4gACgkQtTMYHG2NR9UtpACdFnxw8/nZKAVI/Hy7s2bVF41j
/+8AoJLmY2ZuyX+kKeXNzo9/6BOVx4T0
=pZAc
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
