Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A06037F3F
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 19:12:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29BE6AC001
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 17:12:55 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SOYCLDm0QrEPEYEQ for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 17:12:53 -0700 (PDT)
Date: Tue, 13 Aug 2013 10:11:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] direct-io: Implement generic deferred AIO completions
Message-ID: <20130813001140.GR12779@dastard>
References: <1373493739-2243-1-git-send-email-jack@suse.cz>
	<20130712004421.GE3438@dastard>
	<20130716210027.GA9595@quack.suse.cz>
	<20130812161455.GA19471@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130812161455.GA19471@quack.suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com, hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Mon, Aug 12, 2013 at 06:14:55PM +0200, Jan Kara wrote:
>   Hi Dave,
> 
>   I remembered about this patch set and realized I didn't get reply from
> you regarding the following question (see quoted email below for details):
> Do you really need to defer completion of appending direct IO? Because
> generic code makes sure appending direct IO isn't async and thus
> dio_complete() -> xfs_end_io_direct_write() gets called directly from
> do_blockdev_direct_IO(). I.e. from a normal context and not from interrupt.

Hi Jan, sorry I haven't got back to you sooner - I've had a lot
of stuff to deal with over the past couple of weeks.

The issue is that one part of the code expects deferral , and the
other part of the code isn't doing a deferral, and I never got
around to determining which was correct. I didn't connect the dots
between aio/appending and sync dispatch meaning that the way it is
operating now is fine - i.e. that the fact it doesn't call the
deferral completion path is OK and was intended to operate that
way by Christoph.

So leaving the code as it is without a deferal is fine.

> I've already addressed rest of your comments so this is the only item that
> is remaining.

Great :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
