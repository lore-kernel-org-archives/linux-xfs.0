Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A093B7F3F
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 20:13:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3A356AC001
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 18:13:41 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	KGGCMEuBdHIsea89 for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 18:13:40 -0700 (PDT)
Date: Tue, 13 Aug 2013 11:13:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: GRUB doesn't work on CRC enabled fs
Message-ID: <20130813011332.GU12779@dastard>
References: <20130812202924.GA354@x4>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130812202924.GA354@x4>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 12, 2013 at 10:29:24PM +0200, Markus Trippelsdorf wrote:
> Just a heads-up: GRUB currently doesn't work on a CRC enabled
> file-system. It will print the following error message:
>  "not a correct XFS inode"

Yup, that is expected. grub digs around in the on disk format, and
we changed it. So, grub won't work with v5 superblocks.

> GRUB's xfs implementation can be found here:
> http://bzr.savannah.gnu.org/lh/grub/trunk/grub/annotate/head:/grub-core/fs/xfs.c

    if (grub_strncmp ((char *) inode->magic, "IN", 2))
	  return grub_error (GRUB_ERR_BAD_FS, "not a correct XFS inode");

So it's failing a magic number test. That means it's read the wrong
location for an inode, so it's getting something badly wrong. Almost
certainly it doesn't grok the new inode format and so isn't finding
the data fork of the inode correctly.

No surprise, really, it hard codes the location and size of the
inode literal area (to 156 bytes or 9 extents) and so will not parse
anything other than a 256 byte version 2 inode correctly. It doesn't
even realise that the literal area might contain an attribute
fork, or that inodes might be larger than 256 bytes.

This pretty much sums up why grub is fundamentally broken...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
