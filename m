Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q56Df1AL222321 for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 08:41:02 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id z3zvbz6AwnWuN5yi for
	<xfs@oss.sgi.com>; Wed, 06 Jun 2012 06:41:00 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q56Dexel011151
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 09:40:59 -0400
Received: from laptop.bfoster (vpn-10-250.rdu.redhat.com [10.11.10.250])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q56Dew4n001936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 09:40:59 -0400
Message-ID: <4FCF5DB9.2000808@redhat.com>
Date: Wed, 06 Jun 2012 09:40:09 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: Still seeing hangs in xlog_grant_log_space
References: <CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
	<CADLDEKsGtsw-rrSOE7gY4T81u+p41b34ixv0B7Dh07afJ73n2w@mail.gmail.com>
	<CAH4wwdFu7DEkHFZ5Bf7_PtLPsG0hUyUDoov03q=82R6t+QkERg@mail.gmail.com>
	<20120605235447.GF22848@dastard>
In-Reply-To: <20120605235447.GF22848@dastard>
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
To: xfs@oss.sgi.com

On 06/05/2012 07:54 PM, Dave Chinner wrote:
> On Fri, May 25, 2012 at 01:03:04PM -0400, Peter Watkins wrote:
>> On Fri, May 25, 2012 at 2:28 AM, Juerg Haefliger <juergh@gmail.com> wrote:

snip

> At this point, running on a 3.5-rc1 kernel is what we need to get
> working reliably. Once we have the problems solved there, we can
> work out what set of patches need to be backported to 3.0-stable and
> other kernels to fix the problems in those supported kernels...
> 

Hi guys,

I've been reproducing a similar stall in my testing of the 're-enable
xfsaild idle mode' patch/thread that only occurs for me in the xfs tree.
I was able to do a bisect from rc2 down to commit 43ff2122, though the
history of this issue makes me wonder if this commit just makes the
problem more reproducible as opposed to introducing it. Anyways, the
characteristics I observe so far:

- Task blocked for more than 120s message in xlog_grant_head_wait(). I
see xfs_sync_worker() in my current bt, but I'm pretty sure I've seen
the same issue without it involved.
- The AIL is not empty/idle. It spins with a relatively small and
constant number of entries (I've seen ~8-40). These items are all always
marked as "flushing."
- Via crash, all the inodes in the ail appear to be marked as stale
(i.e. li_cb == xfs_istale_done). The inode flags are
XFS_ISTALE|XFS_IRECLAIMABLE|XFS_IFLOCK.
- The iflock in particular is why the ail marks these items 'flushing'
and why nothing seems to proceed any further (xfsaild just waits for
these to complete). I can kick the fs back into action with a 'sync.'

It looks like we only mark in inode stale when an inode cluster is
freed, so I repeated this test with 'ikeep' and cannot reproduce. I'm
not sure if anybody is testing for this in recent kernels (Mark?), but
if so I'd be curious if ikeep has any effect on your test (BTW, this is
still the looping 273 xfstest).

It seems like there could be some kind of race here with inodes being
marked stale, but also appears that either completion (xfs_istale_done()
or xfs_iflush_done()) should release the flush lock. I'll see if I can
trace it further and get anything useful...

Brian

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
