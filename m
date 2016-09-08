Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E0387CA0
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 15:57:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E35568F8052
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 13:57:38 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id mv1ltFBf3N1bFCCA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 Sep 2016 13:57:36 -0700 (PDT)
Date: Thu, 8 Sep 2016 21:57:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
	detected
Message-ID: <20160908205732.GA3088@ZenIV.linux.org.uk>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
	<1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
	<20160903003919.GI30056@dastard>
	<1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
	<20160908175632.GH2356@ZenIV.linux.org.uk>
	<CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
	<20160908204450.GJ2356@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160908204450.GJ2356@ZenIV.linux.org.uk>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 09:44:50PM +0100, Al Viro wrote:
> On Thu, Sep 08, 2016 at 11:12:33AM -0700, Linus Torvalds wrote:
> 
> > So the XFS model *requires* that XFS_IOLOCK to be outside all the operations.
> > 
> > But then in iter_file_splice_write we have the other ordering.
> > 
> > Now, xfs could do a wrapper for ->splice_write() like it used to, and
> > have that same "take the xfs lock around the call to
> > iter_file_splice_write(). That was my first obvious patch.
> > 
> > I threw it out because that's garbage too: then we end up doing
> > ->write_iter(), which takes the xfs_rw_ilock() again, and would
> > immediately deadlock *there* instead.
> > 
> > So the problem really is that the vfs layer seems to simply not allow
> > the filesystem to do any locking around the generic page cache helper
> > functions. And XFS really wants to do that.
> 
> Why *have* ->splice_read() there at all?  Let's use its ->read_iter(), where
> it will take its lock as it always did for read.
> 
> All we need is a variant of __generic_file_splice_read() that would pass
> a new kind of iov_iter down to filesystem's own ->read_iter().  And let that
> guy do whatever locking it wants.  It will end up doing a sequence of
> copy_page_to_iter() and, possibly, copy_to_iter() (XFS one would only do the
> former).  So let's add an iov_iter flavour that would simply grab a reference
> to page passed to copy_page_to_iter() and allocate-and-copy for copy_to_iter().
> As the result, you'll get an array of <page, offset, count> triples - same
> as you would from the existing __generic_file_splice_read().  Pages already
> uptodate, with all readahead logics done as usual, etc.
> 
> What else do we need?  Just feed the resulting triples into the pipe and
> that's it.  Sure, they can get stale by truncate/punchhole/whatnot.  So
> they can right after we return from xfs_file_splice_read()...
> 
> Moreover, I don't see why we need to hold pipe lock the actual call of
> ->read_iter().  Right now we only grab it for "feed into pipe buffers"
> part.  Objections?

PS: take a look at how much of do_generic_file_read() logics is kinda-sorta
open-coded in __generic_file_splice_read(); readahead stuff, etc.  It also
assumes that filesystem needs no extra locking for playing with pagecache,
etc.  That's exactly why XFS ends up having to do a wrapper for that sucker
and why we get all this headache.  Why bother, when we already have a method
that turns "read that much from this offset in this file" into a sequence of
"take that many bytes from that offset in this page" and "take that many
bytes from that buffer"?  It doesn't even need to be a ->splice_read() instance
- just a function called by do_splice_to() if ->read_iter() is present.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
