Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 19B137CA1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 16:11:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7EF0EAC01D
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 14:11:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xG4K17PNDGRqD2yE for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 14:11:50 -0700 (PDT)
Date: Wed, 13 Apr 2016 07:11:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: xfs_inode_free() isn't RCU safe
Message-ID: <20160412211148.GJ567@dastard>
References: <0A92B65A3BF94F60BB36EA3FA716DF1F@alyakaslap>
	<570CDC0B.3070802@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <570CDC0B.3070802@sgi.com>
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
To: Brent Bice <bbice@sgi.com>
Cc: Shyam Kaushik <shyam@zadarastorage.com>, Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Tue, Apr 12, 2016 at 05:29:15AM -0600, Brent Bice wrote:
>    Could you resend it to be sure? I flagged it for redelivery the
> day I emailed you so if nobody else has seen it yet then something
> still didn't work.  I was pretty sure I'd seen it get delivered ok
> to oss, but... (shrug)

No, it didn't, and it's not in the archives, either.

It seems that sgi.com is rejecting quite a bit of legitimate mail
lately. I've seen a couple of people in the past couple of weeks
send stuff that has reached my private in boxes but not the list.
Now this one, too.

If someone is having to micro-manage the list to prevent rejections
of valid email then that is bad...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
