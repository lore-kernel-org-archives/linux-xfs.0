Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 05:26:52 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0NDQhGY023115
	for <linux-xfs@oss.sgi.com>; Wed, 23 Jan 2008 05:26:46 -0800
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAC2C122EC29
	for <linux-xfs@oss.sgi.com>; Wed, 23 Jan 2008 05:27:03 -0800 (PST)
Received: from mx1.suse.de (mail.suse.de [195.135.220.2]) by cuda.sgi.com with ESMTP id BFfK97bPYvVoMhDM for <linux-xfs@oss.sgi.com>; Wed, 23 Jan 2008 05:27:03 -0800 (PST)
Date: Wed, 23 Jan 2008 14:27:00 +0100
From: Jan Blunck <jblunck@suse.de>
Subject: Re: blktrace & btrace usability
Message-ID: <20080123132700.GI4531@hasse.suse.de>
References: <47906577.8090604@tlinx.org> <20080122164145.GB4531@hasse.suse.de> <47964B66.5020001@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47964B66.5020001@tlinx.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <lkml@tlinx.org>
Cc: linux-btrace@vger.kernel.org, Linux-Xfs <linux-xfs@oss.sgi.com>

On Tue, Jan 22, Linda Walsh wrote:

> Jan Blunck wrote:
>> blktrace is used by the preload package. The preload package is capable of
>> remapping blocks for faster booting. Therefore we need the blktrace
>> output. But we only have a remapper for ext3.
>>   
> ----
>    I wondered about that, but the blktrace package doesn't containg
> any utility for remapping blocks. The blktrace-0.99.3-12 package
> included in OSuse-10.3, I only see utilities "blkparse, blktrace, btrace,
> blkrawverify, btt, and verify_blktrace". 
>    Was it left out by accident?  ---or---

No, this is the reason why I said "blktrace is used by the preload
package". The ext3remapper is part of the preload package.

>    If the remapping is in a separate package, then shouldn't
> the blktrace package "just" do the block tracing, regardless
> of file type (i.e. in typical unix fashion, it does its part, and
> another util (a block-re-arranger) does its part...? 

Yes it is just doing that. If you only have a remapper for ext3 (I wasn't
aware of XFS) there is no point in gathering the blktrace data for other
filesystem. boot.blktrace, which is the script you are refering to is part of
the preload package. Remember that we haven't changed blktrace that it only
works for ext3 or something similar.

>    Having blktrace do it's thing no matter what filesystem
> follows might encourage or enable someone to write re-arrangers
> for other filesystems...(?)  After all, xfs already has
> one block-rearranger program (for what little it is needed)
> in "xfs_fsr".  Does ext3 have something similar now? 

Yes, the ext3remapper written by Jan Kara.
