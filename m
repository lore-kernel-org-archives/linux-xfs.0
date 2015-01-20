Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 559937F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 11:08:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 426BA304048
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 09:08:32 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id hJIKUstg0ICaYkaE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 09:08:30 -0800 (PST)
Date: Tue, 20 Jan 2015 18:08:29 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/17] quota: Add ->quota_{enable,disable} callbacks for
	VFS quotas
Message-ID: <20150120170829.GE3648@quack.suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-4-git-send-email-jack@suse.cz>
	<20150119090248.GC27474@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150119090248.GC27474@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Mon 19-01-15 01:02:48, Christoph Hellwig wrote:
> On Fri, Jan 16, 2015 at 01:47:37PM +0100, Jan Kara wrote:
> > +EXPORT_SYMBOL(dquot_quota_enable);
> 
> > +EXPORT_SYMBOL(dquot_quota_disable);
> 
> I can't find any modular users of this (in fact none outside this
> file), so I'd suggest to keep these local.
  OK, we can do that. I've exported the functions because in principle
filesystems are free to provide own .quota_enable function and then may
want to call dquot_quota_enable() from there but currently nobody needs
that so let's export them only if there are real users.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
