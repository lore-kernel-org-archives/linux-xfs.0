Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17829 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdGYF5R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2017 01:57:17 -0400
Date: Mon, 24 Jul 2017 22:56:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfsprogs commit 4944defad4ae2cbcf056207490d7c597bb92cd7c
Message-ID: <20170725055659.GC4369@magnolia>
References: <c16e39da-27dd-d35c-e9e1-463d36472a8b@gentoo.org>
 <8A0CFE17-BAB8-4CC9-8A01-BFD99F6C83FE@jabberwocky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A0CFE17-BAB8-4CC9-8A01-BFD99F6C83FE@jabberwocky.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Shaw <dshaw@jabberwocky.com>
Cc: "Jory A. Pratt" <anarchy@gentoo.org>, cmaiolino@redhat.com, xfs <linux-xfs@vger.kernel.org>

[cc xfs list]

On Sun, Jul 23, 2017 at 10:21:56AM -0400, David Shaw wrote:
> On Jul 22, 2017, at 10:13 PM, Jory A. Pratt <anarchy@gentoo.org> wrote:
> > 
> > Is there any specific reason you all have drop'd away from the posix
> > standard? This change introduces build failure as it no longer follows
> > the posix standard for stdout.
> > 
> > metadump.c:2875:10: error: assignment of read-only variable 'stdout'
> >   stdout = stderr;
> >          ^
> > metadump.c:2911:10: error: assignment of read-only variable 'stdout'
> >   stdout = outf;

Huh?  What system configuration (libc, etc.) is this?

The Open Group Base Specifications Issue 7
http://pubs.opengroup.org/onlinepubs/9699919799/functions/stdin.html
only mentions this:

    extern FILE *stderr, *stdin, *stdout;

and says that it defers to the ISO C standard.

The ISO C11 standard (draft 1570, anyway)
https://port70.net/~nsz/c/c11/n1570.txt
has this to say:

            stderr
            stdin
            stdout
    which are expressions of type ''pointer to FILE'' that point to the
    FILE objects associated, respectively, with the standard error,
    input, and output streams.

I don't see anything in there about stdout being read only, though I
suppose there's nothing in that explicitly requiring they be assignable.

<grumble> musl, isn't it...?

--D

> 
> Hi,
> 
> I think you may have meant this to go to Darrick Wong
> (darrick.wong@oracle.com), cc'd.  I reported the bug (well,
> indirectly), but Darrick was the person who fixed it.
> 
> David
> 
