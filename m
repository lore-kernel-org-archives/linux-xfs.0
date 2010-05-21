Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4L2Dv2v240700 for <xfs@oss.sgi.com>; Thu, 20 May 2010 21:13:58 -0500
Received: from mail-ew0-f228.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CBEF9F5F42
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 19:17:32 -0700 (PDT)
Received: from mail-ew0-f228.google.com (mail-ew0-f228.google.com
	[209.85.219.228]) by cuda.sgi.com with ESMTP id
	LeHHZDzkbqiPRZKB for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 19:17:32 -0700 (PDT)
Received: by ewy28 with SMTP id 28so96814ewy.18
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 19:16:15 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 May 2010 03:16:15 +0100
Message-ID: <AANLkTilJD2Jfr4W97BiAlyc_7C9jLEhEzuEWSDyVKXYP@mail.gmail.com>
Subject: Tuning XFS for real time audio on a laptop with encrypted LVM
From: Pedro Ribeiro <pedrib@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

I was wondering what is the best scheduler for my use case given my
current hardware.

I have a laptop with a fast Core 2 duo at 2.26 and a nice amount of
ram (4GB) which I use primarily for real time audio (though without a
-rt kernel). All my partitions are XFS under LVM which itself is
contained on a LUKS partition (encrypted with AES 128).

CFQ currently does not perform very well and causes a lot of thrashing
and high latencies when I/O usage is high. Changing it to the noop
scheduler solves some of the problems and makes it more responsive.
Still performance is a bit of a let down: it takes 1m30s to unpack the
linux-2.6.34 tarball and a massive 2m30s to rm -r.
I have lazy-count=1, noatime, logbufs=8, logbsize=256k and a 128m log.

Is there any tunable I should mess with to solve this? And what do you
think of my scheduler change (I haven't tested it that much to be
honest)?

Regards,
Pedro

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
