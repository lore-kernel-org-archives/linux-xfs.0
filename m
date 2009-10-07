Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97KMj9m208358 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 15:22:46 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77579BD9945
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 13:24:10 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id HD3KcIEcKeSzYxir for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 13:24:10 -0700 (PDT)
Subject: Re: [PATCH] mkfs: add discard support
From: Andi Kleen <andi@firstfloor.org>
References: <20091006184758.GA4780@infradead.org>
	<20091007044215.GK9464@discord.disaster>
Date: Wed, 07 Oct 2009 22:24:07 +0200
In-Reply-To: <20091007044215.GK9464@discord.disaster> (Dave Chinner's message
	of "Wed, 7 Oct 2009 15:42:16 +1100")
Message-ID: <87iqerymu0.fsf@basil.nowhere.org>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:

> On Tue, Oct 06, 2009 at 02:47:58PM -0400, Christoph Hellwig wrote:
>> Call the BLKDISCARD ioctl to mark the whole disk as unused before creating
>> a new filesystem.  This will allow SSDs, Arrays with thin provisioning support
>> and virtual machines to make smarter allocation decisions.
>
> Good idea, but perhaps the discard should be optional rather than
> unconditional.  My immediate thought was the SOP for setting up
> encrypted devices - fill the empty disk with random data before
> setting up the encrypted device. If you then send it a discard....

This actually doesn't really work for SSDs, because SSDs typically
have more internal capacity than they advertise and when you fill
it up then it will just allocate new blocks and leave some of the
blocks with the existing data around. 

AFAIK there's no way to really reliably delete something physically
on a SSD short of applying a hammer.

For thin provisioning arrays you have similar problems.

So I think Christoph's case of making it default is fine.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
