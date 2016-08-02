Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 11BFE7CA7
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:14:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D6736304032
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 06:14:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Cr8RkBWhfox4DiSb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 06:14:29 -0700 (PDT)
Date: Tue, 2 Aug 2016 21:14:27 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs_quota: fall back silently if XFS_GETNEXTQUOTA fails
Message-ID: <20160802131427.GD16413@zlang.usersys.redhat.com>
References: <1470120540-15135-1-git-send-email-zlang@redhat.com>
	<20160802122721.GE31492@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160802122721.GE31492@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Tue, Aug 02, 2016 at 05:27:21AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 02, 2016 at 02:49:00PM +0800, Zorro Lang wrote:
> > After XFS_GETNEXTQUOTA feature has been merged into linux kernel and
> > xfsprogs, xfs_quota use Q_XGETNEXTQUOTA for report and dump, and
> > fall back to old XFS_GETQUOTA ioctl if XFS_GETNEXTQUOTA fails.
> > 
> > But when XFS_GETNEXTQUOTA fails, xfs_quota print a warning as
> > "XFS_GETQUOTA: Invalid argument". That's due to kernel can't
> > recognize XFS_GETNEXTQUOTA ioctl and return EINVAL. At this time,
> > the warning is helpless, xfs_quota just need to fall back.
> 
> We'd still want to report other errors, right?

Yes. This patch will make xfs_quota's report and dump command report
nothing if XFS_GETNEXTQUOTA fails and falls back to XFS_GETQUOTA.

But if XFS_GETQUOTA fails, it'll report errors.

As I mentioned in email, we don't report errors if XFS_GETNEXTQUOTA
fails, or we don't report errors if kernel has no XFS_GETNEXTQUOTA
feature? The first one won't report any errors from XFS_GETNEXTQUOTA call,
include kernel has no this feature. 

So:
"cmd == XFS_GETQUOTA" or "!(cmd == XFS_GETNEXTQUOTA && errno == EINVAL)"

I think they all make sense. Do you have any suggestions?

Thanks,
Zorro

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
