Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865E9C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 14:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B99961244
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 14:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhKEO6y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Nov 2021 10:58:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231140AbhKEO6x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Nov 2021 10:58:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636124173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1J1I5S2lDGsBNLKtr0NgjE/ChGyiz2i7OqGKseJWHq0=;
        b=DIvhKR9OzfLf49Q6xUiGpLq1vtbWd8gZpGWqr56IsR5hseDQJE5YrIc4oRpLZLwA6U0N/G
        20mykgG5rkwp5NkehftgTXpibLYKknu60Om3MEb/y3SmquCZT/ssB1LZK4FDF9+FlPt9kB
        mqGZmdEEll/STEFvDtkqnDZkveCSwvk=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-o8hxpSGlNE2YeM-R1I41UA-1; Fri, 05 Nov 2021 10:56:12 -0400
X-MC-Unique: o8hxpSGlNE2YeM-R1I41UA-1
Received: by mail-io1-f71.google.com with SMTP id k20-20020a5d97d4000000b005da6f3b7dc7so6438525ios.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Nov 2021 07:56:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=1J1I5S2lDGsBNLKtr0NgjE/ChGyiz2i7OqGKseJWHq0=;
        b=wT7si0Ui20e4+PM+/2wKCyqKDLHpnbK7z7OO0xyS2wDSVetYyOveLpjYfsDOw5KS6l
         togKk7rrUop5ivtqB6AhZZWep30qkIaL7H+0SbmTmBXLCboyYc7Fyj77FY5/tqPeePSR
         zcYIhAGk1H15Bd8ctX3WGIsHiQwsKtvC2fucQWDFJHw+8V+Y+Q1IxLZJOqEIE+9h1+hC
         JdQ/c65Z3oZBmaoq1JwqIxw03F4MmduXz36kfBXC9Fl5WerDH6du7XhJQPkxlh9b9/9J
         6j2qcdZfu6+3g+vTbNyD5K9SQAmgfriJKAcscohE8TuYDUZ0/KXtz0/xalqt6kILpNr4
         F3kQ==
X-Gm-Message-State: AOAM533htYELYf6Qw5vtE0hpCBv5cRPANMhbinJilIk7VymgVdVt6zHw
        gx1EmrBxJ/xR6KCWKR2RRMtdU9s1dPdtNEwKDgLpiHW5lClZ8fojl9EOG0n3Uj4T5AWkKEF3HmO
        mvaOR+Mos0bJFALQdKCN/
X-Received: by 2002:a92:d78a:: with SMTP id d10mr7215576iln.108.1636124171924;
        Fri, 05 Nov 2021 07:56:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDqKebw/ACBq6HVHk2ShqXxs0125EN6e1s5r+yGYf1SAI/EVOiEzX6/b5vGFp1jJ88frvjrQ==
X-Received: by 2002:a92:d78a:: with SMTP id d10mr7215553iln.108.1636124171689;
        Fri, 05 Nov 2021 07:56:11 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id e17sm4951491iow.18.2021.11.05.07.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 07:56:11 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <6af37cfb-1136-6d07-45a0-c0494b64b0d7@redhat.com>
Date:   Fri, 5 Nov 2021 09:56:10 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: XFS / xfs_repair - problem reading very large sparse files on
 very large filesystem
Content-Language: en-US
To:     Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
References: <20211104090915.GW32555@pcnci.linuxbox.cz>
 <39784566-4696-2391-a6f5-6891c2c7802b@sandeen.net>
 <20211105141343.GH32555@pcnci.linuxbox.cz>
 <20211105141719.GI32555@pcnci.linuxbox.cz>
In-Reply-To: <20211105141719.GI32555@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/5/21 9:17 AM, Nikola Ciprich wrote:
>>> I'm guessing they are horrifically fragmented? What does xfs_bmap tell you
>>> about the number of extents in one of these files?
>>
>> unfortunately, xfs_bmap blocks on this file too:
> 
> anyways, trying to run it on another similar file, which doesn't seem
> to suffer such problem (of 10TB size) shows 680657 allocation
> groups which I guess is not very good..
> 
> here's the output if it is of some use:
> 
> https://storage.linuxbox.cz/index.php/s/AyZGW5Xdfxg47f6

Just to be clear - I think Dave and I interpreted your original email slightly
differently.

Are these large files on the 1.5PB filesystem filesystem images themselves,
or some other type of file?

And - the repair you were running was against the 1.5PB filesystem?

(see also Dave's reply in this thread)

-Eric

