Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 18:01:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9311Kh2011198
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 18:01:22 -0700
Date: Wed, 03 Oct 2007 11:05:05 +1000
Subject: Re: REVIEW: xfs_reno
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.tzj549h63jf8g2@pc-bnaujok.melbourne.sgi.com> <20071002090216.GA22721@infradead.org> <20071002091951.GE995458@sgi.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tzljyrfc3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20071002091951.GE995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, 02 Oct 2007 19:19:51 +1000, David Chinner <dgc@sgi.com> wrote:

> On Tue, Oct 02, 2007 at 10:02:16AM +0100, Christoph Hellwig wrote:
>> On Tue, Oct 02, 2007 at 05:08:59PM +1000, Barry Naujok wrote:
>> >
>> > The attached tool allows an inode64 filesystem to be converted to  
>> inode32.
>> > For this to work, the filesystem has to be mounted inode32 before  
>> it's run.
>> >
>> > I'm not sure if there is any packaging changes required.
>>
>> Together with the stop allocating from specific AGs patch this should be
>> 90% towards an xfs_shrinkfs, right?
>
> Well, this just moves the inodes - it's one piece of the puzzle.  We
> still need to collide xfs_fsr with xfs_reno to move the data.
>
> After that, we need to work out how to move the orphan metadata
> blocks out of the AGs that are to be truncated off. That's not
> simple....

I believe xfs_bmap on all inodes can reveal extended attributes and
directory data in extra AGs. Copying those like xfs_reno does with
"blocked" AGs should perform the desired metadata moving.

> After that, we need the transaction to shrink the fs.
>
> At that point, we'll got a "working" shrink that will allow
> shrinking to only 50% of the original size because the log will
> get in the way. To fix that, we'll need to implement transactions
> to move the log...
>
> Cheers,
>
> Dave.
