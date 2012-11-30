Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAUG3vKK189271 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 10:03:57 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DRukTLGuVzIpvv61 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 Nov 2012 08:06:16 -0800 (PST)
Date: Fri, 30 Nov 2012 11:06:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fsck scratch device if it got used
Message-ID: <20121130160616.GD5667@infradead.org>
References: <50B7B0AB.6040406@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B7B0AB.6040406@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 29, 2012 at 12:59:55PM -0600, Eric Sandeen wrote:
> This will cause the $SCRATCH_DEV to be fscked if it
> was used in the prior test.  Without this I don't
> think it gets done unless specifically requested
> by the test.

This one looks good.

> Also recreate lost+found/ in one test so that e2fsck
> doesn't complain.

This one I can't make any sense of.  Care to send it separately with a
good explanation?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
