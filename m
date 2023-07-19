Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6489C001DC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 20:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjGSUjM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 16:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjGSUjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 16:39:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5416189
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 13:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689799102;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SgRYG1yPEdYUax9y1XDYKcS5/JUvwRiwpBw53hja6CY=;
        b=CdYNz8CL0feaAMOZnXD3WXw74Bbm1bvUrVx1ClpwoSnjV2HSeb49x6lGzWBOsPzLpyv/e2
        lnNLNAMkVGGcY+lu7WRqdD0sZAMAgDPRBPzVWgwNIRDKxLPLLqiCErtourX32myjjaue59
        J3mt5D1yzk/2AqxMKBBskKA1WxxEBW8=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-fzQ2IgZ4NCeqoLOoQr0n3g-1; Wed, 19 Jul 2023 16:38:21 -0400
X-MC-Unique: fzQ2IgZ4NCeqoLOoQr0n3g-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-77e3eaa1343so954239f.2
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 13:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689799100; x=1690403900;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SgRYG1yPEdYUax9y1XDYKcS5/JUvwRiwpBw53hja6CY=;
        b=I9CXKps5cGC7WGYT5vvkjsLzbNHeDX3iXdbsNbZyMGEa7Kgbd32NyKVxNHkpIHbHEj
         zPmOzCbB5SfDOWFNMNAkvjwe/bE6QyCFWZEnr+Fdw+H4+ROxzj4YgWWc2qBo86+VRaOk
         iPBafmP7Sy77Mqq9LaxOiooVJ3NACi64tqQZRI1PlJqUIIEF9w0IUPyk6n/A5WAnZbhB
         tiGlmbuRiTeZ8PS+56O6b3jyCW79MVPEbdxUFIET8ZZzdtfva55xGq9rF+TkYNe76l1G
         NZJvQdeQiH/y5WG+J/6p6rds8Qm7SfAvSdMylg5LeCUcWOPf24b1T4mhb+o8iT1WS2Uj
         nWPA==
X-Gm-Message-State: ABy/qLbj8nF6Ksg2KXrN2J/fuGiB23Z2Sz6fItjfWd044hu+2p0ntYOZ
        Nl9CUbulfQsxa5xOPSdOTZBPUTE86ODpWYdM4b0BD7ggBDq/1jrI5dbzQap3CGPSoz5efXbMeRr
        s26Jct5y8rRTGqcxnwrO/IdxdT4au
X-Received: by 2002:a6b:d013:0:b0:787:34d:f1a4 with SMTP id x19-20020a6bd013000000b00787034df1a4mr6508359ioa.4.1689799099966;
        Wed, 19 Jul 2023 13:38:19 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEILmGMFmg2/mmx959pQb4da6rheWMJQKbDJaCaMeqMwgJZhHt1fudfABS6fVi6QFrDDhrxXA==
X-Received: by 2002:a6b:d013:0:b0:787:34d:f1a4 with SMTP id x19-20020a6bd013000000b00787034df1a4mr6508354ioa.4.1689799099747;
        Wed, 19 Jul 2023 13:38:19 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id s12-20020a02cf2c000000b0041f552e4aa2sm1472568jar.135.2023.07.19.13.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 13:38:19 -0700 (PDT)
Message-ID: <b630989d-1eb5-6285-6e22-9946de8e2ca5@redhat.com>
Date:   Wed, 19 Jul 2023 15:38:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Reply-To: sandeen@redhat.com
Subject: Re: Question on slow fallocate
Content-Language: en-US
To:     Andres Freund <andres@anarazel.de>,
        Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Masahiko Sawada <sawada.mshk@gmail.com>,
        linux-xfs@vger.kernel.org
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <ZJTrrwirZqykiVxn@dread.disaster.area>
 <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
 <3f604849-877b-f519-8cae-4694c82ac7e4@sandeen.net>
 <CAD21AoBHd35HhFpbh9YBHPsLN+F_TZX5b47iy+-s44jPT+fyZQ@mail.gmail.com>
 <82b74cbc-8a1d-6b6f-fa2f-5f120d958dad@sandeen.net>
 <20230711224911.yd3ns6qcrlepbptq@awork3.anarazel.de>
 <ZLeP8VwYuXGKYC/Z@dread.disaster.area>
 <20230719202917.qkgtvk43scl4rt2m@awork3.anarazel.de>
From:   Eric Sandeen <esandeen@redhat.com>
In-Reply-To: <20230719202917.qkgtvk43scl4rt2m@awork3.anarazel.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/19/23 3:29 PM, Andres Freund wrote:
> Somewhat tangential: I still would like a fallocate() option that actually
> zeroes out new extents (via "write zeroes", if supported), rather than just
> setting them up as unwritten extents. Nor for "data" files, but for
> WAL/journal files.

Like this?

fallocate(2):

    Zeroing file space
        Specifying  the  FALLOC_FL_ZERO_RANGE  flag  (available  since 
Linux 3.15) in mode zeros space in the byte range starting at offset and 
continuing for len bytes.

Under the covers, that uses efficient zeroing methods when available.

-Eric

