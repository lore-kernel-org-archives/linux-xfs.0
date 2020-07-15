Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80FAC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 07:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DEA62065E
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 07:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ruM48ch9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgGOHFx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 03:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgGOHFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 03:05:52 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E45EC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 00:05:52 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id y18so472550lfh.11
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 00:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=cZpPBr6QcgD5NOThIEIEbMR8/zmIhcJKg83JOkvRNYg=;
        b=ruM48ch9N6M9quf5nDkhp3/eGHmMdnaQcpQUjKVUHOLrbxX/G38pqqFarleq4dPIH/
         00rRqo8QwqpmCrreS0sP0d+DmCynWJ1PiObN4SlNXZxMTKiksWuDbQsxoNdb3+7unZqU
         eoAr4xP+vOPFhOulL+uJmOD1U8mTXoTBJORja+WQ7qRwc5OVQiJ3aIfFTq7gMllXaURj
         I+zetKof9z9CeCjK+/DApN2v3czJ7qmToBfPzrl3x1h0Ed76xHHGCAOMFImPIxAgkYnn
         xBgq0MXUPjHAgjulTfkLOt28FycUjeKwMWeZYSaftBI8nsy3tBOOmteohGrPp23ng1Hy
         715w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=cZpPBr6QcgD5NOThIEIEbMR8/zmIhcJKg83JOkvRNYg=;
        b=MsDLpzt95WNNHPfOj+chssjiHHx/SIsLr5oT6z8r2PfOULawXJVEA+xfl40huy/De4
         35xRHcVCkqWiOOcXzA7DsTGbH3oaK+uqWRbMLTnY43wenlRXVMEpYq5u5MVrhQd4bTEG
         qARqZYXoNzkUGmCFAVjpagTzZ4cgeVrIC12/Sjwy5SIwOxYhl7HZgqa4lPHcs7nfhedT
         4hVl9zfUuJz2+QNUfpgma4DDWys090b/7+kbdZlGD1Be2rldk6gl5WBRd/5zbVjQufgH
         9YbCHyu9chdZ9fCyYjmn1SfvsnYipoLr6iXX+hARMBDc8uScTlj6B58xSkutoIJvzY14
         zbRQ==
X-Gm-Message-State: AOAM533lGFJ/3/fkG+8hcKq4dPngzMWZHB/EBHZ9yS3hCm9SMo8u36jG
        GMqcwUvYWB3HSMctRA+bCUXHBfTw
X-Google-Smtp-Source: ABdhPJxOrcB3+imwTjsa1DaYwvhR9uteb3/7CTzjALi6j+9KTM25zn8NoIHc9XkY1oLY1/2JIXxj7A==
X-Received: by 2002:a19:806:: with SMTP id 6mr3980586lfi.171.1594796750196;
        Wed, 15 Jul 2020 00:05:50 -0700 (PDT)
Received: from amb.local (out244.support.agnat.pl. [91.234.176.244])
        by smtp.gmail.com with ESMTPSA id t15sm359143lft.0.2020.07.15.00.05.49
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 00:05:49 -0700 (PDT)
From:   =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Subject: xfs_repair doesn't handle: br_startoff 8388608 br_startblock -2
 br_blockcount 1 br_state 0 corruption
To:     linux-xfs@vger.kernel.org
Message-ID: <744867e7-0457-46c6-f14b-8d7b91a61bbc@gmail.com>
Date:   Wed, 15 Jul 2020 09:05:47 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hello.

xfs_repair (from for-next from about 2-3 weeks ago) doesn't seem to
handle such kind of corruption. Repair (few times) finishes just fine
but it ends up again with such trace.

Metadump is possible but problematic (will be huge).


Jul  9 14:35:51 x kernel: XFS (sdd1): xfs_dabuf_map: bno 8388608 dir:
inode 21698340263
Jul  9 14:35:51 x kernel: XFS (sdd1): [00] br_startoff 8388608
br_startblock -2 br_blockcount 1 br_state 0
Jul  9 14:35:51 x kernel: XFS (sdd1): Internal error xfs_da_do_buf(1) at
line 2557 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller
xfs_da_read_buf+0x6a/0x120 [xfs]
Jul  9 14:35:51 x kernel: CPU: 3 PID: 2928 Comm: cp Tainted: G
  E     5.0.0-1-03515-g3478588b5136 #10
Jul  9 14:35:51 x kernel: Hardware name: Supermicro X10DRi/X10DRi, BIOS
3.0a 02/06/2018
Jul  9 14:35:51 x kernel: Call Trace:
Jul  9 14:35:51 x kernel:  dump_stack+0x5c/0x80
Jul  9 14:35:51 x kernel:  xfs_dabuf_map.constprop.0+0x1dc/0x390 [xfs]
Jul  9 14:35:51 x kernel:  xfs_da_read_buf+0x6a/0x120 [xfs]
Jul  9 14:35:51 x kernel:  xfs_da3_node_read+0x17/0xd0 [xfs]
Jul  9 14:35:51 x kernel:  xfs_da3_node_lookup_int+0x6c/0x370 [xfs]
Jul  9 14:35:51 x kernel:  ? kmem_cache_alloc+0x14e/0x1b0
Jul  9 14:35:51 x kernel:  xfs_dir2_node_lookup+0x4b/0x170 [xfs]
Jul  9 14:35:51 x kernel:  xfs_dir_lookup+0x1b5/0x1c0 [xfs]
Jul  9 14:35:51 x kernel:  xfs_lookup+0x57/0x120 [xfs]
Jul  9 14:35:51 x kernel:  xfs_vn_lookup+0x70/0xa0 [xfs]
Jul  9 14:35:51 x kernel:  __lookup_hash+0x6c/0xa0
Jul  9 14:35:51 x kernel:  ? _cond_resched+0x15/0x30
Jul  9 14:35:51 x kernel:  filename_create+0x91/0x160
Jul  9 14:35:51 x kernel:  do_linkat+0xa5/0x360
Jul  9 14:35:51 x kernel:  __x64_sys_linkat+0x21/0x30
Jul  9 14:35:51 x kernel:  do_syscall_64+0x55/0x100
Jul  9 14:35:51 x kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9


Longer log:
http://ixion.pld-linux.org/~arekm/xfs-10.txt


-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
