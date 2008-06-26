Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 22:13:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q5DXx7013552
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 22:13:35 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E257228281B
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 22:14:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id WjPh30b2JNcHkAcb for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 22:14:33 -0700 (PDT)
Message-ID: <486325B8.5010505@sandeen.net>
Date: Thu, 26 Jun 2008 00:14:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS w/ extern journal as root on Linux?
References: <732501.9968.qm@web34508.mail.mud.yahoo.com>
In-Reply-To: <732501.9968.qm@web34508.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: MusicMan529@yahoo.com
Cc: xfs@oss.sgi.com

Mark wrote:
> Well, I tried to convert my non-/home space to XFS with an external journal, but Linux consistently choked on it. I passed "rootfstype=xfs root=/dev/sdb5 rootflags=logdev=/dev/sda2" on the kernel command line (via GRUB) but it panicked every time. 
> 
> Here is a transcript of the boot panic from an unmodified kernel:
> 
> ~~~~~~~~~~~~~~~~~
> md: Autodetecting RAID arrays.
> md: Scanned 0 and added 0 devices.
> md: autorun ...
> md: ... autorun DONE.
> XFS: Invalid device [/dev/sda2], error=-2

Hm, xfs wants to open it by name ("/dev/sda2") but if we look at the
early mount stuff it's doing essentially:

	root_device_name = saved_root_name; /* from root= */

        ROOT_DEV = name_to_dev_t(root_device_name);

        create_dev("/dev/root", ROOT_DEV);
        mount_block_root("/dev/root", root_mountflags);

so it's creating its own dev to open, and this isn't done for the logdev.

I wonder if xfs can do similar tricks, or maybe do name_to_dev_t and do
the open by dev_t not path?

This is probably where somebody tells me I'm wrong for the following
reasons: a, b, c, ... :)

-Eric
