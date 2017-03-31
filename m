Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52390 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933149AbdCaP4z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 11:56:55 -0400
Date: Fri, 31 Mar 2017 08:56:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: statx manpage
Message-ID: <20170331155653.GA27655@infradead.org>
References: <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10435.1488907375@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-man@vger.kernel.org

On Tue, Mar 07, 2017 at 05:22:55PM +0000, David Howells wrote:
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > This would be great to have in 4.11 together with the initial statx
> > implementation.  But until I see documentation and testcases for statx
> > I don't really feel comfortable reviewing anything related to it.
> 
> Well, since you asked for documentation, here's a manual page for you to
> review:-)
> 
> Note that as it isn't in glibc yet, I've left out all the
> set-this-and-that-#define-to-make-it-appear stuff except where it is pertinent
> to particular constants.

I think we'll initially need to make this a section 2 page as libcs
will take a while to pick things up.  But in the end Michael will have
to decide.  Adding linux-man to the Cc list so that the right people
are involved.

Quoting the rendered page below:

>   Invoking statx():
 
 This is an odd header for a man page.  Usually this would start as

DESCRIPTION

(in bold).

>       [*] By absolute path.

Odd way to enumerate in a man page - I'll leave it to the linux-man regulars
to point out the right way, because I don't know it off-hand.

>       AT_EMPTY_PATH (since Linux 2.6.39)

All these have been there since statx was added, so we can remove the annotation.

>           STATX_BASIC_STATS   [The stuff in the normal stat struct]

Please enumerate the actual fields.

>           STATX_ALL           [All currently available stuff]

How about "All currently available fields"
