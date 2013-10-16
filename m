Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B7D507F3F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 20:47:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 938FB8F8040
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 18:47:06 -0700 (PDT)
Date: Wed, 16 Oct 2013 12:46:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] xfs corruption - structure need cleaning
Message-ID: <20131016014654.GC4446@dastard>
References: <CAMg3XqqJgxnc2+ZkuMaK9RC1_Basfh9AzcqCpNdvmPpCXgNHZg@mail.gmail.com>
	<20131015204346.GS4446@dastard>
	<CAMg3XqptephuOPEJ-iiQF+Bs5Kp7MO=D-siw6fbNMG4=2CQGKg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMg3XqptephuOPEJ-iiQF+Bs5Kp7MO=D-siw6fbNMG4=2CQGKg@mail.gmail.com>
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
To: Roy Zhang <royzhangzzl@gmail.com>
Cc: xfs-masters <xfs-masters@oss.sgi.com>, xfs <xfs@oss.sgi.com>

On Wed, Oct 16, 2013 at 08:12:00AM +0800, Roy Zhang wrote:
> Hi Dave,
> I performance a ssd and hdd by flashcache. The info as below.
> kernel version 2.6.32.220

So you're using out of tree modules in the IO path, on a custom
Centos 6.3 kernel and you are getting random hangs waiting for IO
completion.

FWIW, 15,000 lines of log files is not the information I asked for,
but this:

[1535047.183083] MEMBlaze Hardware IO Request Irresponsible

indicates that you are using some kind of PCIe flash hardware from a
chinese startup that doesn't have in-kernel drivers or english
documentation.  There's no way we can really help you diagnose IO
stack problems given these conditions.

FWIW, your logs indicate that something is going wrong in your IO
stack, not with XFS.  XFS is triggering the hung task timer waiting
for IO completion, and only after many, many reboots as a result of
these hangs you see a log corruption when trying to mount the
filesystem.

So - look to flashcache or your hardware as the source of your
problem...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
