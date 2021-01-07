Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E77CC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B553233CF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbhAGTky (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 14:40:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728240AbhAGTky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 14:40:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610048367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TTnE+e274J0XR116SYcFy+bmFzMf1rapQW1xp8qUHtY=;
        b=A3MV/gcgJwiDHFmdT9TqQJ30jfei9RmCoKxrpobur0h1ObKJZEG4/wOn7jyuiWxVbl5bnr
        k0qtBajwykezWoaVABbyuvpqNlOVl4gje0L6zdt3xY5PZzUdeNZ7kjLDk72GtCmgW+FMw/
        Fx7YjNLZMmMylWbHCRGPIoLq5H96V68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-j_d6GYuMPhaycW3wM0R20A-1; Thu, 07 Jan 2021 14:39:25 -0500
X-MC-Unique: j_d6GYuMPhaycW3wM0R20A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2583107ACE3;
        Thu,  7 Jan 2021 19:39:23 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7ADF010002A6;
        Thu,  7 Jan 2021 19:39:23 +0000 (UTC)
Subject: Re: [PATCH V2] xfsprogs: cosmetic changes to libxfs_inode_alloc
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>
References: <3fa15760-2e68-2c64-3914-fafbdd0e41fd@redhat.com>
 <20210107193724.GI6918@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <b6b49681-faf8-b0e2-845b-4536abc769af@redhat.com>
Date:   Thu, 7 Jan 2021 13:39:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210107193724.GI6918@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/7/21 1:37 PM, Darrick J. Wong wrote:
> On Thu, Jan 07, 2021 at 01:20:49PM -0600, Eric Sandeen wrote:
>> This pre-patch helps make the next libxfs-sync for 5.11 a bit
>> more clear.
>>
>> In reality, the libxfs_inode_alloc function matches the kernel's
>> xfs_dir_ialloc so rename it for clarity before the rest of the
>> sync, and change several variable names for the same reason.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> V2: Fix up local transaction pointer problems pointed out by Brian.
>>
>> Essentially, use tp locally, and reassign tpp on return.
>>
>> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
>> index 742aebc8..01a62daa 100644
>> --- a/include/xfs_inode.h
>> +++ b/include/xfs_inode.h
>> @@ -156,7 +156,7 @@ typedef struct cred {
>>  	gid_t	cr_gid;
>>  } cred_t;
>>  
>> -extern int	libxfs_inode_alloc (struct xfs_trans **, struct xfs_inode *,
>> +extern int	libxfs_dir_ialloc (struct xfs_trans **, struct xfs_inode *,
>>  				mode_t, nlink_t, xfs_dev_t, struct cred *,
>>  				struct fsxattr *, struct xfs_inode **);
>>  extern void	libxfs_trans_inode_alloc_buf (struct xfs_trans *,
>> diff --git a/libxfs/util.c b/libxfs/util.c
>> index 252cf91e..376c5dac 100644
>> --- a/libxfs/util.c
>> +++ b/libxfs/util.c
>> @@ -531,9 +531,9 @@ error0:	/* Cancel bmap, cancel trans */
>>   * other in repair - now there is just the one.
>>   */
>>  int
>> -libxfs_inode_alloc(
>> -	xfs_trans_t	**tp,
>> -	xfs_inode_t	*pip,
>> +libxfs_dir_ialloc(
>> +	xfs_trans_t	**tpp,
>> +	xfs_inode_t	*dp,
>>  	mode_t		mode,
>>  	nlink_t		nlink,
>>  	xfs_dev_t	rdev,
>> @@ -541,16 +541,18 @@ libxfs_inode_alloc(
>>  	struct fsxattr	*fsx,
>>  	xfs_inode_t	**ipp)
>>  {
>> -	xfs_buf_t	*ialloc_context;
>> +	xfs_trans_t	*tp;
>>  	xfs_inode_t	*ip;
>> -	int		error;
>> +	xfs_buf_t	*ialloc_context = NULL;
>> +	int		code;
> 
> Maybe de-typedef this function too?  Though I guess if the next patch is
> a backport of "xfs: move on-disk inode allocation out of xfs_ialloc" to
> libxfs/util.c then maybe that doesn't matter and I'll just shut up.  :)

As Mr. Reznor says, "everything goes away, in the end."
 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks,
-Eric

