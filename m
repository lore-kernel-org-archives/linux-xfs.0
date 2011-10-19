Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9J9hvto174512 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 04:43:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67BA91D9968
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 02:43:57 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AvfdGKiARlghcNlH for <xfs@oss.sgi.com>;
	Wed, 19 Oct 2011 02:43:57 -0700 (PDT)
Date: Wed, 19 Oct 2011 05:43:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] 265: Functional test case for the btrfs
	de-fragmentation
Message-ID: <20111019094356.GC3083@infradead.org>
References: <20111013005652.GM3159@dastard>
	<1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
	<1318919336-32206-3-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318919336-32206-3-git-send-email-Anand.Jain@oracle.com>
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
To: Anand Jain <Anand.Jain@oracle.com>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Oct 18, 2011 at 02:28:55PM +0800, Anand Jain wrote:
> To verify the btrfs de-fragmentation does not fail.

Any reason you can't simply fold btrfs defragmentation testing into
the existing common defragmentation test (218)?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
