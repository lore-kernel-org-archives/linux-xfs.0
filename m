Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9033218B2
	for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 14:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761315125; cv=none; b=cePuvv4FFpoklQRgaYmCDYbAfj6E3ntPrLlXFUa3MhaH7Eqh/iq5TwfmDwJUWQ0EsC/YNDZZG/CUDiCj+J5MYKCu5v0/rk8y4ORI6PqJpFM3rFKJa37nEaRUYLUqZZLLe5/hFmqB68Zwdc89t3/MTw0E4PLCFEFB93V7l5CC0Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761315125; c=relaxed/simple;
	bh=HN4SG8Tc9Lo4RABBZetdrW5lu5OU2pYnC/8jcLCSPDo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=K1RJXxX0Z758MmMOaXNcvWxNQ5lHkvbXOaIhqRVGNW7iwhjLDbOf3FylN8opHNNhxUSTAo2nQU+sBh1X2mKj1/cKUSZ3I+lAM+oMXc9ddxL4WDx4sG0BWQbnaPS5FRyuLj0FPoJO5QFqxSXjfS8TeRcdVTs2I4YoJuTzGdHX+Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gnUnte83; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gnUnte83"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b679450ecb6so1541709a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 07:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761315123; x=1761919923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SxjAAwvJxcKyZkTF4DfQc6OYD277RCMtejBYyIJXDsE=;
        b=gnUnte83eRgANIufkHhT4H6ixg/SOQ/MPYY37MLmWcIlUN9L+zwkyqJcOpl1dc0EVE
         jkn/DxSk24ONiyIprFWe8/VXt1ynoKYPSvRHhlDNCZDyHIopkjXwANvVK3nqsyGTuiuT
         hj2azbQLCMm0pkwVXp+auukoHA/8ll0tM81CDHdI+cf/TP5sJx/AYRckxRZe6bJiGStA
         qQWVw4wO8+F+pKIXUyKBW2ENgwqBMuBX9U5FUA1OfnrIbXth35v4XexF/NVyvxUE+dcJ
         8Mmm2QiiwN5O5AKxcn/prT5L/DSYNzAQENCwMD0R/ft/6ckNR5KBC5uL9d91pmzAiJN6
         OS2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761315123; x=1761919923;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SxjAAwvJxcKyZkTF4DfQc6OYD277RCMtejBYyIJXDsE=;
        b=EAUR/sndL8+CZeMRreAB3ete+vL01KT36tu8cmD5K7TDhLDe51ez63sIN5ZHWuyIDV
         kJJrLadViqpBP3ypNdO+ky5B3qtocwgsktbWlfoPzCRn/RdvBdrSt0AhMj4Q/5muEjXU
         j+V0Pw1YdRCL/L3G0VN/CKNV0Z+I47NqjFkkezM0y182JQOkxBemdea24KVPJlfDavm6
         8ZhuEVPkX5WfwCRTY9VSumb6PZzoYRYjSPVbuGWvrjWVQ2hNMrCXWoQn9W7KnsGAakYM
         1wqhHZw6Klkg7vCkasBWfb9SaH0CQD4NyP7ET4xMsDvTrjuN3zomENQFoJfWVmZDOb6P
         jHGw==
X-Forwarded-Encrypted: i=1; AJvYcCUtrVwRsXDptEj69Bfk3juAXaJ+tTPA22LRMtNm9MZIdRQh6QTnvvmBhj+eskFeptwgo8Guh5tAhWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi0v95F9EejnWGZCqwIKkTCYXSyeLaSlgxxxWjh2EgxLnhFE+w
	5WNa9tKXbWcbdOdkx59VGGFe5nSpyQmb9dR65Yzmox7csmVVARkGdy+L
X-Gm-Gg: ASbGnctUVoAXdXNe9sYBQ29pPCHreY6stX1hvbwG9ug6mgXAKPPWb/p3e6YOUH4jpak
	alwjIZ2gqZ3w+NRMwkVEjeosPDJ3Ktu8o47SsjFzuUxI6mTUGOgtdSuxDpjQM1KXWgkwmIanbQr
	+Mmdii2W/nAK9YDnwvQnpI4FM+99GkkveyKBHc7aUZvc2L5JrzzP4H4fm+ybu5JMaAt7/7GwLSK
	NWWyoTppPHyk+FD9QJ1yQWNU5Kd/o9ByEmjnKy+Xrr1G/FlGdT70aLL+K9tcMnzzugX73BcH+xD
	Q4KC1a9fhSkXhZ2y4NxHnxV7+i/de5IICnnok8EmLRriPRnVGTuHMLcL3xjHic1+BRcaFSnIXzP
	noTfp7mqzuG+ba68mSTBCA2OyzxQnrZiQSyIpLnTOpco2QrfohYVWZylvO9x1tel3payYzVhMKT
	lV1amExJrVwgIz4rl2i74qAV9TBI6ebU+G2Jdkymn9DV1/RiWbNuyVVdkPYGQB1CA=
X-Google-Smtp-Source: AGHT+IHvWUViWUbcO4jFDmrP4XCETisDqYKqzRJMqbtZ69yGInyTHi+Yd9XnBN1TIdB68GJvKa9mEg==
X-Received: by 2002:a17:902:e543:b0:282:ee0e:5991 with SMTP id d9443c01a7336-2946e0eb3cemr82154295ad.30.1761315123024;
        Fri, 24 Oct 2025 07:12:03 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946dfd05dbsm57178835ad.54.2025.10.24.07.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 07:12:02 -0700 (PDT)
Message-ID: <c45c71ce0c3dcd321807debfe580c86cc185623a.camel@gmail.com>
Subject: Re: [PATCH 1/3] writeback: cleanup writeback_chunk_size
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>, 
	Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong"
	 <djwong@kernel.org>
Date: Fri, 24 Oct 2025 19:41:56 +0530
In-Reply-To: <20251017034611.651385-2-hch@lst.de>
References: <20251017034611.651385-1-hch@lst.de>
	 <20251017034611.651385-2-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2025-10-17 at 05:45 +0200, Christoph Hellwig wrote:
> Return the pages directly when calculated instead of first assigning
> them back to a variable, and directly return for the data integrity /
> tagged case instead of going through an else clause.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/fs-writeback.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 2b35e80037fe..11fd08a0efb8 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1893,16 +1893,12 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	 *                   (maybe slowly) sync all tagged pages
>  	 */
>  	if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages)
> -		pages = LONG_MAX;
> -	else {
> -		pages = min(wb->avg_write_bandwidth / 2,
> -			    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> -		pages = min(pages, work->nr_pages);
> -		pages = round_down(pages + MIN_WRITEBACK_PAGES,
> -				   MIN_WRITEBACK_PAGES);
> -	}
> +		return LONG_MAX;
>  
> -	return pages;
> +	pages = min(wb->avg_write_bandwidth / 2,
> +		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> +	pages = min(pages, work->nr_pages);
> +	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
This looks fine to me since this simplies the overall structure of the code. I don't think this
introduces any functional change.

Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>  }
>  
>  /*

