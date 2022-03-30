Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D2CC43217
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 12:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345344AbiC3MLk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 08:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347607AbiC3MHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 08:07:13 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF53FF3
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 05:05:27 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c7so2377685wrd.0
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 05:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rlCisVygGG6W4gUfS3tyeCpOri+Ta/Bd8LsBFEHJk10=;
        b=xaiNI3yTq36LrEQz3Zfrk/muDPKFualH4gy+/iobqJ32/u7zrCtR3uErGaFvEnSZX+
         kPcGHJcHqKEwsTWz4FMxevXJ8mmQjTwyKFjzuAh77wBRKZ/i5xie47zHFzbdNuJf2pV6
         R6JclQ7iQiLqrRFdafTSrO8qlLDhfPWjhJEBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rlCisVygGG6W4gUfS3tyeCpOri+Ta/Bd8LsBFEHJk10=;
        b=7B5Y7lkZiGNz9wHnOaMET7XfNQ9GAvia6EgfYBmkdWaIZiA1mnSyYWydGQY9xHg5P9
         zx6uJ1skVMYndKzfw6k1zLJsytyUm7i4wN6hv15qtsN9UbHuJzU0eq7Z3Ng5tY+t8Zrj
         oTR1Z9i8tiHUITDfUcNAHreYhGbHAjyglzfat3UlNnS0UFeTOzD0EdjPGrkvZ5yb05lh
         G9hhV0eK2sJjJPNQUyIGIYF6qkNzxM+0s/14yrlGIAuDPuUdMJz66Fh5ewcBipdEa2kw
         90tWSkWCpGSoFzfHd7uWyZx8cyCPoMosXAEJoHmnZscvuh17k/AIHjIz125goKzs7ffx
         lliA==
X-Gm-Message-State: AOAM530fzUpsFba8Hxa2FO138EWnAOjCQXSMX5TmNQf500tG5fEcLh2G
        mRzSHnarlOIylHrROIUvGHLGzQ==
X-Google-Smtp-Source: ABdhPJx28Wi99a7MjeIroPQqpdKXwMcbCs7Gq9gSxClKFyE+8x4Ja9ucf56URfPyw8Ge5eEQdOQkew==
X-Received: by 2002:a05:6000:3cb:b0:205:7b9d:cade with SMTP id b11-20020a05600003cb00b002057b9dcademr35599524wrg.239.1648641925961;
        Wed, 30 Mar 2022 05:05:25 -0700 (PDT)
Received: from localhost ([2a01:4b00:8432:8a00:5ee4:2aff:fe50:f48d])
        by smtp.gmail.com with ESMTPSA id b1-20020adfd1c1000000b002058537af75sm18053079wrd.104.2022.03.30.05.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 05:05:25 -0700 (PDT)
Date:   Wed, 30 Mar 2022 13:05:24 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <YkRHhJT2dLu4ypwR@chrisdown.name>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YkMKyN9w0S8VFJRk@alley>
User-Agent: Mutt/2.2.2 (aa28abe8) (2022-03-25)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Petr,

Petr Mladek writes:
>On Fri 2022-03-25 10:19:46, Jonathan Lassoff wrote:
>> In order for end users to quickly react to new issues that come up in
>> production, it is proving useful to leverage the printk indexing system.
>> This printk index enables kernel developers to use calls to printk()
>> with changeable ad-hoc format strings, while still enabling end users
>> to detect changes from release to release.
>>
>> So that detailed XFS messages are captures by this printk index, this
>> patch wraps the xfs_<level> and xfs_alert_tag functions.
>>
>> Signed-off-by: Jonathan Lassoff <jof@thejof.com>
>
>> --- a/fs/xfs/xfs_message.h
>> +++ b/fs/xfs/xfs_message.h
>> @@ -6,34 +6,45 @@
>>
>>  struct xfs_mount;
>>
>> +#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)		\
>> +({								\
>> +	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt);	\
>
>I would probably use "%sXFS: " for the first parameter as
>a compromise here.
>
>It affects how the printk formats are shown in debugfs. With the
>current patch I see in /sys/kernel/debug/printk/index/vmlinux:
>
><4> fs/xfs/libxfs/xfs_ag.c:877 xfs_ag_shrink_space "%sXFS%s: Error %d reserving per-AG metadata reserve pool."
><1> fs/xfs/libxfs/xfs_ag.c:151 xfs_initialize_perag_data "%sXFS%s: AGF corruption. Please run xfs_repair."
><4> fs/xfs/libxfs/xfs_alloc.c:2429 xfs_agfl_reset "%sXFS%s: WARNING: Reset corrupted AGFL on AG %u. %d blocks leaked. Please unmount and run xfs_repair."
><4> fs/xfs/libxfs/xfs_alloc.c:262 xfs_alloc_get_rec "%sXFS%s: start block 0x%x block count 0x%x"
><4> fs/xfs/libxfs/xfs_alloc.c:260 xfs_alloc_get_rec "%sXFS%s: %s Freespace BTree record corruption in AG %d detected!"
><1> fs/xfs/libxfs/xfs_attr_remote.c:304 xfs_attr_rmtval_copyout "%sXFS%s: remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)"
><4> fs/xfs/libxfs/xfs_bmap.c:1129 xfs_iread_bmbt_block "%sXFS%s: corrupt dinode %llu, (btree extents)."
>
>In reality, the prefix is chosen in __xfs_printk() at runtime:
>
>	+ "%sXFS (%s): "	when mp->m_super is defined
>	+ "%sXFS: "		otherwise
>
>It means that "%sXFS: " is not perfect but it looks closer to reality
>than "%sXFS%s: ".

I think we do actually want "%sXFS%s: " here. Without that, it's not possible to 
be confident marrying up a userspace detector to its original printk 
counterpart if the detector actually looks at what's in mp->m_super->s_id (eg.  
to exclude or include some device).

Some messages in practice also typically only ever come out with mp->m_super 
present, so the userspace detector is likely to accomodate for that whether it 
uses the data in mp->m_super->s_id or not. Since we can't detect which printks 
those are at compile time, we pretty much have to use "%sXFS%s: ".

Thanks,

Chris
