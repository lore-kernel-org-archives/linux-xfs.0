Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55543 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751856AbdKHSGw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 13:06:52 -0500
Date: Wed, 8 Nov 2017 10:06:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171108180645.GA23143@infradead.org>
References: <20171107020607.GA26910@magnolia>
 <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com>
 <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com>
 <20171107184658.56b87d41@alans-desktop>
 <20171107191526.x3rzfcnnlmaz264d@thunk.org>
 <20171107192846.GA24617@infradead.org>
 <CAOFm3uFLRCZwtw4F884Rd=5=yZnX_ibzBzyiC4f+=5iju4k81Q@mail.gmail.com>
 <20171108151121.GC10374@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171108151121.GC10374@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>

And I swear I wrote the previous mail before I read this announcement:

https://fsfe.org/news/2017/news-20171108-01.en.html

But the actual practices there are pretty much what I'd expect as a
start (plus a list of acceptable licenses), they even use the same
identifiers as you are adding, but they also back them up with the
actual license texts in the source tree, which makes them a whole lot
more useful.

On Wed, Nov 08, 2017 at 07:11:21AM -0800, Christoph Hellwig wrote:
> On Wed, Nov 08, 2017 at 01:35:46PM +0100, Philippe Ombredanne wrote:
> > The benefits now and later:
> > - no distraction with licensing boilerplate cr*p in patches and files
> > - no guessing licensing needed when sending a patch
> > - anyone can grep the kernel tree for licensing, no extra tool needed
> > - Greg must feel really good about deleting so much things for once
> 
> This patch didn't delete anything, it added random notes.
> 
> I see now Greg deletes things from files he maintains which is even
> worse, given that the kernel tree doesn't document anywhere what these
> tags actually mean.
> 
> So he deletes a lot of license tags and replaces them with tags he
> puts a great significance on, but which aren't defined.  A quick googles
> shows some Linuxfoundation web page defines them, but they could change
> them any time they want, nevermind that we don't even have a reference
> to them either.
> 
> > 
> > The downsides:
> > - folks can no longer express their creativity in licensing texts like
> > licensing thermal code under the "therms" of the GPL [2]
> 
> I'd love something like that to happen.  But for that we don't need a
> sneaky patch that doesn't talk to kernel contributors.
> 
> For that we need to
> 
>  a) agree on which licensing schemes we accept for future contributions
>  b) cleary document that policy in the kernel tree
>  c) reject anything that doesn't matter the above policy by manual
>     and/or automated review
> 
> An automated tag scheme might help with b) and c) above if done
> properly.  But for that we need to document it, agree on it, discuss
> it with everyone involved, etc.  None of that has happened.  Instead
> Greg farted arcane tags that he thinks have a legal singnificance
> all over three three without talking to the people whos code he tagged,
> without any RFC or public discussion, without documenting what his
> tags mean or any future strategy towards making use of them.
---end quoted text---
