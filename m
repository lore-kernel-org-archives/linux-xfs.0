Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2G3HQa086343 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 10:03:17 -0600
Received: from e38.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3220329472A
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 08:03:16 -0800 (PST)
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159]) by
	cuda.sgi.com with ESMTP id 8vofv05Hjy1dSzzE for
	<xfs@oss.sgi.com>; Fri, 02 Dec 2011 08:03:16 -0800 (PST)
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 2 Dec 2011 09:03:15 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pB2G2ojd033926 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 09:03:01 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id pB2G2nVQ026750
	for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 09:02:50 -0700
Subject: Re: [PATCH 4/4] xfs: fix the logspace waiting algorithm
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20111202111649.GA3072@infradead.org>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111128081925.981681380@bombadil.infradead.org>
	<1322767713.7115.1548.camel@chandra-lucid.austin.ibm.com>
	<20111202111649.GA3072@infradead.org>
Date: Fri, 02 Dec 2011 10:02:39 -0600
Message-ID: <1322841759.31919.0.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Cc: xfs@oss.sgi.com

Then it is all good

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>
  
On Fri, 2011-12-02 at 06:16 -0500, Christoph Hellwig wrote:
> On Thu, Dec 01, 2011 at 01:28:33PM -0600, Chandra Seetharaman wrote:
> > Tested the patch with testcases 234 and 273. They ran for more than 350
> > iterations without getting into the hang situation.
> > 
> > Tested-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > 
> > Few generic comments on the patch
> > 
> > 1. xlog_*_wake could use something to indicate that they are looking for
> > log space in the specific queue. ex: xlog_reserveq_available()
> > 
> > 2. All new functions expect a lock to be held on entry. Can be
> > explicitly specified in a comment.
> > 
> > 3. Change the trace function names to reflect the names of the
> > function ?!
> 
> All this is going to change with the refactoring of these to use a
> common data structure which I have in my queue for 3.3.
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
