Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2F3C2BA1E
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D751C21D82
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:30:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ik/l16Xe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgDFMac (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:30:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43733 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbgDFMab (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:30:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id s4so345457pgk.10;
        Mon, 06 Apr 2020 05:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=88EvbIlsqMA877V4g4WdYtSu+wV/32/AuYejppF3O7k=;
        b=Ik/l16XeXSN4KHpMobdHofighcnvsttgzISn2u+lJt5a4c0x/HzWLWWZUK/CJJUeLU
         MEwb3Y6ucuNMGXhM4LKeN7LCJ0/l8pwol4lJz34SJztrb0eaZcxy2gscFva0c5Rma+Dc
         8lKeQEss0+4I6jK0TawCCAm234XdmBqwDyq0dq725NXS6sOa2it2EySQFbjrZeRZDvCF
         pK28devdxi/ARNB2BXJt74RFQN2la+sJaYxeUFev5daT6o439fRpQcxZmqJSbr/S810Q
         /7Tlc+8B20hskmzAlbYWGChyKx8GDqvHg10KEEpp+bebpTCqw8A9xwHnUzQG2jnBBK7i
         JePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=88EvbIlsqMA877V4g4WdYtSu+wV/32/AuYejppF3O7k=;
        b=eIKK9now2hMnHMUN45UPbsEr+pLsHl4BXgepKIZv7rMdamoTQeRGfCeJy+41LL6HjP
         n46YNko45CPjXdTK4XfNOuU/Xh1VC+LmuPkZVSvInlGsDc1GjsafhJNDlS9NJHScIwXj
         TFD1xDgiSP+vvLPmRbYBeXPMNii/8rVkMlQ+Cia1bTHIDypeuGrjaTutTDgfZLr9ZfQC
         +4zab09kJnVUr7qjX8H6TXfMVWmEb/NjT5wtIvGhoSLUF9T1jLmyEgJLJFvoAaGQ+Lq2
         hZJQ3zv5j+uB85Qusk8A7+wTh/YBhio0cHOCTElDt65F7vVPNTWMuIwyfhBvGei5HPTk
         Nffw==
X-Gm-Message-State: AGi0PuaqaG6J5OadBWoBaA/lVdOMMOIbqDCvcpBlMHjcGjg0Vxgul/9o
        wegC6rIJrULqhR60IKnxTiP2YaT4
X-Google-Smtp-Source: APiQypI7URiGETxNzlsC80UvhBKNmpN6+2eBGg8pqX+SNvQO1h5X9IMK1d81C4RZWNMkyJFRBEnLmg==
X-Received: by 2002:a63:141:: with SMTP id 62mr428606pgb.101.1586176228707;
        Mon, 06 Apr 2020 05:30:28 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id g25sm3930494pfh.55.2020.04.06.05.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 05:30:27 -0700 (PDT)
Date:   Mon, 6 Apr 2020 20:31:07 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, chandan@linux.ibm.com, hch@infradead.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common/xfs: Execute _xfs_check only when explicitly asked
Message-ID: <20200406123030.GG3128153@desktop>
References: <20200330101203.12049-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330101203.12049-1-chandanrlinux@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 30, 2020 at 03:42:03PM +0530, Chandan Rajendra wrote:
> fsstress when executed as part of some of the tests (e.g. generic/270)
> invokes chown() syscall many times by passing random integers as value
> for the uid argument. For each such syscall invocation for which there
> is no on-disk quota block, xfs invokes xfs_dquot_disk_alloc() which
> allocates a new block and instantiates all the quota structures mapped
> by the newly allocated block. For filesystems with 64k block size, the
> number of on-disk quota structures created will be 16 times more than
> that for a filesystem with 4k block size.
> 
> xfs_db's check command (executed after test script finishes execution)
> will try to read in all of the on-disk quota structures into
> memory. This causes the OOM event to be triggered when reading from
> filesystems with 64k block size. For filesystems with sufficiently large
> amount of system memory, this causes the test to execute for a very long
> time.
> 
> Due to the above stated reasons, this commit disables execution of
> xfs_db's check command unless explictly asked by the user by setting
> $EXECUTE_XFS_DB_CHECK variable.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  README     |  2 ++
>  common/xfs | 17 +++++++++++++----
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/README b/README
> index 094a7742..c47569cd 100644
> --- a/README
> +++ b/README
> @@ -88,6 +88,8 @@ Preparing system for tests:
>                 run xfs_repair -n to check the filesystem; xfs_repair to rebuild
>                 metadata indexes; and xfs_repair -n (a third time) to check the
>                 results of the rebuilding.
> +	     - set EXECUTE_XFS_DB_CHECK=1 to have _check_xfs_filesystem
> +               run xfs_db's check command on the filesystem.

It seems spaces are used for indention instead of tab in README.

>               - xfs_scrub, if present, will always check the test and scratch
>                 filesystems if they are still online at the end of the test.
>                 It is no longer necessary to set TEST_XFS_SCRUB.
> diff --git a/common/xfs b/common/xfs
> index d9a9784f..93ebab75 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -455,10 +455,19 @@ _check_xfs_filesystem()
>  		ok=0
>  	fi
>  
> -	# xfs_check runs out of memory on large files, so even providing the test
> -	# option (-t) to avoid indexing the free space trees doesn't make it pass on
> -	# large filesystems. Avoid it.
> -	if [ "$LARGE_SCRATCH_DEV" != yes ]; then
> +	dbsize="$($XFS_INFO_PROG "${device}" | grep data.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"

This is probably a left-over from v1 patch, which is not needed in v2.

> +
> +	# xfs_check runs out of memory,
> +	# 1. On large files. So even providing the test option (-t) to
> +	# avoid indexing the free space trees doesn't make it pass on
> +	# large filesystems.
> +	# 2. When checking filesystems with large number of quota
> +	# structures. This case happens consistently with 64k blocksize when
> +	# creating large number of on-disk quota structures whose quota ids
> +	# are spread across a large integer range.
> +	#
> +	# Hence avoid executing it unless explicitly asked by user.
> +	if [ -n "$EXECUTE_XFS_DB_CHECK" -a "$LARGE_SCRATCH_DEV" != yes ]; then
>  		_xfs_check $extra_log_options $device 2>&1 > $tmp.fs_check

Looks fine to me, I'd like to see xfs_check being disabled. But it'd be
great if xfs folks could ack it as well.

Thanks,
Eryu

>  	fi
>  	if [ -s $tmp.fs_check ]; then
> -- 
> 2.19.1
> 
