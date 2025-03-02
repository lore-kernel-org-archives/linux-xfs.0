Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B492A13AF2
	for <linux-xfs@vger.kernel.org>; Sun,  2 Mar 2025 21:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740951363; cv=none; b=idxcuXaFPM3mG39ApnKD1POVAxL/J+MxA4SVXJwWFoMdnHfBwSR0YO9ca3vL6R4jNRP0SlTe6jvJ0Wx7ZivdLdgk9eJQ5WhMWAFThX8FfbZthXt18oikzPVfL8q9pJB+TJA4AYz8KXCBHOB7SYsgqaId534jU9RPu+tXOeg5/8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740951363; c=relaxed/simple;
	bh=Vi1ahqBonGpjrg2PEWKZLVcuWf78WV5TpJRGh5ZcfbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A8D233tuP4kY7RovzSVxDINMgWrj6ayIBEhFIrvZL1NH25NH7tkmMrapc/i3WdED5K4h8ObJxLYe2QmLH/zV5WkzRPr5zgKLG9zzCshU23tbwVh/4/4kzqxCrK+oJhYrgesROUlSiV5G9TG22RHGnDpIYvXn7XYHQI/LcHRLlMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YCGa/Mxi; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YCGa/Mxi"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22382657540so19777895ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 02 Mar 2025 13:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1740951361; x=1741556161; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sLhjlRFb9FxCIkbEAsGqVYWBx9J4SRJUCGTiHpg85ok=;
        b=YCGa/Mxi7ySmnlvSzSTA5uG10jbzLmi5kjxMxm6usdbpeZYzBMqAbUEEhrCbP2ZunW
         +v7bWaO0mYS/5LGX6F5uJdt5DUtz61aJMiK8g9+5W713FVipgRq/W6oo44BnBlWOGf+V
         jFMbGmu0fny6HBRGQXcKut4CSVf1bl8Wj3hZb4CjDXDDKt/qdO6d7faQv+bGvxAZ/8Vn
         pIdEOv76PH+JiQC9yADbNQ8xKwVzTaF1odAXE26ViL0nw1FkNcFdsn4PWT8Uazlf6yiL
         DQ4HAYvfRuF4W3PDqgmHffxjuFHSPt+EzlGcW6QFaCc+/7BfChzjFXN0jItji8cghazw
         KVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740951361; x=1741556161;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLhjlRFb9FxCIkbEAsGqVYWBx9J4SRJUCGTiHpg85ok=;
        b=WUQObSc0vwzPHOVSCaISXVf0A90USzj/AFxbugjFgv8c85l9VbsrGklbdK00iBb94c
         6uuX/94d/qvE6Z//QkAwOOQ2FqOVWUE5auTKA7lGUl5d+aMO5BFvcIRvkLGap1ak3B0B
         hV0Iht08Rw4Z6Ki8TqoMjqoIw5FTB7lzrS6nku9jR7F2vQlHYe2ES3kOduhXPKUHR4Dh
         cDxtkR3qQGZt4ZLmmptLgP+ZSeu0oohN2YlxUwZrB4gt+Hvz5r0Ki2hIurWG4TECPyYm
         aEw1h/d/fj46UVv/JQ2yCEHZa9zu9JWWe9/39ZJItLxwqpCnwA1dXbFiYp/A/fZaxFUl
         cq6Q==
X-Gm-Message-State: AOJu0YzrsuO0kev/4OV/Ra8Eu2ZcROcakbquBEsLnEt+gkz61g6h5CLQ
	qanipaLMyHh0fSOmw8IzgPyK3d+pidgPFXB0U3TR3U/XiJmstAKd1TcBiMpCGf3QKWW1kLGjtZE
	i
X-Gm-Gg: ASbGnctCQuKFwXSOsX1Swm9m56eyE0RSmpeuNLoRmubH1xlKpoB2HfvQZLfyz2BS11+
	jcphGTVoSYt8MsD55iyILfItvDzkUlRCo4hrdq1WMn4BbajjmKIlvf0Z26785Eq2q8rULRvBrD4
	AmUl9HOV4pd3/pfhX93et+jaRxoki+vHkqUQkf4iWXJsz1bPGRrOCETITL0OtqCuofNkWotwr33
	Ej/GZMUcKlH0OdGdmyl4BlTf+BSm6aLlJVPc0BHNsujRWXrCfQyC3eme19K7rrQGc1hTCIvlZka
	uuzlmoaiectD6BlKvxv6ph4LBGC+kKf4Q6cM6xlsIexSj+FS2q/iGcP1Jlgqm22hbw8cUkQvg/r
	Oc5qnYzPlJJ3R6ZytpK2A
X-Google-Smtp-Source: AGHT+IEH+IYdiUWiJUXXq8l28e5wBpaKi+TmPc+MX9B6l31vruEnMkNjQqRzGyVebbB9Pe6Z3xWH+A==
X-Received: by 2002:a17:903:198e:b0:223:4537:65b1 with SMTP id d9443c01a7336-22369255638mr162599425ad.36.1740951360929;
        Sun, 02 Mar 2025 13:36:00 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501fbd47sm65177365ad.67.2025.03.02.13.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Mar 2025 13:36:00 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1toqyb-000000083MM-1Imq;
	Mon, 03 Mar 2025 08:35:57 +1100
Date: Mon, 3 Mar 2025 08:35:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Slow deduplication
Message-ID: <Z8TPPX3g9rA5XND_@dread.disaster.area>
References: <20250302084710.3g5ipnj46xxhd33r@sesse.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302084710.3g5ipnj46xxhd33r@sesse.net>

On Sun, Mar 02, 2025 at 09:47:10AM +0100, Steinar H. Gunderson wrote:
> This ioctl call successfully deduplicated the data, but it took 71.52 _seconds_.
> Deduplicating the entire set is on the order of days. I don't understand why
> this would take so much time; I understand that it needs to make a read to
> verify that the file ranges are indeed the same (this is the only sane API
> design!), but it comes out to something like 2800 kB/sec from an array that
> can deliver almost 400 times that. There is no other activity on the file
> system in question, so it should not conflict with other activity (locks
> etc.), and the process does not appear to be taking significant amounts of
> CPU time. iostat shows read activity varying from maybe 300 kB/sec to
> 12000 kB/sec or so; /proc/<pid>/stack says:
> 
>   [<0>] folio_wait_bit_common+0x174/0x220
>   [<0>] filemap_read_folio+0x64/0x8b
>   [<0>] do_read_cache_folio+0x119/0x164
>   [<0>] __generic_remap_file_range_prep+0x372/0x568
>   [<0>] generic_remap_file_range_prep+0x7/0xd

This does comparison one folio at a time and does no readahead.
Hence if the data isn't already in cache, it is doing synchronous
small reads and waiting for every single one of them. This really
should use an internal interface that is capable of issuing
readahead...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
