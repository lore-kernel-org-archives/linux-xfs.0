Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 19:53:57 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m622rtVV001504
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 19:53:55 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C4071860317
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 19:54:57 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 6KUdSymz7qdWpfBu for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 19:54:57 -0700 (PDT)
Date: Wed, 2 Jul 2008 12:54:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Fix use after free when closing log/rt devices
Message-ID: <20080702025454.GW29319@disturbed>
References: <48647746.5010007@sgi.com> <20080627063219.GA25015@infradead.org> <48648B2B.3080709@sgi.com> <20080627090822.GA17374@infradead.org> <486AE0F8.5080506@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486AE0F8.5080506@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Mark Goodwin <markgw@sgi.com>, Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jul 02, 2008 at 11:59:20AM +1000, Timothy Shimmin wrote:
> Christoph Hellwig wrote:
> > On Fri, Jun 27, 2008 at 04:39:39PM +1000, Mark Goodwin wrote:
> >> do we have any QA tests that test external log?
> > 
> > Most QA tests will use the external log if you set it up that way.  But
> > ithout slab poisoning this won't be noticed either.
> 
> I think you need:
>   USE_EXTERNAL=yes
>   SCRATCH_LOGDEV=somelogdevice
>   TEST_LOGDEV=somelogdevice
> to get the scratch and test mounts using an external log.

Yes. Typically I used to use SCRATCH_LOGDEV=/dev/ram0 so I didn't
need another block device on the machine just for an external
log on a throw-away filesystem....

> There are no explicit external log tests (logdev=) that I can see.

It should be easy to write one using files and multiple
loopback devices.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
