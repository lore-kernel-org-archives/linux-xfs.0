Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 20:30:11 -0700 (PDT)
Received: from hogwarts.egr.duke.edu (hogwarts.egr.duke.edu [152.3.195.84])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9V3U6Z3010020
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 20:30:08 -0700
Date: Tue, 30 Oct 2007 23:30:04 -0400 (EDT)
From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 2.6TB Storage Size Problem
In-Reply-To: <13501909.post@talk.nabble.com>
Message-ID: <alpine.LRH.0.9999.0710302328250.29151@hogwarts.egr.duke.edu>
References: <13501909.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "paul.lkw" <paul.lkw@mfun.org>
Cc: xfs@oss.sgi.com

On Tue, 30 Oct 2007 at 7:35pm, paul.lkw wrote

> I have a DELL server with a hardware raid controller card and 6 x 750GB
> Harddisk, and I configured it as a Raid-5 (5 x 750GB) and 1 of HotSpare. I
> partitioned 50GB of the main base CentOS system and the remain unpartitioned
> size should be 2.5xxxTB, but however I just have 2.0T as EXT-3 limitation (I
> think), How can I use the full size of this with LVM?

This has been answered many times on the CentOS list:

1) On a device larger than 2.0TB, you must use a gpt disklabel rather than
    the default msdos.

2) You must use parted when partitioning such a device.

3) You can't boot from such a device (as neither grub nor lilo support gpt
    disklabels).

-- 
Joshua Baker-LePain
QB3 Shared Cluster Sysadmin
UCSF
