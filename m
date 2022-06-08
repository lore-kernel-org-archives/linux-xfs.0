Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5675C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 05:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiFHFTO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 01:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiFHFSS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 01:18:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19EAD408A43
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 19:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654655410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oyW2f1itNzUs1cDiwavRlrb+HnzIpQOceE6iFqvlW/o=;
        b=PyZhvB6JPeOsIn8hnUZZSfipyfqHhRcPyM0jLV29ffETPLxP8rHovkZ/GcHFhM5FkFk8j0
        CrHpZx9f+Q3Ivx+px8coE3bRHHwXi9UsPDg3A3N2sOsL4DvmYD5ORF6vpQ4A9Dl+0XQBY3
        3Xoi81nvmrm0Ws2xMuLNUK2DUQ6TsD0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-Oql4XZoWMnaF0EGDstIJEA-1; Tue, 07 Jun 2022 22:19:31 -0400
X-MC-Unique: Oql4XZoWMnaF0EGDstIJEA-1
Received: by mail-qk1-f197.google.com with SMTP id bi27-20020a05620a319b00b006a6c5696621so5316302qkb.20
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jun 2022 19:19:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oyW2f1itNzUs1cDiwavRlrb+HnzIpQOceE6iFqvlW/o=;
        b=wyypBDkBMZIpb5bbtWlRUUfHcnXW7UTJI7EQwHTP3/drOOW95DR9PRuPASV2ZIEqtr
         KFZt3imLhYu7jdLh2WpAzA9C1UQOPoAJHvM9yp3jaCYLG9nZaJNF+0ZFTIKlGhVWNKK8
         mZJdCykQIAZbFxh6qkbZ6CZ9txLwQgDoKprKFFj0tTIej/gdDKTpf/9Y/kMsA7JQW5gY
         +tTnIH/HlyC97io1sCEooFGdIIfqvJf/BmsukPDKuImih++2Qpd6IINGNhmWQO9QpouH
         A/i+jcySZMmCWG+H/Pk+lUMdXzQekEFlUM8hIg5iLPKrV0jnoNRUUXaKhzXh990Xcjuw
         2ziw==
X-Gm-Message-State: AOAM533MVeIZrxVJMdAV0odWEy1fk7jt7sNe/0Dbtepd2gbIMoc54gCL
        06agE9S5oK6jL9hlBTjf1lrSMMVgTZGP1XQ2YQBpUV1/7uotW+IUpBf9yu4dagkeCdUPhgM3se0
        SWJKOJTn9bUZfaw6po99t
X-Received: by 2002:a05:620a:17a2:b0:6a5:a7df:a70 with SMTP id ay34-20020a05620a17a200b006a5a7df0a70mr22039271qkb.570.1654654771022;
        Tue, 07 Jun 2022 19:19:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVr1TLwu7qQKyc9dkV5UbnbCCGRBP8arBkF1FJFbPNcZASu1MPuoZ5qxb4v92BtJOOQBmC7g==
X-Received: by 2002:a05:620a:17a2:b0:6a5:a7df:a70 with SMTP id ay34-20020a05620a17a200b006a5a7df0a70mr22039261qkb.570.1654654770721;
        Tue, 07 Jun 2022 19:19:30 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y19-20020a05620a44d300b006a6a4b43c01sm11625168qkp.38.2022.06.07.19.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 19:19:29 -0700 (PDT)
Date:   Wed, 8 Jun 2022 10:19:22 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n  o area'
 (offset 0, size 1)!
Message-ID: <20220608021922.n2izu7n4yoadknkx@zlang-mailbox>
References: <bug-216073-27@https.bugzilla.kernel.org/>
 <20220606151312.6a9d098c85ed060d36519600@linux-foundation.org>
 <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 07, 2022 at 05:05:01PM +0200, Alexander Gordeev wrote:
> On Mon, Jun 06, 2022 at 03:13:12PM -0700, Andrew Morton wrote:
> > (switched to email.  Please respond via emailed reply-to-all, not via the
> > bugzilla web interface).
> 
> Hi Zorro,
> 
> Unfortunately, I am not able to reproduce the issue. Could you please
> clarify your test environment details and share your xfstests config?

One of the test environment details as [1]. The xfstests config as [2].
It's easier to reproduce on 64k directory size xfs by running xfstests
auto group.

Thanks,
Zorro

[1]
CPU
Vendor	IBM/S390
Model Name	8561
Family	0
Model	3126312
Stepping	0
Speed	0.0
Processors	2
Cores	0
Sockets	0
Hyper	True
Flags	edat dfp vxp vx vxe ldisp sie vxe2 highgprs etf3eh te vxd gs sort zarch msa stfle dflt eimm esan3
Arch(s)	s390x

Memory	4096 MB
NUMA Nodes	1

Disks
Model	Size	Logical sector size	Physical sector size
3390/0c	41.03 GB / 38.21 GiB	4096 bytes	4096 bytes

[2]
# cat local.config
FSTYP=xfs
TEST_DEV=/dev/loop0
TEST_DIR=/mnt/fstests/TEST_DIR
SCRATCH_DEV=/dev/loop1
SCRATCH_MNT=/mnt/fstests/SCRATCH_DIR
LOGWRITES_DEV=/dev/loop2
MKFS_OPTIONS="-n size=65536 -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1"
TEST_FS_MOUNT_OPTS=""

> 
> Thanks!
> 

