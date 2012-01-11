Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BBk4xb162463 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 05:46:05 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	wkHrWkyowwJn9UO5 for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 03:46:03 -0800 (PST)
Date: Wed, 11 Jan 2012 06:46:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 271: use xfs_io to truncate file instead of
	truncate(1)
Message-ID: <20120111114603.GF14423@infradead.org>
References: <1326213469-22687-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1326213469-22687-1-git-send-email-guaneryu@gmail.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 11, 2012 at 12:37:48AM +0800, Eryu Guan wrote:
> Distros(eg. RHEL5) with older version of coreutils have no truncate(1)
> command. Use xfs_io instead to avoid "command not found" failures.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
