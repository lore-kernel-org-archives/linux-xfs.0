Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 12:00:29 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0MK0K2n009315
	for <linux-xfs@oss.sgi.com>; Tue, 22 Jan 2008 12:00:25 -0800
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0CBACC70EA
	for <linux-xfs@oss.sgi.com>; Tue, 22 Jan 2008 12:00:40 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id gjBABjg3s9H4tILo for <linux-xfs@oss.sgi.com>; Tue, 22 Jan 2008 12:00:40 -0800 (PST)
Message-ID: <47964B66.5020001@tlinx.org>
Date: Tue, 22 Jan 2008 12:00:38 -0800
From: Linda Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Re: blktrace & btrace usability
References: <47906577.8090604@tlinx.org> <20080122164145.GB4531@hasse.suse.de>
In-Reply-To: <20080122164145.GB4531@hasse.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Blunck <jblunck@suse.de>
Cc: linux-btrace@vger.kernel.org, Linux-Xfs <linux-xfs@oss.sgi.com>

Jan Blunck wrote:
> blktrace is used by the preload package. The preload package is capable of
> remapping blocks for faster booting. Therefore we need the blktrace
> output. But we only have a remapper for ext3.
>   
----
    I wondered about that, but the blktrace package doesn't containg
any utility for remapping blocks. The blktrace-0.99.3-12 package
included in OSuse-10.3, I only see utilities "blkparse, blktrace, btrace,
blkrawverify, btt, and verify_blktrace". 

    Was it left out by accident?  ---or---

    If the remapping is in a separate package, then shouldn't
the blktrace package "just" do the block tracing, regardless
of file type (i.e. in typical unix fashion, it does its part, and
another util (a block-re-arranger) does its part...? 

    Having blktrace do it's thing no matter what filesystem
follows might encourage or enable someone to write re-arrangers
for other filesystems...(?)  After all, xfs already has
one block-rearranger program (for what little it is needed)
in "xfs_fsr".  Does ext3 have something similar now? 

    Was the ext3 block re-arranging tool supposed to be
in the blktrace package? 

thanks,
linda
