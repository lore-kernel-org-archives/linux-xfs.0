Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58JFZtU020712 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 14:15:36 -0500
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAF07118F797
	for <xfs@oss.sgi.com>; Thu, 29 Jul 2010 20:01:00 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14])
	by cuda.sgi.com with ESMTP id 148Pt7dVn7fE842b for
	<xfs@oss.sgi.com>; Thu, 29 Jul 2010 20:01:00 -0700 (PDT)
Date: Thu, 29 Jul 2010 20:53:24 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] dio: track and serialise unaligned direct IO
Message-ID: <20100730025324.GO25774@parisc-linux.org>
References: <1280443516-14448-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280443516-14448-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, sandeen@sandeen.net, xfs@oss.sgi.com

On Fri, Jul 30, 2010 at 08:45:16AM +1000, Dave Chinner wrote:
> If we get two unaligned direct IO's to the same filesystem block
> that is marked as a new allocation (i.e. buffer_new), then both IOs will
> zero the portion of the block they are not writing data to. As a
> result, when the IOs complete there will be a portion of the block
> that contains zeros from the last IO to complete rather than the
> data that should be there.

Urgh.  Yuck.

> This is easily manifested by qemu using aio+dio with an unaligned
> guest filesystem - every IO is unaligned and fileystem corruption is
> encountered in the guest filesystem. xfstest 240 (from Eric Sandeen)
> is also a simple reproducer.
> 
> To avoid this problem, track unaligned IO that triggers sub-block zeroing and
> check new incoming unaligned IO that require sub-block zeroing against that
> list. If we get an overlap where the start and end of unaligned IOs hit the
> same filesystem block, then we need to block the incoming IOs until the IO that
> is zeroing the block completes. The blocked IO can then continue without
> needing to do any zeroing and hence won't overwrite valid data with zeros.

Urgh.  Yuck.

Could we perhaps handle this by making an IO instantiate a page cache
page for partial writes, and forcing that portion of the IO through the
page cache?  The second IO would hit the same page and use the existing
O_DIRECT vs page cache paths.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
