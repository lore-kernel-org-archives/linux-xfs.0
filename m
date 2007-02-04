Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Feb 2007 13:57:31 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l14LvO3c011236
	for <xfs@oss.sgi.com>; Sun, 4 Feb 2007 13:57:26 -0800
Subject: Re: Review: freezing sometimes leaves the log dirty
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070202114623.GA23187@infradead.org>
References: <20070130220326.GM33919298@melbourne.sgi.com>
	 <20070202114623.GA23187@infradead.org>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 08:56:55 +1100
Message-Id: <1170626215.18017.394.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Fri, 2007-02-02 at 11:46 +0000, Christoph Hellwig wrote:
> On Wed, Jan 31, 2007 at 09:03:26AM +1100, David Chinner wrote:
> > +	/* flush inodes and push all remaining buffers out to disk */
> > +	xfs_quiesce_fs(mp);
> > +
> > +	BUG_ON(atomic_read(&mp->m_active_trans) > 0);
> > +
> 
> xfs_vfsops.c is considered common code, so you should probably use
> ASSERT here, not BUG_ON.

There's also an ASSERT_ALWAYS macro IIRC, if you want the equivalent
functionality of BUG_ON (i.e. always check).

cheers.

-- 
Nathan
