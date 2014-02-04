Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 596A27F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 16:29:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 483398F8037
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 14:29:06 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	J9Xq5Z5N9OC8YBfx for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 14:29:04 -0800 (PST)
Date: Wed, 5 Feb 2014 09:29:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] support appending AIO writes
Message-ID: <20140204222901.GE13997@dastard>
References: <20140204172402.380571745@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140204172402.380571745@bombadil.infradead.org>
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

On Tue, Feb 04, 2014 at 09:24:02AM -0800, Christoph Hellwig wrote:
> At least XFS can support appending AIO writes easily, and Sergey has
> demonstrated a use case for them.
> 
> I've not done any performance testing myself, but ensured that xfstests
> already exercises the code path.

The patches look sane. Does the dio change conflict with the
work Al is doing right now of the direct IO path, or will
marshalling that part of the change through the XFS tree be fine?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
