Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933217AbdCaQn1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 12:43:27 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170331155653.GA27655@infradead.org>
References: <20170331155653.GA27655@infradead.org> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk>
Subject: Re: statx manpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29844.1490978603.1@warthog.procyon.org.uk>
Date: Fri, 31 Mar 2017 17:43:23 +0100
Message-ID: <29845.1490978603@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, mtk.manpages@gmail.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-man@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> Quoting the rendered page below:
> 
> >   Invoking statx():
>  
>  This is an odd header for a man page.  Usually this would start as
> 
> DESCRIPTION
> 
> (in bold).

Yes, I know.  But it seems to make more sense this way round.  Putting the
struct definition before the description of how to access it means that I can
refer to it in the definitions of the flags that you OR into the mask and
means you get to the struct much faster.  Maybe I should put it under the
SYNOPSIS section?

> >       [*] By absolute path.
> 
> Odd way to enumerate in a man page - I'll leave it to the linux-man regulars
> to point out the right way, because I don't know it off-hand.

Me neither.

> >       AT_EMPTY_PATH (since Linux 2.6.39)
> 
> All these have been there since statx was added, so we can remove the
> annotation.

You're not the first to note this.  I've already taken that out.

> >           STATX_BASIC_STATS   [The stuff in the normal stat struct]
> 
> Please enumerate the actual fields.

They're enumerated immediately prior.  I've changed it to:

	STATX_BASIC_STATS   [All of the above]

> >           STATX_ALL           [All currently available stuff]
> 
> How about "All currently available fields"

Sure.

David
