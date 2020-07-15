Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC41C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 11:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75A53206E9
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 11:41:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BkAoMaDh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgGOLlM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 07:41:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23206 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725924AbgGOLlM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 07:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594813268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DxNfnmdm5vohZA2Oi7n1B5zgDA0X1rQVc6cnuGyh+XY=;
        b=BkAoMaDhBIVs/f2phGtmvLshvExMkUtxejTZH5U/2YqWj+GMQ/8C6CssLgOBbcrfqF30+Q
        ELtwbQEjXfND3dMst7KwUnvBU4I4QLIaMv7myP9ZlipvNtxzHj5i+pXZU0rZy9UYEORJdg
        gkNCLXcxFcqBzvEmkldp9rGPa6qi4Sg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-jhqSvy3lPmqigGH_TlGohA-1; Wed, 15 Jul 2020 07:41:01 -0400
X-MC-Unique: jhqSvy3lPmqigGH_TlGohA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 641C418A1DE2;
        Wed, 15 Jul 2020 11:41:00 +0000 (UTC)
Received: from bfoster (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 08A1F61982;
        Wed, 15 Jul 2020 11:40:59 +0000 (UTC)
Date:   Wed, 15 Jul 2020 07:40:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs_repair doesn't handle: br_startoff 8388608 br_startblock -2
 br_blockcount 1 br_state 0 corruption
Message-ID: <20200715114058.GB51908@bfoster>
References: <744867e7-0457-46c6-f14b-8d7b91a61bbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <744867e7-0457-46c6-f14b-8d7b91a61bbc@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 09:05:47AM +0200, Arkadiusz Miśkiewicz wrote:
> 
> Hello.
> 
> xfs_repair (from for-next from about 2-3 weeks ago) doesn't seem to
> handle such kind of corruption. Repair (few times) finishes just fine
> but it ends up again with such trace.
> 

Are you saying that xfs_repair eventually resolves the corruption but it
takes multiple tries, and then the corruption reoccurs at runtime? Or
that xfs_repair doesn't ever resolve the corruption?

Either way, what does xfs_repair report?

> Metadump is possible but problematic (will be huge).
> 

How huge? Will it compress?

> 
> Jul  9 14:35:51 x kernel: XFS (sdd1): xfs_dabuf_map: bno 8388608 dir:
> inode 21698340263
> Jul  9 14:35:51 x kernel: XFS (sdd1): [00] br_startoff 8388608
> br_startblock -2 br_blockcount 1 br_state 0

It looks like we found a hole at the leaf offset of a directory. We'd
expect to find a leaf or node block there depending on the directory
format (which appears to be node format based on the stack below) that
contains hashval lookup information for the dir.

It's not clear how we'd get into this state. Had this system experienced
any crash/recovery sequences or storage issues before the first
occurrence?

Brian

> Jul  9 14:35:51 x kernel: XFS (sdd1): Internal error xfs_da_do_buf(1) at
> line 2557 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller
> xfs_da_read_buf+0x6a/0x120 [xfs]
> Jul  9 14:35:51 x kernel: CPU: 3 PID: 2928 Comm: cp Tainted: G
>   E     5.0.0-1-03515-g3478588b5136 #10
> Jul  9 14:35:51 x kernel: Hardware name: Supermicro X10DRi/X10DRi, BIOS
> 3.0a 02/06/2018
> Jul  9 14:35:51 x kernel: Call Trace:
> Jul  9 14:35:51 x kernel:  dump_stack+0x5c/0x80
> Jul  9 14:35:51 x kernel:  xfs_dabuf_map.constprop.0+0x1dc/0x390 [xfs]
> Jul  9 14:35:51 x kernel:  xfs_da_read_buf+0x6a/0x120 [xfs]
> Jul  9 14:35:51 x kernel:  xfs_da3_node_read+0x17/0xd0 [xfs]
> Jul  9 14:35:51 x kernel:  xfs_da3_node_lookup_int+0x6c/0x370 [xfs]
> Jul  9 14:35:51 x kernel:  ? kmem_cache_alloc+0x14e/0x1b0
> Jul  9 14:35:51 x kernel:  xfs_dir2_node_lookup+0x4b/0x170 [xfs]
> Jul  9 14:35:51 x kernel:  xfs_dir_lookup+0x1b5/0x1c0 [xfs]
> Jul  9 14:35:51 x kernel:  xfs_lookup+0x57/0x120 [xfs]
> Jul  9 14:35:51 x kernel:  xfs_vn_lookup+0x70/0xa0 [xfs]
> Jul  9 14:35:51 x kernel:  __lookup_hash+0x6c/0xa0
> Jul  9 14:35:51 x kernel:  ? _cond_resched+0x15/0x30
> Jul  9 14:35:51 x kernel:  filename_create+0x91/0x160
> Jul  9 14:35:51 x kernel:  do_linkat+0xa5/0x360
> Jul  9 14:35:51 x kernel:  __x64_sys_linkat+0x21/0x30
> Jul  9 14:35:51 x kernel:  do_syscall_64+0x55/0x100
> Jul  9 14:35:51 x kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> 
> Longer log:
> http://ixion.pld-linux.org/~arekm/xfs-10.txt
> 
> 
> -- 
> Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
> 

