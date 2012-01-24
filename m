Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OIHRpS062081 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 12:17:27 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	gDExBYgW5Z6e9QPB (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 10:02:18 -0800 (PST)
Date: Tue, 24 Jan 2012 13:02:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove unecessary AIL push wakeups
Message-ID: <20120124180215.GC23671@infradead.org>
References: <20120113013028.6802d878@ustc>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120113013028.6802d878@ustc>
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
To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc: elder@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jan 13, 2012 at 01:30:28AM +0800, JiSheng Zhang wrote:
> 
> In commit 0030807c66("xfs: revert to using a kthread for AIL pushing"),
> AIL pushing is revert back to use a kthread. But unfortunately, it
> introduced a regression: there are unnecessary AIL push wakeups during
> idle, ~20 wakeups/s. This change remove the wakeups by reverting a bit
> more: set "tout" value as zero during idle.
> 
> Signed-off-by: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>

Looks fine, although I'm a bit worried that I don't have the setup to
reproduce the issue that the patch addressed any more and we might
regress here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
