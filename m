Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA283C4338F
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Aug 2021 15:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F3A9610E7
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Aug 2021 15:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhHGPN5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 7 Aug 2021 11:13:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231144AbhHGPN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 Aug 2021 11:13:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628349219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8TUlriaZFNZEM9c2tNzS1DucIzgYFUHXbvV00dzstpE=;
        b=SdBLew9xUMmNqHyXwBL1cjlFod6zzG7DCYGShzyxOViWDPZyXKWAGp+RwAstyA5bt6iA2p
        Z+rwkLJSK/itFsTSu3Ws1AAWo6jSL1c4lteTI5U9JwOvg4MTRYdljcsF5oyTqbQdEu0m1v
        TijLoQU+NW11EOPAoxVpotlhnYwEGYo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-rv-5ruLtNUaJ6GFzOKUlvA-1; Sat, 07 Aug 2021 11:13:37 -0400
X-MC-Unique: rv-5ruLtNUaJ6GFzOKUlvA-1
Received: by mail-ed1-f71.google.com with SMTP id g3-20020a0564024243b02903be33db5ae6so2348197edb.18
        for <linux-xfs@vger.kernel.org>; Sat, 07 Aug 2021 08:13:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8TUlriaZFNZEM9c2tNzS1DucIzgYFUHXbvV00dzstpE=;
        b=K6683g1QdytKS2SL6butE1mWagInO+VgcqkmOxnqQx2Dke8/WX3W2vh8crrtXEgmxD
         DTUjKvm5wFh/rDjT5S1j4Da93OJflJxaXpwByARcv1VUjc1kmqzvyvNn96i/iqumVUEQ
         OEMZ9LGaxKdc3epOofgRFAG3Tq+SHaHZLJX+6rmll+YFOU7FsyI1nGNl7Zb+YFE7FBXX
         x7Ivv1DKJciDj/XlBks08wRA0xOauWgxxRH8hWIv9yLV117mPYfIcp/y0FPe6uW39+2o
         Vj9otaooXnqZAWhVe/wpjyQgM1igKV9vChPPioBVxzETkU2PQP6nHWFT+3G7BgFq1hd2
         pTLA==
X-Gm-Message-State: AOAM533PXnFeN8AKQGae31Bl1wcJfww4D/Vly+uMQIZzYxWTcACKL6td
        f/V7ixxgOnsw40TFouxtIPZTT8IKihCFUSqLTUa584Ym/2GBqNc6cdCTqe60X+k8Ll4zEbe2jRG
        K9H5DdoWfHmU6XPHPfNNgIx9Zs3GRKwXchgWk0lNPmG3TM5e4U1RSQVnE4gZoO2n0jkgG1y0=
X-Received: by 2002:a17:906:8493:: with SMTP id m19mr164029ejx.103.1628349216375;
        Sat, 07 Aug 2021 08:13:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKljsNFT9CQwY6TnPQdl7HyxEux0andLsuMI+ctV4uPsQWtnfv+0gemqgWFeUtNlg1ujhn8w==
X-Received: by 2002:a17:906:8493:: with SMTP id m19mr164014ejx.103.1628349216150;
        Sat, 07 Aug 2021 08:13:36 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id e22sm5267439edu.35.2021.08.07.08.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Aug 2021 08:13:35 -0700 (PDT)
Subject: Re: [PATCH v2 00/29] xfsprogs: Drop the 'platform_' prefix
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210806212318.440144-1-preichl@redhat.com>
 <20210806230501.GG2757197@dread.disaster.area>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <ea2b07fb-a664-3566-687c-43ffac1af4a8@redhat.com>
Date:   Sat, 7 Aug 2021 17:13:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806230501.GG2757197@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 8/7/21 1:05 AM, Dave Chinner wrote:
> On Fri, Aug 06, 2021 at 11:22:49PM +0200, Pavel Reichl wrote:
>> Stop using commands with 'platform_' prefix. Either use directly linux
>> standard command or drop the prefix from the function name.
> Looks like all of the patches in this series are missing
> signed-off-by lines.  Most of them have empty commit messages, too,
Sorry about the missing signed-off-by, I really need to have a
check-list before posting patches...or send more patches :-).
> which we don't tend to do very often.
>
>>   51 files changed, 284 insertions(+), 151 deletions(-)
> IMO, 29 patches for such a small change is way too fine grained for
> working through efficiently.  Empty commit messages tend to be a
> sign that you can aggregate patches together.... i.e.  One patch for
> all the uuid changes (currently 7 patches) with a description of why
> you're changing the platform_uuid interface, one for all the mount
> related stuff (at least 5 patches now), one for all the block device
> stuff (8 or so patches), one for all the path bits, and then one for
> whatever is left over.
OK, I'll do this in the next version.
>
> Every patch has overhead, be it to produce, maintain, review, test,
> merge, etc. Breaking stuff down unnecessarily just increases the
> amount of work everyone has to do at every step. So if you find that
> you are writing dozens of patches that each have a trivial change in
> them that you are boiler-plating commit messages, you've probably
> made the overall changeset too fine grained.
OK, sincerely thank you for the 'rules-of-thump'. However, In the
first version of the patch set I grouped the changes into way less patches
and passed along a question about the preferred granularity of patches
and got the following answer:

>   * What would be best for the reviewer - should I prepare a separate
>   patch for every function rename or should I squash the changes into
>   one huge patch?
> One patch per function, please.

However, I agree that I should have mentioned that some patches would
be too small and not blindly follow the request...I'll do better next
time.
>
> Also....
>
>>   libxfs/init.c               | 32 ++++++------
>>   libxfs/libxfs_io.h          |  2 +-
>>   libxfs/libxfs_priv.h        |  3 +-
>>   libxfs/rdwr.c               |  4 +-
>>   libxfs/xfs_ag.c             |  6 +--
>>   libxfs/xfs_attr_leaf.c      |  2 +-
>>   libxfs/xfs_attr_remote.c    |  2 +-
>>   libxfs/xfs_btree.c          |  4 +-
>>   libxfs/xfs_da_btree.c       |  2 +-
>>   libxfs/xfs_dir2_block.c     |  2 +-
>>   libxfs/xfs_dir2_data.c      |  2 +-
>>   libxfs/xfs_dir2_leaf.c      |  2 +-
>>   libxfs/xfs_dir2_node.c      |  2 +-
>>   libxfs/xfs_dquot_buf.c      |  2 +-
>>   libxfs/xfs_ialloc.c         |  4 +-
>>   libxfs/xfs_inode_buf.c      |  2 +-
>>   libxfs/xfs_sb.c             |  6 +--
>>   libxfs/xfs_symlink_remote.c |  2 +-
> Why are all these libxfs files being changed?

I believe this is because of patch #6 - xfsprogs: Stop using 
platform_uuid_copy()

Here I dropped the usage of platform_uuid_copy() even in libxfs by:

1) removing the uuid_copy() macro that was implemented by calling
    platform_uuid_copy() in libxfs/libxfs_priv.h

  -#define uuid_copy(s,d) platform_uuid_copy((s),(d))

2) using directly standard uuid_copy() instead
    Which resulted into plenty of trivial changes all over libxfs, the
    core of the changes being that uuid params are passed-by-value to
    standard uuid_copy(), but to libxfs' uuid_copy() it is
    passed-by-reference.

    E.g.
- uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
+               uuid_copy(agf->agf_uuid, mp->m_sb.sb_meta_uuid);
> Cheers,
>
> Dave.
Hi Dave,
Thank you for you comments, please see reactions above.
Have a nice day.



