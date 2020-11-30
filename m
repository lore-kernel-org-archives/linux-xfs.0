Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFC4C5519F
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Nov 2020 09:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F39B520679
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Nov 2020 09:06:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMlhUhKo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgK3JGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 04:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgK3JGG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 04:06:06 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93211C0613CF
        for <linux-xfs@vger.kernel.org>; Mon, 30 Nov 2020 01:05:26 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id m9so9709873pgb.4
        for <linux-xfs@vger.kernel.org>; Mon, 30 Nov 2020 01:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NuXrGroVzlYH1ZOYLFj4MbE0/oO24rZf0kKm8I+CNA4=;
        b=YMlhUhKoKWTNRwZHonGt3undnSjcUwFlkx6VAWkfzPQ+r6A3JAEWIWNqbr3C4ZmYJ7
         34iZR8eZolQyI4GmZ6Cv6kyR5/8UBycI9UTjLXjQsyfr1Jozv/uqyH2Hs4I6SAB1ijNF
         U1zYjVV31LY4G709HuAL5lpHUGLeZCLsYRW9rXLqt/lCbj7ma0JJXIIA5e5rD7czzJl5
         JxRcbs/8u4Bk88JM5xKTey3DTV14RhNwJjtzhkfk76oEIsWacXJOrhzec1jKi9dxIA+w
         MZp0FKNeBDOCXYeTy7XpH47j4wm+jOVewWfxNr+NBSqLpH2/rxDhRZECE/QQvhIOVor/
         wAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NuXrGroVzlYH1ZOYLFj4MbE0/oO24rZf0kKm8I+CNA4=;
        b=GwXpKIAEzWLsOWEIMpjPEhPVXPmOmLJpHJrU4oJumwIi5PUBbNbTXoERq8gIGDiKbX
         fSRvwDzg8aUc7+TMkS4srjmUFq/Rkke9XqgU+IQaty9f6ksQEbdd/WyEa7hwgpzYuS0a
         tgyexgmr1UPEJLa+vQnw4gIwzPjPt0hSHSeQoZaXL+pl9RagiQhxBeclmYmrwNqsEHTJ
         yw3Wa0KoWht64eiDcG139aoXj6jE7Ca/loNXJNXu6mmKXH44gb3fPOT1cU6oIG+UHIOB
         dgOwgLSi5gNP559K5qXchTWwkPOyBc3c/0Q2ErNpqpoVL8klNPgnooIt4toMC+FCI3+y
         W6uw==
X-Gm-Message-State: AOAM5304BAgsAWLJMMcEPqn1VPUoK9bg3AYPV9/Ulg7/zkqrlk3Gq4Lz
        GYcdnPmSgjDgUmno1ULEgkm9CwfYHko=
X-Google-Smtp-Source: ABdhPJy1Qo40Mn4ayu5E+lmFUO2PUTE5im99q8VO7Q04pL92HelgmRKEsIJw+/QHWzGR3oueLlRzSQ==
X-Received: by 2002:a62:77c3:0:b029:18b:b3df:8c6c with SMTP id s186-20020a6277c30000b029018bb3df8c6cmr17741972pfc.17.1606727125732;
        Mon, 30 Nov 2020 01:05:25 -0800 (PST)
Received: from garuda.localnet ([122.179.43.203])
        by smtp.gmail.com with ESMTPSA id js9sm660654pjb.2.2020.11.30.01.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 01:05:24 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, darrick.wong@oracle.com
Subject: Maximum height of rmapbt when reflink feature is enabled
Date:   Mon, 30 Nov 2020 14:35:21 +0530
Message-ID: <3275346.ciGmp8L3Sz@garuda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The comment in xfs_rmapbt_compute_maxlevels() mentions that with
reflink enabled, XFS will run out of AG blocks before reaching maximum
levels of XFS_BTREE_MAXLEVELS (i.e. 9).  This is easy to prove for 4k
block size case:

Considering theoretical limits, maximum height of rmapbt can be,
max btree height = Log_(min_recs)(total recs)
max_rmapbt_height = Log_45(2^64) = 12.

Detailed calculation:
nr-levels = 1; nr-leaf-blks = 2^64 / 84 = 2e17;
nr-levels = 2; nr-blks = 2e17 / 45 = 5e15;
nr-levels = 3; nr-blks = 5e15 / 45 = 1e14;
nr-levels = 4; nr-blks = 1e14 / 45 = 2e12;
nr-levels = 5; nr-blks = 2e12 / 45 = 5e10;
nr-levels = 6; nr-blks = 5e10 / 45 = 1e9;
nr-levels = 7; nr-blks = 1e9 / 45 = 3e7;
nr-levels = 8; nr-blks = 3e7 / 45 = 6e5;
nr-levels = 9; nr-blks = 6e5 / 45 = 1e4;
nr-levels = 10; nr-blks = 1e4 / 45 = 3e2;
nr-levels = 11; nr-blks = 3e2 / 45 = 6;
nr-levels = 12; nr-blks = 1;

Total number of blocks = 2e17

Here, 84 is the minimum number of leaf records and 45 is the minimum
number of node records in the rmapbt when using 4k block size. 2^64 is
the maximum possible rmapbt records
(i.e. max_rmap_entries_per_disk_block (2^32) * max_nr_agblocks
(2^32)).

i.e. theoretically rmapbt height can go upto 12.

But as the comment in xfs_rmapbt_compute_maxlevels() suggests, we will
run out of per-ag blocks trying to build an rmapbt of height
XFS_BTREE_MAXLEVELS (i.e. 9).

Since number of nodes grows as a geometric series,
nr_nodes (roughly) = (45^9 - 1) / (45 - 1) = 10e12

i.e. 10e12 blocks > max ag blocks (2^32 == 4e9)


However, with 1k block size we are not close to consuming all of 2^32
AG blocks as shown by the below calculations,

 - rmapbt with maximum of 9 levels will have roughly (11^9 - 1) / (11 -
   1) = 2e8 blocks.
   - 11 is the minimum number of recs in a non-leaf node with 1k block size.
   - Also, Total number of records (roughly) = (nr_leaves * 11) = 11^8 * 11
     = 2e9 (this value will be used later).
 
 - refcountbt
   - Maximum number of records theoretically = maximum number of blocks
     in an AG = 2^32
   - Total (leaves and non-leaf nodes) blocks required to hold 2^32 records
     Leaf min recs = 20;  Node min recs = 60 (with 1k as the block size).
     - Detailed calculation:
 	    nr-levels = 1; nr-leaf-blks = 2^32 / 20 = 2e8;
 	    nr-levels = 2; nr-blks = 2e8 / 60 = 4e6
 	    nr-levels = 3; nr-blks = 4e6 / 60 = 6e4
 	    nr-levels = 4; nr-blks = 6e4 / 60 = 1.0e3
 	    nr-levels = 5; nr-blks = 1.0e3 / 60 = 2e1
 	    nr-levels = 6; nr-blks = 1
 
     - Total block count = 2e8
 
 - Bmbt (assuming all the rmapbt records have the same inode as owner)
   - Total (leaves and non-leaf nodes) blocks required to hold 2e9 records
     Leaf min recs = 29;  Node min recs = 29 (with 1k as the block size).
     (2e9 is the maximum rmapbt records with rmapbt height 9 and 1k block size).
       nr-levels = 1; nr-leaf-blks = 2e9 / 29 = 7e7
       nr-levels = 2; nr-blks = 7e7 / 29 = 2e6
       nr-levels = 3; nr-blks = 2e6 / 29 = 8e4
       nr-levels = 4; nr-blks = 8e4 / 29 = 3e3
       nr-levels = 5; nr-blks = 3e3 / 29 = 1e2
       nr-levels = 6; nr-blks = 1e2 / 29 = 3
       nr-levels = 7; nr-blks = 1
 
   - Total block count = 7e7
 
 Total blocks used across rmapbt, refcountbt and bmbt = 2e8 + 2e8 + 7e7 = 5e8.
 
Since 5e8 < 4e9(i.e. 2^32), we have not run out of blocks trying to
build a rmapbt with XFS_BTREE_MAXLEVELS (i.e 9) levels.

Please let me know if my understanding is incorrect.

I have come across a "log reservation" calculation issue when
increasing XFS_BTREE_MAXLEVELS to 10 which is in turn required for
extending data fork extent count to 48 bits. To proceed further, I
need to have a correct understanding of problem I have described w.r.t
1k filesystem block size.

-- 
chandan



