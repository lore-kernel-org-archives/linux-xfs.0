Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81126C7EE29
	for <linux-xfs@archiver.kernel.org>; Mon, 22 May 2023 02:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjEVCXm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 May 2023 22:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjEVCXk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 May 2023 22:23:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBBFEC
        for <linux-xfs@vger.kernel.org>; Sun, 21 May 2023 19:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684722174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gCnSvHg5O9ml4/OuYzbyOxwskor4dFbbIHvczRVaEk=;
        b=RobspGm3+bSGNagOU7fC7pFLucpKSzZAnFz7yRVjVRFbdYz+fu/xH6EnpDkcv5TiOtF7KC
        7lOHk0a4i21LnzBFfuVoH8pSvG3MihCn0DE478+I+GNGDVIOCFhleUU6JEwLKj49IVcpYP
        05cX7dEXR0sRnndr/aaQQLcMDjw8kQQ=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-R59dyiTpNXyReiRVjKcQIw-1; Sun, 21 May 2023 22:22:52 -0400
X-MC-Unique: R59dyiTpNXyReiRVjKcQIw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-517c06c1a1bso2944678a12.3
        for <linux-xfs@vger.kernel.org>; Sun, 21 May 2023 19:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684722171; x=1687314171;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6gCnSvHg5O9ml4/OuYzbyOxwskor4dFbbIHvczRVaEk=;
        b=MgGD8eOTPUQN+CQA/g2Ko9sHLqNpYkTJ/LQYW2wLozgmJG8gb8bpaaZPwGOvQmZMN4
         xC/HpL7T/qSwAv2gjXcYrFMdjk8RKj1C8+LM+tsF9jkmgrzMPW20dMDtdrTmS30/ACFS
         mhaZ7809A8gyBNa6Yy+hH39SiIrp8CuhPwyXqxcVmLt2EXeUt2SjUs4mxvn4+KzvNzKq
         WLo74YUqxRU2UzEIHzdpLJxlTwW2UtzoHhsqupwe6kfn69VvlEUzVerjr5yAI0EAvi0j
         wawtTEnD5d7e6o00OA7VZPKCc83fti7ygD4V/DjwZws4KyF4x/bKx/mzX1YgkM6jr+CH
         hUEg==
X-Gm-Message-State: AC+VfDzjqfnW6kfF1dKlhdLk4O0jP7SO2hKz0H3obVQXmnzL5rA9Wvw7
        9qhMYtFJTtb7HiLbPnSx+o2othW/zA/74SukqJQOU0JBMUzyuPTu3hJHwI3RcWD1H/Vz985fIBM
        L+ZFs9Bsge4uRhGxzatBX
X-Received: by 2002:a05:6a20:428a:b0:10b:e54f:1c00 with SMTP id o10-20020a056a20428a00b0010be54f1c00mr597180pzj.57.1684722171598;
        Sun, 21 May 2023 19:22:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6YIe9VLQS6yzKMQ0WkmEEqdfd17sZ9Y4FgV9G2cXXtS6sfNqDs6Fii9g74G57D4O2vtAJBpQ==
X-Received: by 2002:a05:6a20:428a:b0:10b:e54f:1c00 with SMTP id o10-20020a056a20428a00b0010be54f1c00mr597169pzj.57.1684722171305;
        Sun, 21 May 2023 19:22:51 -0700 (PDT)
Received: from [10.72.12.68] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d22-20020a631d16000000b0050be8e0b94csm3281962pgd.90.2023.05.21.19.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 May 2023 19:22:50 -0700 (PDT)
Message-ID: <25ae2aff-daab-eaa3-19dd-aa5e56c9b6f1@redhat.com>
Date:   Mon, 22 May 2023 10:22:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 03/13] filemap: assign current->backing_dev_info in
 generic_perform_write
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        "open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>,
        cluster-devel@redhat.com, linux-xfs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-mm@kvack.org
References: <20230519093521.133226-1-hch@lst.de>
 <20230519093521.133226-4-hch@lst.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230519093521.133226-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 5/19/23 17:35, Christoph Hellwig wrote:
> Move the assignment to current->backing_dev_info from the callers into
> generic_perform_write to reduce boiler plate code and reduce the scope
> to just around the page dirtying loop.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/ceph/file.c | 4 ----
>   fs/ext4/file.c | 3 ---
>   fs/f2fs/file.c | 2 --
>   fs/nfs/file.c  | 5 +----
>   mm/filemap.c   | 2 ++
>   5 files changed, 3 insertions(+), 13 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index feeb9882ef635a..767f4dfe7def64 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1791,9 +1791,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   	else
>   		ceph_start_io_write(inode);
>   
> -	/* We can write back this queue in page reclaim */
> -	current->backing_dev_info = inode_to_bdi(inode);
> -
>   	if (iocb->ki_flags & IOCB_APPEND) {
>   		err = ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE, false);
>   		if (err < 0)
> @@ -1938,7 +1935,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   		ceph_end_io_write(inode);
>   out_unlocked:
>   	ceph_free_cap_flush(prealloc_cf);
> -	current->backing_dev_info = NULL;
>   	return written ? written : err;
>   }
>   
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 50824831d31def..3cb83a3e2e4a2a 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -29,7 +29,6 @@
>   #include <linux/pagevec.h>
>   #include <linux/uio.h>
>   #include <linux/mman.h>
> -#include <linux/backing-dev.h>
>   #include "ext4.h"
>   #include "ext4_jbd2.h"
>   #include "xattr.h"
> @@ -285,9 +284,7 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>   	if (ret <= 0)
>   		goto out;
>   
> -	current->backing_dev_info = inode_to_bdi(inode);
>   	ret = generic_perform_write(iocb, from);
> -	current->backing_dev_info = NULL;
>   
>   out:
>   	inode_unlock(inode);
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 9e3855e43a7a63..7134fe8bd008cb 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -4517,9 +4517,7 @@ static ssize_t f2fs_buffered_write_iter(struct kiocb *iocb,
>   	if (iocb->ki_flags & IOCB_NOWAIT)
>   		return -EOPNOTSUPP;
>   
> -	current->backing_dev_info = inode_to_bdi(inode);
>   	ret = generic_perform_write(iocb, from);
> -	current->backing_dev_info = NULL;
>   
>   	if (ret > 0) {
>   		f2fs_update_iostat(F2FS_I_SB(inode), inode,
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index 3cc87ae8473356..e8bb4c48a3210a 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -648,11 +648,8 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
>   	since = filemap_sample_wb_err(file->f_mapping);
>   	nfs_start_io_write(inode);
>   	result = generic_write_checks(iocb, from);
> -	if (result > 0) {
> -		current->backing_dev_info = inode_to_bdi(inode);
> +	if (result > 0)
>   		result = generic_perform_write(iocb, from);
> -		current->backing_dev_info = NULL;
> -	}
>   	nfs_end_io_write(inode);
>   	if (result <= 0)
>   		goto out;
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4d0ec2fa1c7070..bf693ad1da1ece 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3892,6 +3892,7 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
>   	long status = 0;
>   	ssize_t written = 0;
>   
> +	current->backing_dev_info = inode_to_bdi(mapping->host);
>   	do {
>   		struct page *page;
>   		unsigned long offset;	/* Offset into pagecache page */
> @@ -3956,6 +3957,7 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
>   
>   		balance_dirty_pages_ratelimited(mapping);
>   	} while (iov_iter_count(i));
> +	current->backing_dev_info = NULL;
>   
>   	if (!written)
>   		return status;

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>

Thanks

- Xiubo


