Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2BGxuA069171 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 05:16:59 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED180293DEF
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 03:16:53 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	UIwZBSBzh3NZKcUh for <xfs@oss.sgi.com>;
	Fri, 02 Dec 2011 03:16:53 -0800 (PST)
Date: Fri, 2 Dec 2011 06:16:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: fix the logspace waiting algorithm
Message-ID: <20111202111649.GA3072@infradead.org>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111128081925.981681380@bombadil.infradead.org>
	<1322767713.7115.1548.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1322767713.7115.1548.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Dec 01, 2011 at 01:28:33PM -0600, Chandra Seetharaman wrote:
> Tested the patch with testcases 234 and 273. They ran for more than 350
> iterations without getting into the hang situation.
> 
> Tested-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> Few generic comments on the patch
> 
> 1. xlog_*_wake could use something to indicate that they are looking for
> log space in the specific queue. ex: xlog_reserveq_available()
> 
> 2. All new functions expect a lock to be held on entry. Can be
> explicitly specified in a comment.
> 
> 3. Change the trace function names to reflect the names of the
> function ?!

All this is going to change with the refactoring of these to use a
common data structure which I have in my queue for 3.3.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
