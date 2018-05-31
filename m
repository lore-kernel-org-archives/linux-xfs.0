Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:41131 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754121AbeEaUfz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 16:35:55 -0400
Received: by mail-ot0-f193.google.com with SMTP id t1-v6so26803333oth.8
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 13:35:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180531191332.GB7825@magnolia>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com> <20180529212510.GJ30110@magnolia>
 <20180529220114.GA13948@linux.intel.com> <20180531191332.GB7825@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 May 2018 13:35:54 -0700
Message-ID: <CAPcyv4i6t1zahuL73m+oL5qiRJ_oikOszBvTMxoby62Z_0e7Hw@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] dax: change bdev_dax_supported() to support
 boolean returns
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Dave Jiang <dave.jiang@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, May 31, 2018 at 12:13 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Tue, May 29, 2018 at 04:01:14PM -0600, Ross Zwisler wrote:
>> On Tue, May 29, 2018 at 02:25:10PM -0700, Darrick J. Wong wrote:
>> > On Tue, May 29, 2018 at 01:51:01PM -0600, Ross Zwisler wrote:
>> > > From: Dave Jiang <dave.jiang@intel.com>
>> > >
>> > > The function return values are confusing with the way the function is
>> > > named. We expect a true or false return value but it actually returns
>> > > 0/-errno.  This makes the code very confusing. Changing the return values
>> > > to return a bool where if DAX is supported then return true and no DAX
>> > > support returns false.
>> > >
>> > > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> >
>> > Looks ok, do you want me to pull the first two patches through the xfs
>> > tree?
>> >
>> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Thanks for the review.
>>
>> I'm not sure what's best.  If you do that then Mike will need to have a DM
>> branch for the rest of the series based on your stable commits, yea?
>>
>> Mike what would you prefer?
>
> I /was/ about to say that I would pull in the first two patches, but now
> I can't get xfs to mount with pmem at all, and have no way of testing
> this...?
>
> # echo 'file drivers/dax/* +p' > /sys/kernel/debug/dynamic_debug/control
> # mount /dev/pmem3 -o rtdev=/dev/pmem4,dax /mnt
> # dmesg
> <snip>
> SGI XFS with ACLs, security attributes, realtime, scrub, debug enabled
> XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> pmem3: error: dax support not enabled
> pmem4: error: dax support not enabled
> XFS (pmem3): DAX unsupported by block device. Turning off DAX.
> XFS (pmem3): Mounting V5 Filesystem
> XFS (pmem3): Ending clean mount
>
> Evidently the pfn it picks up is missing PFN_MAP in flags because
> ND_REGION_PAGEMAP isn't set, and looking at the kernel source, pmem that
> comes in via NFIT never gets that set...?
>
> relevant qemu pmem options:
>
> -object memory-backend-file,id=memnvdimm0,prealloc=no,mem-path=/dev/shm/a.img,share=yes,size=13488881664
> -device nvdimm,node=0,memdev=memnvdimm0,id=nvdimm0,slot=0
> (repeat for five more devices)
>
> <confused>
>

What does "ndctl list" say? The namespaces need to be in fsdax mode.
