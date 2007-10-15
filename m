Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Oct 2007 02:37:03 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9F9aoPv006857
	for <xfs@oss.sgi.com>; Mon, 15 Oct 2007 02:36:52 -0700
Subject: Re: Interaction between Xen and XFS: stray RW mappings
From: Andi Kleen <andi@firstfloor.org>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com>
Date: Mon, 15 Oct 2007 11:36:50 +0200
In-Reply-To: <20071014225618.GN23367404@sgi.com> (David Chinner's message of "Mon\, 15 Oct 2007 08\:56\:18 +1000")
Message-ID: <p731wbw4t3h.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Williamson <mark.williamson@cl.cam.ac.uk>, Morten =?iso-8859-1?Q?B=C3=B8geskov?= <xen-users@morten.bogeskov.dk>, xfs-masters@oss.sgi.com, nickpiggin@yahoo.com.au

David Chinner <dgc@sgi.com> writes:
>
> And yes, we delay unmapping pages until we have a batch of them
> to unmap. vmap and vunmap do not scale, so this is batching helps
> alleviate some of the worst of the problems.

You're keeping vmaps around for already freed pages?

That will be a big problem for proper PAT support, which needs
to track all mappings to memory. It's not just a problem for Xen.

In fact I suspect it is already broken with DRM or AGP for example which
can use UC and WC mappings -- if you keep the mapping around and
DRM or AGP turns the page in another mapping uncacheable you're
creating an illegal cache attribute alias. These are known to occasionally
create cache corruptions on several x86s; giving ___VERY___ hard to debug
bugs once a blue moon.

Probably it'll require some generic VM batching mechanism where
Xen or PAT code can hook into the list or force unmap the mappings
as needed.

Definitely needs to be fixed if true. You're lucky that Xen caught it
in time.

-Andi
