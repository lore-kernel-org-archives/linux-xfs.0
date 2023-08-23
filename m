Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C40EE49A5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Aug 2023 03:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjHWDGj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 23:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbjHWDGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2023 23:06:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048B5CE8
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2023 20:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692759938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4QiA9d3P5G85In9NHSJpzGB0lSBcXOKFk4V0WBI5ChE=;
        b=McTIZxpnbHIkNQU04NPyln2vrbappZPeK8VjxjdL16O5NaJDEbyY6USeMCh0izLyZlsI71
        i3XJ1BelO/bvPzDylWsM6kSoBHMr8NWln2XYc6FpBGoGW+5qU3Xp3k6lV1IzNTk7Yn4lw/
        8lnMwGj99QAl7AkSedBDcGS/gJFVlrE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-RIU_HgHhOMuh8wDFTrE2ow-1; Tue, 22 Aug 2023 23:05:36 -0400
X-MC-Unique: RIU_HgHhOMuh8wDFTrE2ow-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1bf39e73558so74715145ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2023 20:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692759935; x=1693364735;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4QiA9d3P5G85In9NHSJpzGB0lSBcXOKFk4V0WBI5ChE=;
        b=ADvVxma6AuohU5LtrOfMm+LwLI8hlYK8ljG3IDjKH0JbWuLFDHWtBoudyYoJHfy62v
         NuvaWiHDYpDnsnk3e3y/RflDQ5Rbvr8fZ8akW/5qooTB5ZseKrLoqTHW+pRsiycNmwE5
         sFd2N8GIEsD32JbxnV/wAoyE0GoXyRVITITeDBQVD+OUuJ4Jup+EVK89Gf1WgCgnckJF
         gWhqT2zfN4yAYy4hBCrr9k4+h+VX2uh6iFtkMt/NCdom2eCUwn4QjofijPrT+Zds+r4i
         KslglObA5NuF2p60CRADPWdz8vlO8+5x8V8eaOzHd2WWiEGxqwCl/I1h4JkvCAH+bsSX
         KvCA==
X-Gm-Message-State: AOJu0Yy1tYB9qHO5d0gqOZE+6btn1jBDf6MF5vZsoaDW18i00YtKk19a
        YvhzXG5GRkljNuqoSfQ+/nZbSzQGxGxCk7VFd61ImLHdNrKBHdDSKWeg00V/4baJc1ln7BvFgKi
        ke4EFVuVJMOHp0NJT/45oPQRVK9t+
X-Received: by 2002:a17:902:bf47:b0:1bd:bdfb:58e9 with SMTP id u7-20020a170902bf4700b001bdbdfb58e9mr10937219pls.40.1692759935407;
        Tue, 22 Aug 2023 20:05:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUrPFRnH57jKmgN1YG7yeqwqpr+eBffQ7Pgm/KI6B/AX2pCgm+xtFXM/Pc6rgWlttzuLqhqA==
X-Received: by 2002:a17:902:bf47:b0:1bd:bdfb:58e9 with SMTP id u7-20020a170902bf4700b001bdbdfb58e9mr10937205pls.40.1692759935045;
        Tue, 22 Aug 2023 20:05:35 -0700 (PDT)
Received: from [10.64.146.155] (61-69-103-54.mel.static-ipl.aapt.com.au. [61.69.103.54])
        by smtp.gmail.com with ESMTPSA id a16-20020a170902b59000b001bba3650448sm9760434pls.258.2023.08.22.20.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 20:05:34 -0700 (PDT)
Message-ID: <3d263b27-fa53-81c0-a711-aefffa2ef354@redhat.com>
Date:   Wed, 23 Aug 2023 13:05:31 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to a86308c98
Content-Language: en-US
To:     Carlos Maiolino <carlos@maiolino.me>, linux-xfs@vger.kernel.org
References: <20230802094128.ptcuzaycy3vzzovk@andromeda>
From:   Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <20230802094128.ptcuzaycy3vzzovk@andromeda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/8/23 19:41, Carlos Maiolino wrote:
> Hello.
> 
> The xfsprogs for-next branch, located at:
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next
> 
> Has just been updated.
> 
> Patches often get missed, so if your outstanding patches are properly reviewed on
> the list and not included in this update, please let me know.
> 

Its a minor one, but the unit test for xfs_repair progress reporting[1] 
depends on

xfs_repair: always print an estimate when reporting progress
https://lore.kernel.org/linux-xfs/20230531064143.1737591-1-ddouwsma@redhat.com/

[1] [PATCH v4] xfstests: add test for xfs_repair progress reporting
https://lore.kernel.org/linux-xfs/20230610063855.gg6cd7bh5pzyobhe@zlang-mailbox/


> The new head of the for-next branch is commit:
> 
> a86308c98d33e921eb133f47faedf1d9e62f2e77
> 
> 2 new commits:
> 
> Bill O'Donnell (1):
>        [780e93c51] mkfs.xfs.8: correction on mkfs.xfs manpage since reflink and dax are compatible

Mmm, this reminds me, sparse inodes have been the default for a while 
now, I thought someone was going to submit a patch to update the 
manpage, but I cant see it anywhere.

- Don

> 
> Wu Guanghao (1):
>        [a86308c98] xfs_repair: fix the problem of repair failure caused by dirty flag being abnormally set on buffer
> 
> Code Diffstat:
> 
>   man/man8/mkfs.xfs.8.in | 7 -------
>   repair/scan.c          | 2 +-
>   2 files changed, 1 insertion(+), 8 deletions(-)

