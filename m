Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E0B847F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:16:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D13558F806F
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:16:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 5IOZC83APhCpSimF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:16:41 -0800 (PST)
Date: Fri, 13 Dec 2013 03:16:39 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS / writeback invoking soft lockup.
Message-ID: <20131213111639.GD23546@infradead.org>
References: <20131213071407.GA6527@redhat.com> <20131213104853.GS10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213104853.GS10988@dastard>
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
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Dec 13, 2013 at 09:48:53PM +1100, Dave Chinner wrote:
> All I can say is that there doesn't look to be any obvious signs
> that this is a XFS or writeback problem fom the stack trace, and
> without more information or a reproducable test case I'm not going
> to be able to understand the cause.
> 
> Is the problem reproducable, or is it just a one-off?

If it's reproducable it would be good to enable the xfs_writepage
tracepoint and get a trace-cmd log of it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
