Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:36908 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725811AbfBVXLp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 18:11:45 -0500
Date: Sat, 23 Feb 2019 10:11:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] pmem: advertise page alignment for pmem devices
 supporting fsdax
Message-ID: <20190222231136.GC23020@dastard>
References: <20190222182008.GT6503@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222182008.GT6503@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dan.j.williams@intel.com, linux-nvdimm@lists.01.org, zwisler@kernel.org, vishal.l.verma@intel.com, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Feb 22, 2019 at 10:20:08AM -0800, Darrick J. Wong wrote:
> Hi all!
> 
> Uh, we have an internal customer <cough> who's been trying out MAP_SYNC
> on pmem, and they've observed that one has to do a fair amount of
> legwork (in the form of mkfs.xfs parameters) to get the kernel to set up
> 2M PMD mappings.  They (of course) want to mmap hundreds of GB of pmem,
> so the PMD mappings are much more efficient.
> 
> I started poking around w.r.t. what mkfs.xfs was doing and realized that
> if the fsdax pmem device advertised iomin/ioopt of 2MB, then mkfs will
> set up all the parameters automatically.  Below is my ham-handed attempt
> to teach the kernel to do this.

What's the before and after mkfs output?

(need to see the context that this "fixes" before I comment)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
