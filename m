Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41793C17441
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 06:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B1A4214E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 06:44:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwBQ20TO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbfKLGoi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 01:44:38 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35297 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfKLGoi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 01:44:38 -0500
Received: by mail-pf1-f193.google.com with SMTP id q13so219138pff.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2019 22:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Roe7PDYeA2LX1VypH3s7YHueUglglHC5iOfiFZefooI=;
        b=DwBQ20TONmT3pS190nxOzoyO3KqHNL0wJ7+XZbrKgKfU3nzj3M5GqLv8KS6Bkslw4o
         bB0gUMZH2owI35QUXWHPj+QyRHdr7UVbgineWYaPve281vg63NuvVtrFUaqx7ReTlNrU
         RBWFkUtPMyUyfOYtsHJr2c4K2At9kjpr1c1wX1Mw84qbCnVN+pAd4zgSnz4OpH9QeL1F
         r0bnwvYgfnoa8L2O+SLsxVE5F89tPlhJYUC8QuS/eYxDdFWhh99n24v6S0d40MUrp3xD
         J9NzTnU0Rp6Lptah7XrhGSmaSEriLTg15+1gUeYX5WyLwzVRrPmHlnuz08Crrp9/HGPj
         GEBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Roe7PDYeA2LX1VypH3s7YHueUglglHC5iOfiFZefooI=;
        b=mtPD3bY/yAcK7sr//JtSudT7nWoKcFuMNNzcGTNBx2L6tzyl/6h1jrTZKpbhz+yOy9
         g76RLugQnT3S5kiPEeG2b0RVtiN5Y5RPygGrUhKXMCniCdKLvzO8cWniAySzzSQJtNax
         NSeXistCI7wHblFNzoxHEyTbQv2F0ELfCfB5dTc2CiG8uCxURszpCi7jz/5yON7cf70G
         0ADUleizl8y3XxmKaaOO5IAgKjhUdgLsDcqciwT6u1HLHI4Unj8o+gB4KzbTqB3dhITM
         aPF2K+HFjqSed1ZDqZbnJzsSy4Y3XzgW90o3RE/xkgkY/YRtJWyAyEXX/RJNAzntOiTH
         uMog==
X-Gm-Message-State: APjAAAVjRB1MbXBYzJEsuhZ5d+hgTiIo3hyN9wC/ZOkRfVDdJdjs8GT0
        6Ga07GAmIC1a1Tyzi47uLDmhTBQ=
X-Google-Smtp-Source: APXvYqwqcUUZVfKvCk74bOq+q/9bdWj3GUfCZujsygNSEXKJfRiT9iKW83ooc9PWbfw+ThgMJgFtRg==
X-Received: by 2002:a63:4a50:: with SMTP id j16mr34553538pgl.308.1573541077376;
        Mon, 11 Nov 2019 22:44:37 -0800 (PST)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id z16sm18896002pge.55.2019.11.11.22.44.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 22:44:36 -0800 (PST)
Subject: Re: [PATCH v3] xfs: Fix deadlock between AGI and AGF when target_ip
 exists in xfs_rename()
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        newtongao@tencent.com, jasperwang@tencent.com
References: <1573128491-14996-1-git-send-email-kaixuxia@tencent.com>
 <20191111132236.GA46312@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <dd583ac6-7476-bcda-61d2-bd41336fd497@gmail.com>
Date:   Tue, 12 Nov 2019 14:44:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191111132236.GA46312@bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/11/11 21:22, Brian Foster wrote:
> On Thu, Nov 07, 2019 at 08:08:11PM +0800, kaixuxia wrote:
>> When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
>> need to hold the AGF lock to allocate more blocks, and then invoking
>> the xfs_droplink() call to hold AGI lock to drop target_ip onto the
>> unlinked list, so we get the lock order AGF->AGI. This would break the
>> ordering constraint on AGI and AGF locking - inode allocation locks
>> the AGI, then can allocate a new extent for new inodes, locking the
>> AGF after the AGI.
>>
>> In this patch we check whether the replace operation need more
>> blocks firstly. If so, acquire the agi lock firstly to preserve
>> locking order(AGI/AGF). Actually, the locking order problem only
>> occurs when we are locking the AGI/AGF of the same AG. For multiple
>> AGs the AGI lock will be released after the transaction committed.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> ---
>> Changes in v3:
>>  -Invoke xfs_dir2_sf_replace_needblock() call in xfs_inode.c
>>   directly.
>>  -Fix the typo.
>>
>>  fs/xfs/libxfs/xfs_dir2.h    |  2 ++
>>  fs/xfs/libxfs/xfs_dir2_sf.c | 21 +++++++++++++++++++++
>>  fs/xfs/xfs_inode.c          | 15 +++++++++++++++
>>  3 files changed, 38 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
>> index f542447..d4a2b09 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.h
>> +++ b/fs/xfs/libxfs/xfs_dir2.h
>> @@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
>>  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
>>  				struct xfs_name *name, xfs_ino_t ino,
>>  				xfs_extlen_t tot);
>> +extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
>> +				struct xfs_inode *src_ip);
>>  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>>  				struct xfs_name *name, xfs_ino_t inum,
>>  				xfs_extlen_t tot);
>> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
>> index 85f14fc..7098cdd 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
>> @@ -945,6 +945,27 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
>>  }
>>  
>>  /*
>> + * Check whether the sf dir replace operation need more blocks.
>> + */
>> +bool
>> +xfs_dir2_sf_replace_needblock(
>> +	struct xfs_inode	*dp,
>> +	struct xfs_inode	*src_ip)
>> +{
>> +	int			newsize;
>> +	xfs_dir2_sf_hdr_t	*sfp;
> 
> We shouldn't introduce new typedef usages. Please use struct
> xfs_dir2_sf_hdr here and throughout the patch.

OKay, will fix it in the next version.
> 
>> +
>> +	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
>> +		return false;
>> +
>> +	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>> +	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
>> +
>> +	return src_ip->i_ino > XFS_DIR2_MAX_SHORT_INUM &&
>> +	       sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp);
>> +}
>> +
> 
> The whole point of this function is to reduce code duplication. There
> should be two callers, one down in the dir code that does the format
> conversion and the new caller in the higher level code to grab the AGI.

Yeah, will add the logic.
Thanks for your comments!

Kaixu
> 
> Brian
> 
>> +/*
>>   * Replace the inode number of an entry in a shortform directory.
>>   */
>>  int						/* error */
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 18f4b26..cb0b93b 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -3196,6 +3196,7 @@ struct xfs_iunlink {
>>  	struct xfs_trans	*tp;
>>  	struct xfs_inode	*wip = NULL;		/* whiteout inode */
>>  	struct xfs_inode	*inodes[__XFS_SORT_INODES];
>> +	struct xfs_buf		*agibp;
>>  	int			num_inodes = __XFS_SORT_INODES;
>>  	bool			new_parent = (src_dp != target_dp);
>>  	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
>> @@ -3361,6 +3362,20 @@ struct xfs_iunlink {
>>  		 * In case there is already an entry with the same
>>  		 * name at the destination directory, remove it first.
>>  		 */
>> +
>> +		/*
>> +		 * Check whether the replace operation need more blocks.
>> +		 * If so, acquire the agi lock firstly to preserve locking
>> +		 * order (AGI/AGF). Only convert the shortform directory to
>> +		 * block form maybe need more blocks.
>> +		 */
>> +		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip)) {
>> +			error = xfs_read_agi(mp, tp,
>> +				XFS_INO_TO_AGNO(mp, target_ip->i_ino), &agibp);
>> +			if (error)
>> +				goto out_trans_cancel;
>> +		}
>> +
>>  		error = xfs_dir_replace(tp, target_dp, target_name,
>>  					src_ip->i_ino, spaceres);
>>  		if (error)
>> -- 
>> 1.8.3.1
>>
> 

-- 
kaixuxia
