Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24DGrth166749 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 07:16:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBC6710A7C2E
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 05:19:44 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id pzrNV78xZMUfa62J for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 05:19:44 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PvUv2-0008MX-8I
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 13:19:44 +0000
Date: Fri, 4 Mar 2011 08:19:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] avoid busy extents during user data allocations
Message-ID: <20110304131944.GA31536@infradead.org>
References: <20110304125953.650347660@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110304125953.650347660@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Fri, Mar 04, 2011 at 07:59:53AM -0500, Christoph Hellwig wrote:
> This patchset adds support to trim down extents

Sorry, sent this out before finishing up the introduction.

This patchset adds support for trimming down allocations of user data
to avoid busy extents.  I'm actually not quite sure it's overly useful
in this form, as we're much better off allowing free reallocation
between data extents, and only avoid busy extents coming from freed
metadata.  Neverless I'd like to get a review of the new search
algorithm in patch 3, especially for the nice comments explaining it
all, based on a mail from Dave.

Patches 1 and 2 on the other hand are simple cleanups which I think
should go into the tree ASAP.

The other patches from the previous submitting are back to the drawing
board - implementing Dave's suggestion of skipping busy extents for
metadata to user data reallocation promises to give a lot of speedups,
but making it work with the requirement to track freed extents for
discard purposes isn't quite trivial as we might have to remove extents
from the busy list during reallocations, which requires additional
infrastructure to lock the list of busy extents in the transaction / cil
context which isn't there yet, and additional exclusion of allocations
from ongoing discards.

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
