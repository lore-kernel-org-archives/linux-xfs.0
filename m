Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53B13C8C7D;
	Mon, 12 Oct 2026 07:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791791424; cv=none; b=iKRbi6izYLn9+hGZVCmDeUpZaG8R3YdVxazVGKRrG+VHu7UStmqbhuyBHsuRIksAueEKruJW8fqivwhOg99R4IakXz+otEwW2A0S83usendTartZ0eHQ/jT4vaApbAEPh3u73CLYRGT3lxIfCGjfiPEn1Tox5Is9gxWo6uyjnik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791791424; c=relaxed/simple;
	bh=C50LJ3Vdsia6GXxtYUqtD+r3BibR95E6noBXKAs8UUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NXGxTwWbPyVr+/z08jtFlDP8P9k9pZuPpTC2RrsmVQWxCt4rUlAmere7uxkBjhHusH9cKnwS/nf8zV/W1oS9m5sEhXUpF02jslkyDdCuQNurGi1kPjdjt5wfkYcBoDHaQU2ApUFjdaWuLigWT5FMAtIqrsQwEy7M2ynZq8poZIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pVvixb49; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pVvixb49"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791791419; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nyvz0mMuh4bqfbMaOFn6ymiAv9PJ0j5FQKUNYH4alZ0=;
	b=pVvixb49ewWJMizZQ27INjqKAkP7cwieO0xtH+nyLfLjwBLGC+2oozXKrMnQO8bAi3mivreHWXAl3DVc7vip3A9HFi7xpUmabKd9gp4bBQIu/FlOlKfNjsC6DU0WLGSsV9MnBIA3V2DuPbCxdZAgDr9TMS4Apn1joZqe9gAoJpU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCclAy1_1791791415;
Received: from 30.221.130.114(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCclAy1_1791791415 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 15:50:17 +0800
Message-ID: <bda10a43-5ff3-4f8d-b9a7-e63161e0fb4b@linux.alibaba.com>
Date: Mon, 12 Oct 2026 15:50:15 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] blk-crypto: reject fallback data unit sizes it
 can't handle
To: sashiko-reviews@lists.linux.dev
Cc: linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org, tytso@mit.edu,
 linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 ebiggers@kernel.org, jaegeuk@kernel.org, axboe@kernel.dk, hch@lst.de,
 djwong@kernel.org, brauner@kernel.org, tytso@mit.edu, berto@igalia.com,
 adilger.kernel@dilger.ca, jack@suse.cz, yi.zhang@huawei.com,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, stable@vger.kernel.org
References: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
 <20261011170958.1759230-4-libaokun@linux.alibaba.com>
 <sashiko-outbox-167341@kernel.org>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <sashiko-outbox-167341@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/10/12 01:20, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] block: NULL pointer deref in blk_crypto_fallback_evict_key() on setup failure
[...]
> [Severity: High]
> Does this early return bypass blk_crypto_fallback_init() and leave
> blk_crypto_fallback_profile as NULL?
>
> If this is the first fallback usage, returning here means we haven't
> initialized the profile. If downstream callers (like dm-inlinecrypt) handle
> this -EOPNOTSUPP error by attempting to evict the partially initialized key,
> can it lead to a NULL pointer dereference?
>
> When target teardown calls blk_crypto_evict_key(), it will eventually call
> blk_crypto_fallback_evict_key(), which passes the uninitialized profile
> directly:
>
> block/blk-crypto-fallback.c:blk_crypto_fallback_evict_key() {
> 	return __blk_crypto_evict_key(blk_crypto_fallback_profile, key);
> }
>
> This unvalidated profile pointer is then dereferenced when checking the number
> of slots:
>
> block/blk-crypto-profile.c:__blk_crypto_evict_key() {
> 	...
> 	if (profile->num_slots == 0) {
> 	...
> }
>
> Could this cause a kernel panic if a user with device mapper access requests
> an unsupported data unit size?
>

The early return does leave blk_crypto_fallback_profile uninitialized,
but the NULL dereference that follows is a pre-existing issue, unrelated
to this series: the same eviction path is reachable on the base tree,
and the two flows below trigger a NULL dereference or a use-after-free:

  dm-inlinecrypt ctor            # first use of the fallback
   ├─ blk_crypto_init_key()      # succeeds, ctx->key.size != 0
   ├─ blk_crypto_start_using_key()
   │   ├─ return -EOPNOTSUPP     # uninit profile, will NULL deref
   │   └─ blk_crypto_fallback_start_using_key()
   │      └─ blk_crypto_fallback_init() fails
   │         └─ kfree(profile)   # not NULLed, will UAF
   ├─ goto bad
   └─ inlinecrypt_dtr()          # evicts whenever key.size is set
      └─ blk_crypto_evict_key()
         └─ blk_crypto_config_supported_natively() = false
            └─ blk_crypto_fallback_evict_key()
               └─ __blk_crypto_evict_key(blk_crypto_fallback_profile)
                  └─ profile->num_slots # BOOM!!!

If this series doesn't need a V2, I'll send the fix as a standalone
bugfix.  If a V2 is needed, I'll include it in the series before this
patch.


Thanks,
Baokun

