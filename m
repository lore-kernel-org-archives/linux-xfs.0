Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B8ECA9ECF
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 08:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F83E21929
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 08:57:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ho8lyfDV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfKDI5E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 03:57:04 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35796 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfKDI5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 03:57:03 -0500
Received: by mail-pl1-f195.google.com with SMTP id x6so7292847pln.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Nov 2019 00:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KAJQv/Oji918Ria58KmBfmsUn6Eh1udyF0HjErfmhcY=;
        b=Ho8lyfDVjR3Ns/ClrfT6R7nq8SpHFZAP4nimho+EItZ13Mg0qnEjWOSLPGYeBso+zk
         86M0ZJ5fAeiIjes8DogvWAFl9auWR7qnRePp+dKVf9mcGveT22CIDRBcKnmMernNgOY7
         RbmHYG2d+PXaiKcVvk10XX8XJB9abF8W+zq118J73cLATjt7wMWKWa4p/GS4exfcSZNm
         ssUCjCeFTSBMVP19PiksiJpsoX84kuQZO+zfdP0VtIp9W06WkYDOSucxWgfMM/IgHa/d
         V+AO0m9Kk/aGvDyxZHEC35AoXOU1JRVnX2fBmUkE8x+/pw6MIWx+v8MYLB8UKFQfJVEc
         MYVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KAJQv/Oji918Ria58KmBfmsUn6Eh1udyF0HjErfmhcY=;
        b=uIQd9+yRzxc1ZxMG2cPXGAly2bdmdi0NV4HiejiMxg+7KNh23ICBFy5AudFC3bicdf
         q3/WaY1BYArUN5IFR5IYoRDN6ZjbgwnGiVs3FgIUKj5FT1+Azl9t9ga/YpOUTSAo+AX6
         0JdOAMYirhXLyDW+wMiCiPQz10NkZfnkFt1vm6nr4n83pNp4NivBiRUOssO4ATQ9OiNC
         KH/RYJp3+JmpFWchz0WVW8ED9CsRenDJihvbRnS72WNx6U1j5VBPESvu/YSSbHe4y9X0
         zKckF/s0RLN0QM2qtrrdEz+zGDGhZzOiz6fRPEcUHKlhveCOxH38By4pKtWHNTbJqcC4
         CGJw==
X-Gm-Message-State: APjAAAX7WGvlHfoIVWfFXIx7OB8ATo4tC0pP484jWcU8dEuSapGRh65z
        hauCwDqH3B8YiLmd1T4gJQ==
X-Google-Smtp-Source: APXvYqxHK1ZHstCI+CvVJW9dhvSIVvud8ECE19vEHVPlidPbyGKIGsejabJC0aljuQslo+k+d6Tyjg==
X-Received: by 2002:a17:902:868e:: with SMTP id g14mr26038470plo.182.1572857822801;
        Mon, 04 Nov 2019 00:57:02 -0800 (PST)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id z23sm2550096pgj.43.2019.11.04.00.57.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Nov 2019 00:57:02 -0800 (PST)
Subject: Re: [PATCH RFC] xfs: Fix deadlock between AGI and AGF when target_ip
 exists in xfs_rename()
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        newtongao@tencent.com, jasperwang@tencent.com
References: <1572428974-8657-1-git-send-email-kaixuxia@tencent.com>
 <20191031122701.GB54006@bfoster>
 <3eb29cb7-8cb4-4cdd-dcf5-2acbca5d2719@gmail.com>
 <20191101103024.GA59146@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <b8cca587-c636-54ba-732f-d995b48334fb@gmail.com>
Date:   Mon, 4 Nov 2019 16:56:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191101103024.GA59146@bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/11/1 18:30, Brian Foster wrote:
> On Fri, Nov 01, 2019 at 03:04:11PM +0800, kaixuxia wrote:
>>
>>
>> On 2019/10/31 20:27, Brian Foster wrote:
>>> On Wed, Oct 30, 2019 at 05:49:34PM +0800, kaixuxia wrote:
>>>> When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
>>>> need to hold the AGF lock to allocate more blocks, and then invoking
>>>> the xfs_droplink() call to hold AGI lock to drop target_ip onto the
>>>> unlinked list, so we get the lock order AGF->AGI. This would break the
>>>> ordering constraint on AGI and AGF locking - inode allocation locks
>>>> the AGI, then can allocate a new extent for new inodes, locking the
>>>> AGF after the AGI.
>>>>
>>>> In this patch we check whether the replace operation need more
>>>> blocks firstly. If so, acquire the agi lock firstly to preserve
>>>> locking order(AGI/AGF). Actually, the locking order problem only
>>>> occurs when we are locking the AGI/AGF of the same AG. For multiple
>>>> AGs the AGI lock will be released after the transaction committed.
>>>>
>>>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>>>> ---
>>>>  fs/xfs/libxfs/xfs_dir2.c | 30 ++++++++++++++++++++++++++++++
>>>>  fs/xfs/libxfs/xfs_dir2.h |  2 ++
>>>>  fs/xfs/xfs_inode.c       | 14 ++++++++++++++
>>>>  3 files changed, 46 insertions(+)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
>>>> index 867c5de..9d9ae16 100644
>>>> --- a/fs/xfs/libxfs/xfs_dir2.c
>>>> +++ b/fs/xfs/libxfs/xfs_dir2.c
>>>> @@ -463,6 +463,36 @@
>>>>  }
>>>>  
>>>>  /*
>>>> + * Check whether the replace operation need more blocks. Ignore
>>>> + * the parameters check since the real replace() call below will
>>>> + * do that.
>>>> + */
>>>> +bool
>>>> +xfs_dir_replace_needblock(
>>>> +	struct xfs_inode	*dp,
>>>> +	xfs_ino_t		inum)
>>>> +{
>>>> +	int			newsize;
>>>> +	xfs_dir2_sf_hdr_t	*sfp;
>>>> +
>>>> +	/*
>>>> +	 * Only convert the shortform directory to block form maybe need
>>>> +	 * more blocks.
>>>> +	 */
>>>> +	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
>>>> +		return false;
>>>> +
>>>> +	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>>>> +	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
>>>> +
>>>> +	if (inum > XFS_DIR2_MAX_SHORT_INUM &&
>>>> +	    sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp))
>>>> +		return true;
>>>> +	else
>>>> +		return false;
>>>> +}
>>>> +
>>>
>>> It's slightly unfortunate we need to do these kind of double checks, but
>>> it seems reasonable enough as an isolated fix. From a factoring
>>> standpoint, it might be a little cleaner to move this down in
>>> xfs_dir2_sf.c as an xfs_dir2_sf_replace_needblock() helper, actually use
>>> it in the xfs_dir2_sf_replace() function where these checks are
>>> currently open coded and then export it so we can call it in the higher
>>> level function as well for the locking fix.
>>>
>> Yeah, makes more sense. Also maybe we could add a function helper like
>> the xfs_dir_canenter() call, it just check whether the replace operation
>> need more blocks,
>>
>>  int xfs_dir_replace_needblock(...)
>>  {
>>  	xfs_dir_replace(tp, dp, name, 0, 0);
>>  }
>>
>> I'm not sure if this approach is reasonable...
>>
> 
> I thought we were attempting to get rid of those calls, but I could be
> mistaken.
> 
Yeah, just like what you said, we can call it in the higher level
function.

>> Actually, there are some different solutions for the locking fix. One solution
>> is checking whether the replace operation need more blocks and acquiring AGI
>> lock before AGF lock. Another one is moving xfs_droplink() call to before the
>> xfs_dir_replace() call, but this solution may not be suitable. The third one
>> is expanding the directory in one transaction, but I'm not sure about this
>> solution and have no idea how to do it... 
>> Comments about these solutions, which one is more reasonable?
>>
> 
> I'm not sure we want to split things up into multiple transactions (if
> that's what you mean by the third option) because then we could be at
> risk of creating an inconsistent state in the event of a crash.
> Reordering the calls is cleaner in some respect because it doesn't
> require any new code, but it would probably require a closer look to
> make sure we don't create a problematic state for the current code in
> any way (i.e. processing a directory entry of an already unlinked
> inode). This patch requires some extra code, but it's the most simple
> solution from a logical standpoint. If you want my .02, I think either
> of the first two options are reasonable (provided they are correct).
> Perhaps others have stronger opinions or other ideas...
> 
Thanks for your comments. I will continue to use the approach in this
patch, and sent the V2 patch to address the comments.

Kaixu

> Brian
> 
>> kaixu    
>>
>>> Brian
>>>
>>>> +/*
>>>>   * Replace the inode number of a directory entry.
>>>>   */
>>>>  int
>>>> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
>>>> index f542447..e436c14 100644
>>>> --- a/fs/xfs/libxfs/xfs_dir2.h
>>>> +++ b/fs/xfs/libxfs/xfs_dir2.h
>>>> @@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
>>>>  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
>>>>  				struct xfs_name *name, xfs_ino_t ino,
>>>>  				xfs_extlen_t tot);
>>>> +extern bool xfs_dir_replace_needblock(struct xfs_inode *dp,
>>>> +				xfs_ino_t inum);
>>>>  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>>>>  				struct xfs_name *name, xfs_ino_t inum,
>>>>  				xfs_extlen_t tot);
>>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>>>> index 18f4b26..c239070 100644
>>>> --- a/fs/xfs/xfs_inode.c
>>>> +++ b/fs/xfs/xfs_inode.c
>>>> @@ -3196,6 +3196,7 @@ struct xfs_iunlink {
>>>>  	struct xfs_trans	*tp;
>>>>  	struct xfs_inode	*wip = NULL;		/* whiteout inode */
>>>>  	struct xfs_inode	*inodes[__XFS_SORT_INODES];
>>>> +	struct xfs_buf		*agibp;
>>>>  	int			num_inodes = __XFS_SORT_INODES;
>>>>  	bool			new_parent = (src_dp != target_dp);
>>>>  	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
>>>> @@ -3361,6 +3362,19 @@ struct xfs_iunlink {
>>>>  		 * In case there is already an entry with the same
>>>>  		 * name at the destination directory, remove it first.
>>>>  		 */
>>>> +
>>>> +		/*
>>>> +		 * Check whether the replace operation need more blocks.
>>>> +		 * If so, acquire the agi lock firstly to preserve locking
>>>> +		 * order(AGI/AGF).
>>>> +		 */
>>>> +		if (xfs_dir_replace_needblock(target_dp, src_ip->i_ino)) {
>>>> +			error = xfs_read_agi(mp, tp,
>>>> +					XFS_INO_TO_AGNO(mp, target_ip->i_ino), &agibp);
>>>> +			if (error)
>>>> +				goto out_trans_cancel;
>>>> +		}
>>>> +
>>>>  		error = xfs_dir_replace(tp, target_dp, target_name,
>>>>  					src_ip->i_ino, spaceres);
>>>>  		if (error)
>>>> -- 
>>>> 1.8.3.1
>>>>
>>>
>>
>> -- 
>> kaixuxia
> 

-- 
kaixuxia
