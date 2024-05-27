Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECA513AA37
	for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 23:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716850805; cv=none; b=chyA9i/DbEKWIzXj3OJ5gHi4SKmN1H8jnbzLhLSErzVHrgAZGv16BxvQnj5HZ405WjHxy/McgOzEuKf1n6wfau8Nl9HgLL9z0UcNJFlMwxqjc/xxO7dZfRacgr7/rM8M5ISBh8F8otDV3i54qghBuVTcVf2uaO0iM6oz+hfQQZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716850805; c=relaxed/simple;
	bh=E6G+aqZWHlnrTbYwGo6oAwibuVwDcI8D1UquvAIxiPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m4d55Qe19ka8tRnawYo8Oyfia8kRAD1h5uqnG3MSgAxfOPDxyF5LncPdfqHKwxcemYo+YkpYK56NJl8SACL+cd3azoi4M4ugFqqUFK3jTRNepWehLFdkvWk+SJ4idRAc/Bu3ZOtELGVne1g7hdz+911La9FXz//ffTuJGjXTGrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Fi/j6fy5; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Fi/j6fy5"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-681907aebebso172001a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 16:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1716850804; x=1717455604; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mper/xMT5Q3IYA66Il/PWwArXhSI6HTMaJh9R/qoXig=;
        b=Fi/j6fy5QCJ62i5AD9zdW7pxC8S5h15wi80AHpJyytYNlQXmn1C0m1OK9RgOxrUlOX
         Msde3hlZgkTiLiuUil7BfYPUnwwCvSs02vIT+HH5eAKfBwrqpMcBfITG3kwF1/1rtAVo
         btNwcLD/vQ7Jm2I+P0Hnyahve9r9V4Co8+a9m0XOEfLP3GGFpIncynUGklQQz86WawVp
         aM5viVNDIVZ7HzZOHAlAKEabsFWji1BqYVnTiWpY2KLemm5aX5FWMjpCco2L0OvtZWMg
         kEUc/CIkQ5ynA5PmoL3NnBcgBTsJgNKzmYw5BuFa8fbDtw4PcZSVw+3unWzBCrsnoerc
         LZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716850804; x=1717455604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mper/xMT5Q3IYA66Il/PWwArXhSI6HTMaJh9R/qoXig=;
        b=KpccIUNJvVD7LxxSRHCuc4G6NSZXTZVv4pJAQ4YynmJrP5AA4tjByfpy/2Bd95HSNI
         qA645X38EzC4ff582XLGqT+56N6zmi6sf2yrIHBwGUh0DZ+2+DC1EuttFhb+pQwlCgsG
         NM1BA/Gwq+Gz0Olvp2Slx92uraNSN0/mX/8Dz/zj8eCjnCgka9HAQk2qTplTgT0uMCqd
         ODeuSFIHhfU8SbNpuPZfHzkiEXjvWvM8ecpVlzlJDBYTNR8X4tsxISptsLdETOxINs5H
         asTwZCLtjguXUXUAe884lk9fy0GihNTJdMh7hvrOSl6o/kNSAfciV4z8uZsr5e2pB3yy
         zujA==
X-Forwarded-Encrypted: i=1; AJvYcCUkb/KvVSmWrCM5j0XMyDiM1YAt0pO7iDDN1u6LXQbiyKUJCllQGsRnJLhn9lQkZNNM3PEYymuoHPXFvpX2dpfYawREuljDclLr
X-Gm-Message-State: AOJu0YwdKVe8r7342XdDdd0FU/ave0AwVjDZErnwqhOmVd4OWlZe2HOU
	b9aT8eYBFtAhpnOmgE5rx3BhLDRE0sK66Esy7do2nvihF1UV2g/r9dRG9Q/tGvw=
X-Google-Smtp-Source: AGHT+IEBodEV0O3WOFxNjrc1u53pF65Ap/xAuIzuYtY1hdwU+UtlwfxMKYh27HDGJMMdTKbqi8t8ng==
X-Received: by 2002:a17:90a:c586:b0:2bf:fd73:1494 with SMTP id 98e67ed59e1d1-2bffd731533mr1282947a91.14.1716850803550;
        Mon, 27 May 2024 16:00:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f9b8144sm6337308a91.55.2024.05.27.16.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 16:00:03 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sBjJw-00CoWT-1R;
	Tue, 28 May 2024 09:00:00 +1000
Date: Tue, 28 May 2024 09:00:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
	akpm@linux-foundation.org, djwong@kernel.org, brauner@kernel.org,
	chandan.babu@oracle.com, hare@suse.de, ritesh.list@gmail.com,
	john.g.garry@oracle.com, ziy@nvidia.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, p.raghav@samsung.com, mcgrof@kernel.org
Subject: Re: [PATCH v5.1] fs: Allow fine-grained control of folio sizes
Message-ID: <ZlUQcEaP3FDXpCge@dread.disaster.area>
References: <20240527210125.1905586-1-willy@infradead.org>
 <20240527220926.3zh2rv43w7763d2y@quentin>
 <ZlULs_hAKMmasUR8@casper.infradead.org>
 <ZlUMnx-6N1J6ZR4i@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlUMnx-6N1J6ZR4i@casper.infradead.org>

On Mon, May 27, 2024 at 11:43:43PM +0100, Matthew Wilcox wrote:
> On Mon, May 27, 2024 at 11:39:47PM +0100, Matthew Wilcox wrote:
> > > > +	AS_FOLIO_ORDER_MIN = 16,
> > > > +	AS_FOLIO_ORDER_MAX = 21, /* Bits 16-25 are used for FOLIO_ORDER */
> > > >  };
> > > >  
> > > > +#define AS_FOLIO_ORDER_MIN_MASK 0x001f0000
> > > > +#define AS_FOLIO_ORDER_MAX_MASK 0x03e00000
> > > 
> > > As you changed the mapping flag offset, these masks also needs to be
> > > changed accordingly.
> > 
> > That's why I did change them?
> 
> How about:
> 
> -#define AS_FOLIO_ORDER_MIN_MASK 0x001f0000
> -#define AS_FOLIO_ORDER_MAX_MASK 0x03e00000
> +#define AS_FOLIO_ORDER_MIN_MASK (31 << AS_FOLIO_ORDER_MIN)
> +#define AS_FOLIO_ORDER_MAX_MASK (31 << AS_FOLIO_ORDER_MAX)

Lots of magic numbers based on the order having only having 5 bits
of resolution. Removing that magic looks like this:

	AS_FOLIO_ORDER_BITS = 5,
	AS_FOLIO_ORDER_MIN = 16,
	AS_FOLIO_ORDER_MAX = AS_FOLIO_ORDER_MIN + AS_FOLIO_ORDER_BITS,
};

#define AS_FOLIO_ORDER_MASK	((1u << AS_FOLIO_ORDER_BITS) - 1)
#define AS_FOLIO_ORDER_MIN_MASK	(AS_FOLIO_ORDER_MASK << AS_FOLIO_ORDER_MIN)
#define AS_FOLIO_ORDER_MAX_MASK	(AS_FOLIO_ORDER_MASK << AS_FOLIO_ORDER_MAX)

This way if we want to increase the order mask, we only need to
change AS_FOLIO_ORDER_BITS and everything else automatically
recalculates.

Doing this means We could also easily use the high bits of the flag
word for the folio orders, rather than putting them in the middle of
the flag space...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
