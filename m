Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3N1ucVS002680 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 20:56:43 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F22A61058FB5
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 18:58:38 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id 84JjjWcMLJNvFPoO for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 18:58:38 -0700 (PDT)
Date: Fri, 23 Apr 2010 09:56:48 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: mkfs.xfs man page for -nsize
Message-ID: <20100423015648.GA2491@laptop.oracle.com>
References: <20100422124118.GA3406@laptop.oracle.com>
	<20100422163355.GA6360@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422163355.GA6360@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, joe.jin@oracle.com, greg.marsden@oracle.com, Wengang Wang <wen.gang.wang@oracle.com>

On 10-04-22 12:33, Christoph Hellwig wrote:
> On Thu, Apr 22, 2010 at 08:41:18PM +0800, Wengang Wang wrote:
> > I got no idea why the value is illegal.
> > 
> > Checking the codes, I found it also must be larger or equal to block size and it
> > must be in powers of 2, 2^N. Should we add these two limitation to man page?
> 
> Yes, this should be added to the man page.  Can you submit a patch to
> add it?
> 
Sure! I will be glad to do that. I will post the patch a bit later.

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
