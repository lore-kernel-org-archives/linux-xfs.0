Return-Path: <SRS0=7N5F=AB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60127C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 12:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E16523B84
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 12:54:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TH3WVKNP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgFTMyY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 08:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgFTMyX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 08:54:23 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B29EC06174E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 05:54:23 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id e8so565329pgc.5
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 05:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y5OIdeo52BYcpDt/JrlreeNWSAURoD41aW4lKV7jHEo=;
        b=TH3WVKNPuCBews2ortLiwLcuHhIhWjRcbx8N5akP6ZJf+zJUcRDSTD7awZzB6LXEAB
         7ovacuaaxzZCtuP3/UPCk7QwnPH2NTDhL7nS8EE6RfWvxpJBW5TccZGtdLvHGTXw8bh8
         MjCEe9sCLdAlzzinJ+M7ph0VIbMGOXiT2rwc6HNPMQmdtlRTQYKrIkdWWKV1DUrQVlGe
         u1YR4mV+vnBj80ioN1tEpa3YaA0RLloyhfKgNtjkbmsXKB/W36jkmJui1zZVnjCKesDH
         BIM6Izr6lvbNrdRHnKVQaSWZS7ASs7Vznbziu8ddA87Oeu1DiRvnffXOIPkNReYDkG6A
         jydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y5OIdeo52BYcpDt/JrlreeNWSAURoD41aW4lKV7jHEo=;
        b=LPmgHcv3/P2LQm0idjD5wpzpubtfXs9pCZF9cBegIrLuSucthP4boJRrzoRVq1dnsu
         aBKaDy+ZUI7ESS+hO1AursKei2tS9VqdHz96cN260p0wIukfCNYcKw91KBF0O0by6HHq
         E6KhH5AIa3DU7sdZZA9HzZ/t/72arJxiowEtV/Dsv5VJGXW30RPvM1AZ2E88WQ8LSxKx
         UUrVeGrHWuucxBsJIfwYw303AsQ8mG+EgH3HD9q/Qf/3a1vYOOKU40IbnRkye4YSyJqE
         9zb2faWsGlkPVqDmo5i32u+uuUa9UbR3XytZHI6jzNy1RbzXwqutKRgf/tzKF5kJQEgi
         N/Fg==
X-Gm-Message-State: AOAM532pmx9Boxd4ruQW+iSGwRBd5lqR9ZZaEUBsbkBnTuSNz+NEtt3y
        tRbGeAd23QMNcq4jch6p1P4=
X-Google-Smtp-Source: ABdhPJzd6eNIPFpj6Y1vsScfYWwnXHeAhkPgCb2mn8r7S/dVne6UZWi1Xo6hIvWroiVLtp68LC0NZw==
X-Received: by 2002:a62:3145:: with SMTP id x66mr11986535pfx.147.1592657662977;
        Sat, 20 Jun 2020 05:54:22 -0700 (PDT)
Received: from garuda.localnet ([171.61.66.69])
        by smtp.gmail.com with ESMTPSA id x3sm8688863pfi.57.2020.06.20.05.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 05:54:22 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: Re: [PATCH 7/7] xfs: Extend attr extent counter to 32 bits
Date:   Sat, 20 Jun 2020 18:23:09 +0530
Message-ID: <7208545.rkixA8KlOQ@garuda>
In-Reply-To: <20200619143917.GD29528@infradead.org>
References: <20200606082745.15174-1-chandanrlinux@gmail.com> <20200606082745.15174-8-chandanrlinux@gmail.com> <20200619143917.GD29528@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 19 June 2020 8:09:17 PM IST Christoph Hellwig wrote:
> On Sat, Jun 06, 2020 at 01:57:45PM +0530, Chandan Babu R wrote:
> > This commit extends the per-inode attr extent counter to 32 bits.
> 
> And the reason for why this is needed or at least nice to have needs
> to go here.
> 

Parent pointers are stored in xattrs of the corresponding inode. Dave had
informed me that there have been instances where we have more than 100 million
hardlinks associated with an inode. This will most likely cause the 16-bit
wide on-disk xattr extent counter to overflow as described below,

1. Insert 5 million xattrs (each having a value size of 255 bytes) and then
   delete 50% of them in an alternating  manner. 
   ./benchmark-xattrs -l 255 -n 5000000 -s 50 -f $mntpnt/testfile-0

   benchmark-xattrs.c and related sources can be obtained from
   https://github.com/chandanr/xfs-xattr-benchmark/blob/master/src/
   
2. This causes 98511 extents to be created in the attr fork of the inode.
   xfsaild/loop0  2035 [003]  9643.390490: probe:xfs_iflush_int: (ffffffffac6225c0) if_nextents=98511 inode=131

3. The incore inode fork extent counter is a signed 32-bit quantity. However
   the on-disk extent counter is an unsigned 16-bit quantity and hence cannot
   hold 98511 extents.

4. The following incorrect value is stored in the attr extent counter
   # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
   core.naextents = -32561

I will add a generic description of the above sequence of events in the commit
message of this patch when posting the next version.

-- 
chandan



