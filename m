Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MKqVuU105810 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 15:52:31 -0500
Received: from e36.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 932C31511A2C
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 13:52:30 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id MCurBZlIjrhvtfN0 for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 13:52:30 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MKkHUw032646
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:46:17 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6MKpEYs175572 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:51:14 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6MEpDJe018826
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 08:51:13 -0600
Subject: Re: [PATCH 09/12] Replace the macro XFS_BUF_ISPINNED with helper
	xfs_buf_ispinned
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1311363514.2771.104.camel@doink>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003343.21069.95122.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311363514.2771.104.camel@doink>
Date: Fri, 22 Jul 2011 13:51:13 -0700
Message-ID: <1311367873.3210.973.camel@chandra-lucid.beaverton.ibm.com>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

On Fri, 2011-07-22 at 14:38 -0500, Alex Elder wrote:
> On Thu, 2011-07-21 at 17:33 -0700, Chandra Seetharaman wrote:
> > Replace the macro XFS_BUF_ISPINNED with an inline helper function
> > xfs_buf_ispinned, and change all its usages.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> One simple suggestion below.  Otherwise:
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> > diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
> > index 7b1f484..71e1d6f 100644
> > --- a/fs/xfs/linux-2.6/xfs_buf.h
> > +++ b/fs/xfs/linux-2.6/xfs_buf.h
> > @@ -280,7 +280,10 @@ xfs_buf_set_ref(
> >  #define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	xfs_buf_set_ref(bp, ref)
> >  #define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
> >  
> > -#define XFS_BUF_ISPINNED(bp)	atomic_read(&((bp)->b_pin_count))
> > +static inline int xfs_buf_ispinned(struct xfs_buf *bp)
> > +{
> > +	return atomic_read(&(bp->b_pin_count));
> 
> Good idea.  But drop the extra parentheses:
> 
> 	return atomic_read(&bp->b_pin_count);

will do
> 
> > +}
> >  
> >  #define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
> >  
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
