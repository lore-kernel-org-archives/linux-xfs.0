Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SJtiMV142483 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 14:55:44 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	kDmHojZ0sW2nCKgP (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Aug 2012 12:56:35 -0700 (PDT)
Date: Tue, 28 Aug 2012 15:56:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/10] xfstests: rename USE_BIG_LOOPFS to be more generic
Message-ID: <20120828195634.GB22845@infradead.org>
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
	<1343291989-14987-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1343291989-14987-3-git-send-email-david@fromorbit.com>
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

On Thu, Jul 26, 2012 at 06:39:41PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> USE_BIG_LOOPFS is really misnamed - it can be used on real devices just as
> easily as loop devices. It really means we are testing a large scratch device
> and that we should enable the special filesystem filling and checking options
> that enable xfstests to be run sanely on large XFS filesystems.

Looks fine, even if I don't like the new name too much either.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
