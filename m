Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42374 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727258AbeHaRPg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Aug 2018 13:15:36 -0400
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
 <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
 <20180830163614.GA27069@lst.de>
 <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
 <20180830180204.GC2853@bfoster> <20180830182849.GA4359@magnolia>
 <10d35380-6f5f-22a5-7b6a-1cfb60c53cfd@sandeen.net>
 <20180831001106.GG5631@dastard>
 <7ae98d88-7cbf-1314-83b6-dc15da5124eb@sandeen.net>
 <20180831030542.GK5631@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <19b4da59-3720-6647-e557-9d7353ed509b@sandeen.net>
Date: Fri, 31 Aug 2018 08:08:11 -0500
MIME-Version: 1.0
In-Reply-To: <20180831030542.GK5631@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 8/30/18 10:05 PM, Dave Chinner wrote:
> On Thu, Aug 30, 2018 at 08:34:02PM -0500, Eric Sandeen wrote:

...

>> We /could/ FIBMAP a reflinked file
>> exactly as well as we can FIBMAP a non-reflinked file, but we choose
>> not to.  This choice creates unnecessary problems for existing apps.
> 
> Yes, we /could/. But we don't, because because of the typical use
> case of FIBMAP which is to map files so that IO (read and/or write)
> can be done directly to the block device without going through the
> filesystem. For normal files this is /relatively/ safe if the
> correct precautions are taken. For a shared extent, writing is
> *never* safe.
> 
> We don't know what users of FIBMAP are going to do with the block
> map they get, but we *know* there are apps that use it to write
> direct to block devices and we *know* that this will cause _silent_
> data corruption and/or exposure of privileged information (shared
> data can have different owners at different permission levels) when
> it occurs.

It'd be way better for my blood pressure if people would stop making
poor arguments about orthogonal issues.

If you can directly read the block device hosting the files, file
permissions of shared blocks are completely beside the point.

And app writers can make bad/dangerous decisions no matter what mapping
mechanisms we provide.

(If an app writer knows enough to look at FIEMAP flags to check for shared
blocks before writing, they'd know enough to use it instead of FIBMAP in
the first place.)

But I'm not even aware of any apps that actually /do/ use FI[BE]MAP mapping
information to write, in any case.

While grub2 does directly write file blocks in one case, it doesn't
even /use/ FIBMAP!  So it will happily continue doing so, even for
reflinked files, despite our best efforts to break the interface for
safe users.


The "typical use case" is to map a file for a bootloader to /read/
at boot, and our arbitrary restriction has broken systems in
the real world, and burned a lot of institutional effort getting
to the bottom of the problem and working around it.

I know it's our job to be pedantic, secure, and correct, but speculating
about what misbehaving privileged apps /could/ do and then plugging a
small fraction of the possible misuse vectors while breaking actual, safe,
real-world usecases just isn't a compelling story.

-Eric
