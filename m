Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jan 2008 19:01:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0H311Hw030158
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 19:01:03 -0800
Date: Thu, 17 Jan 2008 14:01:11 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
Message-ID: <20080117030111.GH155259@sgi.com>
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253594C@pvn-3001.purevideo.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F0253594C@pvn-3001.purevideo.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 16, 2008 at 03:19:19PM -0800, Mark Magpayo wrote:
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

Hmmm - what kernel and what version of xfsprogs are you using?
(xfs_growfs -V).

Also, can you post the output of the growfs command if you still
have it?

If not, the output of:

# xfs_db -r -c 'sb 0' -c p <device>
# xfs_db -r -c 'sb 1' -c p <device>

because:

> I was unable write to the logical volume I had just created.  I tried to
> remount it, but I kept getting an error saying the superblock could not
> be read.  I tried running an xfs_repair on the filesystem, and get the
> following:
> 
> Phase 1 - find and verify superblock...
> superblock read failed, offset 19504058859520, size 2048, ag 64, rval 0

That's a weird size for a superblock, and I suspect you should only
have AG's numbered 0-63 in your filesystem. (a 8.9TB filesystem will
have 32 AGs (0-31) by default, and doubling the size will take it
up to 64).

> I am not very experienced with xfs (I was following commands in some
> documentaion), and I was recommended to post to this mailing list.  If
> anyone could provide some help, it would be greatly appreciate.  Also,
> if there is any information I can provide to help, I will gladly provide
> it.  Thanks in advance!

Seeing as the filesystem has not mounted, I think this should be
recoverable if you don't try to mount or write anything to the
filesystem until we fix the geometry back up....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
