Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 951737F3F
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 21:48:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84A88304070
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 19:48:09 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	JQrPy7Me89j6Ed4z for <xfs@oss.sgi.com>;
	Tue, 14 Jan 2014 19:48:06 -0800 (PST)
Date: Wed, 15 Jan 2014 14:48:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
Message-ID: <20140115034803.GT3469@dastard>
References: <20140113015007.GC3469@dastard>
	<EDB09149-717F-4089-9C21-1D342CF77A7D@kotlarek.com>
	<20140113031947.GG3469@dastard>
	<E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>
	<20140113192732.GI3469@dastard>
	<0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>
	<20140114022414.GM3469@dastard>
	<BE0C947E-37DE-4CA1-B120-59B95E1E8EB8@kotlarek.com>
	<20140115015350.GR3469@dastard>
	<61E74CEF-8244-4E90-BA7D-91D54DADC3C1@kotlarek.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <61E74CEF-8244-4E90-BA7D-91D54DADC3C1@kotlarek.com>
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
To: Zachary Kotlarek <zach@kotlarek.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 14, 2014 at 05:59:23PM -0800, Zachary Kotlarek wrote:
> 
> On Jan 14, 2014, at 5:53 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > Pretty simple - the leaf[].address is simply a compressed offset
> > into the leaf. all dirents are 8 byte aligned, and the tag is the
> > byte offset into the leaf dirent space. Hence:
> > 
> > 	leaf[].address = bu[16].tag >> 3
> > 			= 0x1d8 >> 3
> > 			= 0x3b
> > 			= bleaf[3].address
> > 
> >> bleaf[3].hashval = 0x16d0707c
> >> bleaf[3].address = 0x3b
> > 
> > And there were are - there's a single bit discrepancy in the lower
> > byte of the hash. That tends to imply we have a bug in xfs_repair.
> > 
> > What version of xfs_repair did you use? (xfs_repair -V)
> 
> 
> 3.1.11.

OK, Now I've looked at the code, the answer is easy and you're
probably not going to like it. I missed this the first time through
from your xfs-info output:

naming   =version 2              bsize=4096   ascii-ci=1
                                              ^^^^^^^^^^

It's called *ASCII* Case Insensitivity for a reason: it doesn't
support anything other than ASCII. So your usage is not actually
supported at all, hence it's no surprise that it has caused
breakage.

Internationalised UTF-8 character sets are not supported
because it causes case conversion issues when kernel and userspace
character sets don't match exactly. IOWs, to support UTF-8 case
insensitivity, we need to have on-disk translation tables so that
the kernel and userspace use the same case translations. See here:

http://xfs.org/index.php/Unfinished_work#Support_for_unicode_.2F_utf8_filesystems

I suspect that the way to fix your filesystem is to run xfs_repair
under a "C" locale so that the glibc tolower() function behaves the
same way the kernel behaves and so the hashes calculated by
xfs_repair match the what the kernel thinks is correct.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
