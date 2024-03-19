Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219E4BE5A
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 00:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711065728; cv=none; b=I2W+1EZaR9m4FiDMDLCKgxqTIPUAkVQYTBQv5qX1fWFyLVXNmRCsCT8qNCA5PPhnf04vL/lLR77sryEdUnRvMy5iugUsrmcpeMYupGCjSgdz/pn6LM0T+LH8eAk+ATk4ObUpuIksZIREUh+g4wguob0WmLuYnrtbZ9a/fy4Xzbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711065728; c=relaxed/simple;
	bh=6+G1sjHqFPVArExQiyfW7MUfRkLiQCAT4ozOgZwjtwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f9scr5gwzg3h2e5LF7EUYsrSNqxsSbq0qnfC9iRH+N0v2GkWXDFXACBnPPTQcwswVui4p9gV2H9xveWwUJkAo0w3UAhoSW7qWS+iNfWxWQbRYPkUf+Ayuh7/KoLg7E3aTASB88Tjrs2KVDi+zmrQ5EkrE++28N9Tt9s1o7EeOwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=M9KRF8yI; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="M9KRF8yI"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dffa5e3f2dso10030315ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 17:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711065726; x=1711670526; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :resent-to:resent-message-id:resent-date:resent-from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UjGog3ZvffaVpb6rTr/ObLpWPMullTEcsb0ecf3K6VE=;
        b=M9KRF8yIaiqc5RuiL69HeVyJIdN+AUXi2/KIDmgsN9jW6klxfx4XECp2KI4vPiVoqB
         IJZJQBL8YApwYDnnBMfwrA/tUefIoLTKRnUZGEfxZ2cig9vfpBcnIf6H5TJLLEjYbZyp
         67tShZs7b+BcOZwqiswwk5k5fwJMqbTZOpshzlKqln6uVeCJJJtJJUUFzRYYOkMT+Ahu
         QFI4Cb4uZVNTccLm123tIN31ojOuqbY8TSwjvfEgX6+JJ4fFNSyZaw8yjb0WHmCutpEn
         Sktgx9gg8z85eiEZK6kqAmgMa8M2xKwINoc/oRa57h6T0TAskb9rCycesUjgxpz/sfMf
         A5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711065726; x=1711670526;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :resent-to:resent-message-id:resent-date:resent-from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UjGog3ZvffaVpb6rTr/ObLpWPMullTEcsb0ecf3K6VE=;
        b=AH8blPHxlSb64VggNyVZViLlgXzrdG2Ne65qI19W3SO+OWzu5tcN77xRcVhlpudvOo
         75uQI9uxDv4wLAsBkSnzU5wql0wC+zRAjGf6MYvJuAxMB5i7TyML4Gh9beoPd03Oz5By
         nmG8arOPrfRUqk2nqHqc9X1EqZta3lmlI+9Rm+yU+eRZkzNGf1NHE8x/Q9uEP8ncDpW2
         L61LIN5koEJ6DbwNGjhvYO0xuv7pv6ZZBaAeqf/hqe4142FMbpwVFMbBOy7gvO+c+DLo
         kD7HAROlJrl4s+1iBmFEBYFV1+Tdhh5HqHByynht54OiuMa+Jquqqz3+yhOIYUOqGDX7
         HVew==
X-Gm-Message-State: AOJu0Ywrag65pStzCnBIgQnuzjWScUoS8g9LHSjKr/xY3+zEQps1llCx
	uaFqb6LCDzjq0uvReAsvzP5WuAvQbu4O9NXGTFv6o9BHQ6gVqGGQPwyl7asW6I4BphgnqwrrN3a
	Z
X-Google-Smtp-Source: AGHT+IFsy60fgVv7TQHdvDLM16F1daaOX0FPwY0TNLlgZzLzHsPhmqRiI7TbveF7sVDAz3P2JYIo9w==
X-Received: by 2002:a05:6a21:6d83:b0:1a3:6a2b:a7d3 with SMTP id wl3-20020a056a216d8300b001a36a2ba7d3mr1352904pzb.47.1711065233932;
        Thu, 21 Mar 2024 16:53:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id r11-20020aa79ecb000000b006e6a684a6ddsm396275pfq.220.2024.03.21.16.53.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 16:53:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnSEI-005It5-2k
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 10:53:50 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Fri, 22 Mar 2024 10:53:50 +1100
Resent-Message-ID: <ZfzIjqLLx7KarFua@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 08:42:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: use folios in the buffer cache
Message-ID: <ZfoGzbDXQsrtlc4i@dread.disaster.area>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-3-david@fromorbit.com>
 <Zfk2hhhXU78WSo18@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zfk2hhhXU78WSo18@infradead.org>

On Mon, Mar 18, 2024 at 11:53:58PM -0700, Christoph Hellwig wrote:
> So while this looks good to me,
> 
> > +	for (i = 0; i < bp->b_folio_count; i++) {
> > +		if (bp->b_folios[i])
> > +			__folio_put(bp->b_folios[i]);
> 
> The __folio_put here really needs to be folio_put or page alloc
> debugging gets very unhappy.

*nod*

I can't remember why I used that in the first place...

> But even with that fixed on top of this patch the first mount just hangs
> without a useful kernel backtrace in /proc/*/stack, although running
> with the entire ѕeries applied it does pass the basic sanity checking
> so far.

Huh. It worked before I folded in your patches to clean everything
up; I don't tend to test individual patches if the whole series
works. I guess I screwed something up somewhere and then fixed it
later - I'll sort that out.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
