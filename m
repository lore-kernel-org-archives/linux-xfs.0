Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MEHw1r088105 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 09:17:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F090180BDAE
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 07:17:55 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lf9OFnvwEJr3ETtc for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2011 07:17:55 -0700 (PDT)
Date: Fri, 22 Jul 2011 10:17:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Message-ID: <20110722141753.GA19681@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
	<1311292237-4155-2-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311292237-4155-2-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Jul 21, 2011 at 07:50:36PM -0400, Theodore Ts'o wrote:
> The tree currently will blow out with a build failure if -DDEBUG is
> specified.

This still doesn't make sense to me.  libxfs explicily overrides
DEBUG in the makefile:

# don't try linking xfs_repair with a debug libxfs.
DEBUG = -DNDEBUG

we really need to figure out why your enviroment doesn't pick this
up, especially as we've never seen that report from anybody else.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
