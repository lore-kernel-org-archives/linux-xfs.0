Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MKox8Q105772 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 15:50:59 -0500
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A78FC180D7BA
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 13:50:58 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id Sq3u8ndOvonp2VSw for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 13:50:58 -0700 (PDT)
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MKPSWB021279
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:25:28 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6MKovMB128918 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:50:57 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6MGoiK1027790 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 13:50:45 -0300
Subject: Re: [PATCH 08/12] xfs: Remove the macro XFS_BUF_SET_PTR
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1311363510.2771.103.camel@doink>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003333.21069.32295.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311363510.2771.103.camel@doink>
Date: Fri, 22 Jul 2011 13:50:55 -0700
Message-ID: <1311367855.3210.972.camel@chandra-lucid.beaverton.ibm.com>
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
> > Remove the definition and usages of the macro XFS_BUF_SET_PTR.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> One suggestion.  Otherwise:
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 4255a1c..21e770f 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1395,8 +1395,9 @@ xlog_sync(xlog_t		*log,
> >  	if (split) {
> >  		bp = iclog->ic_log->l_xbuf;
> >  		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
> > -		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
> > -					    (__psint_t)count), split);
> > +		xfs_buf_associate_memory(bp,
> > +				(xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
> > +				    (__psint_t)count), split);
> 
> If you just cast the address appropriately you can make this
> look a lot nicer:
> 
> 		xfs_buf_associate_memory(bp,
> 			(void *) &iclog->ic_header + count, split);
> 

will do
> >  		bp->b_fspriv = iclog;
> >  		bp->b_flags &= ~(XBF_FUA|XBF_FLUSH);
> >  		XFS_BUF_ASYNC(bp);
> 
> . . .
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
