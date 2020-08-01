Return-Path: <SRS0=tAZO=BL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801D7C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 08:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55944206E9
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 08:31:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSLeu0/n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgHAIbz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 1 Aug 2020 04:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgHAIby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Aug 2020 04:31:54 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E90C06174A
        for <linux-xfs@vger.kernel.org>; Sat,  1 Aug 2020 01:31:54 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d4so17222584pgk.4
        for <linux-xfs@vger.kernel.org>; Sat, 01 Aug 2020 01:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=evU3HVU9jMRZIXhOJBlQF6Vyhp97md0RYjcyvJijOVE=;
        b=iSLeu0/nu5NbXv6yonfM9/ciC7XOounxnW22a2cUI9x888CzgfAbCVzIpSCoGtf8X9
         3hVZMHjZm1OtLVxRVmlCft4JG6Dj+y5GsOn02nAxltDs8oZ72RBFDH7IIx5weSTalzni
         /G7fxC7ayECV0JNYReL99/9BXXA45qVPr65nQgPRvzLPsY6vLqIPsrIwpYkYEBuK8nqp
         fGnWMk44P2f6ovarcVcDlN3Mt+252V3w3MD1nPPQ58Gb2oPjc9+Ms/8U/kbQwiG60c7c
         BIUFRcryiy9IvGxhDMnpp7s16fWtbFVuuEDky24zckTRckYwjtq6ikfRzG9j6fVSejPw
         R0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=evU3HVU9jMRZIXhOJBlQF6Vyhp97md0RYjcyvJijOVE=;
        b=XdXNgkmQsjkaT077AXmnSu+IOKP34UBpMK7oDxglSxtT9fFcQnBRDSSe6UFWgGYtUB
         MpJr832rZahyJ67LLrbIcYyAb+PDnhsiRGwpxeaULOzCt4KO6q0UJK6YnnOjikS90Gz7
         ywfidHtNNvrVZqpwX8pRi9arHfsx/5sulm8AEwFzkmYYFATkkDOZBrRTV+MY5S+J/s5Q
         /AghkuApvIh0uAxQey0uCeTQRjqrxbzV1w3eBt65nV1vphLGTLfGNkcZE+AKn99wK4md
         2EQ8Vlk0IqvJD4qqu3taYW/Kr4x9WThU54AaFzwiebz3oviD6ZkzsQT2tfcTdvvpu3V5
         Q91Q==
X-Gm-Message-State: AOAM532mgS1/XIYYIEz/NrC//hBM8cAmonz1u5U5gHMmYeRN0su6sGPm
        NUoBqjUK0V2nyu3d7h6VO+1DNYNy
X-Google-Smtp-Source: ABdhPJyUzNZO4mTTmo7iQBXyif02YJe9RY1I+olYGW0VPEMp38iwyWQibf1Ju1hTP7zXnr9ezkvLXw==
X-Received: by 2002:a63:3005:: with SMTP id w5mr6943821pgw.441.1596270713710;
        Sat, 01 Aug 2020 01:31:53 -0700 (PDT)
Received: from garuda.localnet ([122.182.254.175])
        by smtp.gmail.com with ESMTPSA id x128sm12718578pfb.120.2020.08.01.01.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 01:31:53 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com
Subject: Re: [PATCH 0/2] Bail out if transaction can cause extent count to overflow
Date:   Sat, 01 Aug 2020 14:01:50 +0530
Message-ID: <1952947.bLG1I4LtqG@garuda>
In-Reply-To: <20200801081421.10798-1-chandanrlinux@gmail.com>
References: <20200801081421.10798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 1 August 2020 1:44:19 PM IST Chandan Babu R wrote:

I messed up "git format-patch" command line and hence missed adding
appropriate entries in TO and CC list for the patches themselves. I have
resent the patches. I am sorry about the unnecessary noise.

> XFS does not check for possible overflow of per-inode extent counter
> fields when adding extents to either data or attr fork.
> 
> For e.g.
> 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
>    then delete 50% of them in an alternating manner.
> 
> 2. On a 4k block sized XFS filesystem instance, the above causes 98511
>    extents to be created in the attr fork of the inode.
> 
>    xfsaild/loop0  2035 [003]  9643.390490: probe:xfs_iflush_int: (ffffffffac6225c0) if_nextents=98511 inode=131
> 
> 3. The incore inode fork extent counter is a signed 32-bit
>    quantity. However the on-disk extent counter is an unsigned 16-bit
>    quantity and hence cannot hold 98511 extents.
> 
> 4. The following incorrect value is stored in the xattr extent counter,
>    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
>    core.naextents = -32561
> 
> This patchset adds a new helper function
> (i.e. xfs_trans_resv_ext_cnt()) to check for overflow of the per-inode
> data and xattr extent counters and invokes it before starting an fs
> operation (e.g. creating a new directory entry). With this patchset
> applied, XFS detects counter overflows and returns with an error
> rather than causing a silent corruption.
> 
> The patchset has been tested by executing xfstests with the following
> mkfs.xfs options,
> 1. -m crc=0 -b size=1k
> 2. -m crc=0 -b size=4k
> 3. -m crc=0 -b size=512
> 4. -m rmapbt=1,reflink=1 -b size=1k
> 5. -m rmapbt=1,reflink=1 -b size=4k
> 
> The patches can also be obtained from
> https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v0.
> 
> PS: I am planning to write the code which extends data/xattr extent
> counters from 32-bit/16-bit to 64-bit/32-bit on top of these patches.
> 
>  fs/xfs/libxfs/xfs_attr.c       | 33 ++++++++++--
>  fs/xfs/libxfs/xfs_bmap.c       |  7 +++
>  fs/xfs/libxfs/xfs_trans_resv.c | 33 ++++++++++++
>  fs/xfs/libxfs/xfs_trans_resv.h |  1 +
>  fs/xfs/xfs_bmap_item.c         | 12 +++++
>  fs/xfs/xfs_bmap_util.c         | 40 ++++++++++++++
>  fs/xfs/xfs_dquot.c             |  7 ++-
>  fs/xfs/xfs_inode.c             | 96 ++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iomap.c             | 19 +++++++
>  fs/xfs/xfs_reflink.c           | 35 +++++++++++++
>  fs/xfs/xfs_rtalloc.c           |  4 ++
>  fs/xfs/xfs_symlink.c           | 18 +++++++
>  12 files changed, 301 insertions(+), 4 deletions(-)
> 
> 


-- 
chandan



