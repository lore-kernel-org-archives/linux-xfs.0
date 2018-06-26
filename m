Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750969AbeFZS6d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jun 2018 14:58:33 -0400
Date: Tue, 26 Jun 2018 14:58:30 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Message-ID: <20180626185830.GA7171@redhat.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-2-ross.zwisler@linux.intel.com>
 <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Toshi Kani <toshi.kani@hpe.com>, device-mapper development <dm-devel@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Jun 26 2018 at  2:52pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Tue, Jun 26, 2018 at 10:59 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > QUEUE_FLAG_DAX is an indication that a given block device supports
> > filesystem DAX and should not be set for PMEM namespaces which are in "raw"
> > or "sector" modes.  These namespaces lack struct page and are prevented
> > from participating in filesystem DAX.
> >
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Suggested-by: Mike Snitzer <snitzer@redhat.com>
> > Cc: stable@vger.kernel.org
> 
> Why is this cc: stable? What is the user visible impact of this change
> especially given the requirement to validate QUEUE_FLAG_DAX with
> bdev_dax_supported()? Patch looks good, but it's just a cosmetic fixup
> afaics.

This isn't cosmetic when you consider that stacking up a DM device is
looking at this flag to determine whether a table does or does _not_
support DAX.

So this patch, in conjunction with the other changes in the series, is
certainly something I'd consider appropriate for stable.

Mike
