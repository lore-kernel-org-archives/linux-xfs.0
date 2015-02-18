Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EBFE729E01
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 11:18:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BB05330406B
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 09:18:05 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 0O0t5xJDg2hjF2Zv (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 09:18:03 -0800 (PST)
Date: Wed, 18 Feb 2015 18:17:58 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [Cluster-devel] [PATCH 6/8] quota: Make ->set_info use structure
	with neccesary info to VFS and XFS
Message-ID: <20150218171758.GB11951@quack.suse.cz>
References: <1424267274-11836-1-git-send-email-jack@suse.cz>
	<1424267274-11836-7-git-send-email-jack@suse.cz>
	<20150218165334.GB29465@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150218165334.GB29465@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed 18-02-15 08:53:34, Christoph Hellwig wrote:
> On Wed, Feb 18, 2015 at 02:47:52PM +0100, Jan Kara wrote:
> > Change ->set_info to take new qc_info structure which contains all the
> > necessary information both for XFS and VFS. Convert Q_SETINFO handler
> > to use this structure.
...
> > +/* Structure for communicating via ->set_info */
> > +struct qc_info {
> > +	int i_fieldmask;	/* mask of fields to change in ->set_info() */
> > +	unsigned int i_flags;		/* Flags QCI_* */
> > +	unsigned int i_spc_timelimit;	/* Time after which space softlimit is
> > +					 * enforced */
> > +	unsigned int i_ino_timelimit;	/* Ditto for inode softlimit */
> > +	unsigned int i_rt_spc_timelimit;/* Ditto for real-time space */
> > +	unsigned int i_spc_warnlimit;	/* Limit for number of space warnings */
> > +	unsigned int i_ino_warnlimit;	/* Limit for number of inode warnings */
> > +	unsigned int i_rt_spc_warnlimit;	/* Ditto for real-time space */
> > +};
> 
> What does the i_ prefix stand for?
  It stands for info. I can change it e.g. to qci_ for quotactl info if you
think that would be better...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
