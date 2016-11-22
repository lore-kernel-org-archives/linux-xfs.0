Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21790 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754405AbcKVVSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 16:18:39 -0500
Date: Tue, 22 Nov 2016 13:17:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 0/2] Btrfs: make a source length of 0 imply EOF for
 dedupe
Message-ID: <20161122211719.GD16801@birch.djwong.org>
References: <cover.1479427384.git.osandov@fb.com>
 <20161118053853.GC31780@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161118053853.GC31780@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>, kernel-team@fb.com

On Thu, Nov 17, 2016 at 09:38:53PM -0800, Christoph Hellwig wrote:
> On Thu, Nov 17, 2016 at 04:07:48PM -0800, Omar Sandoval wrote:
> > So now we have 3 options:
> > 
> > a) Apply these patches as-is.
> > b) Fix XFS to both return the actual bytes_deduped and cap the length
> >    for the EOF case. Do the same for Btrfs.
> > c) Make XFS consistent with the existing Btrfs behavior.
> > 
> > I'm starting to lean towards option c after writing this cover letter,
> > but I might as well send these out and get a second opinion.
> 
> I agree - btrfs was there first, and there is no fatal flaw in the ABI,
> so let's adjust XFS to it.

Ok.  I'll send in a fix for generic/182, a patch to fix XFS, and I'll
roll the same fix into the ocfs2 patches before the next submission.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
