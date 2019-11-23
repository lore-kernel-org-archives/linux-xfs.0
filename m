Return-Path: <SRS0=qbJ3=ZP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60680C432C0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Nov 2019 18:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 350AB2067D
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Nov 2019 18:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mqrJ0NRm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfKWSMZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Nov 2019 13:12:25 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41485 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfKWSMZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Nov 2019 13:12:25 -0500
Received: by mail-pg1-f195.google.com with SMTP id 207so5025480pge.8
        for <linux-xfs@vger.kernel.org>; Sat, 23 Nov 2019 10:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fsMFIiqX55DoBmpazW+9ohix9+cT6hcqtIMlCRaFEuc=;
        b=mqrJ0NRmaqCSvKsyvpUPRDxLhxwlC7otA8XRawynQQA2QZQl1TPkuUCJ1nIyCs61om
         2L3/OOFOJYefA0OVy3rUdw4eUlNoyfxdJRz7SNUNrvlAPkTbT0qnftjLJkW7DqnSgQf3
         XA0tV3KafXgae0G7FzKDUNtD3ZJtOA/w7U5d8uvm+c0GFZ24xrjeDa+75Go/MZMac6xY
         v1nWx2KOdkeIm/J2rX0kuc5Y5NB/jLol6nsWdeqMBpwvZ2NjOUY9LlubLJwbqudZS87H
         fY8/e3EWEK22wbPkT9Mfwu7J5OPeKDqHJyIRNYHpxWAL4XAEw9QrwAw5iivSITJO7QsH
         /wvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fsMFIiqX55DoBmpazW+9ohix9+cT6hcqtIMlCRaFEuc=;
        b=HomCokM0e3iiOzFz2yoLvzZkb+73g7aVQCb/BIxwqDRVYqNQZ1XaNGXVMKvLI8H16Y
         sZzUTL7ybSybKCLUVq7OFyXzdb1YoQ4m6MBiCNgD6fv1PdjsLquSu5ozxCe9xU8oHP8d
         RnMEwuUQ0FE+/7a+TGa+7XMYefZmXszCrQdNq69YXa5jHedHqtr0DydMSJOYPbBjG0Ej
         XmrnHW0I40UlIyXAXodmKhFw/Cy7fdpwXY2bdPEHg0JLMjcWYAZuJqDhn3c1/S8t1Gz2
         Gt6uObS+3aOHXjI8rRy4oxLZb4mvWHUUQuAipVhw2hXwZoC+3twPo5GA1Iy3LOAcE0RC
         m0Dw==
X-Gm-Message-State: APjAAAVvJtsmqzqoYkGIlocVJ382DViEIBStsGh8SBhXaDVNYQhwAekY
        1uTwdPRkd2EKhJchyS0URgwmHfIW
X-Google-Smtp-Source: APXvYqzPJ6U0uhWT0fdDrjN3eSvTWFsRQPfNafec8nJakXmfDiyooHkf/ApcRWxXsBDBsWifcDT25A==
X-Received: by 2002:a63:d854:: with SMTP id k20mr23343258pgj.305.1574532742337;
        Sat, 23 Nov 2019 10:12:22 -0800 (PST)
Received: from [192.168.1.74] (cm-58-10-155-5.revip7.asianet.co.th. [58.10.155.5])
        by smtp.gmail.com with ESMTPSA id a23sm2792985pjv.26.2019.11.23.10.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 10:12:21 -0800 (PST)
To:     Chris Murphy <lists@colorremedies.com>
Cc:     xfs list <linux-xfs@vger.kernel.org>
References: <a3ab6c1b-1a69-5926-706f-1976b20d38a8@gmail.com>
 <CAJCQCtSXhX8VFYwp9j7RXD3_CHPMC83D6W-mCS80byxmor1PCg@mail.gmail.com>
From:   Pedro Ribeiro <pedrib@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=pedrib@gmail.com; prefer-encrypt=mutual; keydata=
 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
Subject: Re: Bug when mounting XFS with external SATA drives in USB enclosures
Message-ID: <192321f0-f79d-8b2d-4bfc-9316ae6fa2e6@gmail.com>
Date:   Sun, 24 Nov 2019 01:12:18 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSXhX8VFYwp9j7RXD3_CHPMC83D6W-mCS80byxmor1PCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 23/11/2019 23:56, Chris Murphy wrote:
> 
> What about checking for differences in kernel messages between the
> stripped down and stocked kernel, during device discovery. That is
> connect no drives, boot the stripped kernel with the problem, connect
> one of the problem USB devices, record the kernel messages that
> result. Repeat that with the stock Debian kernel that doesn't exhibit
> the bug.

I'm not sure if you received it in the first email, but I have a zipfile
with the dmesg output of both the Debian config and my own config, as
well as the configs themselves.

If for some reason the mailing list didn't process the attachment, you
can download it from here:
https://gofile.io/?c=6TaB3p

Not sure if there a way to enable more verbose output?

> 
> My guess is this is some obscure USB related bug. There are a ton of
> bugs with USB enclosure firmware, controllers, and drivers.
> 

Possibly, although it affects 3 different enclosures, so it should not
be something enclosure specific, but affect a common layer.


> Also, is this USB enclosure directly connected to the computer? Or to
> a powered hub? I have inordinate problems with USB enclosures directly
> connected to an Intel NUC, but when connected to a Dyconn USB hub with
> external power source, the problems all go away. And my understanding
> is the hub doesn't just act like a repeater. It pretty much rewrites
> the entire stream. So there's something screwy going on either with
> the Intel controller I have, or the USB-SATA bridge chip, that causes
> confusing that the hub eliminates.

All connected directly to the computer, two via USB-3, one via USB-C,
same errors.


> 
