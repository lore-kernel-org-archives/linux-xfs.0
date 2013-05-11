Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45DD629DF8
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 20:15:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31D6C30405F
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 18:15:13 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KwS8huHkOtSIBcoG for <xfs@oss.sgi.com>;
	Fri, 10 May 2013 18:15:08 -0700 (PDT)
Date: Sat, 11 May 2013 11:15:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Error during bulk removal of files
Message-ID: <20130511011505.GB32675@dastard>
References: <CAEUQcejFPKDqqwbT_BNFJEVkUeAY=mgYGv-kUvLX6Ys7YQkqfg@mail.gmail.com>
	<518D22F0.8040405@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518D22F0.8040405@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Subranshu Patel <spatel.ml@gmail.com>, xfs@oss.sgi.com

On Fri, May 10, 2013 at 11:40:16AM -0500, Mark Tinguely wrote:
> On 05/10/13 11:17, Subranshu Patel wrote:
> 
> <reformated> Call Trace:
> 
>  [<ffffffffa056c492>] xlog_wait+0x72/0x90 [xfs]
>  [<ffffffff81060250>] ? default_wake_function+0x0/0x20
>  [<ffffffffa056e08b>] xlog_grant_log_space+0x3ab/0x520 [xfs]
>  [<ffffffffa0582d1a>] ? kmem_zone_zalloc+0x3a/0x50 [xfs]
>  [<ffffffff8127f3ac>] ? random32+0x1c/0x20
>  [<ffffffffa057d201>] ? xfs_trans_ail_push+0x21/0x80 [xfs]
>  [<ffffffffa056e2e6>] xfs_log_reserve+0xe6/0x140 [xfs]
>  [<ffffffffa057bad0>] xfs_trans_reserve+0xa0/0x210 [xfs]
>  [<ffffffffa055f0a3>] xfs_fs_log_dummy+0x43/0x90 [xfs]
>  [<ffffffffa056c9c4>] ? xfs_log_need_covered+0x94/0xd0 [xfs]
>  [<ffffffffa0591831>] xfs_sync_worker+0x81/0x90 [xfs]
>  [<ffffffffa059171e>] xfssyncd+0x17e/0x210 [xfs]
>  [<ffffffffa05915a0>] ? xfssyncd+0x0/0x210 [xfs]
>  [<ffffffff81091d66>] kthread+0x96/0xa0
>  [<ffffffff8100c14a>] child_rip+0xa/0x20
>  [<ffffffff81091cd0>] ? kthread+0x0/0xa0
>  [<ffffffff8100c140>] ? child_rip+0x0/0x20
> 
> Ran out of log grant space trying to write out the dummy record in
> the sync worker.
> 
> Something is not getting moved off the AIL. This could be a symptom;
> for example a lock not being released could lead to depleted log
> space. What else is happening on the filesystem?
> 
> >
> >--------------------->8------------
> >
> >The XFS filesystem size is 14TB (LVM), kernel version 2.6.32

What 2.6.32 kernel? Output of uname -a?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
