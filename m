Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36444 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753653AbdKIIx3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 03:53:29 -0500
Date: Thu, 9 Nov 2017 00:53:24 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171109085324.GA4909@infradead.org>
References: <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com>
 <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com>
 <20171107184658.56b87d41@alans-desktop>
 <20171107191526.x3rzfcnnlmaz264d@thunk.org>
 <20171107192846.GA24617@infradead.org>
 <CAOFm3uFLRCZwtw4F884Rd=5=yZnX_ibzBzyiC4f+=5iju4k81Q@mail.gmail.com>
 <20171108151121.GC10374@infradead.org>
 <20171109082335.GD27461@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171109082335.GD27461@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Philippe Ombredanne <pombredanne@nexb.com>, Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>

On Thu, Nov 09, 2017 at 09:23:35AM +0100, Greg Kroah-Hartman wrote:
> The documentation of this process is lagging the patches, as usually
> happens, sorry about that.

In cases like this the documentation is the most important part.
Without documentation it is completely pointless.

> 
> Thomas is working on a document to describe the process, and what a file
> should contain, based on the work he has been doing.  This was discussed
> at the kernel summit, and sorry for it not getting out wider than that
> audience, things take time, which is why I was only touching my
> subsystems with the "general license cleanups" at the moment until his
> document was ready.
> 
> Hopefully a draft of it will go out today, Thomas?

It would help to Cc him, I've done that. 

> SPDX is an industry-wide accepted set of tags for all licenses, some
> projects have been using it for years (like Uboot).  These are not going
> to change randomly, and again, the document that Thomas has will
> describe these in detail.

It is not an 'industry-wide accepted set of tags' (did you get a company
discount on buzzwords).  Yes, it it a scheme someone can up with (seems
like an industry consortium that happens to employ you, what a
coincidence), and from a quick look it even seems like a pretty reasonable
scheme.  But without backing it with an explanation of those tags in
the tree, and explaining people how to use them and how they are
relevant it is absolutely useless.

And to come up with a scheme we need to have a broad discussion on
what we are doing.

> sorry for the confusion, it was not intended at all, but it what happens
> in time with distributed developers, all working at different rates on
> different parts of the tree.

Sorry but I call bullshit on this.  We have absolutely no problem
working together if we try.  You clearly did not even try to cooperate
with anyone - the clear indicator is that no RFC was posted, no
questions were asked but you just sent a pull requests right before
the end of the merge window.
