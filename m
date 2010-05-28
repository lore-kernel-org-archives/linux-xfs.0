Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4S7ghSo203616 for <xfs@oss.sgi.com>; Fri, 28 May 2010 02:42:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F6AF37F960
	for <xfs@oss.sgi.com>; Fri, 28 May 2010 00:45:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AfG1BmItgyeSUEsm for
	<xfs@oss.sgi.com>; Fri, 28 May 2010 00:45:07 -0700 (PDT)
Date: Fri, 28 May 2010 03:45:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] writeback: initial tracing support
Message-ID: <20100528074500.GA14151@infradead.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-2-git-send-email-david@fromorbit.com>
	<20100527143233.836b2c47.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100527143233.836b2c47.akpm@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, May 27, 2010 at 02:32:33PM -0700, Andrew Morton wrote:
> > +#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
> 
> Could/should be implemented in C.
> 
> > +/*
> > + * We don't actually have pdflush, but this one is exported though /proc...
> > + */
> > +int nr_pdflush_threads;
> 
> So this is always zero now?
> 
> We don't want to keep it forever.  Add a
> printk_once("nr_pdflush_threads is deprecated") when someone reads it,
> remove it in 2014.

These two lines are just moved down a bit by the patch, I think any
cleanups should be left to separate patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
