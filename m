Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A8A829DF7
	for <xfs@oss.sgi.com>; Sat, 15 Mar 2014 21:39:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1573E304032
	for <xfs@oss.sgi.com>; Sat, 15 Mar 2014 19:39:35 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id B858Ta5RSGip5qdY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 15 Mar 2014 19:39:33 -0700 (PDT)
Date: Sun, 16 Mar 2014 02:39:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: fs corruption exposed by "xfs: increase prealloc size to double
	that of the previous extent"
Message-ID: <20140316023931.GR18016@ZenIV.linux.org.uk>
References: <20140315210216.GP18016@ZenIV.linux.org.uk>
	<20140316022105.GQ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140316022105.GQ18016@ZenIV.linux.org.uk>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Sun, Mar 16, 2014 at 02:21:05AM +0000, Al Viro wrote:
> On Sat, Mar 15, 2014 at 09:02:16PM +0000, Al Viro wrote:
> 
> > And that's essentially what makes generic/263 complain.  Note, BTW, that
> > fallocate and hole-punching is irrelevant - test in generic/263 steps into
> > those, but the same thing happens with these operations disabled (by -F -H).
> > 
> > I've found the thread from last June where you've mentioned generic/263
> > regression; AFAICS, Dave's comments there had been wrong...
> 
> BTW, experimenting with that thing shows that junk in the tail of the page
> actually comes from some unused sectors on the same device.  So it's an
> information leak at the very least - I have seen it pick bits and pieces of
> previously removed files that way.

Hrm...  s/unused/not zeroed out/, actually - block size is 4K.  So we have
an empty file extended by ftruncate(), then mmap+msync+munmap in its tail,
then O_DIRECT write starting from a couple of blocks prior to EOF and
extending it by ~15 blocks.  New EOF is 2.5Kb off the beginning of the
(new) last block.  Then it's closed.  Remaining 1.5Kb of that last
block is _not_ zeroed out; moreover, pagefault on that page ends up
reading the entire block, the junk in the tail not getting zeroed out
in in-core copy either.  Interesting...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
