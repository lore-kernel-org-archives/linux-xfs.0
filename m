Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8BvglW029185 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 05:57:43 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YLwT3NQJh2hjrBtF (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 04:00:09 -0800 (PST)
Date: Sat, 8 Dec 2012 07:00:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: Ensure cmdline geometry puts mkfs.xfs into
	multidisk mode
Message-ID: <20121208120007.GB4430@infradead.org>
References: <50ABB115.9070905@sandeen.net>
	<20121121095636.GC23339@infradead.org>
	<50C115E8.9090106@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50C115E8.9090106@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Ben England <bengland@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Dec 06, 2012 at 04:02:16PM -0600, Eric Sandeen wrote:
> Ensure that when mkfs.xfs is invoked with commandline geometry, it
> triggers multidisk mode and creates more AGs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> Maybe this should also test device-specified geometry, but not sure
> how to do that easily within xfstests, any ideas?

That would involved scsi_debug so that we could set them up.  We had
several ideas how to use scsi debug for these sort of tests but never
really bothered to do it.  If you have some spare cycles I'd love to see
this sort of tests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
