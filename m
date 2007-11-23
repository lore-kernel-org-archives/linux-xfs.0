Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Nov 2007 12:51:34 -0800 (PST)
Received: from perches.com (DSL022.labridge.com [206.117.136.22])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lANKpSSe028464
	for <xfs@oss.sgi.com>; Fri, 23 Nov 2007 12:51:30 -0800
Subject: Re: [PATCH 9/9] Clean up open coded inode dirty checks
From: Joe Perches <joe@perches.com>
In-Reply-To: <Pine.LNX.4.64.0711231914300.12552@fbirervta.pbzchgretzou.qr>
References: <20071122004422.GO114266761@sgi.com>
	 <20071123180239.GA13229@infradead.org>
	 <Pine.LNX.4.64.0711231914300.12552@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Fri, 23 Nov 2007 11:47:31 -0800
Message-Id: <1195847251.4930.21.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Fri, 2007-11-23 at 19:16 +0100, Jan Engelhardt wrote:
> static inline bool xfs_inode_clean(const struct xfs_inode *ip)
> {
> 	if (ip->i_itemp == NULL)
> 		return true;
> 	if (!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL) &&
> 	    ip->i_update_core == NULL)
> 		return true;
> 	return false;
> }

Your code changed the test.
xfs_inode.i_update_core is an unsigned char.

I believe reordering the tests to avoid a possibly
unnecessary dereference is better.

	if (ip->i_update_core)
		return false;
	if (!ip->i_itemp)
		return true;
	return ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL;
