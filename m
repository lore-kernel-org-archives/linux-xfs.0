Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20AFC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbiK2VSF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiK2VSE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:18:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8A655A9C
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:18:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7BAE6CE16B6
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E72C433D6;
        Tue, 29 Nov 2022 21:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669756679;
        bh=Q4iwnMEX22ABfTxZYfVuAumAbM7RqGj/QVGISuOrm1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PnH5zeLkbGy0Vcl1k8qLhOvL6w7a2szdRVoq6G4pUwqT7i4UFZEhsvcE3gHlBm1kk
         lD5K2TAbtX0BMnYzG7jyCclij9FVzCoHvrTlqg1JmcawglBlNnbt9xJDRagsm4b0Fm
         BHR2TpdRnbZvfqEQ5z2smMiBjEqWA05YQ7FB7rfBuREuqXeNMzAJAS32i7PW/4MVlN
         t4/sTD97ttu/LkStXE5/duj0jQhBfnTTVWcVdPtNRy8RAgEryGkkmvKMbR3CeRl1H1
         gVgGPG3X4wVYxP3fSPfhxXOOeGQxyvUqP6edhM1FGPMwQO7jRV47xS/uT3NVmn21Dn
         S3iG89Qzls2Kg==
Date:   Tue, 29 Nov 2022 13:17:58 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Shawn <neutronsharc@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Do I have to fsync after aio_write finishes (with fallocate
 preallocation) ?
Message-ID: <Y4Z3BiqGKdPCx9Hc@magnolia>
References: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 11:20:05AM -0800, Shawn wrote:
> Hello all,
> I implemented a write workload by sequentially appending to the file
> end using libaio aio_write in O_DIRECT mode (with proper offset and
> buffer address alignment).  When I reach a 1MB boundary I call
> fallocate() to extend the file.
> 
> I need to protect the write from various failures such as disk unplug
> / power failure.  The bottom line is,  once I ack a write-complete,
> the user must be able to read it back later after a disk/power failure
> and recovery.
> 
> In my understanding,  fallocate() will preallocate disk space for the
> file,  and I can call fsync to make sure the file metadata about this
> new space is persisted when fallocate returns.  Once aio_write returns
> the data is in the disk.  So it seems I don't need fsync after
> aio-write completion, because (1) the data is in disk,  and (2) the
> file metadata to address the disk blocks is in disk.
> 
> On the other hand, it seems XFS always does a delayed allocation
> which might break my assumption that file=>disk space mapping is
> persisted by fallocate.
> 
> I can improve the data-in-disk format to carry proper header/footer to
> detect a broken write when scanning the file after a disk/power
> failure.
> 
> Given all those above,  do I still need a fsync() after aio_write
> completion in XFS to protect data persistence?

Yes.  The only time you don't is if you're performing an O_SYNC write
to a part of a file that you've already written (and fsync'd) that's
entirely below EOF and you've arranged that the filesystem will never
COW or otherwise require metadata updates.

Hey, at least aio_fsync works now...

--D

> Thanks all for your input!
> 
> regards,
> Shawn
