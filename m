Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OHmqoV059411 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 11:48:52 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	pViWHKLxGL7CvtqE (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 09:48:51 -0800 (PST)
Date: Tue, 24 Jan 2012 12:48:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 2/4] Define a new function xfs_inode_dquot()
Message-ID: <20120124174850.GE9853@infradead.org>
References: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173130.31546.80744.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120123173130.31546.80744.sendpatchset@chandra-lucid.austin.ibm.com>
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
Cc: xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 11:31:30AM -0600, Chandra Seetharaman wrote:
> Define a new function xfs_inode_dquot() that takes a inode pointer
> and a disk quota type and returns the quota pointer for the specified
> quota type.
> 
> This simplifies the xfs_qm_dqget() error path significantly.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
> +{
> +	type &= XFS_DQ_ALLTYPES;
> +	switch(type) {

Same style nitpick as for the last patch.

Btw, instead of masking out XFS_DQ_ALLTYPES first this would be more
readable as:

	switch (type & XFS_DQ_ALLTYPES) {

(that also applies to the previous patch).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
