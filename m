Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED153B893C
	for <linux-xfs@vger.kernel.org>; Fri,  7 Aug 2026 07:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786088949; cv=none; b=MUrLAh60PYGDaFAfrZSwyy3XNZ4V6wMsvxQNt+PD7TjljO9+i3YZNCDULvAxMpvvIZbu8H4Lpuv+6mgKFScuA1Otk/CpSIEOcI7R9AVh+IJSUzPWuUy+6ApCpSvEpRtZAMu9GX4f0hBubx/DDCdG87BEcpjO/buVlODIRxe7NL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786088949; c=relaxed/simple;
	bh=qFAl9L2XJ76BW5cM9Bdtke4KwqFYXF74aj3UCx++9vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OXzukoz1twjNPyeTZCFfWXsWBpSi2tiE0DX1QDFugkvJGUM/TF4dke9EH0NrPf6fgIzK6kcKnrZQ7+55pf+89oi4wSSiIoc/cp50juvGvQDMhRkodYyedF+goFRv75K4khV+GIwWqRPT4D6Zo0peW28nsW1tr3Gwr1svCQvAKoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gliAOaaC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rqUvKuxV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gliAOaaC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rqUvKuxV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786088946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Cn3Pt6Cz41BB0ng4dLgJQ+cvpxzDsp5MGLSW2C/r2o=;
	b=gliAOaaCN4N2h7rqt2Lvb12DQB5WBr3IkKtaoi5kpwpZqKrKyfbjnzsuQM0Zm/eHVqOcro
	4zZLcymXyDfeYWYS+kipu2ALUEQ+V7rUBok9jkkWqNVBAQp67Xx64LN+7MKMGf5qS23noS
	XixumwBB3jGOYad8ewHFa9QZF734Gd0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-8J_-sle7Oj-wepCibC0rIw-1; Fri, 07 Aug 2026 03:49:03 -0400
X-MC-Unique: 8J_-sle7Oj-wepCibC0rIw-1
X-Mimecast-MFC-AGG-ID: 8J_-sle7Oj-wepCibC0rIw_1786088942
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d001671a54so58035845ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 07 Aug 2026 00:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786088942; x=1786693742; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4Cn3Pt6Cz41BB0ng4dLgJQ+cvpxzDsp5MGLSW2C/r2o=;
        b=rqUvKuxVrCmBhYy61BdM3wqT92MQshR4xAANl8vaLztguYglIrFDerUHSSJgyzU4qT
         PlE+GXHAIyG+2bOwpmh0y0h1J6+nPmUN5varoASxxhAdK40N/MJzTKc3bC8wVwTM6NMD
         HTIlXGXneLerTAv/Y+uPjOVUSe0XoaILqz2/KiSqTc3em5sr0GohDTS+6QX/sd70eITf
         1RK1CHIYgynmEkFAP2oUlNSWCdOU/RKpU+drj4npbtIUrQpq/pMFdF32lTrRsLXDwGhf
         kfJt8UhwZa4VK/iHCjT8thb4lVgHOILmsJ1ivaCuZG0c1TluXUNoBUWy/d8QiX4/TstK
         sijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786088942; x=1786693742;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4Cn3Pt6Cz41BB0ng4dLgJQ+cvpxzDsp5MGLSW2C/r2o=;
        b=rKjwVUZd7ADeXSCgAXTa7QQRq2lr2X5sUD/lGAhSwycizgzIB72JYH6L/41UyfRHoe
         TjUjI3c1k5c49My2QEO3fIqIHDF+9EqTDZd5ByePWUosGprK45OQLGLrEb6lY7PBfBQv
         jpgUgk4pYyZUUj51E5fyEuF4lnXwIp4mBQR/rKfA+jTh3vBIdOHago0qvx2s8QcUmmT+
         iiAFAT5AhlVWsJkpix/2F/i7LVpMsdKTyKPGXOxYwNaVFdLxOLTCie9iY1ZBxDNVGD/G
         uoNRKod1X/ywjxQygQjZSy8Tq2I+e48pJqixPv3JEanxjQVAbQQRE7gwzmeRq9kra1nv
         1bhQ==
X-Gm-Message-State: AOJu0YxjwT0ea+9+6B0QK2XnJRoaNg8H2IE9QOUqXEUoTzWTB2Szga9x
	xRaPwJXcYwsY9x9KRKLyeghcKHvJIa7nFdFmykxrGi3tDdHzHUGuo/I1qSfe2VsgQsJmVLKSmw6
	Hz0PJBq4oXQ0G5WTUqdQn8uKJHv7aDzOJRw7P8FRwPTjfLGMnEfNtlVtFdK/sd3AjBoy5tKRo+E
	Q9Aw7sYHsNdh91mtzgFqGtm6oU4zWjTsPM+R1HRnpLvE4Y/Q==
X-Gm-Gg: AR+sD10JaGKUlRLW74L/M1GJWvxrlUiYmh8XpI7QD5/9iMM3argHb69TYx2xeCKMqfK
	CTa7Nd73X2NFhO4STJ4786GahGEk7JECOmR7dHBiEAfC7fMeMoo66ZMeam6aFqB7knmQeSqDYrV
	/fRblE7zlxxD+Tgx8JzSIImRWtVtcalJ7BmNrmZ60GmX5K8vPX4wR2mhVzU3KsxMWxo9yH34kYH
	cyLxPFAjNzQE4VdB73Dm5Ua27ldpMA61LKoIRyb9jSxcs/jwH9tIkRSoJXOjb1Wqo0BvTA3FOOB
	gNje7PyRGSo+4YQtovqPAnRvBMreBpqF6GDrb6MzqRS5zGn3idJrjBRMxqYKmTFp7tSnCNibr+u
	aA7OSUCd2iX4d+oJA0fyqCMdPIfQLa1Xjf4EJ5r/5RPzFF2Q=
X-Received: by 2002:a17:90b:4d84:b0:381:5bd6:eb19 with SMTP id 98e67ed59e1d1-3903c5dfd9amr19664249a91.18.1786088941937;
        Fri, 07 Aug 2026 00:49:01 -0700 (PDT)
X-Received: by 2002:a17:90b:4d84:b0:381:5bd6:eb19 with SMTP id 98e67ed59e1d1-3903c5dfd9amr19664215a91.18.1786088941259;
        Fri, 07 Aug 2026 00:49:01 -0700 (PDT)
Received: from ?IPV6:2001:8003:4b1b:d900:266e:8be8:569:ffa6? ([2001:8003:4b1b:d900:266e:8be8:569:ffa6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3925ff6658bsm1425135a91.14.2026.08.07.00.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 00:49:00 -0700 (PDT)
Message-ID: <304f1600-70ef-411e-b56c-5b91102ba343@redhat.com>
Date: Fri, 7 Aug 2026 17:48:57 +1000
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
Content-Language: en-US, en-AU
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <amiGzsz0KuUrV29o@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/7/26 20:39, Zorro Lang wrote:
> On Thu, Jul 23, 2026 at 04:26:17PM +1000, Donald Douwsma wrote:
>> Regression test for cumulative restores where a directory has been
>> renamed outside of the subtree being restored triggering the assert:
>>
>>   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>> ---
>> Changes since v1
>> - Fix use of _do, including label quoting
>> - Update test output
>> - Add tests for additional edge cases
>> ---
>>  tests/xfs/995     | 58 +++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/995.out |  8 +++++++
>>  2 files changed, 66 insertions(+)
>>  create mode 100755 tests/xfs/995
>>  create mode 100644 tests/xfs/995.out
>>
>> diff --git a/tests/xfs/995 b/tests/xfs/995
>> new file mode 100755
>> index 000000000..bba0bcd52
>> --- /dev/null
>> +++ b/tests/xfs/995
>> @@ -0,0 +1,58 @@
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
>> +_do_die_on_error="always"
> 
> I think this line is useless now, right? I'll remove it.
> 

Yes, thanks.

I did have a general question about how _do_die_on_error is used

$ git grep _do_die_on_error
common/rc:# second argument. If the command fails and the variable _do_die_on_error
common/rc:# is set to "always" or the two argument form is used and _do_die_on_error
common/rc:      && [ "$_do_die_on_error" = "always" \
common/rc:          -o \( $# -eq 2 -a "$_do_die_on_error" = "message_only" \) ]
tests/generic/017:_do_die_on_error=y
tests/generic/053:_do_die_on_error=y
tests/xfs/041:_do_die_on_error=message_only
tests/xfs/042:_do_die_on_error=message_only
tests/xfs/596:_do_die_on_error=message_only
tests/xfs/635:_do_die_on_error=message_only

_do_die_on_error=y doesn't seem valid.

generic/017 doesn't use _do, and I think generic/053 wants _do_die_on_error=always

Thoughts?

Don



