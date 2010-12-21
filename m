Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBLBUYcw014126 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 05:30:35 -0600
Received: from daytona.panasas.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DA092126F4
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 03:32:31 -0800 (PST)
Received: from daytona.panasas.com (daytona.panasas.com [67.152.220.89]) by
	cuda.sgi.com with ESMTP id orYCTGI49DG58tGA for
	<xfs@oss.sgi.com>; Tue, 21 Dec 2010 03:32:31 -0800 (PST)
Message-ID: <4D109047.8050300@panasas.com>
Date: Tue, 21 Dec 2010 13:32:23 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
MIME-Version: 1.0
Subject: Re: XFS status update for November 2010
References: <20101220180013.GA16283@infradead.org>
In-Reply-To: <20101220180013.GA16283@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 12/20/2010 08:00 PM, Christoph Hellwig wrote:
>>From looking at the kernel git commits November looked like a pretty
> slow month with just two hand full fixes going into the release candidates
> for Linux 2.6.37, and none at all going into the development tree.
> But in this case git statistics didn't tell the whole story - there
> was a lot of activity on patches for the next merge window on the list.
> The focus in November was still at metadata scalability, with various
> patchsets that improves parallel creates and unlinks again, and also
> improves 8-way dbench throughput by 30%.  In addition to that there
> were patches to improve preallocation for NFS servers, to simplify
> the writeback code, and to remove the XFS-internal percpu counters
> for free space for the generic kernel percpu counters, which just needed
> a small improvement.
> 
> On the user space side we saw the release of xfsprogs 3.1.4, which
> contains various accumulated bug fixes and Debian packaging updates.
> The xfsdump tree saw a large update to speed up restore by using
> mmap for an internal database and remove the limitation of ~ 214
> million directory entries per dump file.  The xfstests test suite
> saw three new testcases and various fixes, including support for the
> hfsplus filesystem.

Hi Christoph, happy holidays

I love these reports you do, thank you

I have one small request, could you please post them to
linux-fsdevel as well. linux-kernel@vger.kernel.org is so crowded
I keep missing them.

Thanks
Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
