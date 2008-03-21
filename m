Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 11:56:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LIu4Qs023906
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:56:04 -0700
Received: from node2.t-mail.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F7136D0A85
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:56:35 -0700 (PDT)
Received: from node2.t-mail.cz (node2.t-mail.cz [62.141.0.167]) by cuda.sgi.com with ESMTP id 8MNyAKohGrBS3mTu for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 11:56:35 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by bl311.tmo.cz (Postfix) with ESMTP id 9BF75374
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 19:56:33 +0100 (CET)
Received: from node2.t-mail.cz ([127.0.0.1])
	by localhost (bl311.tmo.cz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vt5JEWQLM5dg for <xfs@oss.sgi.com>;
	Fri, 21 Mar 2008 19:56:22 +0100 (CET)
Received: from dasa-laptop (89-24-45-214.i4g.tmcz.cz [89.24.45.214])
	by bl311.tmo.cz (Postfix) with ESMTP id 0A334230
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 19:56:22 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by dasa-laptop (Postfix) with ESMTP id 952C825D7C
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 19:56:19 +0100 (CET)
Subject: serious problem with XFS on nvidia IDE controller
From: Massimiliano Adamo <maxadamo@gmail.com>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 19:56:18 +0100
Message-Id: <1206125778.6867.14.camel@dasa-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

I have a notebook, Acer Aspire 5520 using the following controller:
0:06.0 IDE interface: nVidia Corporation Unknown device 0560 (rev a1)

dmidecode doesn't recognize this controller, lshw says almost the same
like lspci does.

My kernel is the one provided with Ubuntu 7.10: 2.6.22-14

At present, this controller is not managed by any driver in the linux
kernel, and in order to boot, I have to append the string
"all_generic_ide" into grub config file. Otherwise system doesn't boot.

As I like all tools provided with XFS (even if it's missing shrinking
capabilities :)), I decided to install Ubuntu over XFS filesystem.

I have installed the system at least 3 times in one day, before
understanding that the problem was XFS filesystem.
After each reboot there were file missing, when running ldconfig I was
getting messages like: the file blabla_blabla.so is truncated, or is
corrupted... I had to perform installation once again, and then use
reiser.

I also noticed that "sync" command was always taking a long time to
complete.

Does anyone has idea what can be the problem?
Does XFS refuses to work with generic_ata driver?
I am using XFS on another 2 computers without any problem.
Furthermore, now with reiser i don't have any kind of problem.

the following is the output taken from lshw-gtk:

product: nVidia Corporation
vendor: nVidia Corporation
bus info: pci@0000:00:06.0
logical name: scsi0
version: a1
width: 32 bits
clock: 66MHz
capabilities:
	ide,
	Power Management,
	bus mastering,
	PCI capabilities listing,
	Emulated device
configuration:
	driver: ata_generic
	latency: 0
	maxlatency: 1
	mingnt: 3
	module: ata_generic



cheers
Massimiliano
