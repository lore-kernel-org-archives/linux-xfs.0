Received: from mail-lf1-f67.google.com (mail-lf1-f67.google.com [209.85.167.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143573BCD3A
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jun 2026 07:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781508521; cv=pass; b=jBsarLhvlAw/MERK45oWarOQsKpC8O9ikUDheI28xdIDi8RfZk3nurD1/mY0LaTz3tv2u4s508+S2lGix9a5pGhVnSWpzsuOg0/ZuXZah67mrhJPA8ZLeSrtHv94SKRFMBtrAmLVtZADAahXLk2CYgTnWfZ8kWntsaDnAx+eXM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781508521; c=relaxed/simple;
	bh=U3UUG3D+Xdoh7un9gFqgo0tIKqfXdkVdzcRzXXrPzDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rtoF2rfFqHq9ezjCW2VlX09Uhvvvab3628KuN/JAbPKfXf21YiSxFQyL/BpAiLRzRcrM9zCpD7LVD7+4MsAMgYWlQONtnlnwYpsIph6SNjxy3Ra4exaEITQGvrHrRRO3gFmaj2T90Td8gN4dZKGW+3WTp29PTQeTB2Vw79VJSbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Du6qgWAL; arc=pass smtp.client-ip=209.85.167.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Du6qgWAL"
Received: by mail-lf1-f67.google.com with SMTP id 2adb3069b0e04-5aa61e3d3f3so2337069e87.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jun 2026 00:28:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781508518; cv=none;
        d=google.com; s=arc-20240605;
        b=grXiPJhSTfCwsLsTbachxrlNLDfgw0ImBS+SI6iUGtytoA4nv56y+RayfMM6OWV/kb
         YuKL1CGVEV/WP9hiSF1ip9SKEg1ef9lJpfRp++vmpXRNo+3gjH038Ke0Q41JqFYIyP22
         TSWgl9yaUaJbJ6oM+AxDEcPLL3XwHoEXI6R7+KsuutmYuWkna+BPT+1g74LX2Xexh1oJ
         yyNyi7RhkooRV+DLJKo/DpKL5yIOjHamCHAZzjG7ceaS2MgsHoHSEmjGjG5gsgKzRX4I
         x8YBpyA10IpdGyrnH0Yl8kLI1pY7QsRgRNK5+DaRXpWMRPaVf9ai8LyGEbHelvJCelIR
         ElnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=U3UUG3D+Xdoh7un9gFqgo0tIKqfXdkVdzcRzXXrPzDI=;
        fh=KJ7n+FJ1sOWahHrlnNwP4te19MRQP+6kPrcBSb6KWIA=;
        b=Xq/141I1Sm+eybNVKCqT1W/uA1zeYcYh55fYQCE3DoOuZBtivLaPPa41EGLHM1HNPX
         HgtTOp1MLoWd3wOczVY/5AToIcZrFEY0wq2+Chg4sOjl4icz5liH5SYKKtItd79p95gl
         Psa6yk3HUMiusYAveOsGAHRl9X3PWu8MTCJbTwmC/5ZYuxc9rrSO/rJ5PHOxIYUxYLI7
         gPLwic9+OQSnPf4Q9Kr3CC+MJRfqtfC7BsK68+8ri63uQ0UglnXp6vMc8fVSk2P34oXO
         ReNzoMaE7lWXtp9EqoiJnejH68rxNrZTb83/6HvKiZ1hfJungOLH2eSQnkljxqlmJOE/
         zUYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781508518; x=1782113318; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U3UUG3D+Xdoh7un9gFqgo0tIKqfXdkVdzcRzXXrPzDI=;
        b=Du6qgWALH8h7imAG4P6Ui42QUHEFA83XZkfldDmecotC+mF/JeI4D5G6Ioqkr3n77i
         Tf2XbWFZFM3Mnq9b/Sg87jj7fF/1MpFN0NXbCfgDgCbxH3Z9snm53oc7w76Cg9JBVJfo
         0WQpiDTYeyCALwOslAKrPXwOFrHiwxDMNdCvTgaFkFxuKJquXyUG20qxR1ReVDNWMhz7
         ovzzs2ZWE2QLDBwx1XW0UC6iaQRYuhmUYtnJTK+b6Fez8JPDv3wAfQ3/tXVmlfvfXLwW
         D6OuAiwTfFu30BNuXlAaZu79e0KXagcZE9e2fqw6V0X2NybRaGWbW06WYUlbXynuPaZw
         Ikqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781508518; x=1782113318;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U3UUG3D+Xdoh7un9gFqgo0tIKqfXdkVdzcRzXXrPzDI=;
        b=YFPTSuX3T3ZsJvOcKyw/FDNcPCoFI1OmsUsvY8isoPMnSz+9tgE+7jS1SfBvTLpS0B
         BBtjRtGDKbqOpC2cJXJl9G/lcngyJtqgwMLvCtiPD1C3Kaq99YeOY8jtvKmR+pf4JSen
         IttqieTaol3G/PBZEVBmoAdU6qJtQXAWAhqEmiUqUrNpt1pfebyCJlGVccr9yhLNCOXG
         Ipj6NXcRimNL04BjRH5qJrpB3UINLttRiMW4ZHoaYWXHr/esvFvd9noyqBCBNSpKZs5Q
         RmtxfKI9BNOsDMURzuh7BqNpaiRn0jmzLrEuzfeZmA8gMEI/bnZswU4gaJQIJi5l0lFT
         3nkA==
X-Forwarded-Encrypted: i=1; AFNElJ8aCEeEP2c1RKxzY5QIB9PeR5xTbW9oMMl6hkl/U9K0ydEwK3hz/igh4gD9mQ3636Ti+tWvP/3U3Rs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhnArpFoO/+UzEu9EG2qzzij2czb5NA3+NmgASeLnt0cxZQZWv
	dCEajBOh4Rkb81HMDUVcG3WFK2R/CSoyh0yqe56Wp+LK3S0feuX19Pk/pN1ROoyK1ytabTdnhX9
	T1Lh1mV57Q6+SedP5ajNq3UgXziXBLAk38yGmS56DPXGUJ48=
X-Gm-Gg: Acq92OFyTwNxD1x1XuM1vwvDanq/eOWt/HjqtdfY3zesz1ADIk6XnaIhTmvBF9Ti5UU
	tIjj/moJQq/zg2KNy0zEe1es3ubXLmV/w3azc/AY9aT6mZCisn3unHlsRc6F69rkmtBQZniNcKh
	NA84Q61zwaSf4yFN9P30PeSptrli9Z2mOOk4Z1YPF/5fpYjcCQxknnTL4RLlCFSzWQorrB9kzFt
	JY8/P8XpLrA/7rkQkan8rOzxmEuxZsp4JDJ9b1xGBF8J5zGRBcTD+CcczcTNXYN8ONCXeOJOBPi
	Eb7oihSLzc3YxQjMWV7ApA3kRMkm4dZwVSmM5v3/f1BlMiUMWto3lXKH/HHlqnpbSk4=
X-Received: by 2002:a05:6512:acc:b0:5aa:116c:4127 with SMTP id
 2adb3069b0e04-5ad2db70e5bmr3237825e87.41.1781508517879; Mon, 15 Jun 2026
 00:28:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260610191904.12533-1-m.lobanov@rosa.ru> <20260610191904.12533-2-m.lobanov@rosa.ru>
 <20260613081322.895929-1-rollkingzzc@gmail.com> <ai-ow6hms2DPyXkX@nidhogg.toxiclabs.cc>
In-Reply-To: <ai-ow6hms2DPyXkX@nidhogg.toxiclabs.cc>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Mon, 15 Jun 2026 15:28:26 +0800
X-Gm-Features: AVVi8Cf2JvWe3apiCLdIy9syq1Hy_gNvehwANDVaW8DJ5WEl8PCvyqBKwqHR7r0
Message-ID: <CAB7XQsGL1HUMJ2LxaUUghVSnQKr5nn9feOxZmR8yJnw4=m_cPg@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] xfs: shut down the filesystem on a failed mount
To: Carlos Maiolino <cem@kernel.org>
Cc: Mikhail Lobanov <m.lobanov@rosa.ru>, "Darrick J . Wong" <djwong@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"

Hi Carlos,

> Too late.

Thanks for the reply. Understood.

Best regards,
Zhang Cen
