Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58703 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbcIJHgt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Sep 2016 03:36:49 -0400
Date: Sat, 10 Sep 2016 09:36:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Message-ID: <20160910073646.GA18547@lst.de>
References: <1473438884-674-1-git-send-email-hch@lst.de> <1473438884-674-7-git-send-email-hch@lst.de> <20160909225557.GF30056@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160909225557.GF30056@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, elliott@hpe.com

On Sat, Sep 10, 2016 at 08:55:57AM +1000, Dave Chinner wrote:
> THe errors from the above two cases are not acted on. they are
> immediately overwritten by:

Yes, Robert also pointed this out.  Fix below.

> Is there a missing "if (error) goto out;" check somewhere here?

Just the one above.

> I'm also wondering if you've looked at supporting the PMD fault case
> with iomap?

PMD faults currently don't work at all.  Ross has a series to resurrect
them, but we'll need to coordinate between the two series somehow.  My
preference would be to not resurrect them for the bh path and only do
it for the iomap version.


diff --git a/fs/dax.c b/fs/dax.c
index a170a94..5534594 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1440,6 +1440,7 @@ int iomap_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	default:
 		WARN_ON_ONCE(1);
 		error = -EIO;
+		goto unlock_entry;
 	}
 
 	/* Filesystem should not return unwritten buffers to us! */
