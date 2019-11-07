Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DD8C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 05:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DE632166E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 05:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ItbUUjGr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfKGFPY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 00:15:24 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39963 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfKGFPY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 00:15:24 -0500
Received: by mail-pl1-f193.google.com with SMTP id e3so607916plt.7
        for <linux-xfs@vger.kernel.org>; Wed, 06 Nov 2019 21:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=idMU2HnkOGduXUe6RyXWfVbudbzp70Ue3yBUVfLpXMo=;
        b=ItbUUjGrRYSgSCZV+WLz0mgv8AJXH5g+zZ6Y6SYrAoshJz3zYN2F/GdRWEzN9EnJNu
         mY+jrPO13J0YThMUr319igZ0c5T6doc5F86wWbEh7a1sOm5kCRxz4NbYD3n+M3Nz0ZT+
         Bk++s1919NF/gKHol6X8bIV+QzIPMk3Rr33lUTf7VMidZwjcDto51hsCOROtrfFD/PgS
         ZLIBj3p2ZVdx2qg1AqT8sOXjpfWc1yEn1fqgFjCCkHoFj1RR/K0ff+H5VWGcA7mMHsXj
         4DrgS5EEeJriaiOofG+7hKAy5kJZmTO2oraUPpB1Zp+rUvlOalYQ4/iSHbfc8ksuAAcN
         qvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=idMU2HnkOGduXUe6RyXWfVbudbzp70Ue3yBUVfLpXMo=;
        b=ZYxsh1e8WhbdZuDRx46V0sdrXwvd9P2Pw4wzjTmoYEncP1jbHb9Juk0WaudNrREzk3
         j921wPF0M016QBRrVxK1Zpd2TYGj2/0Km8AyzxTIQUwWAjZY+sjtB+G/Tsq2HR+zAWZE
         dNl27cIhwou4HYw2TETfNxOTY0ivfkXMwGvk7mA7iigJf9R2K4AGB2H2br24rlxrwXtW
         O4/VrY9pJrTK7hPrlYI7omk4GHCa+y8OymiUcIr7aSgLN0iIpjAZS5xwRN7tGICnMKlu
         p1EFk6uzBc6KOyyp2Q6nXOVuMdSLilTldW3b6tFnQk4RaBXIxzmL9/x09+C8wAyCyhPl
         rKAw==
X-Gm-Message-State: APjAAAXu6RayrSTEEqw7OA0hmUKT17JD1uIICoDCAwZxJEjnaPSVPsrQ
        dkwV/V3T0eKeDK3zo46U6w==
X-Google-Smtp-Source: APXvYqyf3UT6YkrGlB+Mdn/Kpx2j7mYdTuUb5DFrviM89d1Ii0Eg4hJo9UOCwtlYlCF3O1nMWnum8w==
X-Received: by 2002:a17:902:9a8b:: with SMTP id w11mr1705662plp.9.1573103723267;
        Wed, 06 Nov 2019 21:15:23 -0800 (PST)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id r24sm843611pgu.36.2019.11.06.21.15.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 21:15:22 -0800 (PST)
Subject: Re: [PATCH v2] xfs: Fix deadlock between AGI and AGF when target_ip
 exists in xfs_rename()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
References: <1572947532-4972-1-git-send-email-kaixuxia@tencent.com>
 <20191106045630.GO15221@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <28d11503-5ac0-0a3d-9b7d-0d7daec7da8b@gmail.com>
Date:   Thu, 7 Nov 2019 13:15:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191106045630.GO15221@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2019/11/6 12:56, Darrick J. Wong wrote:
> On Tue, Nov 05, 2019 at 05:52:12PM +0800, kaixuxia wrote:
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
>> Changes in v2:
>>  - Add xfs_dir2_sf_replace_needblock() helper in
>>    xfs_dir2_sf.c.
>>
>>  fs/xfs/libxfs/xfs_dir2.c      | 23 +++++++++++++++++++++++
>>  fs/xfs/libxfs/xfs_dir2.h      |  2 ++
>>  fs/xfs/libxfs/xfs_dir2_priv.h |  2 ++
>>  fs/xfs/libxfs/xfs_dir2_sf.c   | 24 ++++++++++++++++++++++++
>>  fs/xfs/xfs_inode.c            | 14 ++++++++++++++
>>  5 files changed, 65 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
>> index 867c5de..1917990 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.c
>> +++ b/fs/xfs/libxfs/xfs_dir2.c
>> @@ -463,6 +463,29 @@
>>  }
>>  
>>  /*
>> + * Check whether the replace operation need more blocks. Ignore
>> + * the parameters check since the real replace() call below will
>> + * do that.
>> + */
>> +bool
>> +xfs_dir_replace_needblock(
> 
> xfs_dir2, to be consistent.
> 
>> +	struct xfs_inode	*dp,
>> +	xfs_ino_t		inum)
> 
> If you passed the inode pointer (instead of ip->i_ino) here then you
> don't need to revalidate the inode number.
> 
>> +{
>> +	int			rval;
>> +
>> +	rval = xfs_dir_ino_validate(dp->i_mount, inum);
>> +	if (rval)
>> +		return false;
>> +
>> +	/*
>> +	 * Only convert the shortform directory to block form maybe
>> +	 * need more blocks.
>> +	 */
>> +	return xfs_dir2_sf_replace_needblock(dp, inum);
> 
> 	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> 		return xfs_dir2_sf_replace_needblock(...);
> 
> Also, do other directories formats need extra blocks allocated?

Yeah, I think so. Other dirs formats only need to change the
inode number to the new value and extra blocks are not necessary
for them.
> 
>> +}
>> +
>> +/*
>>   * Replace the inode number of a directory entry.
>>   */
>>  int
>> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
>> index f542447..e436c14 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.h
>> +++ b/fs/xfs/libxfs/xfs_dir2.h
>> @@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
>>  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
>>  				struct xfs_name *name, xfs_ino_t ino,
>>  				xfs_extlen_t tot);
>> +extern bool xfs_dir_replace_needblock(struct xfs_inode *dp,
>> +				xfs_ino_t inum);
>>  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>>  				struct xfs_name *name, xfs_ino_t inum,
>>  				xfs_extlen_t tot);
>> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
>> index 59f9fb2..002103f 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
>> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
>> @@ -116,6 +116,8 @@ extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
>>  extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
>>  extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
>>  extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
>> +extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
>> +		xfs_ino_t inum);
>>  extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
>>  extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
>>  
>> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
>> index 85f14fc..0906f91 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
>> @@ -945,6 +945,30 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
>>  }
>>  
>>  /*
>> + * Check whether the replace operation need more blocks.
>> + */
>> +bool
>> +xfs_dir2_sf_replace_needblock(
> 
> Urgggh.  This is a predicate that we only ever call from xfs_rename(),
> right?  And it addresses a particular quirk of the locking when the
> caller wants us to rename on top of an existing entry and drop the link
> count of the old inode, right?  So why can't this just be a predicate in
> xfs_inode.c ?  Nobody else needs to know this particular piece of
> information, AFAICT.
> > (Apologies, for Brian and I clearly aren't on the same page about
> that...)
Hmm... sorry, I had misunderstood Brian's mean. Right, maybe we only
need the xfs_dir2_sf_replace_needblock() call, and then involve it
in both places.

Thanks for your comments, will address them soon and send v3.

Kaixu
> 
>> +	struct xfs_inode	*dp,
>> +	xfs_ino_t		inum)
>> +{
>> +	int			newsize;
>> +	xfs_dir2_sf_hdr_t	*sfp;
>> +
>> +	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
>> +		return false;
> 
> This check should be used up in xfs_dir2_replace_needblock() to decide
> if we're calling xfs_dir2_sf_replace_needblock(), or just returning
> false.
> 
>> +
>> +	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>> +	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
>> +
>> +	if (inum > XFS_DIR2_MAX_SHORT_INUM &&
>> +	    sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp))
>> +		return true;
>> +	else
>> +		return false;
> 
> return inum > XFS_DIR2_MAX_SHORT_INUM && (all the rest of that);
> 
>> +}
>> +
>> +/*
>>   * Replace the inode number of an entry in a shortform directory.
>>   */
>>  int						/* error */
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 18f4b26..c239070 100644
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
>> @@ -3361,6 +3362,19 @@ struct xfs_iunlink {
>>  		 * In case there is already an entry with the same
>>  		 * name at the destination directory, remove it first.
>>  		 */
>> +
>> +		/*
>> +		 * Check whether the replace operation need more blocks.
>> +		 * If so, acquire the agi lock firstly to preserve locking
> 
>                                                "first"
> 
>> +		 * order(AGI/AGF).
> 
> Nit: space between "order" and "(AGI/AGF)".
>> +		 */
>> +		if (xfs_dir_replace_needblock(target_dp, src_ip->i_ino)) {
>> +			error = xfs_read_agi(mp, tp,
>> +					XFS_INO_TO_AGNO(mp, target_ip->i_ino), &agibp);
> 
> Overly long line here.
> 
> --D
> 
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

-- 
kaixuxia
