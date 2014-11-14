Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 552EF7F3F
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 15:50:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 419008F8050
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 13:50:13 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	e4CMEd7OTKCVK7cY for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 13:50:10 -0800 (PST)
Date: Sat, 15 Nov 2014 08:50:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS locking issues in 3.18-rc3+
Message-ID: <20141114215007.GC29950@dastard>
References: <CALCETrWN71T1JsSNix52+ez_Sxt4i+vL-fX_2RTNbt8Ex1p=vw@mail.gmail.com>
	<20141114052523.GB29950@dastard>
	<CALCETrVcp1BY3cO4Y2sdgGC+eQnyOF3xUCK6qng_Z_Y7dNi2yg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALCETrVcp1BY3cO4Y2sdgGC+eQnyOF3xUCK6qng_Z_Y7dNi2yg@mail.gmail.com>
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
To: Andy Lutomirski <luto@amacapital.net>
Cc: xfs@oss.sgi.com

On Fri, Nov 14, 2014 at 01:02:59PM -0800, Andy Lutomirski wrote:
> On Thu, Nov 13, 2014 at 9:25 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Nov 13, 2014 at 04:57:11PM -0800, Andy Lutomirski wrote:
> >> I'm running a kernel somewhere between 3.18-rc3 and 3.18-rc4.  I got
> >> the warnings below.  Is this a known issue?
> >
> > Yup, false positive. shmem is instantiating an inode under the
> > mmap_sem and in doing so taking inode locks under the mmap_sem,
> > which triggers other filesystems to issue false warnings about
> > mmap_sem <-> inode lock order.
> 
> I still have an enormous flood of warnings even if
> CONFIG_PROVE_LOCKING=n.  This one is repeated at high frequency:
> 
> [   70.969118] ------------[ cut here ]------------
> [   70.969121] WARNING: CPU: 8 PID: 653 at mm/truncate.c:758
> pagecache_isize_extended+0x105/0x110()

Fixed in 3.18-rc4.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
