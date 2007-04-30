Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Apr 2007 23:01:35 -0700 (PDT)
Received: from smtp107.sbc.mail.mud.yahoo.com (smtp107.sbc.mail.mud.yahoo.com [68.142.198.206])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3U61UfB028760
	for <xfs@oss.sgi.com>; Sun, 29 Apr 2007 23:01:32 -0700
Date: Sun, 29 Apr 2007 23:01:26 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070430060126.GA15038@tuatara.stupidest.org>
References: <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com> <20070430052559.GA13145@tuatara.stupidest.org> <20070430055632.GR32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430055632.GR32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Mon, Apr 30, 2007 at 03:56:32PM +1000, David Chinner wrote:
> On Sun, Apr 29, 2007 at 10:25:59PM -0700, Chris Wedgwood wrote:

> IIRC, the argument for FA_ALLOCATE changing file size is that
> posix_fallocate() is supposed to change the file size.

But it's not posix_fallocate; it's something more generic. glibc can
do posix_fallocate using truncate + fallocate.

> Note that the way XFS implements growing the file size after the
> allocation is via a truncate....

What's wrong with that?  That seems very reasonable.

> That's would what I did because otherwise you'd use ftruncate64().
> Without documented behaviour or an ext4 implementation, I have to
> ask what it's supposed to do, though ;)

How many *real* users are there for ext4?  Why does 'what ext4 does'
define 'the semantics'?

Surely semantics should be decided either by precedent (if there is an
existing relevant userbase) or sensible thought and some debate?
