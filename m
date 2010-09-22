Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MIhIX9078244 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 13:43:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97176E430D9
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 11:56:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xneZY9itRMjDqVwF for
	<xfs@oss.sgi.com>; Wed, 22 Sep 2010 11:56:42 -0700 (PDT)
Date: Wed, 22 Sep 2010 14:44:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH VER 4] xfsprogs: projid32bit handling
Message-ID: <20100922184412.GB9911@infradead.org>
References: <1285177343-11108-1-git-send-email-arekm@maven.pl>
	<1285177520-11513-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285177520-11513-1-git-send-email-arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Wed, Sep 22, 2010 at 07:45:20PM +0200, Arkadiusz Mi??kiewicz wrote:
> Add projid32bit handling to userspace. mkfs is able to enable this
> feature for new filesystems. xfs_db knows what projid_lo/hi are.

Looks good except for the bstat field naming I already mentioned, and
the possibly required addition of xfs_admin support to toggling the
flag.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
