Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7722A32B115
	for <linux-xfs@vger.kernel.org>; Thu, 21 May 2026 03:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779335604; cv=none; b=pr/i+kZ65kU0oBzSqttoM8y8FBH7nUYkOw/6oSNDA05dVapTMj7tN/cddQVlmeIpdW2xcEHvYRrwWj/HI9b9ferU3X/TQj4NXLQneV0dQornq7cwEif104GO7+UBhv1RavYB/VZB9IkMJOHgl+IJ8SFs/cPBTzAs3MQX74QHQok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779335604; c=relaxed/simple;
	bh=eok54mhCucuigz/kkExUggB/hcLzC5H+qAC9NqM0TWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PthEryh1xsIp4w0Wdunv9Q0Gw7SR8mc51y82H5ofTUe8okO6h+03yAhUNiTsoJqqdpEDf9fLzOtAGr3CsqXm6j3Z6IIE+oxGadWWYi/NDZ3zm6a04iYaykwX3PosLHdtNN9MgOCcyCQTDdKEr04JBy5TpeATBIhwCfCgRj+pjus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eL+2L3zW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=X4Tc+Vin; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eL+2L3zW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4Tc+Vin"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779335599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GCau9b/qRv6sn0ASGLiE3kHwpQdsZ+lHvqgPOEmWsVI=;
	b=eL+2L3zWGR/DkO98TF43vFmJM1oNYWGD78NcYyOjmrYixtMXWYYum8TQ3D/wVJILPfnxhN
	iyO9b1TySpxZKnUh6+XnF8IeHkvKBdBhB9JzrAP4MKlr3LR/xXCtjyAJvs7ZLn5MVL/YTW
	8TQCgmut2QcmFPS6FPDN2mvGcHuQGcU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-rD9aYX9NPfuo5f9RpMrN_A-1; Wed, 20 May 2026 23:53:12 -0400
X-MC-Unique: rD9aYX9NPfuo5f9RpMrN_A-1
X-Mimecast-MFC-AGG-ID: rD9aYX9NPfuo5f9RpMrN_A_1779335590
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3662990c03fso4770436a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2026 20:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779335590; x=1779940390; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GCau9b/qRv6sn0ASGLiE3kHwpQdsZ+lHvqgPOEmWsVI=;
        b=X4Tc+VinEJCWkAcQqXOz9kZKpQ2uQe16SGW3ba1TSKrAFdP9bmMWQGtDjDIWIzmJ8N
         927UfiT8p28KczeMN/SnqaKa1rGVKHCAPwAxXfEHVyzszl74b6aOxd3I5nCnYKmPmMeC
         7Z7lzJ/JH5EqQsVVaPPC4zUao+8wIjY5F0CkMligoXYSbMiAeWl88bKSCHza7ySjDjes
         nic5QcscPqNu76DG87O4JMD2wA7DRt5q11TNUN6T9x5YMlRokuLo9ILGjzAf05LrHMoH
         hDqUpF4gXV23mSq+d1ukrIaAwJaMXboXRCtjvlz3tIf1mQYWmOiBSaDSKxeP0D6IJ3m1
         WLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779335590; x=1779940390;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GCau9b/qRv6sn0ASGLiE3kHwpQdsZ+lHvqgPOEmWsVI=;
        b=IdLVLu47egUTB76OTtpJXwdBqn18s98o/JkzbcKaee28g6/BCwNub0GorbzwzOmWRO
         vhMccY6/bVAUK+/PNlVR4FOE6xr3M97yzoS975PfX3T/1F5RWj//VXqxw20ogAKI2nSm
         oRADojKRNA4M3CkUbhj1jXlXoYOc+BFYD8wHKK2+jn5e/Ji60tQs9/QG22aRc2i90TND
         07FFVdB2llJckOt+ulgnMOz9I2roXZQkzCj/gRixVY3ClzJaZh2QQ8LTI4whWi8u/63x
         j5HH4Smfci3LcgkIHz4a4Yi63Kw+TGK8+TqZTTpcORj2g5u51FGyh6yB4yNh00jeNBlZ
         ibEA==
X-Forwarded-Encrypted: i=1; AFNElJ8e7aZFm5ksGLEAo5L381EEDuzfngNO2XbuuDxWDlnidSAO0V5YbsibGL6oSLKP+Mf0xqoA82HgSeU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcPbXRHaN7b0KNmy3bDp0XmvA0e3WyHYO69zu3RD/bM020Cctv
	iv6nBMqyv5QrvNRr+/qeL8xXT1n3mjSkf4Wlr373Mxypyq4kd74nNFi8NQ49TkuOaAFKRGAPPwL
	PXVblGfYA9M+N8VWWSsHOW5j3UO+b/ZQzzuuYz53oLfu9YcKXg6MvrtTsU2nOfTQfG7NwfA==
X-Gm-Gg: Acq92OFJlG3wm1YfLj6iFnZWsxjcikkkr5CKHB4vMSg+kF9VagHwBtqm4rMNZbxa3zB
	4V5umMbmhBWIrbJPDk8YvxxsiTdThTx83Kmx810LuEfXDDqZbYFZ7VB38IdX2VGNHIVmW2p2a0j
	HMqHBT4l2hL+b3WfCoklRMeYxQmyWFRycxAGbzFBEs9fQbaiqnlIfeHF9wCgrE7VepIZxgxwNZe
	pubkwvEJE2DMKbfj5DrL0CDXG5H88kvmMHWE0pFN5JLu7ohWe8/IqkDK2Tb+1dYOnl7QjkZqO6m
	1FuafEH3UqHrC0afxkm0K/TpurM6FDxxTkzVDaD1E/8bc2xpnh4knNNWdD+DmKDD7GtK4+RAoaH
	uK3SuTkWK2h7tAt6nwhHhLfA0A6JEiNmX0IFEIFUvo5gw+amnXzH+0f99HY+Wr0hNfbAgfrw=
X-Received: by 2002:a17:90b:48:b0:369:7944:d723 with SMTP id 98e67ed59e1d1-36a48e237c0mr845135a91.4.1779335589861;
        Wed, 20 May 2026 20:53:09 -0700 (PDT)
X-Received: by 2002:a17:90b:48:b0:369:7944:d723 with SMTP id 98e67ed59e1d1-36a48e237c0mr845107a91.4.1779335589362;
        Wed, 20 May 2026 20:53:09 -0700 (PDT)
Received: from ?IPV6:2001:8003:4a36:e700:56b6:ee78:9da2:b58f? ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a46c1ed73sm294477a91.3.2026.05.20.20.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 20:53:08 -0700 (PDT)
Message-ID: <22768917-d555-44fb-a757-8cd88a6e8553@redhat.com>
Date: Thu, 21 May 2026 13:53:05 +1000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: test xfsdump subtree restores
To: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260326025443.1569874-1-ddouwsma@redhat.com>
 <20260326030012.1571545-1-ddouwsma@redhat.com>
 <afy-9iJYNqDdXgml@zlang-mailbox>
Content-Language: en-US, en-AU
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <afy-9iJYNqDdXgml@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

G'day Zorro,

On 8/5/26 02:59, Zorro Lang wrote:
> On Thu, Mar 26, 2026 at 02:00:12PM +1100, Donald Douwsma wrote:
>> Regression test for cumulative restores where a directory has been
>> renamed outside of the subtree being restored triggering the assert:
>>
>>   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>> ---
>>  tests/xfs/995     | 51 +++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/995.out |  2 ++
>>  2 files changed, 53 insertions(+)
>>  create mode 100755 tests/xfs/995
>>  create mode 100644 tests/xfs/995.out
>>
>> diff --git a/tests/xfs/995 b/tests/xfs/995
>> new file mode 100755
>> index 00000000..54172572
>> --- /dev/null
>> +++ b/tests/xfs/995
>> @@ -0,0 +1,51 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Red Hat.  All Rights Reserved.
>> +#
>> +# FS QA Test 995
>> +#
>> +# Regression test for cumulative restores where a directory has been
>> +# renamed outside of the subtree being restored resulting in
>> +#
>> +#   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto dump
>> +
>> +_fixed_by_git_commit xfsdump XXXXXXX \
>> +	"xfsrestore: only process subtrees that are selected"
>> +
>> +# Override the default cleanup function.
>> +_cleanup()
>> +{
>> +	_cleanup_dump
>> +	cd /
>> +	rm -r -f $tmp.*
>> +}
>> +
>> +# Import common functions.
>> +. ./common/dump
>> +
>> +# Modify as appropriate.
>> +_require_scratch
>> +_scratch_mkfs_xfs >>$seqres.full
>> +_scratch_mount
>> +
>> +mkdir -p $SCRATCH_MNT/a/b/c/d/e/f/g
>> +mkdir -p $SCRATCH_MNT/restore_me/B/C/D/E/F/G
>> +
>> +_do "$XFSDUMP_PROG -L "lab_l0" -M "test" -l0 -f $tmp.dump.l0 $SCRATCH_MNT"
>> +
>> +mv $SCRATCH_MNT/a/b/c $SCRATCH_MNT/1
>> +
>> +_do "$XFSDUMP_PROG -L "lab_l2" -M "test" -l2 -f $tmp.dump.l2 $SCRATCH_MNT"
>> +
>> +dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
>> +_do "$XFSRESTORE_PROG -f $tmp.dump.l0 -r -s restore_me $dir"
>> +_do "$XFSRESTORE_PROG -f $tmp.dump.l2 -r $dir"
> 
> Hi Donald,
> 
> I almost forgot we had this _do helper :)
> 
> I think your test target is the 2nd xfsrestore command line (about incremental
> changes), a comment might be good.

Ack

> I saw used four _do calls here. I just checked the logic of the _do helper, I
> suspect your current usage might prevent the test from catching command failures,
> allowing it to 'successfully' continue...

*sigh* thanks for pointing this out, I switched to using _do for the ease of
redirecting to seqres.full. I found having the full output available was useful
when investigating (coupled with adding -v tree=debug).

I couldn't figure out why my failing test started succeeding even though it aborted,
which is why i added the test.

The second two are a duplicate, earlier I had a bunch more cases, including
restoring without -s, and restoring the l2 dump on its own, must have fumbled a 
cut-n-pasta, I'll revise to cover these edge cases.

> A simple fix would be adding a "note" as a first argument to each _do helper call,
> e.g:
>   _do "Full dump" "$XFSDUMP_PROG ..."

> Once all four calls are updated this way, we can remove the "test $? -ne 0 && exit"
> lines too, and rely on golden image matching to detect any failures. What do you
> think?

Once i fix _do the coredump control may start working again, in which case we'd see
a failure with "[dumped core]".

Don

> 
>> +
>> +test $? -ne 0 && exit
>> +
>> +echo Silence is golden
>> +# success, all done
>> +_exit 0
>> diff --git a/tests/xfs/995.out b/tests/xfs/995.out
>> new file mode 100644
>> index 00000000..776fa6f2
>> --- /dev/null
>> +++ b/tests/xfs/995.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 995
>> +Silence is golden
>> -- 
>> 2.47.3
>>
>>

