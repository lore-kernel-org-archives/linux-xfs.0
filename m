Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 51DF27F37
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 19:40:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34210304075
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 17:40:54 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id iSIfRen0qPSsRp6i (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 17:40:53 -0800 (PST)
Date: Tue, 25 Feb 2014 17:40:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/10] repair: BMBT prefetch needs to be CRC aware
Message-ID: <20140226014052.GA31905@infradead.org>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-11-git-send-email-david@fromorbit.com>
	<20140225172518.GA12871@infradead.org>
	<20140225235112.GK13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140225235112.GK13647@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Feb 26, 2014 at 10:51:12AM +1100, Dave Chinner wrote:
> Sure, but it's way outside the scope of fixing this bug.
> We'd need to start with the kernel code, then port it is userspace
> and propagate it into all the utilities. Patches welcome ;)

Just doing that repair-local would be a start.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
