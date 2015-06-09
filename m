Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 56F8C7F84
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2015 18:52:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 268FA8F8064
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2015 16:52:03 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	OyXcBJj2gxOMBBCV for <xfs@oss.sgi.com>;
	Tue, 09 Jun 2015 16:52:01 -0700 (PDT)
Date: Wed, 10 Jun 2015 09:51:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: simplify transaction commit and cancel interfaces V2
Message-ID: <20150609235159.GT9143@dastard>
References: <1433335796-23445-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433335796-23445-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jun 03, 2015 at 02:49:51PM +0200, Christoph Hellwig wrote:
> Changes since V1:
>   - rebased to todays for-next branch
>   - fix the inverted regrant logic in path 4
>     (the full series was already corrent in the previous version)

Hi Christoph, with this series now committed to the kernel code, can
you port it to the xfsprogs codebase? The for-next branch of the
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git tree woul dbe
the best target as it should mostly just apply to the libxfs/ side
of things. Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
