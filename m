Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iF2geH0k"
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE96AA
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 04:51:10 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-332e58d4219so2282314f8f.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 04:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701089469; x=1701694269; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lkEnJkQ+8Ev6iHNDxxp1hNcEh3zIdT+74ecMOxzL+Rc=;
        b=iF2geH0kV9npsudi2Kpj/f5nlB3Tio+r06KazJSspbX7gAl0J1PF4JTicwwgrokSrQ
         QuDtScJUZLCwrd+UwSZ4p5ZqrPg0AGrFaGcMU44puZXPD1TNDvdsA+CDMzXGApZJrINW
         dWx0w8QRamEVeE3f8Jl/moT0B+3sRHwnhVhJbUrzIWw4qlIyijZz1d4P1RyI85ValrNb
         OGe3q4Ktpe4M4eRYbKJS/5OgsOG7zF35hR6qf/3FYDuFr+b9P+FlN9jAHs9LxncNM4BU
         2VPO/bPwWrXy2asc5yAjY4UDOYr98mtHQupP9fozGwaOdZ/zG8Q2JhJet6Fe+hB+6IX+
         uPKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701089469; x=1701694269;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkEnJkQ+8Ev6iHNDxxp1hNcEh3zIdT+74ecMOxzL+Rc=;
        b=DtTfFXsCzs7ehy8mN1hrYrYw03CUgZPNmsgNGd6oj/cBBPRa2nViPS/oNRvpIrQBd+
         KUxwftUvNnV5gMIfhkuX57SAyCUHsnSAjnTIun1uAjrjccPxIdjfPo4X1IO29/GxSMIv
         cU0cD6pXCssp+3Nws4x857NiTRH0xiQ8LYEwfV39pgAuP2uHYGKi7e8cL0ETgcAz6rY+
         Hk/nIEK6iqRL+YFIj/RVNsePBHulZUF8M6rfA+9Ey+61oyleQ9mKvos4OmAyLaxmlNI2
         ufwLBSOOn1y4Ray+QQRxPYQrTG0ir1M/abo6FC8s28jjj6/kMzasFsvT9yDoWUifH2ZP
         PSsg==
X-Gm-Message-State: AOJu0Yy1PuV2Ozl4+3bRyxJJ8F/+QxIW5b5o+CqD6l8X4ynzRhogJgyI
	RDL2iV+7QMa0hkicqu+GGbOkxb/1lbcaiRV1NZI=
X-Google-Smtp-Source: AGHT+IESTXcdj+cFasSB8O6jt39AbGsFvEEJSEIi1tOb8PnF7kDzxKBNbXijkusKpfYHALW6AWqHBg==
X-Received: by 2002:a5d:4903:0:b0:332:e4fb:6b62 with SMTP id x3-20020a5d4903000000b00332e4fb6b62mr7426566wrq.39.1701089469383;
        Mon, 27 Nov 2023 04:51:09 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id dr22-20020a5d5f96000000b00333018c4b2asm2271798wrb.71.2023.11.27.04.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 04:51:08 -0800 (PST)
Date: Mon, 27 Nov 2023 15:51:05 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-sparse@vger.kernel.org, linux-xfs@vger.kernel.org,
	smatch@vger.kernel.org
Subject: Re: sparse feature request: nocast integer types
Message-ID: <3423b42d-fc11-4695-89cc-f1e2d625fa90@suswa.mountain>
References: <ZUxoJh7NlWw+uBlt@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUxoJh7NlWw+uBlt@infradead.org>

On Wed, Nov 08, 2023 at 09:03:34PM -0800, Christoph Hellwig wrote:
> Hi dear spearse developers,
> 
> in a lot of kernel code we have integer types that store offsets and
> length in certain units (typically 512 byte disk "sectors", file systems
> block sizes, and some weird variations of the same), and we had a fair
> amount of bugs beause people get confused about which ones to use.
> 
> I wonder if it is possible to add an attribute (say nocast) that works
> similar to __attribute__((bitwise)) in that it disallows mixing this
> type with other integer types, but unlike __attribute__((bitwise))
> allows all the normal arithmetics on it?  That way we could annotate
> all the normal conversion helpers with __force overrides and check
> where people are otherwise mixing these types.

I started writing something like this in Smatch for tying variables to
a specific unit.

https://github.com/error27/smatch/blob/master/smatch_units.c

But unfortunately, it doesn't actually work.  The problem is that once
I said x is a byte, then if you have y = x then I would store that in
the database.  If the first "x is a byte" assessment was wrong then the
misinformation gets amplified times 100 and can't be purged without
a mass delete.

The second problem is that Smatch automatically determines that a struct
foo->bar is a byte unit or whatever.  Which generally works, but
sometimes fails catastrophically.  For example, it's not true to
all the registers are used to store byte units.  But some code does
store bytes there and now Smatch thinks the everything stored in
registers is in bytes.

My plan was to go through the false positives and manually edit out
stuff like this.  The problem is that it's a lot of work and I haven't
done it.  I did a similar thing for tracking user data and that works
pretty decently these days.  So it's doable.

I tend to avoid manual annotations, but here it could be good.  Manually
annotating things would avoid the false positives (at the expense of
missing bugs).

I'd prefer an annotation that had the type of the unit built in.

Creating an annotation like that is difficult because you have to
coordinate with GCC and Clang etc.  In the mean time, I could just
create a table in smatch which has stuff like:

	{ "(struct foo)->member", &byte_units },

regards,
dan carpenter
