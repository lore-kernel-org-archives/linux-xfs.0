Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50948 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752738AbeBEQz1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Feb 2018 11:55:27 -0500
Subject: Re: xfs_scrub: call for testing
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
 <20180205161049.7e22aa09@harpe.intellique.com>
 <61166e99-1195-1192-d229-f7e01f1d52da@sandeen.net>
 <20180205164412.GF4849@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <86b1a8c3-4228-c0bb-84dd-3c9baae2d752@sandeen.net>
Date: Mon, 5 Feb 2018 10:55:22 -0600
MIME-Version: 1.0
In-Reply-To: <20180205164412.GF4849@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 2/5/18 10:44 AM, Darrick J. Wong wrote:
>>> root@bareos16:~# ./xfs_scrub /mnt/raid/
>>> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
>>> Error: /mnt/raid: Kernel metadata scrubbing facility is not available.
>>> Info: /mnt/raid: Scrub aborted after phase 1.
>>> /mnt/raid: 2 errors found.
>> Yup.  TBH I'm not a fan of listing "your kernel can't scrub" as
>> "errors found."  I think we should find a way around that.
> What do you mean by that?
> 
> --D
> 

When people run a tool like scrub and they see "errors found"
at the end of the run, I think it's very easy to have that register
as "filesystem errors found" which is not the case here.

If a kernel can't do scrub at all, "2 errors found" is a confusing
message - I'd rather find a way to not conflate filesystem
errors with operational errors (or simply missing capabilities).

As a first cut I might suggest that if required capabilities for
the requested action were not found, we should not even print
the "errors found" line, just the informational text.  i.e.
just reset the error counters in that specific case before exit.

-Eric
