Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 94DE429DF5
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 17:54:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5F0E3304032
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 15:54:05 -0800 (PST)
Received: from mail-ob0-f173.google.com (mail-ob0-f173.google.com
	[209.85.214.173]) by cuda.sgi.com with ESMTP id
	8Y9N2zxPCkZ5JCfP (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 19 Nov 2015 15:54:03 -0800 (PST)
Received: by obbbj7 with SMTP id bj7so73904919obb.1
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 15:54:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151119232455.GM14311@dastard>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119232455.GM14311@dastard>
Date: Fri, 20 Nov 2015 00:54:02 +0100
Message-ID: <CAFLxGvx9x-4gnCQh7203G72Jy+EULbMnGTK=2r3ko=Yy9FB7Wg@mail.gmail.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
From: Richard Weinberger <richard.weinberger@gmail.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Octavian Purdila <octavian.purdila@intel.com>, LKML <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>

On Fri, Nov 20, 2015 at 12:24 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
>> Naive implementation for non-mmu architectures: allocate physically
>> contiguous xfs buffers with alloc_pages. Terribly inefficient with
>> memory and fragmentation on high I/O loads but it may be good enough
>> for basic usage (which most non-mmu architectures will need).
>
> Can you please explain why you want to use XFS on low end, basic
> non-MMU devices? XFS is a high performance, enterprise/HPC level
> filesystem - it's not a filesystem designed for small IoT level
> devices - so I'm struggling to see why we'd want to expend any
> effort to make XFS work on such devices....

The use case is the Linux Kernel Library:
https://lkml.org/lkml/2015/11/3/706

Using LKL and fuse you can mount any kernel filesystem using fuse
as non-root.

-- 
Thanks,
//richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
