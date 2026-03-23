Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FC62BD11
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 01:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774230495; cv=none; b=Mj9iSJh290ZiB4iTE7s62p+0rVzfgwQrDadYv4Ohc+U3U61AoQlFcdoBfI+vv0jYY15UZDjlwSY10QAWlI7/JJIjXboE57aSpZ9Ul5E2Zm/hw7a5VO/n6MZT12TFXjoJtr/zIXb52ErKrOVEWR3WxwhbwRZy3/iwU/LCw9V2LY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774230495; c=relaxed/simple;
	bh=cEEN+qS+v0cPQzz26QhVNgxrvSPNC3mjwIeTUXYVsNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XcJO83RcqlGsxPEPF+BLe6vDgMCVxpt7O0gJaK2I0hFlnyPD5oBfdodWvjSSy/UCGt26tNcqs7ZcZg31bqW+PShIjzebC+X3qQ3oTYbwJfgHt6bEBSYoPIBjiBziXzvFpqykvDnawlBXhIWwBq99KmcKVNN0vCQ7FKtR5nN5QN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QywXo7QM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PqxRtrVd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QywXo7QM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PqxRtrVd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774230492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mYgZZR0kXxMZ2oWd4hYeewbulFpFFbdeDyMrMn7fieg=;
	b=QywXo7QMiS8MErG8iH7C/zVZM52D4Q3GaEYZ/+Zr35I4wFchNEDytVpEJYL/o4XlBq7IYm
	NVmgk0n90H2K8YjEHKMc8Zv62hq0fBK6IsEwNDjyCa3/oYNPvoaarqDZ6Yubhtn8u7l5Lu
	MZrJlkQCiOp8gU7XiBD3h+sn5r+LArw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-mnL9ATz8PK6WxAyihS42LA-1; Sun, 22 Mar 2026 21:48:11 -0400
X-MC-Unique: mnL9ATz8PK6WxAyihS42LA-1
X-Mimecast-MFC-AGG-ID: mnL9ATz8PK6WxAyihS42LA_1774230490
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b064f043adso51952445ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 22 Mar 2026 18:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774230490; x=1774835290; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mYgZZR0kXxMZ2oWd4hYeewbulFpFFbdeDyMrMn7fieg=;
        b=PqxRtrVdcZUI4jCZKN0bv4yXxFOj7tU5otOjsSiNGEw+wmpGqPrGl75tIX58zZ8JEI
         Xh3rVoAnE+HXGwoMEic3rYlvrKwisGAFEcQcwAAoNNpB/rA6LdSP2Bsia0q0I8y20pls
         EjO8ZIWX5Z5a59Xn11odMu1lZ3W4mtfn8Eh1gREtLSSQVbVG+0/qtbIou5j6HXnGoEUG
         jeYTOgRqkfpAhdKV8FNOaGEo2uvEDJAnl1RSavt2DedLcCkik2BQOR8N+XoF1LuU1SRD
         2L1SizCL34ejbWoUmHnlGMrWNJHZZDyD3ZTJbLLKAjZKqv9nucum5q/a6zwg6k9PkN/z
         p6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774230490; x=1774835290;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mYgZZR0kXxMZ2oWd4hYeewbulFpFFbdeDyMrMn7fieg=;
        b=LEgi2KXfan8774eE5/DhnfiBtua7t9Nsa54WeCD1JJbBGEcC8sFkr3AML5y7naktly
         KaRsGqRmMVrlgkzRyUkVgCN6taV+rvj+Ef6kxlLGhtPuu5w/RGDyuliR0vT71/7TyqXH
         zojon7AKsCZS7vc5ruCRQAwPsg0kRX67xb7VNSE3/GA1rB+u44x97KO+/HwgUJpZE+f1
         A9hq949AkmZQLarxZTe9uzXtJDFMqzcyZC7NWJdPeT949I03CAj1IAbD8K1uvcT+wWgO
         /o7GzH9mLtveD5Zkghu8fgs5t3gww9ptqPI7l3DB8C+sOGvF1awDtkfnzjEBogw2LybB
         ZXgg==
X-Gm-Message-State: AOJu0Yzqn/eWG9N+M4Ore+KHZj4Yqm9tZtFiZqnrii0bh9uEVILGr6BI
	f/rsogadrcL+4A3ixbv26qFGxA4f6j8qEaLnKLEuEzaEpjnjnQzO9mxm7pOAEtQKdV/ky+qWEv1
	Sas9CsWH6z4Rgy++6qxfTNluj2A39tG/4UkHTPrcFwguzuXz7xdZlTVh8bScJTiDTQot6qg==
X-Gm-Gg: ATEYQzzquGMDr7bgmIrqgmEZZF1z6CTSg4ugh3u8ahx0xKtQmFHrwtw9I5jKjG4qxKl
	jnFhqRC0HEiykWvN24WfI2wPJ0nwCzTX1gUaXoowDaFl45whAZGTjto8qQOebEDJHpUT8VQwf6C
	3CLQLAQ0B5Zn+TxAKdTbxe17sYTPWFxt5PEamcH4mfO9sWJT4MjRwBinnB5vEbI5xFwjqU9Szv6
	bIrs6ID66MytloUNmJcd0vqk7mOV0rBE652IKFQsHgNMfG9XgvcpqGHWfWOCoLh7rHgKJ4u/pck
	SrD0M16LbeuYph5Sdv7UYU2xl8LaGurRcNmS5xhRbOhwVjUz6gMatDsqJibZFltz+eSj1HyjXFA
	Q/7DVb3E3hhMYgPYS1GzKDN+m96tUoZtpjIEhLJ1WxmPISeU9ag8t8D990lSahfv0HVeQ0Vg=
X-Received: by 2002:a17:903:283:b0:2ae:54b2:27c7 with SMTP id d9443c01a7336-2b0827a15ffmr92050655ad.39.1774230490157;
        Sun, 22 Mar 2026 18:48:10 -0700 (PDT)
X-Received: by 2002:a17:903:283:b0:2ae:54b2:27c7 with SMTP id d9443c01a7336-2b0827a15ffmr92050515ad.39.1774230489762;
        Sun, 22 Mar 2026 18:48:09 -0700 (PDT)
Received: from ?IPV6:2001:8003:4a36:e700:56b6:ee78:9da2:b58f? ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836554acsm115719105ad.51.2026.03.22.18.48.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 18:48:09 -0700 (PDT)
Message-ID: <fce43d76-de74-4767-9435-c0fde65d37ec@redhat.com>
Date: Mon, 23 Mar 2026 12:48:06 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] xfsdump, xfsprogs distro builds and DEBUG=
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org
References: <20260224071712.1014075-1-ddouwsma@redhat.com>
 <nxyxi6y5hdpr3jpmr3aehoaklpe53qqdrpkf27ejn4ospx4rin@6oib2fgjv3hm>
Content-Language: en-US, en-AU
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <nxyxi6y5hdpr3jpmr3aehoaklpe53qqdrpkf27ejn4ospx4rin@6oib2fgjv3hm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/3/26 00:12, Andrey Albershteyn wrote:
> On 2026-02-24 18:17:07, Donald Douwsma wrote:
>> tldr; Fedora builds with -DDEBUG, is that what folk want or expect?
>>
>> We see cases from the field where xfsrestore aborts on an assert(3).
>> In each case there's a real problem that needs to be fixed, but these
>> problems are preventing folk from restoring their data. With the asserts
>> suppressed or removed xfsrestore usually does something sane enough, at
>> worst leaving restored content in the orphanage where a user can find
>> it.
>>
>> This was notably seen with the original xfsdump bind mount fix, now
>> we're seeing asserts fire during cumulative restores in
>> noref_elim_recurse.
>>
>>   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
>>
>> This appears to be caused by a rename to within the tree between restore
>> levels, or a combination of modifications during occurring during the
>> dump. Fixing it will likely require changes in noref_elim_recurse, or
>> tree_post, to ensure elements of the tree are created for these edge
>> cases.
>>
>> But why are we seeing assert(3) active in Fedora based distro builds?
>>
>> xfsprogs and xfsdump m4/package_globals.m4 shows builds should default
>> to DEBUG and xfsdump doc/INSTALL talks about how to turn off asserts and
>> create an optimized build, but only Debian has its build rules in-tree,
>> where they set DEBUG=-DNDEBUG.
>>
>> Building locally on Fedora or similar gets varied results with recent
>> Fedora versions building as if DEBUG=-DNDEBUG was set within the realm
>> of configure or autoconf, which may be misleading people.
>>
>> But for Fedora release builds we can see that they're building with
>> DEBUG=-DDEBUG resulting in gcc called with -DDEBUG in the build logs.
>>
>>   https://src.fedoraproject.org/rpms/xfsdump
>>   https://kojipkgs.fedoraproject.org//packages/xfsdump/3.2.0/4.fc44/data/logs/x86_64/build.log
>>
>>   https://src.fedoraproject.org/rpms/xfsprogs
>>   https://kojipkgs.fedoraproject.org//packages/xfsprogs/6.18.0/2.fc44/data/logs/x86_64/build.log
>>
>> I don't think the intention was to have these build as DEBUG, but that
>> seems to be the current result. But before I dig into this further can I
>> confirm what people think this should do?
>>
>> The following series is illustrative of the changes to build xfsdump
>> cleanly with DEBUG=-DNDEBUG, or the type of downstream workarounds
>> required to help end users hitting problems for the status quo.
>>
>> Don
>>
>> Donald Douwsma (5):
>>   xfsrestore: remove unused variable strctxp
>>   annotate variables only used for assert
>>   xfsrestore: include TREE_DEBUG all builds
> 
> First 3 patches looks good to me to include, not sure about the
> rest and the original use of the those asserts.
> 

Thanks for looking over these.

I've done a bit more digging and have a reproducer for the recent
noref_elim_recurse assert, with what I know now the tree debug
messages may not be as useful.

Regarding the assert stuff, its a bit of a can of worms, the
documentation in the build system is misleading, when it was
written the idea seems to have been to have debug and release
builds, but Fedora/rpm distros didn't follow that.

Since then it looks like most packages have moved to assert(3),
being active for all builds. So perhaps its better to keep it
that way and remove some of the unused DEBUG options from the
docs and build scripts.



