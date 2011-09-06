Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86E2iu7082863 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 09:02:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3525D13C6F8D
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2011 07:06:38 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GsiuUAObMGkPoFMf for <xfs@oss.sgi.com>;
	Tue, 06 Sep 2011 07:06:38 -0700 (PDT)
Date: Tue, 6 Sep 2011 10:02:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix possible overflow in xfs_ioc_trim()
Message-ID: <20110906140238.GA11643@infradead.org>
References: <1315233205-27093-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315233205-27093-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Sep 05, 2011 at 04:33:25PM +0200, Lukas Czerner wrote:
> In xfs_ioc_trim it is possible that start+len might overflow. Fix it by
> decrementing the len so that start+len equals to the file system size in
> the worst case.

The idea of the check looks reasonable, but I think it needs to be done
a bit different.  Was this caught by the new testcase you just sent?

> +	xfs_fsblock_t		max_blks =  XFS_MAX_DBLOCKS(&(mp->m_sb));

XFS_MAX_DBLOCKS is the maximum number of blocks that the given
geometry could support.  But the last AG could be shorter than the
others.  I think you really want to check against mp->m_sb.sb_dblocks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
