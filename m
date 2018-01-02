Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:34002
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750970AbeABVoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 16:44:55 -0500
Date: Wed, 3 Jan 2018 08:44:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 08/18] tools/testing/nvdimm: add 'bio_delay' mechanism
Message-ID: <20180102214450.GU5858@dastard>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407700353.38751.17609507477918854876.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151407700353.38751.17609507477918854876.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

On Sat, Dec 23, 2017 at 04:56:43PM -0800, Dan Williams wrote:
> In support of testing truncate colliding with dma add a mechanism that
> delays the completion of block I/O requests by a programmable number of
> seconds. This allows a truncate operation to be issued while page
> references are held for direct-I/O.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Why not put this in the generic bio layer code and then write a
generic fstest to exercise this truncate vs direct IO completion
race condition on all types of storage and filesystems?

i.e. if it sits in a nvdimm test suite, it's never going to be run
by filesystem developers....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
