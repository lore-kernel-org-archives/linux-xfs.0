Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbeBEWlC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 17:41:02 -0500
Date: Mon, 5 Feb 2018 14:40:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs_scrub: call for testing
Message-ID: <20180205224057.GK4849@magnolia>
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
 <20180205161049.7e22aa09@harpe.intellique.com>
 <61166e99-1195-1192-d229-f7e01f1d52da@sandeen.net>
 <20180205164412.GF4849@magnolia>
 <86b1a8c3-4228-c0bb-84dd-3c9baae2d752@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86b1a8c3-4228-c0bb-84dd-3c9baae2d752@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 05, 2018 at 10:55:22AM -0600, Eric Sandeen wrote:
> 
> 
> On 2/5/18 10:44 AM, Darrick J. Wong wrote:
> >>> root@bareos16:~# ./xfs_scrub /mnt/raid/
> >>> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> >>> Error: /mnt/raid: Kernel metadata scrubbing facility is not available.
> >>> Info: /mnt/raid: Scrub aborted after phase 1.
> >>> /mnt/raid: 2 errors found.
> >> Yup.  TBH I'm not a fan of listing "your kernel can't scrub" as
> >> "errors found."  I think we should find a way around that.
> > What do you mean by that?
> > 
> > --D
> > 
> 
> When people run a tool like scrub and they see "errors found"
> at the end of the run, I think it's very easy to have that register
> as "filesystem errors found" which is not the case here.
> 
> If a kernel can't do scrub at all, "2 errors found" is a confusing
> message - I'd rather find a way to not conflate filesystem
> errors with operational errors (or simply missing capabilities).
> 
> As a first cut I might suggest that if required capabilities for
> the requested action were not found, we should not even print
> the "errors found" line, just the informational text.  i.e.
> just reset the error counters in that specific case before exit.

Yeah.  As you and I have been batting around on IRC all day, I've
changed most of the non-fs-corruption str_warn/str_error calls into
str_info since they pretty much all abort the scrub anyway (which is
itself recorded as a runtime error).

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
