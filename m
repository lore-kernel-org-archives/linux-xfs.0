Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E001FC3
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 23:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747091237; cv=none; b=Ubr2rcU0fnHzGqg7fvR1RGrrD7S4MejRRNTdLwWSyb31CAA5W2z29hjGd/G7JGojNTssEWA0S5pvRVWBZGkUCJLjkvUDnptlLgHI0k8I0gqt4ET+q+aYzsj7V8wQRt6SBHeC8r36+42vLyjLw8Wg8OG9LsSk0P1usGJ4kdVKzfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747091237; c=relaxed/simple;
	bh=qRcNiq83JweqQcYK8kq4aGr2ZJoc2Y2/sCh/irswA1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GrPvBHNKpvwLnZvevNd0hTO+kS9zdeGD+ur3LJCa/xNWmtWrqCSJYhMhTukEjIf1LoJo5R/WhbMow/HsBsn0+7iFSR7mOV1eqnAIgLsBBpT/3S5A6M+y/jrUWWfzIMi7ApTeAoAtjo8pRRFvJNJPpzFh8LcDjB29541s2/8EoBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=CcirjXB8; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="CcirjXB8"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-742596d8b95so2521723b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 16:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1747091232; x=1747696032; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WK7Yd8P7FpRuxY5aAd5983KfadgpMOEiZza+JUavOPU=;
        b=CcirjXB8TK0i1LSeIt2Ods1cGPlLkGkWaoRmkiTPpvY1sUCvIgejlI32HAq/nW0AZm
         fHu1qEsGJ0HI6aFql/5IeKTopobza8AWi1gBChM8rqh/tUEEtOUp4hFMR1PyeOVJkGhN
         pDZ5EJRLdvFpbyc5UzKokLpAEt1OUc9OFkP1MsBy947oHphk2dAQS+8xmoqvAwVe93hn
         dDIJnrzT0mkbROMr1dPPtQxrR/qeidnKWnwiKcm5oyQhtBfzw97gn7wZD7l1blBiwAmr
         9vkjen3D98cbGm5fS8wSgrnj5oZG6bxyLxVT/9oeJYGtJhM1VOaKcfq1MDwXWL0I48Ez
         ODZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747091232; x=1747696032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WK7Yd8P7FpRuxY5aAd5983KfadgpMOEiZza+JUavOPU=;
        b=vMvqSAW+MLJUwqZyQCJQNnNJmqoPeyjNT6wu68TgH5vfoamIw6A8RJvzp5F7DIESAt
         KUKGbbZJ2yPvjduq+pMMWhG16Pr89+7OLqSRuU8sLscTx1YJEFibozEoueorZFL7sGcF
         cZeFl2YpeznQ0ctAHJlQZbq0iaEpuAAfuvCGuSByeEcQcmZRklyL9O1dOcPZnc0B+i6I
         L6N1miWLCQnw4kJNtsWlAfSkC54jSZgi2Bp/V781rieGgzDAfa5M6UjrIoNHTE61a15N
         gdZPEZgYAIq1emHUaszO5OIzatv46sPI5Bmt0IG/vWXYaZSn/e9tjJNThmikHjkio6n0
         iinQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiSde7J299nhwV0czrLP9QmsXbwaScjdfbm/oMsyCu8o4PO6ciMmbnvWg1iWPmVYeFYi0XKBoB1ag=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxNTqYKz00b4H6kO+SR9kzvG32LHvpBeufpLGX4vSAy01+HDLt
	+c0VdV9RBZ7q+/dF2pfFQrAMzNsoVtH4jfTkMtj8+jwsVb5gMhkAew+9r7ZzTUw=
X-Gm-Gg: ASbGncuAW1QJscgbezxqVVr9K2DqFpe1EdtvjJGvDpXLG0fLp4c6QhvZsTx5y+GnLAu
	HV5MmW58+PSv3iGU8RWu/dQK3sRvNsy4e/p2MLZUhgpTcA1c+6zHG6BfkSamX6PsHTzH54g8Vq/
	NuX8RmBaxwEI/0UGnqclY7Dzni89l48WmRYnzWkfjLtmcYGSchAeQh/h/CEB22/APp8fvYgN+c7
	P3RhlS/7LUQ+Wk6I5F6YU2geWOmtAwip6MVY/O5tuz8ARjSRC/CnifTPNxSAZ+NXnoUbfRkAJ6K
	rE0EM8braf4+B1hmqqHE2b9IeqIIbB83wjU1xKf9QwSBb87ofiS/Tsh3+PZXUai529OjCMofJmN
	T2TRvLdLm6dAcuw==
X-Google-Smtp-Source: AGHT+IEwoMBYExdTvspniPjmOtpyEWuDpafJkhtbN1Qs9YtB2zpqDP1aOIc7Sy6N+jI+KDLx+moeuQ==
X-Received: by 2002:a05:6a00:17a7:b0:736:5b85:a911 with SMTP id d2e1a72fcca58-7423bc128f2mr25276221b3a.8.1747091232587;
        Mon, 12 May 2025 16:07:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742377050c6sm6467660b3a.21.2025.05.12.16.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 16:07:11 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uEcEn-00000002lRN-1YFL;
	Tue, 13 May 2025 09:07:09 +1000
Date: Tue, 13 May 2025 09:07:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove some EXPERIMENTAL warnings
Message-ID: <aCJ_HTLLV7zoAYQ-@dread.disaster.area>
References: <20250510155301.GC2701446@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250510155301.GC2701446@frogsfrogsfrogs>

On Sat, May 10, 2025 at 08:53:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Online fsck was finished a year ago, in Linux 6.10.  The exchange-range
> syscall and parent pointers were merged in the same cycle.  None of
> these have encountered any serious errors in the year that they've been
> in the kernel (or the many many years they've been under development) so
> let's drop the shouty warnings.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Seems reasonable to me. I haven't encountered any problems with them
over the past few months, so no objections here.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
