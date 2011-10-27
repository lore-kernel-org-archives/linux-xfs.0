Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9RINOBR112773 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 13:23:24 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5B371CC297B
	for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 11:23:23 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id ajKTAJNVhbt8eLOa for
	<xfs@oss.sgi.com>; Thu, 27 Oct 2011 11:23:23 -0700 (PDT)
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Oct 2011 14:14:30 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9RICDHM230408 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 14:12:13 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p9RICCPt008748 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 14:12:13 -0400
Subject: Re: [RFC v2 PATCH 1/5] xfs: Prep work for supporting both pquota
	and gquota.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20111027161724.GA30209@infradead.org>
References: <20111026212150.6513.38058.sendpatchset@chandra-lucid.austin.ibm.com>
	<20111026212158.6513.17142.sendpatchset@chandra-lucid.austin.ibm.com>
	<20111027161724.GA30209@infradead.org>
Date: Thu, 27 Oct 2011 13:12:11 -0500
Message-ID: <1319739131.1959.91.camel@chandra-lucid.austin.ibm.com>
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

Sure.

Will submit this as a separate set, so that it can go in faster.

Chandra
On Thu, 2011-10-27 at 12:17 -0400, Christoph Hellwig wrote:
> On Wed, Oct 26, 2011 at 04:21:58PM -0500, Chandra Seetharaman wrote:
> > Define few macros, inline functions, and change interface in
> > preparation for allowing pquota and gquota to be used together.
> 
> Looks good, but I'd really prefer to split this up further:
> 
>  - one patch for adding xfs_inode_dquot
>  - one patch for adding XFS_IS_TYPE_QUOTA_ON
>    (which I'd rather make an inline and call xfs_this_quota_on)
>  - one for passing the mount structure to xfs_sb_from_disk
>  - one for the quota flags changes.
> 
> All of these also should have a good changelog, most importantly the flag
> changes.  If you can repost just these changes relatively soon please do
> so, as I have a huge series for the quota code that should go into the
> 3.2 tree which I need to rebase anyway, and I'd like to do it on top of
> your changes.
> 
> > -	xfs_sb_t	*to,
> > +	xfs_mount_t	*mp,
> >  	xfs_dsb_t	*from)
> >  {
> > +	xfs_sb_t	*to = &mp->m_sb;
> > +
> 
> For code you touch please always use the struct versions instead of
> the typedefs for lines you change anyway or add.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
