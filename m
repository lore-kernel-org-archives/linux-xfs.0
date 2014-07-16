Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A48087FEC
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 18:41:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F4D1AC001
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 16:41:39 -0700 (PDT)
Received: from mail-qc0-f178.google.com (mail-qc0-f178.google.com
	[209.85.216.178]) by cuda.sgi.com with ESMTP id
	16KVKMO2o4LMi9pi (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 16:41:33 -0700 (PDT)
Received: by mail-qc0-f178.google.com with SMTP id x3so1492709qcv.9
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 16:41:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140716223150.GE4453@dastard>
References: <alpine.DEB.2.00.1407151634250.21336@cobra.newdream.net>
	<20140716092226.GA23561@infradead.org>
	<CAPYLRziqpnjHbViaFw2MtXcYKiCDE9wz8qaqiQjAJGDoUbG7cg@mail.gmail.com>
	<20140716223150.GE4453@dastard>
Date: Wed, 16 Jul 2014 16:41:32 -0700
Message-ID: <CA+4uBUYTu9LsgfuBvz7_S5QYb3ySwOdfPcvDTK-Ym6usEQ=0-g@mail.gmail.com>
Subject: Re: v0.80.4 Firefly released
From: Samuel Just <sam.just@inktank.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Gregory Farnum <gregory.farnum@dreamhost.com>, xfs@oss.sgi.com, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Sage Weil <sage@inktank.com>

[Apologies for the repost, attachment was too big]

Sorry for the delay.  I've been trying to put together a simpler
reproducer since no one wants to debug a filesystem based on rbd
symptoms :).  It doesn't appear to be related to using extsize on a
non-empty file. The linked archive below has a reproducer
(xfs_extsize_reproducer.cc), an input op sequence (trimmed-ops.in),
the resulting file and what it should be (test, test.correct), and a
summary (notes.txt).

http://filedump.ceph.com/samuelj/reproducer.tgz

I think this probably is fixed in the commit mentioned above (xfs: Use
preallocation for inodes with extsz hints).

Thanks!
-Sam

On Wed, Jul 16, 2014 at 3:31 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jul 16, 2014 at 10:26:23AM -0700, Gregory Farnum wrote:
>> On Wed, Jul 16, 2014 at 2:22 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Tue, Jul 15, 2014 at 04:45:59PM -0700, Sage Weil wrote:
>> >> This Firefly point release fixes an potential data corruption problem
>> >> when ceph-osd daemons run on top of XFS and service Firefly librbd
>> >> clients.  A recently added allocation hint that RBD utilizes triggers
>> >> an XFS bug on some kernels (Linux 3.2, and likely others) that leads
>> >> to data corruption and deep-scrub errors (and inconsistent PGs).  This
>> >> release avoids the situation by disabling the allocation hint until we
>> >> can validate which kernels are affected and/or are known to be safe to
>> >> use the hint on.
>> >
>> > I've not really seen an report for that on the XFS list, could it be
>> > that you're running into the issue fixed by
>> >
>> >  "xfs: Use preallocation for inodes with extsz hints"
>> >
>> > (commit aff3a9edb7080f69f07fe76a8bd089b3dfa4cb5d)?
>>
>> Sam reported the issue we're seeing in "consequences of
>> XFS_IOC_FSSETXATTR on non-empty file?",
>
> Assuming you've created an extent size hint with a file with delayed
> allocation on it and no blocks, then that's more than likely the
> same issue. The above commit uses preallocation to allocate
> unwritten extents rather than delayed allocation for files with
> extent size hints because delayed allocation doesn't write zeros
> over ranges in the allocated extents that don't have dirty data over
> them.
>
> Moral of the story: any time you get what appears to be data
> corruption in the underlying data store, you should report it to the
> relevant filesystem list rather than try to work around it....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
