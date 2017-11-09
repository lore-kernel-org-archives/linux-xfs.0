Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50700 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753102AbdKIIXY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 03:23:24 -0500
Date: Thu, 9 Nov 2017 09:23:35 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171109082335.GD27461@kroah.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Philippe Ombredanne <pombredanne@nexb.com>, Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>

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

The documentation of this process is lagging the patches, as usually
happens, sorry about that.

Thomas is working on a document to describe the process, and what a file
should contain, based on the work he has been doing.  This was discussed
at the kernel summit, and sorry for it not getting out wider than that
audience, things take time, which is why I was only touching my
subsystems with the "general license cleanups" at the moment until his
document was ready.

Hopefully a draft of it will go out today, Thomas?

> So he deletes a lot of license tags and replaces them with tags he
> puts a great significance on, but which aren't defined.  A quick googles
> shows some Linuxfoundation web page defines them, but they could change
> them any time they want, nevermind that we don't even have a reference
> to them either.

SPDX is an industry-wide accepted set of tags for all licenses, some
projects have been using it for years (like Uboot).  These are not going
to change randomly, and again, the document that Thomas has will
describe these in detail.

sorry for the confusion, it was not intended at all, but it what happens
in time with distributed developers, all working at different rates on
different parts of the tree.

thanks,

greg k-h
