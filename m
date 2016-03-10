Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 58DAD7CA2
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 08:14:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C81A3AC001
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 06:14:40 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id n6AiLLvRkS4C3XDG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2016 06:14:35 -0800 (PST)
Date: Thu, 10 Mar 2016 06:14:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/16] xfs: first part of rmapbt functionality
Message-ID: <20160310141434.GA29058@infradead.org>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457410578-30233-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Tue, Mar 08, 2016 at 03:16:02PM +1100, Dave Chinner wrote:
> This isn't all of the rmap functionality. It's patches up to the
> point where I've come across the first piece that needs to be
> reworked (the rmap intent execution code), so there's no point
> holding these back until I've sorted that out. This builds on top of
> for-next and the patch set I posted yesterday.
> 
> Darrick, I've changed the authorship of the patches to reflect
> the original series this has come from - can you check to see if
> there's anything I got wrong when I did that?

I'll come some minor bits on the actual patches, but I'd like to
understand a few fundamental things first:

For one Darrick has introduced a new rmapxbt btree recently, which
allows using a rmap on reflink enabled file systems.  In his tree
we thus have two different implementation of a reverse mapping
btree.  Is there any good reason to keep it this way?  For one
reflinks are a compelling feature that I doubt people want to
disable in the long run, so most filesystem will be using rmapxbt.
I also don't think having these two implementations is good for the
testing matrix in the long run.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
