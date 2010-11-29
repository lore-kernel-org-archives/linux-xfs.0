Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATFrbdf183541 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 09:53:37 -0600
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8595F1C7EE0E
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 07:55:19 -0800 (PST)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	WKhhJ7hIHeEzPJJb for <xfs@oss.sgi.com>;
	Mon, 29 Nov 2010 07:55:19 -0800 (PST)
Received: by qyk11 with SMTP id 11so36862qyk.5
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 07:55:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101129145523.GA22839@infradead.org>
References: <AANLkTikUOZJeSnSHO+pAM5d6DjWEPBdUSiua1dcv0pxt@mail.gmail.com>
	<20101129145523.GA22839@infradead.org>
Date: Mon, 29 Nov 2010 21:25:18 +0530
Message-ID: <AANLkTi=aRdWhYbPTt0nBQD+yBfJxTEV+ospxTkRC3npT@mail.gmail.com>
Subject: Re: XFS repair utils
From: naveen yadav <yad.naveen@gmail.com>
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
Cc: xfs@oss.sgi.com

Thanks for your response.

I am using ARM as my target, and I got some time issue in radix tree..
with error Kernel BUG.

radix_tree_tag_set+0x74/0xe43


[<801dfa80>] radix_tree_tag_set+0x74/0xe4 from[<801b6be0>]
__xfs_inode_set_reclaim_tag+0x4c/0x7358:49:736
0358:49:736
[<801b6be0>] __xfs_inode_set_reclaim_tag+0x4c/0x70 from[<801b6c58>]
xfs_inode_set_reclaim_tag+0358:49:752
x54/0xb8358:49:752
[<801b6c58>] xfs_inode_set_reclaim_tag+0x54/0xb8 from[<80182948>]
xfs_iget+0x7d8/0x8b0358:49:752
[<80182948>] xfs_iget+0x7d8/0x8b0 from[<801a0eb0>]
xfs_trans_iget+0x48/0x88358:49:767
[<801a0eb0>] xfs_trans_iget+0x48/0x88 from[<80186e88>]
xfs_ialloc+0xd4/0x5b8358:49:767
[<80186e88>] xfs_ialloc+0xd4/0x5b8 from[<801a2014>]
xfs_dir_ialloc+0x98/0x2a4358:49:783
[<801a2014>] xfs_dir_ialloc+0x98/0x2a4 from[<801a48b4>]
xfs_create+0x2e0/0x6b8358:49:783
[<801a48b4>] xfs_create+0x2e0/0x6b8 from[<801b2fc0>]
xfs_vn_mknod+0xc0/0x130358:49:783
[<801b2fc0>] xfs_vn_mknod+0xc0/0x130 from[<800c22cc>]
vfs_create+0x80/0xe4358:49:799
[<800c22cc>] vfs_create+0x80/0xe4 from[<800c5328>]
do_filp_open+0x284/0x8c8358:49:799
[<800c5328>] do_filp_open+0x284/0x8c8 from[<800b5858>]
do_sys_open+0x6c/0x114358:49:814
[<800b5858>] do_sys_open+0x6c/0x114 from[<800102c4>]
stack_done+0x20/0x3c358:49:814









On Mon, Nov 29, 2010 at 8:25 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Nov 29, 2010 at 07:30:50PM +0530, naveen yadav wrote:
>> Hi All,
>>
>> I am using XFS 2.6.34 kernel on my target, and I have
>> #xfs_repair -V
>> xfs_repair version 3.0.5
>>
>> So is there any issue of compatibility with latest XFS_repair utils.
>> or it will work fine with my latest kernel(2.6.34).
>
> It works just fine, but the 3.1.x series of xfsprogs brings large
> repair memory savings.
>
>> Since some time mount fails.
>
> What mount messages, what platform?
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
