Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JIe8wX147397 for <xfs@oss.sgi.com>; Wed, 19 May 2010 13:40:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B867235C160
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 11:42:27 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id K8hgRIJVM20EWoHq for <xfs@oss.sgi.com>;
	Wed, 19 May 2010 11:42:27 -0700 (PDT)
Date: Wed, 19 May 2010 14:42:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] Fix test whether kernel supports quotas
Message-ID: <20100519184225.GA32747@infradead.org>
References: <1274276289-8839-1-git-send-email-jack@suse.cz>
	<1274276289-8839-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274276289-8839-3-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Wed, May 19, 2010 at 03:38:04PM +0200, Jan Kara wrote:
> For all 2.6 kernels presence of quota support in kernel can be detected by
> checking /proc/sys/fs/quota. This is actually more reliable than trying to
> mount a filesystem with quota options (for example because SCRATCH_DEV does
> not have to contain a filesystem type we are going to test).

It's not actually correct.  /proc/sys/fs/quota only gets registered by
fs/quota/dquot.c, which means it's not avaiable in a kernel that only
has XFS quotas.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
