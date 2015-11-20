Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4544F7F37
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 07:43:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 339898F8033
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 05:43:23 -0800 (PST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com
	[74.125.82.42]) by cuda.sgi.com with ESMTP id kFXAB8ERg1tZuaWf
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Nov 2015 05:43:21 -0800 (PST)
Received: by wmww144 with SMTP id w144so19961410wmw.1
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 05:43:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151119232455.GM14311@dastard>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119232455.GM14311@dastard>
Date: Fri, 20 Nov 2015 15:43:20 +0200
Message-ID: <CAE1zot+sqVnrothFX9e9y95RV435EnK5J4P40Rk+MQEwg4RJ=Q@mail.gmail.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
From: Octavian Purdila <octavian.purdila@intel.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Nov 20, 2015 at 1:24 AM, Dave Chinner <david@fromorbit.com> wrote:
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
>

Hi David,

Yes XFS as the main fs on this type of devices does not make sense,
but does it hurt to be able to perform basic operation on XFS from
these devices? Perhaps accessing an external medium formatted with
XFS?

Another example is accessing VM images that are formatted with XFS.
Currently we can do that with tools like libguestfs that use a VM in
the background. I am working on a lighter solution for that where we
compile the Linux kernel as a library [1]. This allows access to the
filesystem without the need to use a full VM.

And a final example is linking the bootloader code with LKL to access
the filesystem. This has a hard requirement on non-mmu.

So, IMHO there are usecases for using XFS on non-mmu architectures. I
think it all boils down to: is the patch simple enough to not put an
unreasonable maintenance burden on developers?

[1] https://github.com/lkl/linux

Thanks,
Tavi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
