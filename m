Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 76D7A7CA0
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 07:27:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47CFA304032
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 05:27:24 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id IDWmYEEVH0aaCbvi (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 05:27:22 -0700 (PDT)
Date: Tue, 2 Aug 2016 05:27:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_quota: fall back silently if XFS_GETNEXTQUOTA fails
Message-ID: <20160802122721.GE31492@infradead.org>
References: <1470120540-15135-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470120540-15135-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Tue, Aug 02, 2016 at 02:49:00PM +0800, Zorro Lang wrote:
> After XFS_GETNEXTQUOTA feature has been merged into linux kernel and
> xfsprogs, xfs_quota use Q_XGETNEXTQUOTA for report and dump, and
> fall back to old XFS_GETQUOTA ioctl if XFS_GETNEXTQUOTA fails.
> 
> But when XFS_GETNEXTQUOTA fails, xfs_quota print a warning as
> "XFS_GETQUOTA: Invalid argument". That's due to kernel can't
> recognize XFS_GETNEXTQUOTA ioctl and return EINVAL. At this time,
> the warning is helpless, xfs_quota just need to fall back.

We'd still want to report other errors, right?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
