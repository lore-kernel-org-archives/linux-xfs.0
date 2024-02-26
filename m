Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E887F498
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 12:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708952033; cv=none; b=uYwK0JtGdRwfiv2v4YRxlda94VGSd3MImgiUdQJJim0cV04HQR7OzVJ0ybXpwN+wMKnd9QjxJLGhznB358K9USmH3N1VoXa4NiXs2gv2336DFepeLKv4ZvSsIHbaTCCbp/XknIdX9LWt7pAu5pJpbjMkGK4MCZLYW2sZ6Pzq6gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708952033; c=relaxed/simple;
	bh=f4NWMEvtENR9SzNVzxJDvykfXwf7cuvQHiTnoUq/J7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sdjFw6v3yaIuUME/DDbPSmE/xHwclKU0ogVXfQulEM9DIFf6sYuSH7e+1j1LQ0jFhka/TpxRYhOcFU4KVyE0XvYLI5R+eFKUPJDtrZWil1MfWsQmK3gpP86EtL0AenGY2duuU0m75DycuCA9Sja/1o3eAIHPyNuJrM1fR57uTEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rOK68tDr; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rOK68tDr"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5dbd519bde6so2400081a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 04:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708952031; x=1709556831; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gHFzgYHnoAZfPnnOPO/pqXuuspwwVCLPAB7tet4K87I=;
        b=rOK68tDrBtVdlvVqa0J4QyxK42wx3N7pqTq1wreNQE9elsjuu1GjMhoosm0LIRg9fi
         U8UvwtqFXPxM/EaMfKMkIJveRmx7mGabcf/pdHiPvgY12lwFYnt8epX1EZfuwQHF4OGs
         VF2zx9YuAKI+S5sgeS/i53HslG6n13UNXDW0NdD8Y3A/Pv37gu+w9F40Oy/zRD108KrH
         f8fiRoC4N5fzNvpwMhyqL+m85xRIluc6T2/qVDD+/4J5xmjaIoTza49rWMT3f3thU9VY
         skBylXvP6geSPZcA9IeVTr4QTLmAXWjCgenUrtugONAWi/UKOVObCVudG+W6S9CjsrKK
         gCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708952031; x=1709556831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHFzgYHnoAZfPnnOPO/pqXuuspwwVCLPAB7tet4K87I=;
        b=vQJyMNoD6Wc1jvXR9W/GPbgahRMkjqf9AbfKKfxdgaXl1ZBtUKV0s7C5YbD1vpRCaw
         pL0aXLDivcQFb7szX72e4kcb6VY+1CsG+moJw6+BwPfZi3LgnC/56B65Iu3NuW4lTSzd
         TWnamuvRG3kOH8DQb/+/uieBux4KTynQGhJLwWiEwZIUVHRmdDlc3uIRZVw8zh+Ho7gw
         mefMp4fF9ZL24r4U4RWnhfRd8NxooqMHWdZPX85gM4f9tdXL2Hwa61OK9YwiPZKOe1cI
         xqhq0uuhq+vhzb655A7y9UuXg+Pdn4ZceuoJGotYgjlAE4ktB2clrrCOIBxTaslQaFMx
         qq9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQZnuTjFzLleE22/3pAf43+cLxnlbN5uGWRSdmPixyx7GQU33P4dgq19EtZR42N/0SUczk/X43OCBViPfEvE7aNDWJ4xQHQ94G
X-Gm-Message-State: AOJu0YwVNaO+WqkoPESVRljd6eoGTTSMJZ42GCWiRyD8HVfqHeh3mQ88
	dLn2k5d97+4LDvXIymrUbbrCvZcnk5OelQ2gTEbP2CPTD1LTndzYU9tn16+v5Kg71+Gfknhfr4M
	x
X-Google-Smtp-Source: AGHT+IGf75kwgCb6FEizA3tnr72rNrc9moyA391ezrNyg0MSRsPu2xStc5P/CX3PoPA+bPRhIIC3iw==
X-Received: by 2002:a05:6a20:ce4e:b0:19c:6297:13b1 with SMTP id id14-20020a056a20ce4e00b0019c629713b1mr6231154pzb.58.1708952030941;
        Mon, 26 Feb 2024 04:53:50 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id z6-20020a170902834600b001db94dfc2b5sm3858832pln.107.2024.02.26.04.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 04:53:50 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1reaUO-00Bl1f-0n;
	Mon, 26 Feb 2024 23:53:48 +1100
Date: Mon, 26 Feb 2024 23:53:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PRBOMB] xfs: online repair patches for 6.9
Message-ID: <ZdyJ3EYJzBspSWzd@dread.disaster.area>
References: <20240224010220.GN6226@frogsfrogsfrogs>
 <ZdxnZnmNvdyy_Xil@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdxnZnmNvdyy_Xil@infradead.org>

On Mon, Feb 26, 2024 at 02:26:46AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 23, 2024 at 05:02:20PM -0800, Darrick J. Wong wrote:
> > pc : kfree+0x54/0x2d8
> > lr : xlog_cil_committed+0x11c/0x1d8 [xfs]
> 
> This looks a lot like the bug I found in getbmap.  Maybe try changing
> that kfree to a kvfree?

yup, I think it is - it's the freeing of the logvec chain that does
it, I think. That memory comes from xlog_kvmalloc().

I have no idea how I haven't tripped over that in my testing as I've
done plenty of 64kB directory block size testing in the past few
weeks...

I'll get a patch out for it and the other kfree issue that was
reported late last week tomorrow...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
