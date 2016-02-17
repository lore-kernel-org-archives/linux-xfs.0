Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DED167CAD
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:32:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BE368304032
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:32:06 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rsnagzDhtr3SKmB5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:32:04 -0800 (PST)
Date: Tue, 16 Feb 2016 23:32:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/15] xfs: move v1 inode conversion to xfs_inode_from_disk
Message-ID: <20160217073204.GB16363@infradead.org>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
	<1455693652-3899-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455693652-3899-12-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Wed, Feb 17, 2016 at 06:20:48PM +1100, Dave Chinner wrote:
> +
> +	sbversion |= XFS_SB_VERSION_NLINKBIT;
> +	setlink_inode(id, be32_to_cpu(dip->di_nlink), type == DBM_DIR, security);
> +

So we always convert to v2 inodes here.  Given that's it's xfs_check
it's only in-core so harmless, but a comment here might be useful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
