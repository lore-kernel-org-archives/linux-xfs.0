Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KKcvgS107974 for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 15:38:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFB5E37414F
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:39:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CpecnIhUZVMeAcXt for
	<xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:39:39 -0700 (PDT)
Date: Mon, 20 Jul 2009 16:39:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_metadump: Allow operation on frozen filesystems
Message-ID: <20090720203939.GA5517@infradead.org>
References: <4A64C063.2070807@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A64C063.2070807@sandeen.net>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On Mon, Jul 20, 2009 at 02:07:15PM -0500, Eric Sandeen wrote:
> The xfs_metadump manpage says that it works on a frozen filesystem,
> but in reality it does not, and fails because the fs still looks
> mounted & writable.
> 
> I don't think we have a way to test for frozen (!) so add a -F 
> option which essentially overrides the xfs_db "-i" option with
> a later "-r" which is more forgiving.

Hmm, that feels a bit dagerous to me.  What about just adding an
option to xfs_metadump to freeze the filesystem itself before performing
the dump and then unfreeze it when done?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
