Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36643 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754038AbdHXQbS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 12:31:18 -0400
Received: by mail-oi0-f41.google.com with SMTP id t196so10072234oif.3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2017 09:31:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170824161152.GB27591@lst.de>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353213655.5039.7662200155640827407.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824161152.GB27591@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 09:31:17 -0700
Message-ID: <CAPcyv4jjNi_+c5DW9nsBLEnYMBtsR_v67+bF6bC4Cb9mY7T+Ww@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] fs, xfs: introduce MAP_DIRECT for creating
 block-map-atomic file ranges
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, xen-devel@lists.xen.org

[ adding Xen ]

On Thu, Aug 24, 2017 at 9:11 AM, Christoph Hellwig <hch@lst.de> wrote:
> I still can't make any sense of this description.  What is an external
> agent?  Userspace obviously can't ever see a change in the extent
> map, so it can't be meant.

External agent is a DMA device, or a hypervisor like Xen. In the DMA
case perhaps we can use the fcntl lease mechanism, I'll investigate.
In the Xen case it actually would need to use fiemap() to discover the
physical addresses that back the file to setup their M2P tables.
Here's the discussion where we discovered that physical address
dependency:

    https://lists.xen.org/archives/html/xen-devel/2017-04/msg00419.html

> It would help a lot if you could come up with a concrete user for this,
> including example code.

Will do.
