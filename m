Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 10:10:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33H9qZh021739
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 10:09:53 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13114902F3A
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 10:10:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id jtIPeQXFmZWrjFKc for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 10:10:16 -0700 (PDT)
Date: Thu, 3 Apr 2008 13:09:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] XFS: ASCII case-insensitive support
Message-ID: <20080403170945.GA22385@infradead.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062708.071715758@chook.melbourne.sgi.com> <20080403015331.GP103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403015331.GP103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, Apr 03, 2008 at 11:53:31AM +1000, David Chinner wrote:
> > +	if (xfs_sb_version_hasoldci(&mp->m_sb))
> > +		sb->s_root->d_op = &xfs_ci_dentry_operations;
> 
> Write a helper function for this: xfs_set_ci_dentry_ops(mp, dentry)
> rather than exporting the xfs_ci_dentry_operations structure.

yes, please.  also the export ops calling d_alloc_anon need to update
the dentry ops aswel and should be using this one.

> > +#define XFS_SB_VERSION_OLDCIBIT		0x4000	/* ASCII only case-insens. */
> >  #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
> >  #define	XFS_SB_VERSION_OKSASHFBITS	\
> 
> Whitespace. 
> 
> But it's a shame you're being sensible about this - I kinda liked
> the Irix name for this feature (XFS_SB_VERSION_BORGBIT). :)

So what exactly prevents us from using it in Linux?  please use the
old name.
