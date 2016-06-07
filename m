Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 754E47CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 23:40:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4725F8F8037
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 21:40:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4rjiPBtDTMYfjLT3 for <xfs@oss.sgi.com>;
	Mon, 06 Jun 2016 21:39:59 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id AA9E0B55
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 23:39:59 -0500 (CDT)
Subject: Re: crash in xfs in current
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
Date: Mon, 6 Jun 2016 23:39:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
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
To: xfs@oss.sgi.com

On 6/6/16 8:43 PM, Reinoud Koornstra wrote:
> Dear Dave and Everyone,
> 
> Today I crashed twice in a row in 4.7-rc1.
> This was the message and trace:
> 
> Jun  6 18:07:34 router-dev kernel: [  134.297442] XFS: Assertion failed: args->op_flags & XFS_DA_OP_OKNOENT, file: fs/xfs/libxfs/xfs_dir2_leaf.c, line: 1307

Ok, that ASSERT has been there since 2005 ...

> Jun  6 18:07:34 router-dev kernel: [  134.297459] ------------[ cut here ]------------
> Jun  6 18:07:34 router-dev kernel: [  134.297474] kernel BUG at fs/xfs/xfs_message.c:113!
> Jun  6 18:07:34 router-dev kernel: [  134.297485] invalid opcode: 0000 [#1] SMP
> Jun  6 18:07:34 router-dev kernel: [  134.297494] Modules linked in:

... unlinewrapping...

> Jun  6 18:07:34 router-dev kernel: [  134.297962] Stack:
> Jun  6 18:07:34 router-dev kernel: [  134.297967]  ffff8803f7ebbc40 ffffffffc0322277 ffff8803f7ebbc58 00000000ffffffff
> Jun  6 18:07:34 router-dev kernel: [  134.297986]  ffff8803ffffffff ffff880414673840 ffff8803f610b000 0000000000000000
> Jun  6 18:07:34 router-dev kernel: [  134.298004]  ffff880452bed380 0000000000000000 ffff003c00a7d2f1 00000000b56d2e47
> Jun  6 18:07:34 router-dev kernel: [  134.298022] Call Trace:
> Jun  6 18:07:34 router-dev kernel: [  134.298039] [<ffffffffc0322277>] xfs_dir2_leaf_lookup_int+0x237/0x350 [xfs]
> Jun  6 18:07:34 router-dev kernel: [  134.298064] [<ffffffffc03229e1>] xfs_dir2_leaf_replace+0x41/0x190 [xfs]
> Jun  6 18:07:34 router-dev kernel: [  134.298088] [<ffffffffc031c06c>] xfs_dir_replace+0x18c/0x1b0 [xfs]
> Jun  6 18:07:34 router-dev kernel: [  134.298114] [<ffffffffc035653f>] xfs_rename+0x45f/0x9d0 [xfs]
> Jun  6 18:07:34 router-dev kernel: [  134.298155] [<ffffffffc034f892>] xfs_vn_rename+0xb2/0xe0 [xfs]
> Jun  6 18:07:34 router-dev kernel: [  134.298169] [<ffffffff8122e824>] vfs_rename+0x5a4/0x940
> Jun  6 18:07:34 router-dev kernel: [  134.298195] [<ffffffff81233475>] SyS_rename+0x3d5/0x3f0
> Jun  6 18:07:34 router-dev kernel: [  134.298207] [<ffffffff819cd236>] entry_SYSCALL_64_fastpath+0x1e/0xa8
> Jun  6 18:07:34 router-dev kernel: [  134.298221] Code: 00 66 2e 0f 1f


> I seem to be able to hit this bug rather frequently.
> So I put in some instrumentation to print out the flags next time I
> hit it and save a core file to another fs.
> Is this is known bug to you or?

xfs_dir2_leaf_lookup_int() only hits that ASSERT if it was given
a name to rename, and failed to find the original.  i.e. that should
not happen.

        /*
         * Loop over all the entries with the right hash value
         * looking to match the name.
         */

<do that loop>
<fail to find the hash value for the name>
<then:>

        ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
        /*
         * Here, we can only be doing a lookup (not a rename or remove).
         * If a case-insensitive match was found earlier, re-read the
         * appropriate data block if required and return it.
         */

A rename should never fail to find the original name.

Did this problem only show up after an update?

Do you have a reproducer?

Have you unmounted and run an "xfs_repair -n" and captured the output
to see if there is any on-disk corruption?

You might gather an xfs_metadump as well, before you do any live
repair that might change the filesystem.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
