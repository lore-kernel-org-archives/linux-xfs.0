Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p222PBaF232104 for <xfs@oss.sgi.com>; Tue, 1 Mar 2011 20:25:11 -0600
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB2B330905F
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2011 18:28:00 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id uXMuUMOvmuWu4C1f for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2011 18:28:00 -0800 (PST)
Message-ID: <4D6DAB06.7090806@tlinx.org>
Date: Tue, 01 Mar 2011 18:27:18 -0800
From: Linda Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Re: RFE kernel option to do the desirable thing,
	w/regards to 'O_DIRECT' and mis-aligned data
References: <4D648D7D.7040500@tlinx.org> <4D64E2BB.7010000@draigBrady.com>
	<4D654C2E.2000703@tlinx.org> <20110224092625.GA3087@dastard>
In-Reply-To: <20110224092625.GA3087@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: LKML <linux-kernel@vger.kernel.org>
Cc: PXXdraig Brady <P@draigBrady.com>, xfs-oss <xfs@oss.sgi.com>


    Thanks for the shorthand Dave, but I wasn't really trying to use
xfs_mkfs to make a file that was failing -- but was more trying to use
it as an example of supporting the idea that both should succeed, and
if a write is a partial write to an O_DIRECT file, that it be allowed
to succeed and the kernel, knowing the device's minimum write size
from the driver, could buffer the last sector. 

To deal with back-compat issues, it could be based off of a proc
var like /proc/kernel/fs/direct_IO_handling using bitfields (or
multiple vars if you don't like bitfields, I s
with the bits defined as:

Bit 0 Controlling allowed partial writes that start at an aligned position
Bit 1 Controlling allowed non-aligned writes
Bit 2 Controlling allowed partial reads that start at aligned position
Bit 3 Controlling allowed non-aligned reads
Bit 4 Controlling whether to use general FS cache for affected sectors

It's a bit of 'overkill' for what I wanted (just case controlled by
Bit 0), but for sake of completeness, I thought all of these combinations
should be specified.

Default of 0 = current behavior of mis-aligned data accesses failing,
while specifying various combinations would allow for variations with
the kernel handling mis-aligned accesses automatically, much like the
x86 processor handles mis-aligned integer additions or stacks automatically
(perhaps at a performance penalty, but with a tendency toward 'working'
rather than failing, if possible).

It seems better to put that logic in the kernel rather than saddle multiple
applications using DIRECT I/O with handling the non-aligned cases. 
This seems especially useful given the long term trend toward
increasing use of static-memory devices which will likely support
arbitrary direct I/O sizes. 

Linda Walsh


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
