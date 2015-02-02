Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 839778000
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 13:34:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5EB568F8037
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 11:34:45 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GEN8oukvNy88tDT1 for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 11:34:43 -0800 (PST)
Date: Tue, 3 Feb 2015 06:34:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: use generic percpu counters for free block
	counter
Message-ID: <20150202193428.GL6282@dastard>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<1422826983-29570-5-git-send-email-david@fromorbit.com>
	<20150202164847.GB695@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202164847.GB695@infradead.org>
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
Cc: xfs@oss.sgi.com

On Mon, Feb 02, 2015 at 08:48:47AM -0800, Christoph Hellwig wrote:
> 
> This screams for having two different helpers for removing vs adding back
> reserved blocks.

Yup, that it does.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
