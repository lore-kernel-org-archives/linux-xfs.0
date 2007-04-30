Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Apr 2007 22:57:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3U5vGfB027585
	for <xfs@oss.sgi.com>; Sun, 29 Apr 2007 22:57:18 -0700
Date: Mon, 30 Apr 2007 15:56:32 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070430055632.GR32602149@melbourne.sgi.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com> <20070430052559.GA13145@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430052559.GA13145@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: David Chinner <dgc@sgi.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Sun, Apr 29, 2007 at 10:25:59PM -0700, Chris Wedgwood wrote:
> On Mon, Apr 30, 2007 at 10:47:02AM +1000, David Chinner wrote:
> 
> > For FA_ALLOCATE, it's supposed to change the file size if we
> > allocate past EOF, right?
> 
> I would argue no.  Use truncate for that.

I'm going from the ext4 implementation because the semantics
have not been documented yet.

IIRC, the argument for FA_ALLOCATE changing file size is that
posix_fallocate() is supposed to change the file size. I think
that having a mode for real preallocation and another for
posix_fallocate is a valid thing to do...

Note that the way XFS implements growing the file size after the
allocation is via a truncate....

> > For FA_DEALLOCATE, does it change the filesize at all?
> 
> Same as above.
> 
> > Or does
> > it just punch a hole in the file?
> 
> Yes.

That's would what I did because otherwise you'd use ftruncate64().
Without documented behaviour or an ext4 implementation, I have to
ask what it's supposed to do, though ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
