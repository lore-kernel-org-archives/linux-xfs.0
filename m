Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6SK5ktC008833 for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 15:05:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35F841EF0254
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 13:05:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qqHQLS6moxQEO4WM for <xfs@oss.sgi.com>;
	Thu, 28 Jul 2011 13:05:40 -0700 (PDT)
Date: Thu, 28 Jul 2011 16:05:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfstests: Add support for btrfs in 015
Message-ID: <20110728200537.GA12758@infradead.org>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
	<bebfc5c98e0fb878f55c1312d8750ce7b7f82e07.1311776403.git.sbehrens@giantdisaster.de>
	<20110728084756.GC3407@infradead.org>
	<4E31A265.5050909@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E31A265.5050909@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 28, 2011 at 07:54:45PM +0200, Stefan Behrens wrote:
> To add a 10% tolerance for btrfs was a bad idea.
> Since the output of df(1) is not yet reliable on btrfs volumes while
> data is not flushed to disk, the better implementation would be to
> either let this test fail, or to force a flush to disk before taking
> the output of df(1).
> The latter is what I have implemented now.

I don't think it's correct either.  dellalloc blocks should be included
in the statfs output, else it it is pretty pointless.  Can you send the
patch to make it generic without that adjustment for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
