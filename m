Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EFE41F5D8
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 09:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786441043; cv=none; b=Mf6oUE+czAXGfjRRtekv1ptMqfx+mqywY5cZRaA4BOTKtrC84lZ+zCkaaQEUgneENps2BcW+Dz1M/PHTJbnxg6R/75T9WA3ZjRITf81ILcbhFdF1TxZ/Q8LLcNkTrqwlrI3VQlzhqV/N59eKCQXKhgsTvfbAbVT7nPfFblRN1b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786441043; c=relaxed/simple;
	bh=pSU8IVvIAGUIpIyPumbuygT7X+2azLg+hx292XwNZvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CLne/DiiTUu1OkTkq33XBaA/xS1hoyRzK/MsN7zEEs63IeV1FqhcSyun4nhpB7ox4sK/Y+8omk9pTD/bbb73ZmCRXEfr1roUXEhEGhYhyEDvrMIG+PmcUAdekhnPRy7r0GIJql5C0RooNp2NYWMc6xrAd4cjjGbTohlHmBJfpKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C1U/pDgJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y1MD5Bt6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C1U/pDgJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y1MD5Bt6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786441040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LpW8KWPyTUIOA0wK2hepkgobhoX/ETbRtiM8mwMxVqM=;
	b=C1U/pDgJ0t9+Xu/B1wWb0jFQ+CBaW6+V+LUNyymOz63vwpqg+EtFAeQG2mgmHiR808qLDs
	1wrHzHGmLasifh5yiYIJBI4Eb3g7ktvbkyM5OB7bBJq4h7+6XQzDXYBQ+ddNVqib6HwWPX
	6RNSnnVo/z+B2LMbrxHAgDb7ehRza+0=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-rjIIaY-OOMOJ4V3feU7WEA-1; Tue, 11 Aug 2026 05:37:19 -0400
X-MC-Unique: rjIIaY-OOMOJ4V3feU7WEA-1
X-Mimecast-MFC-AGG-ID: rjIIaY-OOMOJ4V3feU7WEA_1786441038
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8488ac68185so7627503b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 02:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786441038; x=1787045838; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LpW8KWPyTUIOA0wK2hepkgobhoX/ETbRtiM8mwMxVqM=;
        b=Y1MD5Bt64hh+zci9+X79V4zKYnVfTZoz7wp1IyYgA1CNX7/NTfodhEjEH+6acEbfJC
         Tm6FUgZeUa5uugkofmp4QbSavPKWUOOyS28jZvOmUMKzTzB7/82r9SUM0EAuYYzI3W4C
         tzlDbmeikc2hwv1TYs7G8aPnnLZv4FYXQuRREhLMTIVlq1hjwLFqxjVIUfNPzr7rj80f
         WXcS+Y9b54tjUGjvV4hKL8teqo+AzorV3W8hbkLmEm3fCiHcl+ppMiglc4oUtG90r1S6
         mp3bfc9nG7z1n2j4fdFq/neRipfn28guV0klSIC9PQWvEMQYeRd7Itgoj9Lp6stm8dst
         /HKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786441038; x=1787045838;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LpW8KWPyTUIOA0wK2hepkgobhoX/ETbRtiM8mwMxVqM=;
        b=JaY5J1xKtd6haRFA7Yss/YKf0gqgL65reypRm/rgHOfC9aLVKMB1G1UqNdCn5VIGVa
         ZJdlbsiEmNSSW/RZ3fRv9mqy5tgRIL0P3TmSSA0Yci5SGH/FkQpymQDr5gOW697HsJ7j
         xy+zQdzTofrSHm+u3mJPN8IyG1P/7lrm06oLRtxEvK3RNusEtm6gjxzZhrWUSk0we3rF
         BDRr6T9uJ5uSYD5UG/iT+aNnTKp4vkr6mFxdcxIe6/Z1GCb4WPKN2A/icbh9sc8N4RVM
         Mbvba8zZSTw76cdwoPDTU7jY2OdTNbGmwYxVgC0QnoqwUthQiiAcyYPnGto/znhd7XtC
         OFHQ==
X-Gm-Message-State: AOJu0Yw9yiO1j/0h5kHbbr8zgHmeq277iEShWtAfuTV0a0GsZh+qB4a4
	yaIyPYc1GDKhzNE3E5ujjyCfM1m7YhoSAAf5jviAFjwjOQ1Z9YoEIFQfKRg72hSiXCv0jLjDh9g
	xW7uK6WxnJpdQfIZxaptJCXa6d+5wwUg5sUssyqcQA75m1CaGWc1OLQgf+usRUNNX/jXekT1ms/
	F65uWILJaUPHk97Kh9ud25eFPHwU7FdtHmWmn5K6+AdoegKg==
X-Gm-Gg: AR+sD10FXfp3mfg4UqTVZbyVhzt8oVNTWmYRgs8Wutwy+voOB8qFqAj1STPFe51Qvwl
	W9Xsz7mRFo8batyD+NqyL9iR0H6/lf3TZioxdsZbiEEQAH0VRNuqHteUTTo2AXRkavO6E4qB76p
	GAJDcsDZir9gO3Tm5fYuvqKvRP0bxexkWXWjOY2Z+nXFTBb59bfczyA6MUMlxqt2BOS+JqIRQa5
	5a/dDJK3Uik+MVpOaZ1xN4HifR2sIiCuXgtqnCPwwx704cHhhsf27UVso3vI3hLty771UvuZSAU
	xvCvEtxjvSrzM/Kk8GSXLlsdlOf1BTxqi4wPYymO6AYX06mqmj3F7EKm/IhYxbxa15cXFnAR7nl
	kmoea+bAFPBgxqCaTuoclQyT6AXuzMYG9VLK3pAts0JGnT7M=
X-Received: by 2002:a05:6a00:3407:b0:845:dbdc:8652 with SMTP id d2e1a72fcca58-84fa867ac70mr2046690b3a.2.1786441038226;
        Tue, 11 Aug 2026 02:37:18 -0700 (PDT)
X-Received: by 2002:a05:6a00:3407:b0:845:dbdc:8652 with SMTP id d2e1a72fcca58-84fa867ac70mr2046636b3a.2.1786441037644;
        Tue, 11 Aug 2026 02:37:17 -0700 (PDT)
Received: from ?IPV6:2001:8003:4b1b:d900:266e:8be8:569:ffa6? ([2001:8003:4b1b:d900:266e:8be8:569:ffa6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84fa9194b49sm437249b3a.1.2026.08.11.02.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 02:37:17 -0700 (PDT)
Message-ID: <edec7e4c-b7c7-44d0-8910-d2e022237c3f@redhat.com>
Date: Tue, 11 Aug 2026 19:37:14 +1000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: test xfsdump subtree restores
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20260723062617.424905-1-ddouwsma@redhat.com>
 <amiGzsz0KuUrV29o@zlang-mailbox>
 <304f1600-70ef-411e-b56c-5b91102ba343@redhat.com>
 <anot8-MiesDW5iqo@zlang-mailbox>
Content-Language: en-US, en-AU
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <anot8-MiesDW5iqo@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/8/26 06:12, Zorro Lang wrote:
> On Fri, Aug 07, 2026 at 05:48:57PM +1000, Donald Douwsma wrote:
>> On 28/7/26 20:39, Zorro Lang wrote:
>>> On Thu, Jul 23, 2026 at 04:26:17PM +1000, Donald Douwsma wrote:
>>>> Regression test for cumulative restores where a directory has been
>>>> renamed outside of the subtree being restored triggering the assert:
>>>>
>>>>   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
>>>>
>>>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>>>> ---
>>>> Changes since v1
>>>> - Fix use of _do, including label quoting
>>>> - Update test output
>>>> - Add tests for additional edge cases
>>>> ---
>>>>  tests/xfs/995     | 58 +++++++++++++++++++++++++++++++++++++++++++++++
>>>>  tests/xfs/995.out |  8 +++++++
>>>>  2 files changed, 66 insertions(+)
>>>>  create mode 100755 tests/xfs/995
>>>>  create mode 100644 tests/xfs/995.out
>>>>
>>>> diff --git a/tests/xfs/995 b/tests/xfs/995
>>>> new file mode 100755
>>>> index 000000000..bba0bcd52
>>>> --- /dev/null
>>>> +++ b/tests/xfs/995
>>>> @@ -0,0 +1,58 @@
>>>> +#! /bin/bash
>>>> +# SPDX-License-Identifier: GPL-2.0
>>>> +# Copyright (c) 2026 Red Hat.  All Rights Reserved.
>>>> +#
>>>> +# FS QA Test 995
>>>> +#
>>>> +# Regression test for cumulative restores where a directory has been
>>>> +# renamed outside of the subtree being restored resulting in
>>>> +#
>>>> +#   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
>>>> +#
>>>> +. ./common/preamble
>>>> +_begin_fstest auto dump
>>>> +_do_die_on_error="always"
>>>
>>> I think this line is useless now, right? I'll remove it.
>>>
>>
>> Yes, thanks.
>>
>> I did have a general question about how _do_die_on_error is used
>>
>> $ git grep _do_die_on_error
>> common/rc:# second argument. If the command fails and the variable _do_die_on_error
>> common/rc:# is set to "always" or the two argument form is used and _do_die_on_error
>> common/rc:      && [ "$_do_die_on_error" = "always" \
>> common/rc:          -o \( $# -eq 2 -a "$_do_die_on_error" = "message_only" \) ]
> 
> Oh, my bad. I confused this parameter with the "enable_error" parameter you
> tried to introduce in your previous patch.

You mean the attr one that ended up as tests/xfs/649"
lol, no. Though that was helpful when creating/debugging a test that panics a box.

> Since this variable is used by the current _do helper, setting it to "always" or
> "message_only" here is good. I will keep this line.

Cool, I think i added _do_die_on_error when working on the v2 because I was testing
it on an older xfstests where the coredump functionality wasn't available.

The v1 of this test only had a 'Silence is Golden', so the test would pass which was
really confusing, I fixed that by adding a better 995.out, so this should work with
or without it now.

> 
>> tests/generic/017:_do_die_on_error=y
>> tests/generic/053:_do_die_on_error=y
>> tests/xfs/041:_do_die_on_error=message_only
>> tests/xfs/042:_do_die_on_error=message_only
>> tests/xfs/596:_do_die_on_error=message_only
>> tests/xfs/635:_do_die_on_error=message_only
>>
>> _do_die_on_error=y doesn't seem valid.
> 
> I think you're right, "y" isn't valid. The _do() helper is quite old and rarely used.
> If you have any optimization suggestions, feel free to send a patch to improve it.
> For this patch, I'll merge your current version directly.

I'll have a think about that, it seemed handy for this test, but I don't understand
how the other tests use it.

Cheers,
Don

>> generic/017 doesn't use _do, and I think generic/053 wants _do_die_on_error=always
> 
>>
>> Thoughts?
>>
>> Don
>>

