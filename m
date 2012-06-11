Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BKx57F136499 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 15:59:05 -0500
Message-ID: <4FD65C19.8080303@sgi.com>
Date: Mon, 11 Jun 2012 15:59:05 -0500
From: Mark Tinguely <tinguely@sgi.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Juerg Haefliger <juergh@gmail.com>, bpm@sgi.com, Peter Watkins <treestem@gmail.com>, xfs@oss.sgi.com

On 06/05/12 18:54, Dave Chinner wrote:


>> Reading bug #922 I see your test case reproduces in recent kernels, so
>> there must be a newer problem also.
>
> Right, that's what we need to find - it appears to be a CIL
> stall/accounting leak, completely unrelated to all the other AIL/log
> space stalls that have been occurring. Last thing is that I was
> waiting for more information on the stall that mark T @ sgi was able
> to reproduce. I haven't heard anything from him since I asked for
> more information on May 23....
>
...

>
> Cheers,
>
> Dave.

I am using the test instructions/programs in the above bug report

  1) Linux 3.5rc1
  2) temporary band-aid of performing a xfs_log_force() before the
     xfs_fs_log_dummy() in the xfs_sync_worker().
   a) Even with a xfs_log_force(), it is still possible to hang the sync
      worker.
   b) or replacing the band-aid with Brian Foster's "xfs: check for stale
      inode before acquiring iflock on push" patch also resulted in a
      quick hard hang.
      i) side note, printk routines in Linux 3.5rc1 has a "struct log"
        item that crash wants to use instead of XFS's "struct log". I
  3) small log (576K)
   a) size of the log in important. The smaller the log, the easier it
      is to hang. 2+MB logs are much harder to hang.
  4) perl program that has multiple workers doing cp/rm.

Sorry Dave, I did not realize you were waiting for more information from 
me. I thought the fixing the sync worker was more important.
I also was hoping empty AIL hang was a result of the band-aid
xfs_log_force() and not a second problem.

I will use the above to try to recreate and core the hang on Linux 
3.5rc1 where the AIL is empty.



Thanks.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
