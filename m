Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:18531 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751152AbeDNV7j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Apr 2018 17:59:39 -0400
Date: Sun, 15 Apr 2018 07:59:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs: xfs: Change return type to vm_fault_t
Message-ID: <20180414215937.GH5572@dastard>
References: <20180414200530.GA20184@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180414200530.GA20184@jordon-HP-15-Notebook-PC>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, willy@infradead.org

On Sun, Apr 15, 2018 at 01:35:30AM +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for fault handlers.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>

Ummm. Why are we adding typedefs to hide basic types?

typedef int vm_fault_t;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
