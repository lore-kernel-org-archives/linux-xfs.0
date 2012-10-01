Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q91LUJa5197313 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 16:30:19 -0500
Message-ID: <506A0BB8.8090204@sgi.com>
Date: Mon, 01 Oct 2012 16:31:36 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
	<5069F9B0.50804@redhat.com>
In-Reply-To: <5069F9B0.50804@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 10/01/12 15:14, Brian Foster wrote:
<deletes by mt>
> Heads up... I was doing some testing against my eofblocks set rebased
> against this patchset and I'm reproducing a new 273 failure. The failure
> bisects down to this patch.
>
> With the bisection, I'm running xfs top of tree plus the following patch:
>
> xfs: only update the last_sync_lsn when a transaction completes
>
> ... and patches 1-6 of this set on top of that. i.e.:
>
> xfs: xfs_sync_data is redundant.
> xfs: Bring some sanity to log unmounting
> xfs: sync work is now only periodic log work
> xfs: don't run the sync work if the filesystem is read-only
> xfs: rationalise xfs_mount_wq users
> xfs: xfs_syncd_stop must die
> xfs: only update the last_sync_lsn when a transaction completes
> xfs: Make inode32 a remountable option
>
> This is on a 16p (according to /proc/cpuinfo) x86-64 system with 32GB
> RAM. The test and scratch volumes are both 500GB lvm volumes on top of a
> hardware raid. I haven't looked into this at all yet but I wanted to
> drop it on the list for now. The 273 output is attached.
>
> Brian

  <deletes by mt>
>
>
> 273.out.bad
>
>
> QA output created by 273
> ------------------------------
> start the workload
> ------------------------------
> _porter 31 not complete
> _porter 79 not complete
> _porter 149 not complete_porter 74 not complete
> _porter 161 not complete
> _porter 54 not complete
> _porter 98 not complete
> _porter 99 not complete
> _porter 167 not complete
> _porter 76 not complete
> _porter 45 not complete
> _porter 152 not complete
> _porter 173 not complete_porter 24 not complete

  <deletes by mt>

I see it too on a single machine. It looks like an interaction between 
patch 06 and the "...update the last_sync_lsn...".

I like the "...update the last_sync_lsn ..." patch because it fixes the 
"xlog_verify_tail_lsn: tail wrapped" and "xlog_verify_tail_lsn: ran out 
of log space" messages that I am getting on that machine.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
