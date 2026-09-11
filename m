Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159E521CA02
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789133930; cv=none; b=XeenZ0LaoY+4GKEJLtEf6K/BGLjbA4NRkxRtEV2J1kQb/QhWcV1TX2VsPS26vCHklfPYbU20LW/sriX1nyNdnJ0oVtcZq3HJOin3lnPYPqgRUrDP4vgpdX0wigGaE6XvbbcbXAL5vZwUjTuia6vkfS7uUHuP2b+0ggmlzBk4gEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789133930; c=relaxed/simple;
	bh=5SC3HT3+5ycGwWh5KBASibBcRAJzdLO3KnH4sjbmFDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lAa9mM8P73wK28RqxXJTZESxR8RTJ80upTNec4FbuxyYkZS0rCpZzVbY7UpcNF/s+67cu1NIKEww75xV5hdwapv0rhpU6tao4vkVMu2RgjsWmAIHON5q0m1RelkWMR4wnknHdCTAxhcM5OdAwbNf//PeEJvJtWVpqspqug8nGi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=sD9i0EPj; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="sD9i0EPj"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-8049e44d0c3so416429a34.3
        for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 06:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789133926; x=1789738726; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sCKlIYEc3WBtqZTRSmkKr4C+yXpeMrWNJb+k5yI49J0=;
        b=sD9i0EPjj0Ig68IeGg90WglA7IXGd9HwDQFuhbJxnkZjB9Si4yn+4RIQak7mynH8zH
         +1igcCeXsxwsXgponQPQcytQjaWGZlR66ar561qN73PpPOlr9uGsjcgjobCPKB/avnlv
         a6LoshCKEOCyssaM+uYy0Rz5r8mafFkENxpBEAhYYNyTBGSrJ2MW1OIYtHElh1gFbyeS
         25eZHFxVSNu4fZY/OuFp1yh2tYbwRN9s8O9Uj3iLNMsZMMstNEZ+LW7X1oDFuiHn3V1Z
         zR3n/XKfT4kjiRHGzC/hy2wBLC4+VjYpRg05efGSlP9DZfjmhocxWk6aScfTYbWrKgFU
         RHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789133926; x=1789738726;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sCKlIYEc3WBtqZTRSmkKr4C+yXpeMrWNJb+k5yI49J0=;
        b=Wj49xFJZIxxxNRJFzqpivutKEICfzNxtAuigoDTf7er9qhrhQXDHA4miqrm+3ym4mA
         FPWndlYFOhkDe2DOojaNksySxivfD1gi3ADOsveN7CD8JVnPCsAz83aHWp0ECtJbyhPc
         OvKqrp6C1ghnQiMnwbkLncg1J5rKiQMp2XsuVxxyLNd2i0SlRCzKrNIl8AMqrepkiShh
         P3B1AD+csN0upNUxo6Np0R5TiEzk31N16taxt0DfEBAhzU6XjgA8saSOGzjRhTJT8Gh1
         Vi+OkL7CAIu1rW7ANAKLLUa6xkxr+W1+5R2zcUfdz3QRbdrdP2Y3Qqh/JDPTqumoaYBf
         BDqg==
X-Forwarded-Encrypted: i=1; AKwUvBwIWX3OuU+NZ/Z+OqAe/Cl918BJxUBbRBwOdCYbyHz0RF9jiH1WV7ABXMX2TsUmLC0mZRWY98pBAqc=@vger.kernel.org
X-Gm-Message-State: AFuF++mkFvoiSP5OanTGTIR6f26R7CdTrphIQVc/fbAcDH4yOIw3uNFG
	OvC6xmcVsTucfJV87TeGzRaDMbkr90hG9jkf5mp/J0Zb4dY0HXV77LlQNMflWpt1xYc=
X-Gm-Gg: AYBFou1SF5n7wm7VYy71v3R1JlHm/shyRUNxAEv5fvUqKMQoE1QcB9WRuydS40DYDJa
	q05wIc86l6cyMR737phEv1qqpuPbi1TLyxBQV9f7MakB6KpMO+vVm0BiqeucAYLI1BrL0ehOX9Z
	nxXn2zlQOgmla0qVNR6hFI9+HulSeRK3UcCDArw4cpK1dMhLQTO3A9XbCQyQj4TeOi9l8DTFRCq
	u/QEGDtY03bI3Vx4VRXB/h1MrRd3jNuViYp7GPSUzCMsO+dSJytFC7NSK60ge6TsNN40iQ/O1Ar
	kWuFfiBSosrpa4y9QIzw8FAXyf7xA6dhtP2gqICa5Sj3RSSuEA/gOlxC61k1UkTLkNsL7a8Zob6
	z7bVxeaJHNl/tQn6yEWism7nfH92Lv518Ahh0hCRpnoPa6NntajMDuAWY6t+PVLF2kZQFVmEt/U
	Kq0siNbjMFioQHJuPu79sabWlaFU3WaKkKZQsrG/XopP3+cfJdBJvEH2a0BrbkL3TvOfqxQpIFo
	lZ2b2iyTr7b3iOY8fXNZcLw3ObA0lUZsqtCW9bWdeNhVNp1NEmmjwKt
X-Received: by 2002:a05:6830:7314:b0:7ee:19dc:b00 with SMTP id 46e09a7af769-803fd2514b3mr3323405a34.3.1789133925938;
        Fri, 11 Sep 2026 06:38:45 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8051005d845sm206965a34.24.2026.09.11.06.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 06:38:45 -0700 (PDT)
Message-ID: <2325107b-8c45-4304-aaa5-f8c768d619bf@kernel.dk>
Date: Fri, 11 Sep 2026 07:38:44 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: lazy bounce buffering for checksummed reads v3
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Tal Zussman <tz2294@columbia.edu>, Anuj Gupta <anuj20.g@samsung.com>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260909060924.1102037-1-hch@lst.de>
 <fe537c5f-114d-4d9a-817d-93f359e12924@kernel.dk>
 <cff350b3-836f-4953-97f3-d664164746b4@kernel.dk>
 <20260911114438.GA21957@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260911114438.GA21957@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/26 5:44 AM, Christoph Hellwig wrote:
> On Thu, Sep 10, 2026 at 02:51:33PM -0600, Jens Axboe wrote:
>>> It's a little hard to split as you have eg block patches both at the
>>> start and beginning... In the spirit of getting this some runtime, I'm
>>> going to queue it up in a separate branch,
>>> for-7.4/lazy-bounce-buffering for now.
>>
>> On 2nd thought since this already relies on stuff in the XFS tree
>> apparently, you can just add my
>>
>> Reviewed-by: Jens Axboe <axboe@kernel.dk>
>>
>> to the block patches. Would probably make everybody's life easier.
> 
> No, the current series is just on top of mainline with the block
> fixes for Sashiko existing issues comments split out.  Which probably
> was a mistake, as that now lead to a side-discussion and Sashiko can't
> apply it any more because it is too stupid to parse the cover letter.
> 
> I guess I'll do another resend with the two of those that stick
> included, and I'll leave the third on to John, who already has a
> handle on it.

OK, I've got it in for-7.4/lazy-bounce-buffering now.

-- 
Jens Axboe
