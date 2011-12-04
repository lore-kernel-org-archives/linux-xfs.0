Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB4LExNj058712 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 15:15:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C1481563226
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 13:14:56 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	uk1xCDfM5hCUY5Ly for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 13:14:56 -0800 (PST)
Date: Sun, 4 Dec 2011 16:14:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfstests: add --largefs check option
Message-ID: <20111204211454.GA13000@infradead.org>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
	<1321875088-30801-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1321875088-30801-2-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 21, 2011 at 10:31:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Make it easier to check large filesystems quickly by adding a
> --large-fs option to check to turn on shortcuts for large scratch
> device filesystem testing.
> 
> Also, reject invalid command line options with a usage message.

Looks good, except that the help text for it doesn't look overly useful.
I don't think we "optimise" for large filesystems, we simply fill most
of it, which is what the documentation should mention.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
