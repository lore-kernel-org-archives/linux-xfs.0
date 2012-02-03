Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13GLWtZ141092 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 10:21:32 -0600
Date: Fri, 3 Feb 2012 10:21:34 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC PATCH 2/4] Define a new function xfs_inode_dquot()
Message-ID: <20120203162134.GI13095@sgi.com>
References: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173130.31546.80744.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120124174850.GE9853@infradead.org>
	<1327434096.2213.18.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1327434096.2213.18.camel@chandra-lucid.austin.ibm.com>
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

Hey Chandra,

On Tue, Jan 24, 2012 at 01:41:36PM -0600, Chandra Seetharaman wrote:
> On Tue, 2012-01-24 at 12:48 -0500, Christoph Hellwig wrote:
> > On Mon, Jan 23, 2012 at 11:31:30AM -0600, Chandra Seetharaman wrote:
> > > Define a new function xfs_inode_dquot() that takes a inode pointer
> > > and a disk quota type and returns the quota pointer for the specified
> > > quota type.
> > > 
> > > This simplifies the xfs_qm_dqget() error path significantly.
> > 
> > Looks good,
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> >
> > > +static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
> > > +{
> > > +	type &= XFS_DQ_ALLTYPES;
> > > +	switch(type) {
> > 
> > Same style nitpick as for the last patch.
> > 
> > Btw, instead of masking out XFS_DQ_ALLTYPES first this would be more
> > readable as:
> > 
> > 	switch (type & XFS_DQ_ALLTYPES) {
> > 
> > (that also applies to the previous patch).
> > 
> 
> Will fix both of these in the next version.

I'll fix them up.  No need to post again.  I also twiddled the order of
USER/GROUP/PROJ in xfs_inode_dquot to match xfs_this_quota_on.

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
