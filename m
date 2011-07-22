Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MET73m088762 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 09:29:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CED021EED1A5
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 07:29:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hrZQOeA4MsGPLRrd for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2011 07:29:06 -0700 (PDT)
Date: Fri, 22 Jul 2011 10:29:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH XFSPROGS 3/3] mkfs: Link against libuuid after liblkid
Message-ID: <20110722142905.GC19681@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
	<1311292237-4155-3-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311292237-4155-3-git-send-email-tytso@mit.edu>
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

On Thu, Jul 21, 2011 at 07:50:37PM -0400, Theodore Ts'o wrote:
> The order in which libraries are searched matters if you are using
> static libraries.  Since libblkid uses some functions from libuuid, it
> needs to come before libuuid in the link line.

Thanks, applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
