Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KI5uFH075158 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 13:05:57 -0500
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8333D1C29D45
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:05:56 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id 8yQIBbw0TMzw8JDB for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:05:56 -0700 (PDT)
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8KHpGB7012114
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 13:51:16 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p8KI5tSv246152 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 14:05:55 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p8KE5gHI027121 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:05:42 -0300
Subject: Re: [PATCH v2] xfs: Check the return value of xfs_trans_get_buf()
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110920150029.GA5239@infradead.org>
References: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
	<20110920150029.GA5239@infradead.org>
Date: Tue, 20 Sep 2011 13:05:54 -0500
Message-ID: <1316541954.9298.65.camel@chandra-lucid.austin.ibm.com>
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
Cc: Alex Elder <aelder@sgi.com>, XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2011-09-20 at 11:00 -0400, Christoph Hellwig wrote:
> On Tue, Sep 20, 2011 at 08:56:55AM -0500, Chandra Seetharaman wrote:
> > --- a/fs/xfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/xfs_attr_leaf.c
> > @@ -2948,6 +2948,8 @@ xfs_attr_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
> >  			bp = xfs_trans_get_buf(*trans,
> >  					dp->i_mount->m_ddev_targp,
> >  					dblkno, dblkcnt, XBF_LOCK);
> > +			if (!bp)
> > +				return ENOMEM;
> >  			xfs_trans_binval(*trans, bp);
> 
> xfs_trans_binval only really does anything if the buffer was in memory.
> 
> We have a few callers using that patterm, and I think they should simply
> switch to not reading the buffer in if it's not there yet, e.g.
> using something like an xfs_trans_incore.

Hi Christoph,

I do not understand. Can you elaborate on what needs to be done.

Thanks

Chandra
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
