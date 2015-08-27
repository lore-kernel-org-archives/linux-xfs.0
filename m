Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A75127F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 22:35:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43202AC006
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 20:35:24 -0700 (PDT)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com
	[209.85.215.54]) by cuda.sgi.com with ESMTP id eG897zvBHEAb7wWV
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2015 20:35:22 -0700 (PDT)
Received: by labgv11 with SMTP id gv11so4003139lab.2
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 20:35:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150813071524.GI17933@dhcp-13-216.nay.redhat.com>
References: <1439449276-1699-1-git-send-email-eguan@redhat.com>
	<20150813071524.GI17933@dhcp-13-216.nay.redhat.com>
Date: Thu, 27 Aug 2015 11:35:20 +0800
Message-ID: <CADVQ27qSWx1jJS_8+X3Xf+oF-ttZSdZysnKbcujx_Qegfufybw@mail.gmail.com>
Subject: Re: [PATCH] repair: fix wrong logic when validating node magic number
From: Zorro Lang <zorro.lang@gmail.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

2015-08-13 15:15 GMT+08:00 Eryu Guan <eguan@redhat.com>:
> On Thu, Aug 13, 2015 at 03:01:16PM +0800, Eryu Guan wrote:
>> Magic number is wrong only when != XFS_DA_NODE_MAGIC and
>> != XFS_DA3_NODE_MAGIC.
>>
>> This is triggered by shared/002 when testing 512 block size XFS.
>>
>>   Phase 1 - find and verify superblock...
>>   Phase 2 - using internal log
>>           - scan filesystem freespace and inode maps...
>>           - found root inode chunk
>>   Phase 3 - for each AG...
>>           - scan (but don't clear) agi unlinked lists...
>>           - process known inodes and perform inode discovery...
>>           - agno = 0
>>   bad magic number febe in block 64 (108) for directory inode 35
>>   ......
>>
>> Fix it by changing "||" to "&&".
>>
>> Signed-off-by: Eryu Guan <eguan@redhat.com>
>
> With this patch applied, shared/002 still fails on 512 block size XFS,


This failure not only be reproduced on 512 block size XFS. When I increase
the stress of shared/002, this bug can be reproduced on any block size XFS.

For example, on my test machine, when I increase $num_attrs to 6000, this
bug be reproduced on 1k block size xfs. When increased $num_attrs to 80k,
this bug be reproduced on 4k block size xfs.

So this's not a block size related bug.

BTW, xfs_repair can repair this corruption. And from shared/002 output, we can
see shared/002 use getfattr to sure all xattrs haven been wrote in
device correctly.
So this corruption maybe due to xfs log problems.

Thanks,
Zorro Lang

> full xfs_repair -n output is
>
> *** xfs_repair -n output ***
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> problem with attribute contents in inode 35
> would clear attr fork
> bad nblocks 67 for inode 35, would reset to 0
> bad anextents 5 for inode 35, would reset to 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> *** end xfs_repair output
>
> And a simplified reproducer is just adding >= 577 xattrs to file foo on
> 512 block size XFS, no dmflaky is needed.
>
> num_xattrs=577
> for ((i = 1; i <= $num_xattrs; i++)); do
>         name="user.attr_$(printf "%04d" $i)"
>         $SETFATTR_PROG -n $name -v "val_$(printf "%04d" $i)" $SCRATCH_MNT/foo
> done
>
> And it's easily reproduced.
>
> Thanks,
> Eryu
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
