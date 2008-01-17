Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jan 2008 18:31:03 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0H2UpIi027251
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 18:30:53 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57207C6CBB0
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 18:31:10 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 8RnBLOPylkEyXepf for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 18:31:10 -0800 (PST)
Message-ID: <478EBDEC.2070305@sandeen.net>
Date: Wed, 16 Jan 2008 20:31:08 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253594C@pvn-3001.purevideo.local>
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F0253594C@pvn-3001.purevideo.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: xfs@oss.sgi.com

Mark Magpayo wrote:
> Hi,
> 
> So I have run across a strange situation which I hope there are some
> gurus out there to help.
> 
> The original setup was a logical volume of 8.9TB.  I extended the volume
> to 17.7TB and attempted to run xfs_growfs.  I am not sure whether the
> command actually finished, as after I ran the command, the metadata was
> displayed, but there was no nothing that stated the the number of data
> blocks had changed.  I was just returned to the prompt, so I'm not sure
> whether the command completed or not..
> 
> I was unable write to the logical volume I had just created.  I tried to
> remount it, but I kept getting an error saying the superblock could not
> be read.  I tried running an xfs_repair on the filesystem, and get the
> following:
> 
> Phase 1 - find and verify superblock...
> superblock read failed, offset 19504058859520, size 2048, ag 64, rval 0
> 
> fatal error -- Invalid argument

hm, how big is your block device for starters - look in /proc/partitions.

-Eric
