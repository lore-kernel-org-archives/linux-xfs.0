Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 12:02:58 -0700 (PDT)
Received: from mail.parisc-linux.org ([192.25.206.14])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6GJ2rbm004505
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 12:02:54 -0700
Date: Mon, 16 Jul 2007 13:02:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] VFS: data=ordered  (was: [Advocacy] Re: 3ware 9650 tips)
Message-ID: <20070716190254.GP13826@parisc-linux.org>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <200707162040.00062.a1426z@gawab.com> <20070716174801.GM13826@parisc-linux.org> <200707162128.08397.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707162128.08397.a1426z@gawab.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Al Boldi <a1426z@gawab.com>
Cc: "Bryan J. Smith" <b.j.smith@ieee.org>, Joshua Baker-LePain <jlb17@duke.edu>, David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Mon, Jul 16, 2007 at 09:28:08PM +0300, Al Boldi wrote:
> Well, conceptually it sounds like a piece of cake, technically your guess is 
> as good as mine.  IIRC, akpm once mentioned something like this.

How much have you looked at the VFS?  There's nothing journalling-related
in the VFS right now.  ext3 and XFS share no common journalling code,
nor do I think that would be possible, due to the very different concepts
they have of journalling.

Here's a good hint:

$ find fs -type f |xargs grep -l journal_start
fs/ext3/acl.c
fs/ext3/inode.c
fs/ext3/ioctl.c
fs/ext3/namei.c
fs/ext3/resize.c
fs/ext3/super.c
fs/ext3/xattr.c
fs/ext4/acl.c
fs/ext4/extents.c
fs/ext4/inode.c
fs/ext4/ioctl.c
fs/ext4/namei.c
fs/ext4/resize.c
fs/ext4/super.c
fs/ext4/xattr.c
fs/jbd/journal.c
fs/jbd/transaction.c
fs/jbd2/journal.c
fs/jbd2/transaction.c
fs/ocfs2/journal.c
fs/ocfs2/super.c

JBD and JBD2 provide a journalling implementation that ext3, ext4 and
ocfs2 use.  Note that XFS doesn't, it has its own journalling code.

If you want XFS to support data=ordered, talk to the XFS folks.  Or
start picking through XFS yourself, of course -- you do have the source
code.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
