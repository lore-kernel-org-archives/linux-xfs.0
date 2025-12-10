Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F8B29AB15
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 22:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765407201; cv=none; b=dvr21SICEHXVNXtPpiFtOACR3qVHeAX9UXsZqSvbOQ5nJsR+zDW10cEIyV4EU9kKT0tCn3o5hEo37keoPjSQ3MZUBwJ6ByUFwVJNlK7gnWcVVnGyuyMkLRD/F39Bw8XfkBtb0tzohm/wHUZ4tuqiNUVIQ93rFfOIUS5EiVdv860=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765407201; c=relaxed/simple;
	bh=6W5fEx3HYAcf4LwhsT3SIuekkgS1NLwCtO9aO0mDvQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VKK/N2VWWb1O9usJUSArgbyGBk23tUGyoUyyj4M8CIUhg+qpwrhDJEuFnumtoXbrQ+0Yc942btsg8ZduuppuEMfx/clz2QOGtB2eBbIGDXVyLu4a1oQlb+7cKPbxzCiYpLYdt5XNJRlCNr2xO7w2h+8U+1nvrQwjk9o1Ihhpyrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cg6/nRoU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nX9jGRef; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cg6/nRoU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nX9jGRef"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765407199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lk2aTLi+Wd5s951sYWzFw0k465O2NOXo1WRBbXXGnNI=;
	b=Cg6/nRoUiHwsJg6iwjtQo9dkwoTZU0oMVw2BYgMcZTARPSzRqPrw+cjEpqho6vSE90INBy
	HgOlFcW4lWhNB/RDEM1QI/X0D4vMMjK+bXKRspZbk21gkh7y/RxhDrv1BDAameXKSHXGPt
	/sycBdE0fwVXOPycr5CrL4WnzeMjaaE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-FpyDNRAoN2WU1OFIYuIBDQ-1; Wed, 10 Dec 2025 17:53:12 -0500
X-MC-Unique: FpyDNRAoN2WU1OFIYuIBDQ-1
X-Mimecast-MFC-AGG-ID: FpyDNRAoN2WU1OFIYuIBDQ_1765407192
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8b51db8ebd9so129288585a.2
        for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 14:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765407192; x=1766011992; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lk2aTLi+Wd5s951sYWzFw0k465O2NOXo1WRBbXXGnNI=;
        b=nX9jGRef4al1nnlCr9RMsCICVhZNfEDGeEm+w/XF1GsQRSNyRSNJoGi5+plibR5O7k
         sogqDU9kB5tnS5K1kDTwePeHoGm2xrH4qwq2kIkEG+zUm8NXeVeN8K+wiuU+J4AhZ6ZJ
         kFcSsPp+hYD3wm1sSTRnmzltff74GeYlrRQP3inkIqzF1gLBviO/tgVgAfPufJrDWIv0
         kmmrGhJ+aJLtGt4+PAGugKV408t8FoYDuXaF7NEC5sR/sJAan8xbSLxOnXpAWmyenfhX
         u2YCACbvcqR/zy6+dhJIWbDJDY5mtGKlzr+d39Y+clH8YCPHcnS6f9kONLt51ebh8pOZ
         w0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765407192; x=1766011992;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lk2aTLi+Wd5s951sYWzFw0k465O2NOXo1WRBbXXGnNI=;
        b=sAKltoUkVXCp3vA1FRPtCugs5DMCRqC21BJxjhWLl38RG90LS9QTKKuXAnPLENVwj+
         i47RnHaHdIoQJNr1clSEzJHVb7GXd65ESlmMUjZXTwySN8Pj4GIZmGSKhdoYK2Oh3cgo
         m8VcvjEE2j/FwzKd3krP3imizj0wmiyJwQt1LychcVcVxkjnDxSaFJelxAMKxht/raU9
         f+UL67KwBgH2l67hXOptL8IGyABif/UAfNqQXaqlVdm6MRX9Bpc2mhaUCV+UVL3cxeiu
         mktx0+hDEJZ963/ShZt/WBWOhyQS8WNpJjTMjxk6XB9prYQy6jGYVkniJCcVyV7ZqF1e
         Aetg==
X-Forwarded-Encrypted: i=1; AJvYcCUU9HEGPpCS7Th8maK/9+G+vxZWxG/edmibsQmfUqi7NeTz7ndj4rwx333mf9TkeRKKXEBb48d1M10=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi2N/4wqkISFFoCpIRsiyjhJntEHSDRtnS380BUjXpZBWb9dBP
	3dhHbaawL4NWGI9f5ckF/Goqu6QLcDWENLQLazetJqKiQ3MK3HoxrH6OwJvAztE6DvZX0m+3w6g
	1PMW+lRmhbBS+x2IwyPviRUQjCjw129jH5WjHQhSbHgEfdjvugzJZYzO6m+WMLA==
X-Gm-Gg: ASbGnctDQ3/zy2kIctnLayvEMHgktFCOeZ86Ge+r7LLTnY2XncD9W+i6bz04xxHg9YL
	OdwUZCRzm5GMQ3LdqKu0cdVjGJiBSHFZ36EZ+C4JL2a1saYPtkpaESBFIsjBjF2J3EjEVy3uz+z
	d5ZbIe3o4t/uYys1jL0w/I0F2RwOfey0fc001Q7pUT+ikOr+XlD60whE/d73ZeFNcsu4xyGasei
	mfyos6AL6gF+VHcT00DQlZbj8p2xziR0QE2T7VAJWZk4ITTbtb5TVyqSY+7n11/SBh5ntAZ39Ht
	5qOjo/VzxiSopqxGYyuhEhixmu2iuWqg02YRPgWaL+NxaGRCRHAaiImGe6i4/Oofx3VAt5DjpEG
	Bg/2QVMakwpLXicNLuLHfdFuD2EoGZuQPzP7mnzmFevPTobgsEw4=
X-Received: by 2002:a05:620a:2681:b0:8b2:726a:1e2d with SMTP id af79cd13be357-8ba39f4af03mr609126885a.85.1765407192043;
        Wed, 10 Dec 2025 14:53:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH6TKUVH4G0Y54vG8a+dbWASRUWy27oDzh1a2uDUcRFhqUoPEy54jbyW88F0gTmrfZzPjNCmA==
X-Received: by 2002:a05:620a:2681:b0:8b2:726a:1e2d with SMTP id af79cd13be357-8ba39f4af03mr609125585a.85.1765407191683;
        Wed, 10 Dec 2025 14:53:11 -0800 (PST)
Received: from [10.0.0.82] (97-127-77-149.mpls.qwest.net. [97.127.77.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8886eef8f77sm8201956d6.35.2025.12.10.14.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 14:53:11 -0800 (PST)
Message-ID: <ecf9aa22-3cc3-4348-bc61-cce094738c60@redhat.com>
Date: Wed, 10 Dec 2025 16:53:10 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mdrestore: fix restore_v2() superblock length check
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>
Cc: Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org,
 chandanbabu@kernel.org, zlang@redhat.com, aalbersh@redhat.com
References: <20251209202700.1507550-1-preichl@redhat.com>
 <20251209202700.1507550-2-preichl@redhat.com>
 <20251209205017.GX89472@frogsfrogsfrogs> <aTkFC2EWf5UX5y9w@infradead.org>
 <aTkMgBUQcp-AmkaC@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <aTkMgBUQcp-AmkaC@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/25 12:00 AM, Christoph Hellwig wrote:
> On Tue, Dec 09, 2025 at 09:28:43PM -0800, Christoph Hellwig wrote:
>> On Tue, Dec 09, 2025 at 12:50:17PM -0800, Darrick J. Wong wrote:
>>>> -	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
>>>> +	if (xme.xme_addr != 0 || cpu_to_be32(xme.xme_len) != 1 ||
>>>
>>> xme.xme_len is the ondisk value, so that should be be32_to_cpu().
>>>
>>> Otherwise the patch looks ok.
>>
>> We really need to bring back regular sparse runs on the userspace
>> code.  Let's see if I can get it back working..
> 
> I just gave it a try, and make CC=cgcc still works in theory.
> But between the urcu headers making it throw up, issues in the
> Linux UAPI headers and our own redefinition of the __be32/__be16
> types it generates so much noise that it stops reporting before
> any real issues including this one.  Sigh.  I'll see if there
> is a way to clean some of this up and get useful results.
> 

"make C=1 / C=2" worked once but when I ran it after seeing this patch,
it didn't seem to catch any errors. It spewed a lot of other things
though, as you mention (urcu, ugh).

I didn't realize that those results could swamp out other reports. :(

-Eric

