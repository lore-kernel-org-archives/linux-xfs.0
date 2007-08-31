Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 19:20:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7V2Kc4p032109
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 19:20:42 -0700
Message-ID: <46D77B79.3040104@sgi.com>
Date: Fri, 31 Aug 2007 12:22:49 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
References: <46D6279F.40601@sgi.com> <46D6480F.4040307@sgi.com> <46D64CAD.6050705@sgi.com> <46D67FE6.20205@sgi.com> <46D68510.1020404@sgi.com>
In-Reply-To: <46D68510.1020404@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:
> Timothy Shimmin wrote:
>>>>   But I'm not sure this is an error...
>>>>   Hmmmm...I'm a bit confused.
>>>>   So you are _almost_ combining an error check with a flushiter check?
>>>>   If one buffer is an inode magic# and the other isn't then we
>>>>   have an error right - and could report it - but we are not doing 
>>>> that here.
>>> Not exactly.  If what's on disk is not an inode but the log item is
>>> then that could be because we haven't written the inode to disk yet
>>> and we need to perform recovery.
>> Yeah, I was thinking about that afterward.
>> The item's format which gives the blk# for the buf to read could
>> be a block which hasn't been used for an inode yet.
>>
> Well, if what's on disk is not an inode but some other data
> and it happens to have the inode magic# which is remotely possible,
> then we are making a bad assumption.
> i.e. if we're not sure what the block/buffer should be, then testing the
> MAGIC# isn't a guarantee it's an inode then.
> Well not for the freeing of inode clusters case I would assume.
> Or am I missing something?
I don't think you're missing anything!

You're right though - a magic number check is no guarantee.  On the same
vein, adding a generation number check isn't much better.
