Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B33AC7F58
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 12:00:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8CB388F8040
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 10:00:55 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id rAJcIUkaCFdZBHy2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 10:00:54 -0800 (PST)
Date: Tue, 4 Feb 2014 18:00:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140204180040.GI10323@ZenIV.linux.org.uk>
References: <20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<52EFC271.3090205@oracle.com>
	<20140204124409.GG10323@ZenIV.linux.org.uk>
	<20140204125220.GB12440@kmo-pixel>
	<20140204151728.GH10323@ZenIV.linux.org.uk>
	<20140204172723.GA11325@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140204172723.GA11325@lenny.home.zabbo.net>
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
To: Zach Brown <zab@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>, Dave Kleikamp <dave.kleikamp@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

On Tue, Feb 04, 2014 at 09:27:23AM -0800, Zach Brown wrote:
> I think Kent is talking about what happens after the user addresses are
> consumed.  Turning dio into more of a bio mapping and redirection engine
> would use more of the bio machinery instead of the bits that dio has
> implemented itself with state in struct dio that hangs off the bios.  I
> imagine it'd still make sense to clean up the addresses/pages arguments
> that feed that engine.  (And give another entry point that already has
> bios for callers like loop, etc.)
> 
> > BTW, folks, any suggestions about the name of that "memory stream" thing?
> > struct iov_iter really implies iterator for iovec and more generic name
> > would probably be better...  struct mem_stream would probably do if nobody
> > comes up with better variant, but it's long and somewhat clumsy...
> 
> I don't like 'stream'.  To me that sounds more strictly advancing than I
> think this'd be capable of.  Maybe something dirt simple like 'mem_vec'?
> With 'mvec_' call prefixes?

Umm...  Frankly, I would rather discourage attempts to read the same data
twice, if only on the naming level...

Case in point: commit 1c1c87 (btrfs: sanitize BTRFS_IOC_FILE_EXTENT_SAME).
I really wonder how many places have similar holes.  What used to happen
was this: we have a userland structure, with a variable-sized array hanging
off its arse.  The size of array is determined by the field in fixed-sized
header.  We copy the header in, decide what size the whole thing should have,
and do memdup_user() to bring everything in.  Very convenient, since at that
point we have a pointer to that struct-with-array in the kernel space.
Attacker manages to increase the 'desc_count' field between two
copy_from_user()... and the sucker proceeds to loop over the array in
kernel-side copy, using the ->desc_count of that copy as the upper limit
of the loop.  Oops - in the best case, that is.

Double reads really ought to raise red flags on review.  I'm not saying that
they should be hard to do (after all, the fix in that commit *does* read the
same thing twice), but it's better if they are not used without thinking.
And no, I'm not suggesting to make ioctls use iov_iter/whatnot - it's just
an example of the class of bugs.  I wouldn't be surprised to find ->write()
instances in drivers suffering the same problem...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
