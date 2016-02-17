Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C4C07CA3
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 02:33:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AC95DAC001
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 00:33:13 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HEcctY1Bk2gUyDL8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 00:33:10 -0800 (PST)
Date: Wed, 17 Feb 2016 00:33:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/15] xfs: move v1 inode conversion to xfs_inode_from_disk
Message-ID: <20160217083308.GA11766@infradead.org>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
	<1455693652-3899-12-git-send-email-david@fromorbit.com>
	<20160217073204.GB16363@infradead.org>
	<20160217074821.GD19486@dastard> <20160217083000.GG19486@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160217083000.GG19486@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Feb 17, 2016 at 07:30:00PM +1100, Dave Chinner wrote:
> > Yeah, probably. I'll have to look at this a bit closer - I think I
> > assumed that we're always going to have v2 inode format here (like
> > we do in the kernel), but that may not be true. I'll have a closer
> > look.
> 
> having a closer look, the XFS_SB_VERSION_NLINKBIT that is set here
> in sbversion is never used, so I just removed it. I also changed it
> back to using the converted in-memory link count so it's always
> going to be correct now. Now it is just:
> 
> +       setlink_inode(id, xino.i_d.di_nlink, type == DBM_DIR, security);

Great.  With that and the other nitpicks address:

Reviewed-by: Christoph Hellwig <hch@lst.de>

for the whole series.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
