Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51832 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbeKPWTW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Nov 2018 17:19:22 -0500
Date: Fri, 16 Nov 2018 20:06:57 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] block: fix 32 bit overflow in __blkdev_issue_discard()
Message-ID: <20181116120655.GA13670@ming.t460p>
References: <20181113214337.20581-1-david@fromorbit.com>
 <10a8dd78-7c00-8593-9f4e-b20eb1161b92@kernel.dk>
 <20181115010651.GD32603@ming.t460p>
 <20181115012201.GX19305@dastard>
 <20181115031035.GE32603@ming.t460p>
 <20181115221337.GY19305@dastard>
 <20181115222419.GV4235@magnolia>
 <20181116040457.GA19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116040457.GA19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Nov 16, 2018 at 03:04:57PM +1100, Dave Chinner wrote:
> On Thu, Nov 15, 2018 at 02:24:19PM -0800, Darrick J. Wong wrote:
> > On Fri, Nov 16, 2018 at 09:13:37AM +1100, Dave Chinner wrote:
> > > On Thu, Nov 15, 2018 at 11:10:36AM +0800, Ming Lei wrote:
> > > > On Thu, Nov 15, 2018 at 12:22:01PM +1100, Dave Chinner wrote:
> > > > > On Thu, Nov 15, 2018 at 09:06:52AM +0800, Ming Lei wrote:
> > > > > > On Wed, Nov 14, 2018 at 08:18:24AM -0700, Jens Axboe wrote:
> > > > > > > On 11/13/18 2:43 PM, Dave Chinner wrote:
> > > > > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > > > > 
> > > > > > > > A discard cleanup merged into 4.20-rc2 causes fstests xfs/259 to
> > > > > > > > fall into an endless loop in the discard code. The test is creating
> > > > > > > > a device that is exactly 2^32 sectors in size to test mkfs boundary
> > > > > > > > conditions around the 32 bit sector overflow region.
> > > > > > > > 
> > > > > > > > mkfs issues a discard for the entire device size by default, and
> > > > > > > > hence this throws a sector count of 2^32 into
> > > > > > > > blkdev_issue_discard(). It takes the number of sectors to discard as
> > > > > > > > a sector_t - a 64 bit value.
> > > > > > > > 
> > > > > > > > The commit ba5d73851e71 ("block: cleanup __blkdev_issue_discard")
> > > > > > > > takes this sector count and casts it to a 32 bit value before
> > > > > > > > comapring it against the maximum allowed discard size the device
> > > > > > > > has. This truncates away the upper 32 bits, and so if the lower 32
> > > > > > > > bits of the sector count is zero, it starts issuing discards of
> > > > > > > > length 0. This causes the code to fall into an endless loop, issuing
> > > > > > > > a zero length discards over and over again on the same sector.
> > > > > > > 
> > > > > > > Applied, thanks. Ming, can you please add a blktests test for
> > > > > > > this case? This is the 2nd time it's been broken.
> > > > > > 
> > > > > > OK, I will add zram discard test in blktests, which should cover the
> > > > > > 1st report. For the xfs/259, I need to investigate if it is easy to
> > > > > > do in blktests.
> > > > > 
> > > > > Just write a test that creates block devices of 2^32 + (-1,0,1)
> > > > > sectors and runs a discard across the entire device. That's all that
> > > > > xfs/259 it doing - exercising mkfs on 2TB, 4TB and 16TB boundaries.
> > > > > i.e. the boundaries where sectors and page cache indexes (on 4k page
> > > > > size systems) overflow 32 bit int and unsigned int sizes. mkfs
> > > > > issues a discard for the entire device, so it's testing that as
> > > > > well...
> > > > 
> > > > Indeed, I can reproduce this issue via the following commands:
> > > > 
> > > > modprobe scsi_debug virtual_gb=2049 sector_size=512 lbpws10=1 dev_size_mb=512
> > > > blkdiscard /dev/sde
> > > > 
> > > > > 
> > > > > You need to write tests that exercise write_same, write_zeros and
> > > > > discard operations around these boundaries, because they all take
> > > > > a 64 bit sector count and stuff them into 32 bit size fields in
> > > > > the bio tha tis being submitted.
> > > > 
> > > > write_same/write_zeros are usually used by driver directly, so we
> > > > may need make the test case on some specific device.
> > > 
> > > My local linux iscsi server and client advertise support for them.
> > > It definitely does not ships zeros across the wire(*) when I use
> > > things like FALLOC_FL_ZERO_RANGE, but fstests does not have block
> > > device fallocate() tests for zeroing or punching...
> > 
> > fstests does (generic/{349,350,351}) but those basic functionality tests
> > don't include creating a 2^32 block device and seeing if overflows
> > happen... :/
> 
> They don't run on my test machines because they require a modular
> kernel and I run a monolithic kernel specified externally by the
> qemu command line on all my test VMs.
> 
> generic/349     [not run] scsi_debug module not found
> generic/350     [not run] scsi_debug module not found
> generic/351     [not run] scsi_debug module not found

Given both null_blk and scsi_debug have tons of module parameters,
it should be inevitable to build them as modules, then you may setup
them in any way you want.

Most of my tests are done in VM too, I start VM by one Fedora offical
kernel, and install modules built from host via 'scp & tar zxf' inside
the VM, then use new built kernel to start VM and run any tests. The
whole script is quite simple, and no need host root privilege.

Thanks,
Ming
