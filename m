Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48977C77B75
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 11:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjDULB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 07:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDULB0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 07:01:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7719016
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 04:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682074839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/8L50GWpN6fABWIe9m8wcqKsoNVJGE9elISSDzejuGk=;
        b=bFPdhbC++5LkvyjQx1A/nmqg4v5FvAZA7ZID19hVx6vtaLpjcjRr40SNauTxvpEKwzs+uN
        /9sFHahR2Losu1CihBsKBxRbluEgQvOjBNfmffipKALZ4SeJkR2FQe9WaOJ1xJSwnqa5ti
        2H2YjApY9eiLK2EJmDsiy0jIfpfBwqs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-l6sQO2D8PoqMQtcn0Mpg_Q-1; Fri, 21 Apr 2023 07:00:37 -0400
X-MC-Unique: l6sQO2D8PoqMQtcn0Mpg_Q-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-5ef640838f6so10305656d6.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 04:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682074836; x=1684666836;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/8L50GWpN6fABWIe9m8wcqKsoNVJGE9elISSDzejuGk=;
        b=fTpsVGPhCXLBy0rYNnTPrR6lx5UrMQtyGldbLZUxUNQsTmigM1qR3pEtLG+CTruJHD
         IAsOVaVFoK87JiIEVnW+8Yu9rebDsG2vgLEpEV3JTYo2btzncW+W5AoVSQWunNRdc54F
         VMGQQhH4e4KR6PZ8Tf/rgny5yjM+CwgU3rNcISeQzYcnpPu6ccH8uNhhBHIOp5HgrSD9
         UxmR6khuvjDkZGJXfdF+O8Zh3J4QllENgQHo+0mBOgNltBF+zXNVCMrwVmfImvuIu9If
         LDp2DYBH0w9Vg6w0rI9ITup+JWfi95ASR9I+Oi5KdbshPyPvDJx7iuuyXOMMbBdiCfNz
         GU2Q==
X-Gm-Message-State: AAQBX9ccpjEEP8/rI/Y+hw1vsdH53sQxUKzdqXteL2Tj6Qh/lMEmUwaD
        sxhS3AfcfzW205vOv3dtCwP7fWKYR0tF53/CCi14QNEraejKf+Qi07KHwQXWP3K5efCjfEESf+s
        GrZhHB5PhdhdrBzhKTgtx/gZ7cpRifCAdrzoVZfIkjpIFt8wvSRtw4CejIgKuvYOfuHYmscJvR9
        SMSUE=
X-Received: by 2002:ad4:5fcb:0:b0:5e7:56cc:c04a with SMTP id jq11-20020ad45fcb000000b005e756ccc04amr7033517qvb.47.1682074836627;
        Fri, 21 Apr 2023 04:00:36 -0700 (PDT)
X-Google-Smtp-Source: AKy350YeTcSVxc3fRI3TWNJBAp8psTOBYfkWiuPkSnoqT5PEh2oC3LIbfp7SNkOKxWBD4/jQ6EUZhw==
X-Received: by 2002:ad4:5fcb:0:b0:5e7:56cc:c04a with SMTP id jq11-20020ad45fcb000000b005e756ccc04amr7033484qvb.47.1682074836356;
        Fri, 21 Apr 2023 04:00:36 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id 17-20020a370411000000b0074e19c4daeasm1255688qke.5.2023.04.21.04.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 04:00:35 -0700 (PDT)
Date:   Fri, 21 Apr 2023 07:02:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [BUG] XFS (delalloc) writeback livelock writing to -ENOSPC on dm-thin
Message-ID: <ZEJtT7vJ9RA4pno4@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The test case is a simple sequential write to XFS backed by a thin
volume. The test vm is running latest 6.3.0-rc7, has 8xcpu and 8GB RAM,
and the thin volume is backed by sufficient space in the thin pool.
I.e.:

lvcreate --type thin-pool -n tpool -L30G test
lvcreate -V 20G -n tvol test/tpool
mkfs.xfs /dev/test/tvol
mount /dev/test/tvol /mnt
dd if=/dev/zero of=/mnt/file bs=1M

The dd command writes until ~1GB or so free space is left in the fs and
then seems to hit a livelock. From a quick look at tracepoints, XFS
seems to be spinning in the xfs_convert_blocks() writeback path. df
shows space consumption no longer changing, the flush worker is spinning
at 100% and dd is blocked in balance_dirty_pages(). If I kill dd, the
writeback worker continues spinning and an fsync of the file blocks
indefinitely.

If I reset the vm, remount and run the following:

dd if=/dev/zero of=/mnt/file bs=1M conv=notrunc oflag=append

... it then runs to -ENOSPC, as expected.

I haven't seen this occur when running on a non-thin lvm volume, not
sure why. What is also interesting is that if I rm the file and repeat
on the thin volume (so the the thin volume is pretty much fully mapped
at this point), the problem still occurs.

This doesn't reproduce on v6.2. Given the number of XFS changes and the
behavior above, it sort of smells more like an XFS issue than dm, but
I've no real evidence of that. Regardless, I ran a bisect over related
XFS commits and it implicated either of the two following commits:

  85843327094f ("xfs: factor xfs_bmap_btalloc()")
  74c36a8689d3 ("xfs: use xfs_alloc_vextent_this_ag() where appropriate")

More specifically, 85843327094f is the first commit that conclusively
exhibits the problem. 74c36a8689d3 is inconclusive because I run into an
almost instant shutdown when running the test. If I take one more step
back to commit 4811c933ea1a ("xfs: combine __xfs_alloc_vextent_this_ag
and xfs_alloc_ag_vextent"), the problem doesn't occur.

Brian

