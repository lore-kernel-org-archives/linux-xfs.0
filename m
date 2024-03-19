Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8019B376
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 00:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068712; cv=none; b=JLwvIA9v2UZGo1vCeaMFzjxpGjG432d3kAjMZy+DLJaIvESjhtVCvo0+qBlgRD+cpZZEfDng1ilDMKmCnqy9JVsV7Qiw7elPpbQnUjN+qA9CJLolBhem1rS1SBOacitpmks6YQVNo8eRKG5u8Y7hjcOikP/ngWalIURflNOd5PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068712; c=relaxed/simple;
	bh=6+G1sjHqFPVArExQiyfW7MUfRkLiQCAT4ozOgZwjtwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gzgKvd9KLYKlHyXfYOxKuF5P/DOvuhLRrTvy7Emcr5GZrxMbgoDnGytGl/KoWpSBCMPBsAA/8XJfKndFUjxQRcoBD3TPAyLVKbKJLePitHOGDvRP+mqi0gCc7OCgSG46t5JfLSAVfcVk7Z7u08oHx7dHrqn2f2ZAkQSb8mhz+V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=SOCpfeWe; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="SOCpfeWe"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e00d1e13a2so9572975ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 17:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711068710; x=1711673510; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :resent-to:resent-message-id:resent-date:resent-from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UjGog3ZvffaVpb6rTr/ObLpWPMullTEcsb0ecf3K6VE=;
        b=SOCpfeWene2LHpj5gCDHdyKCFasrVB/J5km4dOHfrzSHDgsge3535lKFwEiY5rzB0e
         osubfV6DwVnFGDcTfJjJgcBFQmTvf6BuCtOgf+R2l/UyQruSn4L7fat5TBNYFZHw7aBd
         qBTV3gCD7xl9M9EJD/E2n3c2V2EI7mp7iK69QG/cyMC3oasR7wv/Q+zroSnFySRLNAmT
         plq8PDIrB42Ne/WPaaPn2Kgo8gdru2HWWuHjdecaptcUdD+OQlJREdp0kD5Lit8h11je
         C2L87FGAJmSl+FjmUmRYF+kbTUjPdhZu3ZRTZJD45SIimdgttdAqjEKcsrCLoEDTkzXl
         48CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711068710; x=1711673510;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :resent-to:resent-message-id:resent-date:resent-from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UjGog3ZvffaVpb6rTr/ObLpWPMullTEcsb0ecf3K6VE=;
        b=gkoDTdO9+wLSgxvQeb+JHSPyvcHhkS4ZPV2f38SpOI2xoOBSb9x6oc1apyp0rx15bt
         eOe1td45EMzl8DMF056LV6Wth7ZtfBJqC8kdUg6mtI0olKPpdZXZ9qhuejVt1j7lJaRg
         pT9mn1OyUqTfUfVZnx5yguxR4eAMfQuhOD5niWi7HrAnp3B1wefByQTWZvaW7MTAMl8v
         SnhTSyts0ATQ/psPIJWo8CJ9HYz/Uip/Pn8K7UeLo+3VqlIV5+83koAjUPqIPu4idIGR
         2kemXiDLsCRKYc1G1EhCha93U4oBVEnvivBL4MYXpsjtTTjXmCDJAUUmP0AN66RCOTEQ
         ja9g==
X-Gm-Message-State: AOJu0YzsWWQRqrIZBbBJCk+ABA8jI8g1FZvzYFcqGgb/bNJNpLwL2EqW
	62ziD7EiKFi9UI2dvgVm2BRJAZYsg+Br/sNghVNqn2MeVPCtfWRri83exVHl+eeW0qBWOmfIkJw
	I
X-Google-Smtp-Source: AGHT+IHIyfsVeY0Bm0Bu6MU69E9eo1XSDEY3purj8swjWJ0NkjkmSHogVloEDV67KPnYDwD+llgzyw==
X-Received: by 2002:a17:902:6805:b0:1e0:63e7:a915 with SMTP id h5-20020a170902680500b001e063e7a915mr1084082plk.6.1711068709484;
        Thu, 21 Mar 2024 17:51:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id z9-20020a170902708900b001db8145a1a2sm487124plk.274.2024.03.21.17.51.48
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 17:51:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnT8M-005TR5-1k
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 11:51:46 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Fri, 22 Mar 2024 11:51:46 +1100
Resent-Message-ID: <ZfzWIs6+6Fw+EnyI@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 08:42:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: use folios in the buffer cache
Message-ID: <ZfoGzbDXQsrtlc4I@dread.disaster.area>
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
