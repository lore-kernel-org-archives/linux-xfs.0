Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752132AbeDCTjO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Apr 2018 15:39:14 -0400
Date: Tue, 3 Apr 2018 15:39:13 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v8 10/18] dax, dm: introduce ->fs_{claim, release}()
 dax_device infrastructure
Message-ID: <20180403193912.GC6556@redhat.com>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152246898322.36038.17918469633893320678.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4jaZV3AhYaOA3d0SQ-AOvb4RKhj4_q-PR0bpt3aoax2mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jaZV3AhYaOA3d0SQ-AOvb4RKhj4_q-PR0bpt3aoax2mA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Alasdair Kergon <agk@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, david <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tue, Apr 03 2018 at  2:24pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Fri, Mar 30, 2018 at 9:03 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > In preparation for allowing filesystems to augment the dev_pagemap
> > associated with a dax_device, add an ->fs_claim() callback. The
> > ->fs_claim() callback is leveraged by the device-mapper dax
> > implementation to iterate all member devices in the map and repeat the
> > claim operation across the array.
> >
> > In order to resolve collisions between filesystem operations and DMA to
> > DAX mapped pages we need a callback when DMA completes. With a callback
> > we can hold off filesystem operations while DMA is in-flight and then
> > resume those operations when the last put_page() occurs on a DMA page.
> > The ->fs_claim() operation arranges for this callback to be registered,
> > although that implementation is saved for a later patch.
> >
> > Cc: Alasdair Kergon <agk@redhat.com>
> > Cc: Mike Snitzer <snitzer@redhat.com>
> 
> Mike, do these DM touches look ok to you?  We need these ->fs_claim()
> / ->fs_release() interfaces for device-mapper to set up filesystem-dax
> infrastructure on all sub-devices whenever a dax-capable DM device is
> mounted. It builds on the device-mapper dax dependency removal
> patches.

I'd prefer dm_dax_iterate() be renamed to dm_dax_iterate_devices()

But dm_dax_iterate() is weird... it is simply returning the struct
dax_device *dax_dev that is passed: seemingly without actually directly
changing anything about that dax_device (I can infer that you're
claiming the underlying devices, but...)

In general user's of ti->type->iterate_devices can get a result back
(via 'int' return).. you aren't using it that way (and maybe dax will
never have a need to return an answer).  But all said, I think I'd
prefer to see dm_dax_iterate_devices() return void.

But please let me know if I'm missing something, thanks.

Mike
