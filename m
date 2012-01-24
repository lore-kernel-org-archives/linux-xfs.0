Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OJg5Yw069395 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 13:42:06 -0600
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id 8ixsC2tFSlZbYBeI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 11:42:04 -0800 (PST)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 24 Jan 2012 12:42:03 -0700
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 851DB19D8048
	for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 12:41:40 -0700 (MST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q0OJfdVp3199102
	for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 14:41:39 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q0OJfdk1003894 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 14:41:39 -0500
Subject: Re: [RFC PATCH 2/4] Define a new function xfs_inode_dquot()
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20120124174850.GE9853@infradead.org>
References: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173130.31546.80744.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120124174850.GE9853@infradead.org>
Date: Tue, 24 Jan 2012 13:41:36 -0600
Message-ID: <1327434096.2213.18.camel@chandra-lucid.austin.ibm.com>
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

On Tue, 2012-01-24 at 12:48 -0500, Christoph Hellwig wrote:
> On Mon, Jan 23, 2012 at 11:31:30AM -0600, Chandra Seetharaman wrote:
> > Define a new function xfs_inode_dquot() that takes a inode pointer
> > and a disk quota type and returns the quota pointer for the specified
> > quota type.
> > 
> > This simplifies the xfs_qm_dqget() error path significantly.
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> > +static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
> > +{
> > +	type &= XFS_DQ_ALLTYPES;
> > +	switch(type) {
> 
> Same style nitpick as for the last patch.
> 
> Btw, instead of masking out XFS_DQ_ALLTYPES first this would be more
> readable as:
> 
> 	switch (type & XFS_DQ_ALLTYPES) {
> 
> (that also applies to the previous patch).
> 

Will fix both of these in the next version.

Thanks for the review Christoph.

Chandra


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
