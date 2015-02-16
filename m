Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F2D2A7F4E
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 08:10:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA03E8F804C
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 06:10:44 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6c9ONBqwD5VyTSv0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 06:10:43 -0800 (PST)
Date: Mon, 16 Feb 2015 09:10:40 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 990 of file
	fs/xfs/xfs_ialloc.c
Message-ID: <20150216141039.GA48651@bfoster.bfoster>
References: <CAF1in6QW=PS0qfBAtQZHC23r+WVAXv5TLxFAr0r6RfTNiOnXcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAF1in6QW=PS0qfBAtQZHC23r+WVAXv5TLxFAr0r6RfTNiOnXcQ@mail.gmail.com>
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
To: Pablo Silva <psilvao@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 13, 2015 at 03:44:57PM -0300, Pablo Silva wrote:
> Hi !
> 
>     We have a server with centos 6.6, kernel version:
> 2.6.32-431.17.1.el6.x86_64, where we got the following message:
> 
> Feb 12 19:22:15 vtl kernel:
> Feb 12 19:22:15 vtl kernel: Pid: 3502, comm: touch Not tainted
> 2.6.32-431.17.1.el6.x86_64 #1
> Feb 12 19:22:15 vtl kernel: Call Trace:
> Feb 12 19:22:15 vtl kernel: [<ffffffffa041ae5f>] ?
> xfs_error_report+0x3f/0x50 [xfs]
> Feb 12 19:22:15 vtl kernel: [<ffffffffa0422980>] ? xfs_ialloc+0x60/0x6e0 [xfs]
> Feb 12 19:22:15 vtl kernel: [<ffffffffa041ec2e>] ? xfs_dialloc+0x43e/0x850 [xfs]
> Feb 12 19:22:15 vtl kernel: [<ffffffffa0422980>] ? xfs_ialloc+0x60/0x6e0 [xfs]
> Feb 12 19:22:15 vtl kernel: [<ffffffffa044007a>] ?
> kmem_zone_zalloc+0x3a/0x50 [xfs]
> Feb 12 19:22:15 vtl kernel: [<ffffffffa043b814>] ?
> xfs_dir_ialloc+0x74/0x2b0 [xfs]
> Feb 12 19:22:15 vtl kernel: [<ffffffffa043d900>] ? xfs_create+0x440/0x640 [xfs]
> Feb 12 19:22:15 vtl kernel: [<ffffffffa044aa5d>] ? xfs_vn_mknod+0xad/0x1c0 [xfs]
> Feb 12 19:22:15 vtl kernel: [<ffffffffa044aba0>] ? xfs_vn_create+0x10/0x20 [xfs]
> Feb 12 19:22:15 vtl kernel: [<ffffffff81198086>] ? vfs_create+0xe6/0x110
> Feb 12 19:22:15 vtl kernel: [<ffffffff8119bb9e>] ? do_filp_open+0xa8e/0xd20
> Feb 12 19:22:15 vtl kernel: [<ffffffff811a7ea2>] ? alloc_fd+0x92/0x160
> Feb 12 19:22:15 vtl kernel: XFS: Internal error
> XFS_WANT_CORRUPTED_GOTO at line 990 of file fs/xfs/xfs_ialloc.c.
> Caller 0xffffffffa0422980
> 

        /*
         * None left in the last group, search the whole AG
         */
        error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
        if (error)
                goto error0;
        XFS_WANT_CORRUPTED_GOTO(i == 1, error0);

        for (;;) {
                error = xfs_inobt_get_rec(cur, &rec, &i);
                if (error)
                        goto error0;
                XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
                if (rec.ir_freecount > 0)
                        break;
                error = xfs_btree_increment(cur, 0, &i);
                if (error)
                        goto error0;
--->            XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
        }

That corresponds to the check above. This code is part of the inode
allocator where we expect an AG to have free inodes and we're doing a
brute force search for a record. Apparently we go off the AG or some
other problem occurs before we find a free inode record.

Does 'xfs_repair -n' report any problems with this fs? Have there been
any other storage errors reported in the logs? Is the problem
reproducible or was it a one off occurrence?

Brian

> I can't find more information for this..., perhaps a bug or other
> thing ..., welcome any hint for to research..
> 
> Thanks in advance!
> 
> -Pablo

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
