Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Apr 2007 22:26:08 -0700 (PDT)
Received: from smtp102.sbc.mail.mud.yahoo.com (smtp102.sbc.mail.mud.yahoo.com [68.142.198.201])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3U5Q3fB024514
	for <xfs@oss.sgi.com>; Sun, 29 Apr 2007 22:26:04 -0700
Date: Sun, 29 Apr 2007 22:25:59 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070430052559.GA13145@tuatara.stupidest.org>
References: <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430004702.GM32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Mon, Apr 30, 2007 at 10:47:02AM +1000, David Chinner wrote:

> For FA_ALLOCATE, it's supposed to change the file size if we
> allocate past EOF, right?

I would argue no.  Use truncate for that.

> For FA_DEALLOCATE, does it change the filesize at all?

Same as above.

> Or does
> it just punch a hole in the file?

Yes.

> FWIW, we definitely need a FA_PREALLOCATE mode (FA_ALLOCATE but does
> not change file size) so we can preallocate beyond EOF for apps
> which use O_APPEND (i.e. changing file size would cause problems for
> them).

FA_ALLOCATE should be able to allocate past-EOF I would argue.
