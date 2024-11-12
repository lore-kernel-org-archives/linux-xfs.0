Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0C61FC7F6
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731420548; cv=none; b=KekY2NQl0WBbqUa8nlnlPESjLRXoiB7pO6rZZ8Ybp9a/FX9SylZ6DkOyW4qd3tkr87plsLVhK6x5dRnnGQWeW/mkldG0tt08bHQhZxtuYjb08dv6XABxoq0/JLOYYiE0gIdDYUDa1nHJoElpV01rQY0sH/hMOBZGjzwCK7QrVxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731420548; c=relaxed/simple;
	bh=6Kcgmtiz1FW/ZzHlnliH50F3dtShqEHk4ESpOMRpn6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l+7bJjaShj1v1KMrpKvhxGlq7mfT2AF0JiBE0Nbo5ezL1kNBW6DoyBR6R/CopcNDr0IaF3tagUq71g/POJnqaLtzkflK14wgA4xciZYbU6+3dYV4GGOnCJNt30PojiYsrmRhmUd5R/YstrGIomfKZkKHDJdcPFvutIwKYqRtXSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n3c4That; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n3c4That"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-290d8d5332cso2669371fac.2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 06:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731420544; x=1732025344; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2VTmM5QSlq1n4SzNFjqKKxkTqt3/4ndegS1abSdzblw=;
        b=n3c4ThatqANXuJpPQpmUl7Ojx2qgDF7iYQB7Zafmd4z6aYq39iMF4xOighkZiWQb3q
         KpjqOKSPCqQV8cSjQdaBRrkNjiQEQ/VNvukESFANe5Hzdjn2cmz5KYyfeFN0dtYfs4Mc
         jCu5WC69UO2GzUXDflWCwXn+dfAQOqt5qDuqAwk7UfihlkjXITeTsYLttQnUDFEAsT2d
         9kG0LRjo+LMAu5Suac+YBlqAgfvEX70nUrXUZqixw0WwGAjxloj7YUkDf+9JzH37gtnY
         Ftbsu6t7nY5y/8TckePIUzs/1D1GxxZz48fHE+5kzRiDjOyLMLOkIk3MJ3EJBifO8I0A
         wf8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731420544; x=1732025344;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2VTmM5QSlq1n4SzNFjqKKxkTqt3/4ndegS1abSdzblw=;
        b=iQtICUIonYm/MHEYcifC0Zt+a6Z8zvYJpRVSoGdduEPNg+O1LwhCi02XDrpLZf6QTE
         Tazz5XmkRoHzQM7KEOILi9xeMwpXakRc/a89S6TYsi5KZ7X0+B56ut40NTASeISkzAsZ
         4x+B1vE2O279Os9KJHRxcgf/6EsUExluOaPxE8usk08LZXmtvL+bDTBqoxu82Xt/nV0C
         VmEn1l6sUlzSalY+pWG5sjIl23F293VCqD2uRWa+joRy58jA4crbxtJYsxzmcnCadkib
         TS23HZYQqjUGJfJduv11Br9inZOeLWUU7EFF3NLbvMnTqOMGhoeQM9UygqDNVCOBRlCB
         Pnjw==
X-Forwarded-Encrypted: i=1; AJvYcCURRlOOGCmToGHaaViPQ3QQRDU44+amFixl+5YbeUpteFvEy/XPQuaXqoUoD72aVusUbh/bt8Y5RBU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd/ubHBCgzS76sPj5VU+hchaqaCCym9DyBmhAwodU/ljCvl0qd
	7R3hh0P7d6xbhgSe5b9IMc//+sgWO8yyQ9hJgP5Gsck4UhH0CnjttssdYz72SBE=
X-Google-Smtp-Source: AGHT+IGKZws8A8A6GExZpeIFWIve06Wn6yTSLfUbW410QSZ9Z8ht/7ABpd8OcL3b6MeePGxUd8BRIw==
X-Received: by 2002:a05:6870:f603:b0:288:60d3:a257 with SMTP id 586e51a60fabf-295603e193dmr14748452fac.40.1731420544420;
        Tue, 12 Nov 2024 06:09:04 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29546c40039sm3431688fac.2.2024.11.12.06.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 06:09:03 -0800 (PST)
Message-ID: <9a5474b6-aaac-4567-9405-351d6755f947@kernel.dk>
Date: Tue, 12 Nov 2024 07:09:02 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/16] mm/filemap: drop uncached pages when writeback
 completes
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hannes@cmpxchg.org,
 clm@meta.com, linux-kernel@vger.kernel.org, willy@infradead.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20241111234842.2024180-1-axboe@kernel.dk>
 <20241111234842.2024180-10-axboe@kernel.dk>
 <mxh6husr25uw6u7wgp4p3stqcsxh6uek2hjktfwof3z6ayzdjr@4t4s3deim7dd>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <mxh6husr25uw6u7wgp4p3stqcsxh6uek2hjktfwof3z6ayzdjr@4t4s3deim7dd>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/12/24 2:31 AM, Kirill A. Shutemov wrote:
> On Mon, Nov 11, 2024 at 04:37:36PM -0700, Jens Axboe wrote:
>> If the folio is marked as uncached, drop pages when writeback completes.
>> Intended to be used with RWF_UNCACHED, to avoid needing sync writes for
>> uncached IO.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  mm/filemap.c | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 3d0614ea5f59..40debe742abe 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -1600,6 +1600,27 @@ int folio_wait_private_2_killable(struct folio *folio)
>>  }
>>  EXPORT_SYMBOL(folio_wait_private_2_killable);
>>  
>> +/*
>> + * If folio was marked as uncached, then pages should be dropped when writeback
>> + * completes. Do that now. If we fail, it's likely because of a big folio -
>> + * just reset uncached for that case and latter completions should invalidate.
>> + */
>> +static void folio_end_uncached(struct folio *folio)
>> +{
>> +	/*
>> +	 * Hitting !in_task() should not happen off RWF_UNCACHED writeback, but
>> +	 * can happen if normal writeback just happens to find dirty folios
>> +	 * that were created as part of uncached writeback, and that writeback
>> +	 * would otherwise not need non-IRQ handling. Just skip the
>> +	 * invalidation in that case.
>> +	 */
>> +	if (in_task() && folio_trylock(folio)) {
>> +		if (folio->mapping)
>> +			folio_unmap_invalidate(folio->mapping, folio, 0);
>> +		folio_unlock(folio);
>> +	}
>> +}
>> +
>>  /**
>>   * folio_end_writeback - End writeback against a folio.
>>   * @folio: The folio.
>> @@ -1610,6 +1631,8 @@ EXPORT_SYMBOL(folio_wait_private_2_killable);
>>   */
>>  void folio_end_writeback(struct folio *folio)
>>  {
>> +	bool folio_uncached = false;
>> +
>>  	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
>>  
>>  	/*
>> @@ -1631,9 +1654,14 @@ void folio_end_writeback(struct folio *folio)
>>  	 * reused before the folio_wake_bit().
>>  	 */
>>  	folio_get(folio);
>> +	if (folio_test_uncached(folio) && folio_test_clear_uncached(folio))
>> +		folio_uncached = true;
> 
> Hm? Maybe
> 
> 	folio_uncached = folio_test_clear_uncached(folio);
> 
> ?

It's done that way to avoid a RMW for the (for now, at least) common
case of not seeing cached folios. For that case, you can get by with a
cheap test_bit, for the cached case you pay the full price of the
test_clear.

Previous versions just had the test_clear, happy to just go back or add
a comment, whatever is preferred.

-- 
Jens Axboe
