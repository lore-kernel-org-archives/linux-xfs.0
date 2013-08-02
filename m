Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 88F8529DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 20:44:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D533AC006
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 18:44:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iYiJn8g9NBM9X2CZ for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 18:44:55 -0700 (PDT)
Date: Fri, 2 Aug 2013 11:44:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/49] xfs: separate dquot on disk format definitions out
	of xfs_quota.h
Message-ID: <20130802014452.GU7118@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-6-git-send-email-david@fromorbit.com>
	<20130801085126.GB13494@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130801085126.GB13494@infradead.org>
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

On Thu, Aug 01, 2013 at 01:51:26AM -0700, Christoph Hellwig wrote:
> > + * This header file defines all the on-disk format definitions for 
> > + * general XFS objects. Directory and attribute related objects are defined in
> > + * xfs_da_format.h, which log and log item formats are defined in
> 
> As of this patch (and the whole series) we still seem to have
> xfs_dir2_format.h and not xfs_da_format.h

I haven't got around to combining them as it's not initially
necessary to harmonise user/kernel space. So the comment is wrong.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
