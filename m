Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB76ZDWn048119 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 00:35:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1E6F1D37829
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 22:35:10 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	sjrbOb2cFbNwp9xL for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 22:35:10 -0800 (PST)
Date: Wed, 7 Dec 2011 01:35:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC, PATCH 0/12] xfs: compound buffers for directory blocks
Message-ID: <20111207063508.GA13931@infradead.org>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323238703-13198-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 07, 2011 at 05:18:11PM +1100, Dave Chinner wrote:
> The series passes xfstests on 4k/4k, 4k/512b, 64k/4k and 64k/512b
> (dirblksz/fsblksz) configurations without any new regressions, and
> survives 100 million inode fs_mark benchmarks on a 17TB filesystem
> using 4k/4k, 64k/512b and 64k/512b configurations.

Do you have any benchmark numbers showing performance improvements
for the large directory block case?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
