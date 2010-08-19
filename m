Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7JC4gto170118 for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 07:04:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AF1C9198
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 05:05:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sZ1HSYvKdJvqCLkF for
	<xfs@oss.sgi.com>; Thu, 19 Aug 2010 05:05:13 -0700 (PDT)
Date: Thu, 19 Aug 2010 08:05:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
Message-ID: <20100819120512.GB9358@infradead.org>
References: <201008191312.49346@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201008191312.49346@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Thu, Aug 19, 2010 at 01:12:45PM +0200, Michael Monnerie wrote:
> The subject is a bit harsh, but overall the article says:
> XFS is slowest on creating and deleting a billion files
> XFS fsck needs 30GB RAM to fsck that 100TB filesystem.
> 
> http://lwn.net/SubscriberLink/400629/3fb4bc34d6223b32/

The creation and deletion performance is a known issue, and too a large
extent fixes by the new delaylog code.  We're not quite as fast as ext4
yet, but it's getting close.

The repair result looks a lot like the pre-3.1.0 xfsprogs repair.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
