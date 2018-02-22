Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-de.maxcluster.net ([62.113.231.250]:42913 "EHLO
        mail-de.maxcluster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751276AbeBVVR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 16:17:29 -0500
Date: Thu, 22 Feb 2018 22:10:24 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: [PATCH] misc: enable retpolines across all xfsprogs utilities
Message-ID: <20180222211024.GA26034@citd.de>
References: <20180222021625.GA9827@magnolia>
 <20180222150922.GA26282@infradead.org>
 <4d78832f-4148-d0d9-e2f2-ee8e02a44e97@redhat.com>
 <20180222171529.GC9827@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180222171529.GC9827@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On 22.02.2018 09:15, Darrick J. Wong wrote:
> On Thu, Feb 22, 2018 at 09:31:41AM -0600, Eric Sandeen wrote:
> > On 2/22/18 9:09 AM, Christoph Hellwig wrote:
> > > On Wed, Feb 21, 2018 at 06:16:25PM -0800, Darrick J. Wong wrote:
> > >> From: Darrick J. Wong <darrick.wong@oracle.com>
> > >>
> > >> Detect and enable retpolines for all code, to mitigate Spectre v2
> > >> (branch target injection) on x86.
> > > 
> > > The mechanics look ok, but why do we really care for xfsprogs?
> > > fs utilities seem like a lesser target and should just be covered
> 
> They're a smaller target than the kernel, for sure, but the scary part
> about spectre is that unprivileged programs running on the same core as
> a privileged xfs_repair can then use branch predictor poisoning to cause
> problems with the xfs_repair.

Spectre & Meltdown are information disclosure vulnerabilities IOW "Read 
Only".
The other process CAN NOT interfere with xfs_repair.

I would speculate that the most it can get, is information about parts 
of the filesystem that are inaccsessible to an unprivileged process by 
spying on xfs_repair.
I don't know how xfs_repair works, especially how xfs_repair handles 
storing data in memory. But for xfs_repair to be a good target, it 
would have to store relevant data in a deterministic fashion and for 
some length of time. At least enough to justify writing an extraction 
program for it.

I would say the 'good old' xfs_repair case isn't really a good target, 
but the online-scrubbing-case sure sounds to be a different beast.

In the past you couldn't, for a given point in time, really expect a 
xfs_repair process to be running, but with online-scrubbing that game 
changes.





-- 

Matthias
