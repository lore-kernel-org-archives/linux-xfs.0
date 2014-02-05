Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07A1E7F51
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 02:00:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0B058F8052
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 00:00:01 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QmOsu5DytTxu9la9 for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 23:59:59 -0800 (PST)
Date: Wed, 5 Feb 2014 18:59:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] support appending AIO writes
Message-ID: <20140205075948.GA13647@dastard>
References: <20140204172402.380571745@bombadil.infradead.org>
	<20140204222901.GE13997@dastard>
	<20140205065728.GA30899@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140205065728.GA30899@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Sergey Meirovich <rathamahata@gmail.com>, xfs@oss.sgi.com

On Tue, Feb 04, 2014 at 10:57:28PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 05, 2014 at 09:29:01AM +1100, Dave Chinner wrote:
> > The patches look sane. Does the dio change conflict with the
> > work Al is doing right now of the direct IO path, or will
> > marshalling that part of the change through the XFS tree be fine?
> 
> I've not seen any changes in that area in Al's trees.  That being said
> I don't think this little flag should cause any major problems as we'll
> have to pass the flags argument in some form of direct I/O method for
> all the other quirks we have.

Fair enough. I'll run some tests tomorrow on it and go from there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
