Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0ECC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 21:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbiEZVxj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 17:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiEZVxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 17:53:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05230E2762
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 14:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653602015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4APDAM/Lb2BqY07GXEO9WAVvlfuelYousWi/WbyKaP4=;
        b=KRObSavgV2Dx/WEyZszh4EGN3A+Qvc52z+s8ww8/S0sz8ukhl7prf8nN54g5uSExPBpbxc
        epyRr3bo/mOd4/8JNSvAR+u5SDfxt/NXCb2WUEPAiFIHhuXyrCOGT5SL06QOwK3a9SRSkt
        9scdB7iuDnAPP3g66NxZRaZE0Zir2Yw=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-6XDsYrUFMMaS1hEFkT4vYQ-1; Thu, 26 May 2022 17:53:33 -0400
X-MC-Unique: 6XDsYrUFMMaS1hEFkT4vYQ-1
Received: by mail-il1-f200.google.com with SMTP id j2-20020a056e02218200b002d16c950c5cso1910263ila.12
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 14:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4APDAM/Lb2BqY07GXEO9WAVvlfuelYousWi/WbyKaP4=;
        b=Iy6u4uF4t1zMTy/hHVuFhG1C/QntfAlLjXga1DSczNZZ52BROKh+HIfdRZrq4/xgcj
         N5lU5lmESO3olVDMDhpDbY2s8yQwwNQWGZAlZhIbREKhIIuMzgDUQwXxJMZy/UlCDful
         tmfAbi+aiocYAeqCXDoUXf6UleV9g/O8bEBtfzMm7wRC7dKaCm9mUuCGGZumQNweSw2Q
         47x4/j5X/QfcdKr4wqCJgs5eJgmPr8/3YlBGM9+7XK5Khl0pNNHpvlynbofnDKRLrAfg
         FUVcH9+gVlXJqHXAHCA7sFDyUs5dXeZUtj/k1hcqD9yHS5MktyxjaCUhoZYnS7cCylpZ
         zgzw==
X-Gm-Message-State: AOAM531Pl6h7HWeYawXyRi89y38Ypj7A56MY2vfNbeherTlK2LYv9ZSV
        NlMLSEXKHoNg4GCKyx4JVERBQAXARP3o0+7ngKu4fDsU6ZWfYPh8QH1fC6kfRMiJ0RNgbSuFnfr
        Z/FlUKLkwUIZqTSingVpr
X-Received: by 2002:a5d:9ed7:0:b0:65b:3312:9946 with SMTP id a23-20020a5d9ed7000000b0065b33129946mr18199715ioe.10.1653602012519;
        Thu, 26 May 2022 14:53:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgtNRt4B7KmFwosqf7n1kAe9y3TlvOjlRpp3rWb6AQ+Rc92y410tgRGxc8rldjPdmPod0nbA==
X-Received: by 2002:a5d:9ed7:0:b0:65b:3312:9946 with SMTP id a23-20020a5d9ed7000000b0065b33129946mr18199711ioe.10.1653602012252;
        Thu, 26 May 2022 14:53:32 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id f13-20020a5ec60d000000b0065a47e16f37sm712934iok.9.2022.05.26.14.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 14:53:31 -0700 (PDT)
Message-ID: <337aa926-ba8c-3383-c200-e54fde4182f1@redhat.com>
Date:   Thu, 26 May 2022 16:53:30 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] xfs_repair: don't flag log_incompat inconsistencies as
 corruptions
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <Yo02nmlajIuFqVez@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <Yo02nmlajIuFqVez@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/24/22 2:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While testing xfs/233 and xfs/127 with LARP mode enabled, I noticed
> errors such as the following:
> 
> xfs_growfs --BlockSize=4096 --Blocks=8192
> data blocks changed from 8192 to 2579968
> meta-data=/dev/sdf               isize=512    agcount=630, agsize=4096 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1
> data     =                       bsize=4096   blocks=2579968, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=3075, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> _check_xfs_filesystem: filesystem on /dev/sdf is inconsistent (r)
> *** xfs_repair -n output ***
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
>         - 23:03:47: zeroing log - 3075 of 3075 blocks done
>         - scan filesystem freespace and inode maps...
> would fix log incompat feature mismatch in AG 30 super, 0x0 != 0x1
> would fix log incompat feature mismatch in AG 8 super, 0x0 != 0x1
> would fix log incompat feature mismatch in AG 12 super, 0x0 != 0x1
> would fix log incompat feature mismatch in AG 24 super, 0x0 != 0x1
> would fix log incompat feature mismatch in AG 18 super, 0x0 != 0x1
> <snip>
> 
> 0x1 corresponds to XFS_SB_FEAT_INCOMPAT_LOG_XATTRS, which is the feature
> bit used to indicate that the log contains extended attribute log intent
> items.  This is a mechanism to prevent older kernels from trying to
> recover log items that they won't know how to recover.
> 
> I thought about this a little bit more, and realized that log_incompat
> features bits are set on the primary sb prior to writing certain types
> of log records, and cleared once the log has written the committed
> changes back to the filesystem.  If the secondary superblocks are
> updated at any point during that interval (due to things like growfs or
> setting labels), the log_incompat field will now be set on the secondary
> supers.
> 
> Due to the ephemeral nature of the current log_incompat feature bits,
> a discrepancy between the primary and secondary supers is not a
> corruption.  If we're in dry run mode, we should log the discrepancy,
> but that's not a reason to end with EXIT_FAILURE.

Interesting. This makes me wonder a few things.

This approach differs from the just-added handling of 
XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR, where we /always/ ignore it. For now I think
that's a little different, because that flag only gets set from userspace, but
that could change in the future, maybe?

So I wonder why we have this feature getting noted and cleared, but the other
one always ignored.

I also notice that scrub tries to avoid setting it in the first place:

         * Don't write out a secondary super with NEEDSREPAIR or log incompat
         * features set, since both are ignored when set on a secondary.

... should growfs avoid it as well?

It feels like we're spreading this special handling around, copying (or not)
and ignoring (or not) at various points.  I kinda want to step back and think
about this a little.

It seems like the most consistent approach would be to always keep all supers
in sync, though I suppose that has costs. The 2nd most consistent approach would
be to never copy these ephemeral features to the secondary.

Whatever the consistent future looks like, I guess we do have to deal with
inconsistent stuff in the wild, already.

Thoughts?

-Eric


> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/agheader.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/agheader.c b/repair/agheader.c
> index 2c2a26d1..478ed7e5 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -286,15 +286,24 @@ check_v5_feature_mismatch(
>  		}
>  	}
>  
> +	/*
> +	 * Log incompat feature bits are set and cleared from the primary super
> +	 * as needed to protect against log replay on old kernels finding log
> +	 * records that they cannot handle.  Secondary sb resyncs performed as
> +	 * part of a geometry update to the primary sb (e.g. growfs, label/uuid
> +	 * changes) will copy the log incompat feature bits, but it's not a
> +	 * corruption for a secondary to have a bit set that is clear in the
> +	 * primary super.
> +	 */
>  	if (mp->m_sb.sb_features_log_incompat != sb->sb_features_log_incompat) {
>  		if (no_modify) {
> -			do_warn(
> -	_("would fix log incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
> +			do_log(
> +	_("would sync log incompat feature in AG %u super, 0x%x != 0x%x\n"),
>  					agno, mp->m_sb.sb_features_log_incompat,
>  					sb->sb_features_log_incompat);
>  		} else {
>  			do_warn(
> -	_("will fix log incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
> +	_("will sync log incompat feature in AG %u super, 0x%x != 0x%x\n"),
>  					agno, mp->m_sb.sb_features_log_incompat,
>  					sb->sb_features_log_incompat);
>  			dirty = true;
> 

