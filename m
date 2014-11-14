Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 101197F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 23:26:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D86FB8F8039
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 21:26:30 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iqspg1FvLFauvdan for <xfs@oss.sgi.com>;
	Thu, 13 Nov 2014 21:26:28 -0800 (PST)
Date: Fri, 14 Nov 2014 16:25:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS locking issues in 3.18-rc3+
Message-ID: <20141114052523.GB29950@dastard>
References: <CALCETrWN71T1JsSNix52+ez_Sxt4i+vL-fX_2RTNbt8Ex1p=vw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALCETrWN71T1JsSNix52+ez_Sxt4i+vL-fX_2RTNbt8Ex1p=vw@mail.gmail.com>
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

On Thu, Nov 13, 2014 at 04:57:11PM -0800, Andy Lutomirski wrote:
> I'm running a kernel somewhere between 3.18-rc3 and 3.18-rc4.  I got
> the warnings below.  Is this a known issue?

Yup, false positive. shmem is instantiating an inode under the
mmap_sem and in doing so taking inode locks under the mmap_sem,
which triggers other filesystems to issue false warnings about
mmap_sem <-> inode lock order.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
