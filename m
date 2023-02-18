Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32A8C636D7
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Feb 2023 06:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjBRGO5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Feb 2023 01:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBRGO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Feb 2023 01:14:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005155B2E2
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676700855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RfbpN2uhmVnkyGZQIB0VqKn/zYaayC1Zq6AMrPa+tLY=;
        b=ReriiLCaDRTcPmwRk/SMfL1eY9Q+SBMZiDEeAfuGuXpYGT3o8xEAVBU2b0y/e1Ymf8RC29
        t/6rCLvbyQhjvKtPd659zDupJr8dMk35kqoV7BBOe9uNcZoYvIob7cUdovAKTZMtMtnvx5
        NbWS259R2pt1EScS6pAJA5v+jPf3O8g=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-319-aJsIl9SWMkGhDKW1wABgQw-1; Sat, 18 Feb 2023 01:14:13 -0500
X-MC-Unique: aJsIl9SWMkGhDKW1wABgQw-1
Received: by mail-pj1-f69.google.com with SMTP id z13-20020a17090a540d00b002356c612574so667531pjh.2
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RfbpN2uhmVnkyGZQIB0VqKn/zYaayC1Zq6AMrPa+tLY=;
        b=EszpW2I9Lz9fzWLByERJa/vN1DK6ivV4V2kqoAYVyUiKe2n9pU3ez4CuqqdtOhFu9z
         kQH1TkIhVG86SfGyHhJnMb3DjjLtPCw8H/goxoD/c5q1smg+RnPqD3cQM44gDwKAUPaR
         s/JEB6mhxEBFwbiQwaQB5n8HNcy76rBhPCbMOpSfKfkCP++jK+czF3LybS+8i37Mb2dV
         fUTQ/G1swJyDWZp4VrNOU9ZgURWWPYmeDrSEOZPKuNID5uVFmUAD4ACKZ57H8M8H/n8V
         uHHTKbv9n32+cEY2xj/iTMQRYKZJjcW+UgqWQ8s9tndjy/tA/AmaMKR+vgZ5YUN6zON5
         JTRQ==
X-Gm-Message-State: AO0yUKVBm5oxSbz1rwGVyCL6gQGVcH9KLSliG7wUWwIEugXDnsxckbSV
        qam0Iye4VHKa2eAtGQuZSr2JzPdrVTC54Kk04iHq7XE/qzvdrlIN11SscsjkbMqI2bhkRgupE0/
        N49TM5HTt+AyJ+2E9t6yq
X-Received: by 2002:a17:903:2803:b0:19a:b869:f2ef with SMTP id kp3-20020a170903280300b0019ab869f2efmr1243202plb.15.1676700852063;
        Fri, 17 Feb 2023 22:14:12 -0800 (PST)
X-Google-Smtp-Source: AK7set8rG+SaUVIP9aSmv+ho24Lao1X7SlVgSwVctTOotsZx0zXmlu/I89GoZ29OJZ3AvIu66W8mgg==
X-Received: by 2002:a17:903:2803:b0:19a:b869:f2ef with SMTP id kp3-20020a170903280300b0019ab869f2efmr1243189plb.15.1676700851739;
        Fri, 17 Feb 2023 22:14:11 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h22-20020a170902ac9600b001963a178dfcsm4021606plr.244.2023.02.17.22.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 22:14:11 -0800 (PST)
Date:   Sat, 18 Feb 2023 14:14:07 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET v24.0 0/2] fstests: online repair for fs summary
 counters
Message-ID: <20230218061407.lr2df4hhaowunalr@zlang-mailbox>
References: <Y69Unb7KRM5awJoV@magnolia>
 <167243877039.727863.13765266441029212988.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243877039.727863.13765266441029212988.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:30PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> A longstanding deficiency in the online fs summary counter scrubbing
> code is that it hasn't any means to quiesce the incore percpu counters
> while it's running.  There is no way to coordinate with other threads
> are reserving or freeing free space simultaneously, which leads to false
> error reports.  Right now, if the discrepancy is large, we just sort of
> shrug and bail out with an incomplete flag, but this is lame.
> 
> For repair activity, we actually /do/ need to stabilize the counters to
> get an accurate reading and install it in the percpu counter.  To
> improve the former and enable the latter, allow the fscounters online
> fsck code to perform an exclusive mini-freeze on the filesystem.  The
> exclusivity prevents userspace from thawing while we're running, and the
> mini-freeze means that we don't wait for the log to quiesce, which will
> make both speedier.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D

This patchset looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fscounters
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-fscounters
> ---
>  tests/xfs/713     |   36 ++++++++++++++++++++++++++++++++++++
>  tests/xfs/713.out |    4 ++++
>  tests/xfs/714     |   41 +++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/714.out |    2 ++
>  tests/xfs/762     |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/762.out |    2 ++
>  6 files changed, 131 insertions(+)
>  create mode 100755 tests/xfs/713
>  create mode 100644 tests/xfs/713.out
>  create mode 100755 tests/xfs/714
>  create mode 100644 tests/xfs/714.out
>  create mode 100755 tests/xfs/762
>  create mode 100644 tests/xfs/762.out
> 

