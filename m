Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A6F929E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 09:26:21 -0600 (CST)
Date: Mon, 18 Nov 2013 09:26:20 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix the comment explaining xfs_trans_dqlockedjoin
Message-ID: <20131118152620.GG1935@sgi.com>
References: <20131106114536.GA18548@infradead.org>
	<20131115173415.GA19381@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131115173415.GA19381@infradead.org>
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

On Fri, Nov 15, 2013 at 09:34:15AM -0800, Christoph Hellwig wrote:
> Not the most important patch ever, but I think it should still be picked
> up :)

Sure.  We'll get it in once the merge window closes.

-Ben

> On Wed, Nov 06, 2013 at 03:45:36AM -0800, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index cd2a10e..4117286 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -295,8 +295,8 @@ xfs_trans_mod_dquot(
> >  /*
> >   * Given an array of dqtrx structures, lock all the dquots associated and join
> >   * them to the transaction, provided they have been modified.  We know that the
> > - * highest number of dquots of one type - usr, grp OR prj - involved in a
> > - * transaction is 2 so we don't need to make this very generic.
> > + * highest number of dquots of one type - usr, grp and prj - involved in a
> > + * transaction is 3 so we don't need to make this very generic.
> >   */
> >  STATIC void
> >  xfs_trans_dqlockedjoin(
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
