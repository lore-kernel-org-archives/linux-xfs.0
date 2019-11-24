Return-Path: <SRS0=28RO=ZQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEF5C432C0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Nov 2019 06:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C24402071A
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Nov 2019 06:49:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UL0KLda/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbfKXGt7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Nov 2019 01:49:59 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:44903 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfKXGt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Nov 2019 01:49:59 -0500
Received: by mail-pg1-f172.google.com with SMTP id e6so5473522pgi.11
        for <linux-xfs@vger.kernel.org>; Sat, 23 Nov 2019 22:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bLezfcCa0O26vAzYpJk/l1NJtBapIaymODi4MyOkfFU=;
        b=UL0KLda/5nxBzhVFUiawKDDpLwTyJmVcE6xV8DNx4DLMqE9kvPNQsjZYEHzQMIZx2A
         8pB6d+KQZrUzp65vaoNxV9w3IYQx+c+XJRwXO43NtpQzVe+c+nlDgs5f4PLPbYHmKuLf
         WiqVG+B2odTheJJ8GP6kBpnAips69esUIVywjoTZadJz56MNSEl+Fyln4HFvfOpxuoEK
         b5YdaLLyLILTwJ7HNtz6/fZ3ED0CFnRrP8PXBNUCf84OvNJTMU+gpTCI0u3mOxfqocRk
         mq2ZHI+AC7X9pDTQIBKFLJqwjjTgJMWJZi/9z4VVwxkOePPEwnJh7SQaQ+IquDuPOc3F
         f+bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bLezfcCa0O26vAzYpJk/l1NJtBapIaymODi4MyOkfFU=;
        b=sXyY4KnuRwDT19DCeKITP5ZcjjTJM7028BQm63zXZZVzompRFT32IvCGuRiv7Zwl/C
         x43P/rqfNlyyjqDQ0hKguolsZmNSZAZaIY0CoymxjyawBQ3+Ml7YWurpTLbkRhCp6C8n
         Cybn1XXLj3rM4KLTEQWXBl2x6vawVngz68gCG+XkrIUbxhFNTpGilL2pPHZugzXLYSXU
         uQemoqsYwtPHEuuMuVpCGcvXZXLk5XrFsiXiNJYCmEKrw3jzaBuRU+azsabZxCm1Z9sm
         RTYMhlQjqE+NpyjGaCsExtk5wkQoJnTPtEALgtALw3rf8tvcUYL2hHM7d4nf0NVYoVha
         zj9Q==
X-Gm-Message-State: APjAAAWagGDWIHZjEAudHWWbahvEDezPF9/vTBLwDfXoY/PjZHxjQud0
        ABgbUBjbaqUZ7GD7k09Wayj9T8aw
X-Google-Smtp-Source: APXvYqwP8UWtaP56YxXH/Xgp6QmmNRQ/7UdDuBKnlpEPT3lVm3k/5RjObWK2t4giKMO9cEmb6ct4+A==
X-Received: by 2002:a62:b60c:: with SMTP id j12mr5973342pff.8.1574578197388;
        Sat, 23 Nov 2019 22:49:57 -0800 (PST)
Received: from [192.168.1.74] (cm-58-10-155-5.revip7.asianet.co.th. [58.10.155.5])
        by smtp.gmail.com with ESMTPSA id hi2sm3559613pjb.22.2019.11.23.22.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 22:49:56 -0800 (PST)
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
References: <a3ab6c1b-1a69-5926-706f-1976b20d38a8@gmail.com>
 <2543ac40-63ba-7a33-8ec5-2ef0797c6cc6@sandeen.net>
From:   Pedro Ribeiro <pedrib@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=pedrib@gmail.com; prefer-encrypt=mutual; keydata=
 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
Subject: Re: Bug when mounting XFS with external SATA drives in USB enclosures
Message-ID: <4728bdc7-3f6e-9abf-34a5-712156c40db3@gmail.com>
Date:   Sun, 24 Nov 2019 13:49:53 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <2543ac40-63ba-7a33-8ec5-2ef0797c6cc6@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 24/11/2019 01:26, Eric Sandeen wrote:

> I haven't looked very closely at your config deltas for what might change
> alignment but it'd be worth giving:
> 
> f8f9ee479439 xfs: add kmem_alloc_io()
> d916275aa4dd xfs: get allocation alignment from the buftarg
> 0ad95687c3ad xfs: add kmem allocation trace points
> 
> a try.
> 
> -Eric

Hi Eric,

That did the trick. Took me some time to resolve the rejects, but now
5.3.11 and 5.3.12 work like a charm.

While trying to track down the patches, I found your reply here:
https://bugzilla.redhat.com/show_bug.cgi?id=1762596

I ended up applying:
f8f9ee479439 xfs: add kmem_alloc_io()
d916275aa4dd xfs: get allocation alignment from the buftarg
0ad95687c3ad xfs: add kmem allocation trace points

And I don't know why at the time (I was sleepy), I ended up applying
this one too:
xfs: assure zeroed memory buffers for certain kmem allocations

I had to remove the second argument to kmem_alloc_io when applying this
last one, as kmem_alloc_io had two arguments in the 5.3.12 tree + those
3 patches above, instead of three arguments in the actual patch:
return kmem_alloc_io(BBTOB(nbblks), align_mask, KM_MAYFAIL | KM_ZERO);
return kmem_alloc_io(BBTOB(nbblks), KM_MAYFAIL | KM_ZERO);

Do you think it's safe to keep these 4 patches on top of the 5.3.12
tree? So far it all looks fine, filesystems mount and work fine.

Regards,
Pedro
