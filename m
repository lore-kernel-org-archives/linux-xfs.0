Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBFC6otT199050 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 06:06:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A41E1CCCCC0
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 04:08:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LQ13HFLELeItFaFh for
	<xfs@oss.sgi.com>; Wed, 15 Dec 2010 04:08:43 -0800 (PST)
Date: Wed, 15 Dec 2010 07:08:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfstests: pwrite hang when writing from mmaped buffer
	of the same page
Message-ID: <20101215120840.GA29650@infradead.org>
References: <1292304018-10827-1-git-send-email-xin.zhong@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292304018-10827-1-git-send-email-xin.zhong@intel.com>
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
To: "Zhong, Xin" <xin.zhong@intel.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 14, 2010 at 01:20:18PM +0800, Zhong, Xin wrote:
> The problem is found in meego testing on btrfs:
> http://bugs.meego.com/show_bug.cgi?id=6672
> 
> Reviewed-by: Hellwig, Christoph <hch@infradead.org> and Chinner, Dave <david@fromorbit.com>
> Signed-off-by: Zhong, Xin <xin.zhong@intel.com>

Thanks, the new patch looks good.  I'll fix up the rewiewed-by line to
be two separate ones, and move the variable declarations to the top of
the main functions as pointed out by Dave and will commit it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
