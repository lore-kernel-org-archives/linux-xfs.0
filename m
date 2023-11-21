Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C96C5AD4C
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Nov 2023 02:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbjKUCuv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 21:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjKUCuu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 21:50:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587B9BC;
        Mon, 20 Nov 2023 18:50:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6589C433C9;
        Tue, 21 Nov 2023 02:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700535046;
        bh=uItyyBrHlmYRqbuInjqrR51CC24F/0OS4aIHR61emlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T8R1nSUGnYZXOszXGBao+f/c2FTXTMJBeZluuBWKJC780NAKy5BIRYf65rr43mF8A
         AaAol62685LB5ckNskckp8Zj1jaVtOK1hTYjFZFH40axcfFcnhNFxrLpbMEpVmKCwj
         DGmHxSsuwS1WV3yKI3ptW+w/PSIv3gnVXWuqmA7mW3nfyJcI1bVBnnop7d5YtjDnav
         GVYoYnmbAlVRlo3VAXQMXQa6AJVM4wIYgSR8ytCZdqY9WP2UNgMJDY0gKWYrJos72k
         yLgIS1Ee6zJxbEjql0VfyqErtmGPG1q9f+bei5BNH+6je+pwsk7rF9TNGwdcN5hjnE
         6/rFa2q2Ac/1Q==
Date:   Mon, 20 Nov 2023 21:50:45 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>, stable@vger.kernel.org,
        linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        ChenXiaoSong <chenxiaosong2@huawei.com>,
        Guo Xuenan <guoxuenan@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: Re: [PATCH 5.15 09/17] xfs: fix NULL pointer dereference in
 xfs_getbmap()
Message-ID: <ZVwbBaNExKrc35jw@sashalap>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
 <20231116022833.121551-9-leah.rumancik@gmail.com>
 <2023112053-monogamy-corned-68ba@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2023112053-monogamy-corned-68ba@gregkh>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 20, 2023 at 04:38:24PM +0100, Greg KH wrote:
>On Wed, Nov 15, 2023 at 06:28:25PM -0800, Leah Rumancik wrote:
>> From: ChenXiaoSong <chenxiaosong2@huawei.com>
>>
>> [ Upstream commit 001c179c4e26d04db8c9f5e3fef9558b58356be6 ]
>>
>> Reproducer:
>>  1. fallocate -l 100M image
>>  2. mkfs.xfs -f image
>>  3. mount image /mnt
>>  4. setxattr("/mnt", "trusted.overlay.upper", NULL, 0, XATTR_CREATE)
>>  5. char arg[32] = "\x01\xff\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00"
>>                    "\x00\x00\x00\x00\x00\x08\x00\x00\x00\xc6\x2a\xf7";
>>     fd = open("/mnt", O_RDONLY|O_DIRECTORY);
>>     ioctl(fd, _IOC(_IOC_READ|_IOC_WRITE, 0x58, 0x2c, 0x20), arg);
>>
>> NULL pointer dereference will occur when race happens between xfs_getbmap()
>> and xfs_bmap_set_attrforkoff():
>>
>>          ioctl               |       setxattr
>>  ----------------------------|---------------------------
>>  xfs_getbmap                 |
>>    xfs_ifork_ptr             |
>>      xfs_inode_has_attr_fork |
>>        ip->i_forkoff == 0    |
>>      return NULL             |
>>    ifp == NULL               |
>>                              | xfs_bmap_set_attrforkoff
>>                              |   ip->i_forkoff > 0
>>    xfs_inode_has_attr_fork   |
>>      ip->i_forkoff > 0       |
>>    ifp == NULL               |
>>    ifp->if_format            |
>>
>> Fix this by locking i_lock before xfs_ifork_ptr().
>>
>> Fixes: abbf9e8a4507 ("xfs: rewrite getbmap using the xfs_iext_* helpers")
>> Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
>> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> [djwong: added fixes tag]
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
>> Acked-by: Chandan Babu R <chandanbabu@kernel.org>
>> ---
>>  fs/xfs/xfs_bmap_util.c | 17 +++++++++--------
>>  1 file changed, 9 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index fd2ad6a3019c..bea6cc26abf9 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -439,29 +439,28 @@ xfs_getbmap(
>>  		whichfork = XFS_COW_FORK;
>>  	else
>>  		whichfork = XFS_DATA_FORK;
>> -	ifp = XFS_IFORK_PTR(ip, whichfork);
>>
>>  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
>>  	switch (whichfork) {
>>  	case XFS_ATTR_FORK:
>> +		lock = xfs_ilock_attr_map_shared(ip);
>>  		if (!XFS_IFORK_Q(ip))
>> -			goto out_unlock_iolock;
>> +			goto out_unlock_ilock;
>>
>>  		max_len = 1LL << 32;
>> -		lock = xfs_ilock_attr_map_shared(ip);
>>  		break;
>>  	case XFS_COW_FORK:
>> +		lock = XFS_ILOCK_SHARED;
>> +		xfs_ilock(ip, lock);
>> +
>>  		/* No CoW fork? Just return */
>> -		if (!ifp)
>> -			goto out_unlock_iolock;
>> +		if (!XFS_IFORK_PTR(ip, whichfork))
>> +			goto out_unlock_ilock;
>>
>>  		if (xfs_get_cowextsz_hint(ip))
>>  			max_len = mp->m_super->s_maxbytes;
>>  		else
>>  			max_len = XFS_ISIZE(ip);
>> -
>> -		lock = XFS_ILOCK_SHARED;
>> -		xfs_ilock(ip, lock);
>>  		break;
>>  	case XFS_DATA_FORK:
>>  		if (!(iflags & BMV_IF_DELALLOC) &&
>> @@ -491,6 +490,8 @@ xfs_getbmap(
>>  		break;
>>  	}
>>
>> +	ifp = XFS_IFORK_PTR(ip, whichfork);
>> +
>>  	switch (ifp->if_format) {
>>  	case XFS_DINODE_FMT_EXTENTS:
>>  	case XFS_DINODE_FMT_BTREE:
>> --
>> 2.43.0.rc0.421.g78406f8d94-goog
>>
>
>This patch breaks the build, how was it tested?
>
>fs/xfs/xfs_bmap_util.c: In function ‘xfs_getbmap’:
>fs/xfs/xfs_bmap_util.c:457:21: error: the comparison will always evaluate as ‘true’ for the address of ‘i_df’ will never be NULL [-Werror=address]
>  457 |                 if (!XFS_IFORK_PTR(ip, whichfork))
>      |                     ^
>In file included from fs/xfs/xfs_bmap_util.c:16:
>fs/xfs/xfs_inode.h:38:33: note: ‘i_df’ declared here
>   38 |         struct xfs_ifork        i_df;           /* data fork */
>      |                                 ^~~~
>cc1: all warnings being treated as errors

That's odd. I actually ended up queueing these patches earlier, and I
don't see any such warnings.

Looking at the code, this is a bit weird too - do you see these warnings
with the current 5.15 queue?

-- 
Thanks,
Sasha
