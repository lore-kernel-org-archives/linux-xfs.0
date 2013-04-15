Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF2507F50
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 08:45:12 -0500 (CDT)
Message-ID: <516C046C.8080908@sgi.com>
Date: Mon, 15 Apr 2013 08:45:16 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: kernels 3.4 slower due to allocation workqueue
References: <516BCACE.1040900@univ-nantes.fr>
In-Reply-To: <516BCACE.1040900@univ-nantes.fr>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: xfs@oss.sgi.com

On 04/15/13 04:39, Yann Dupont wrote:
> Hello,
> last week we received new machines (DELL R720xd) for an extension of our
> ceph cluster.
> (64 Gb ram, 2x Xeon E5-2650, PERC H710P (really LSI MEGARAID), and 12x3
> TB disks + 2SSD (not used as cachecade))
>
> I was doing test on the raid card with kernel 3.4.38 to try to find what
> I can get of this beast with RAID5, when I noticed an unusual slow
> values on compilebench. The difference is very visible on the initial
> create tests (can detail more if needed).
>
> I finally observed that ONLY 3.4 kernels exhibit that behaviour ;
> 3.3.xxx and before are OK, 3.5.xxx and later are back to good values.
>
> I bisected the problem to this commit
>
> c999a223c2f0d31c64ef7379814cea1378b2b800 is the first bad commit
> commit c999a223c2f0d31c64ef7379814cea1378b2b800
> Author: Dave Chinner <dchinner@redhat.com>
> Date: Thu Mar 22 05:15:07 2012 +0000
>
> xfs: introduce an allocation workqueue
>
> I understand this regression is not a bug, and probably just a corner
> case of the new code, that was certainly corrected after during 3.5
> development (didn't tried to bisect this one, maybe dave know what is
> the corrective patch ?)
>
> The problem is that 3.4 is the last long-term kernel for the moment, and
> it's unfortunate it shows this regression.
>
> Maybe a backport of the fix (if this backport is possible AND not very
> intrusive) could be a good idea ?
>
> Cheers,
>

Here are the allocation worker changes.

The biggest performance commit should be aa292847, which limits the 
callers to the worker.

commit 3b876c8f2a361ceeed3fed894980c69066f903a0
Author: Jeff Liu <jeff.liu@oracle.com>
Date:   Thu Jun 7 15:44:32 2012 +0800

     xfs: fix debug_object WARN at xfs_alloc_vextent()

commit aa292847b9fc6e187547110de833a7d3131bbddf
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jul 12 07:40:43 2012 +1000

     xfs: don't defer metadata allocation to the workqueue

  commit 2455881c0b52f87be539c4c7deab1afff4d8a560
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Oct 5 11:06:58 2012 +1000

     xfs: introduce XFS_BMAPI_STACK_SWITCH

commit e04426b9202bccd4cfcbc70b2fa2aeca1c86d8f5
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Oct 5 11:06:59 2012 +1000

     xfs: move allocation stack switch up to xfs_bmapi_allocate

commit 9e96fe6df44425b69ed89f6ac20352cec1f127d7
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Jan 17 13:11:29 2013 -0500

     xfs: pull up stack_switch check into xfs_bmapi_write


The last 3 patches address an AGF buffer hang with the allocation worker.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
