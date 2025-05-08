Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E962F22A7FD
	for <linux-xfs@vger.kernel.org>; Thu,  8 May 2025 13:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746709820; cv=none; b=uiLKS65u+e4xwThUXI4EP+LKYqUBQWsvhUfscZSbDSw3AMRjfC4HGD/OlhIa7h0PXWxKUGoiH7wRv+KJ3ZbIL9vYNKZw8KDAWBtP26gDnTvFGyaxQUtZUjzfsUp8a69pMIQhaGKjRbNKFrpfRyAhQfxZ6UPibDlEzwnNGFOb+vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746709820; c=relaxed/simple;
	bh=p3igjo1WeQ4ei3xNoOb2bq7IvOmv4IUIwEwUY8QYhsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Db5TLjRxNq6dHYhuf5a4R7KB6VSXtLHuPppS+oFylRuJ7OaHHUXlf0bpRoFiiYECh/Gw5IJiVGtLOI4ZOtJLpUr6BAbNu7I08KNhhQt7HVskOzt0fMibJSJuFhqV4lNYErWbbJGMuhLNo8YXgplu9VruNI43fgqxIC7Shx6PfPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Tkl66Hd6; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Tkl66Hd6"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7cadd46ea9aso137129585a.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 May 2025 06:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746709817; x=1747314617; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XTDtbe4K12xhEpViDB+3A6qWj2g+MO64MrS+vZvyuzM=;
        b=Tkl66Hd6oKryphc9p8kkr1Mg5prsFBFUR3n6KnVt3T6ymlULM+JMCOV+Owzs8+hsFw
         VUEYc2HIjCByzjBSZHZUwAlqRKGNXlMMtaIHboI5dlOnnGkq+YAd8P3czzQbDIBol2fA
         zPYOsW/OcbdMNO158HzzUoozg5OxjfVAjduUsVOeHvHggdeezkilJ9h3zB+v8bUpPArO
         HAs5LbIatDvTh0HBkZwmJuMXmWzxpRA7e1pldYtwxRoDweXv/Oj9fhfOc3faJynREGTw
         5FhrlXY2ifjcb9esxqWwBW0kLa4DgX45VVS/6VQsS+r8ZBagKfp5Zk570XvJr4SsObBY
         FFQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746709817; x=1747314617;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XTDtbe4K12xhEpViDB+3A6qWj2g+MO64MrS+vZvyuzM=;
        b=SESzy+znIMBIQDWqoGoRL907RufKZVjXWfA5m7KuGraz9/6WpcF54NN0mZRR09RpiV
         JpHwg38l9+QMPk1kr33OvqchBEuCxbi9Xr2qYvFmiFVROYc9wlRrFPXOd6RVDdV+qSU7
         YtEloqcgGWyYMfmqs3H/q1wDHZHZ/X3o/uo2CetMdDRkKtNC6d9T1l6ZIVjE/mQZdtDE
         zU+FmI6ZCYXsm7PKoijij38e6ZfMnb9lyobHdcBy7tasoMuHNxAcW+Via+WLZKHcE2pR
         8WABhL23IHxto56q0j59NVnj5C+kONhjPgJJbHk54Lk72ETPltoPZVxnqOLwI/2/gwJX
         Sa4w==
X-Forwarded-Encrypted: i=1; AJvYcCXnmDOSg1Cnq/rX67B3UI9B4idyzp19ygXXlDDznSVBmqnE8v0z4iRPCrI4yRghwKYt8il9pVfqqsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCMW4jqn7SZbVvu61vUW9Lo1ztagPR7Vijr6kTz3rFqK7LD54Z
	yHuzJnOjTuti2F9qGxr1k8gZAWOeZQLkqRTU+8C/+ACnlqIBOF8KsjzByc/UziDnOCX8U2R5Nsv
	t
X-Gm-Gg: ASbGncsBKjBPtP6QgwngDsEroCpuwEqsgScyBlMOpVpjVewyOtdSs/T4b7VD06uvXTy
	ajHJPHX6I/2Q+RBvOqk25lbsW6wz3usG5chapecAa+rhnWSTMrXD5pUmStkrmz9YMpTrD0ouxGs
	T4rN7Dyl5Er7O/olyxoXnyzfkgxXL6tAd9Jdfm1uxXYwQgsOTqs80RUoEhz3VtCk8Fo+7+mUjLE
	kpU4YkWtO23zodXzdgOFlW/jZ+hnShl4wwjFxtB5jhd4PbazDK/XgwtPaEutGq0s8J3kWDXKqK2
	16WJotW6d84Siqwk8geStwUqAIljqo0N/tZJ
X-Google-Smtp-Source: AGHT+IFc67B3rj29wLwGe5b9hNdUhbBaJDAFmOrgjOa9uQdS/eOlhjhIK4I5PRu/Z5lCJQDbW0IFWg==
X-Received: by 2002:a05:6e02:12ef:b0:3d4:6ff4:261e with SMTP id e9e14a558f8ab-3da73867d6fmr68904585ab.0.1746709805765;
        Thu, 08 May 2025 06:10:05 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a945471sm3173148173.70.2025.05.08.06.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 06:10:05 -0700 (PDT)
Message-ID: <0df727b4-c0fb-4051-9169-3bd11035d3e0@kernel.dk>
Date: Thu, 8 May 2025 07:10:03 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/19] block: add a bdev_rw_virt helper
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-pm@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250507120451.4000627-1-hch@lst.de>
 <20250507120451.4000627-3-hch@lst.de>
 <a789a0bd-3eaf-46de-9349-f19a3712a37c@kernel.dk>
 <aBypK_nunRy92bi5@casper.infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aBypK_nunRy92bi5@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/8/25 6:52 AM, Matthew Wilcox wrote:
> On Wed, May 07, 2025 at 08:01:52AM -0600, Jens Axboe wrote:
>> On 5/7/25 6:04 AM, Christoph Hellwig wrote:
>>> +int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
>>> +		size_t len, enum req_op op)
>>
>> I applied the series, but did notice a lot of these - I know some parts
>> like to use the 2-tab approach, but I still very much like to line these
>> up. Just a style note for future patches, let's please have it remain
>> consistent and not drift towards that.
> 
> The problem with "line it up" is that if we want to make it return
> void or add __must_check to it or ... then we either have to reindent
> (and possibly reflow) all trailing lines which makes the patch review
> harder than it needs to be.  Or the trailing arguments then don't line
> up the paren, getting to the situation we don't want.

Yeah I'm well aware of why people like the 2 tab approach, I just don't
like to look at it aesthetically. And I've been dealing that kind of
reflowing for decades, never been a big deal.

> I can't wait until we're using rust and the argument goes away because
> it's just "whatever rustfmt says".

Heh one can hope, but I suspect hoping for a generic style for the whole
kernel across sub-systems is a tad naive ;-)

-- 
Jens Axboe
