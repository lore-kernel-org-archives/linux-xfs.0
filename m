Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728279AbfAXOBY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Jan 2019 09:01:24 -0500
Date: Thu, 24 Jan 2019 09:01:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 6/6] xfs: use the latest extent at writeback delalloc
 conversion time
Message-ID: <20190124140121.GB2855@bfoster>
References: <20190123184131.46188-1-bfoster@redhat.com>
 <20190123184131.46188-7-bfoster@redhat.com>
 <20190124085230.GB24774@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124085230.GB24774@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 24, 2019 at 12:52:30AM -0800, Christoph Hellwig wrote:
> And this I really don't like.  I much prefer the full version
> I've done here, which has evolved a bit from the work I've been
> posting to the list for months now:
> 

This patch is just an incremental step in that direction to fix the
underlying problem. The functionality with regard to imap race
mitigation in the delalloc conversion path is essentially equivalent.
The difference is you've cleaned up the API further by lifting the
lookup into the caller and implementing a more proper conversion
implemention.

> http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-mapping-validation.2
> 
> Which also fixes up some layering issues we have in that code path.

Ok... I've not reviewed the details but as noted above, the approach to
dealing with imap validity looks sane to me. Essentially all I'm asking
for here is isolated patches for fixes vs. refactoring vs. whatever
other cleanups/changes were related to the always cow stuff and offering
this (or the v2 patch) as an already tested way to do that.

If you'd rather just put this all in your series, then please split this
all up into a patch per logical change (i.e., separate patches to
move/rename functions first, introduce the new bmapi delalloc conversion
helper, modify writeback to use said helper, the layering fixups you're
referring to, etc.). At a glance, the commit above looks like it could
easily be split into at least 3 or 4 patches.

Brian
