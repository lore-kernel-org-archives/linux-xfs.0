Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 10:32:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3OHWEfB008448
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 10:32:15 -0700
Message-ID: <462E3DEA.1070907@sandeen.net>
Date: Tue, 24 Apr 2007 12:27:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: review: allocate alloc args
References: <20070419073216.GT48531920@melbourne.sgi.com> <20070423212201.GB13572@infradead.org> <20070423223257.GM32602149@melbourne.sgi.com>
In-Reply-To: <20070423223257.GM32602149@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Mon, Apr 23, 2007 at 10:22:01PM +0100, Christoph Hellwig wrote:

>> I don't like doing even more dynamic allocations that deep
>> down in the stack.
> 
> I'm not a big fan of it either, but I don't really see any other
> option here. We need a bunch of temporary space for structures
> *somewhere*, and if there isn't enough stack space then it's
> got to come frm somewhere else.

How about a global array of such structures which can be accessed as
needed.  :)

/me runs

I think Christoph is on the right track here; find ways to make the
functions use less stack down the chain, either by breaking them up,
breaking up the large structures into what's actually needed, or
something along those types of refactoring lines... I'm so burned out on
this stuff though.  :)

-Eric
