Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D371A248881
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 09:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764839096; cv=none; b=CEKL3bW+vt92KxmZvC4fdI4pKHHEkeWrtC2WYaSJWXwDQwwVg9aTp/UvoNl/KDjV2shczTugCYb7wctiBTDX03MCSaxfF6oXZi506qHsdrmtaqSBczDIoWE5hLKajTOCI3EyJvsQJ4AYh1w4irkfuQzzG2KiSOD7qls8r2d1eHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764839096; c=relaxed/simple;
	bh=9SkH5euyM73xk7P/E0OpUAc7UFJFGl6fHiZY90xPnLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kETX8n7XCp9oDsPTvoaqqJvv4q2wt3kNrrHBgIJ+r8FLdEYcAo15KAvIrS9Ps/bVRkRZPFKo+00vQAVk0CBuKDJPDpfiQpEUMjVydD3YRAToWbWIJLNh1M/IbKl2b9HV9aR2Jco6woKul9A6RPQ8T54La1afH0RXGgaIA4uhZao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rjcKb81u; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rjcKb81u"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso807504b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 04 Dec 2025 01:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1764839094; x=1765443894; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BiZoIGPb2JMTczJoLpKCpG+3kTA2fYAxm37HrUVvshw=;
        b=rjcKb81u+1tdpSIyk2qLxPE8hm1biDsDIaA6MXkg7+/xdwEhOipj3pO5fZWzXGbwJD
         jefxOYPNEdPzEHiN4PfXLrWeIAcWiAcNUS9Frp2MRzRUxx549sNhISXyEzEygP4+yyI9
         +hbpxO+mIPptmEw88Rj6ao2VVQpZF4BCJsFxWiN4SrfxAPOEkFbi399FTCOTVfotlcJ4
         ZeIs+BEdrVvRKpCrrkPLtwRtRQq5mzFxTQFrFnGw8uDNX/kV4UsGQc6SwSei8DPL7bVy
         apR0ch1QfxIQdKk55lk1fbUodd9NVo1joH4sbHpJ7eAQ0EHdvBwaXvAdT1KrID2z0i5W
         50OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764839094; x=1765443894;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BiZoIGPb2JMTczJoLpKCpG+3kTA2fYAxm37HrUVvshw=;
        b=emM8ggHKFYYeFJAjIFkDdt6hc4GiLXYclFivKjz1QLYtHBeeE1MDVaWczBe8B5dykB
         5d1IYo8Bd2y828rWen7WnASm9wIU3+xjYZo0maU4pXU17RR1gnMO8FdgLWeH8MBTG19q
         By2GxfS4+5csi/1eLIygghh1xhqzvBW63pbsAe+vvQrMMM+HGK8BKj3zmrUnkusnHLYh
         +bZNOeoY/vJY+NZFslMIfYvVuwsysYqZnTE6haOwJjRtTptBME7at5Wt/MXHkHR9ibVk
         muWNE2Shz85UNixoqKQxGBw2KQqe78aKXc3WpjRzKTuzWhqOnTuevZ0N864MSwTP/Yku
         UK4w==
X-Forwarded-Encrypted: i=1; AJvYcCWz5SMCY3/mgtRhxV4Dpuk47R1CR+0sa0jZU2YDuRn9FAEj5OmkdHKe77iTtUOH6rCcfJGsWeMSbdU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpS3LIvKbod1hTl7BGJ54XmUHGIfc/RvahpxrBLgLJP5PVkNRt
	FAGP59mCa9MVtOdeF5wkUS4M92H9UZgTHICfSXMh8qL1/GZnaoZTD8PLVvMFpGJ3yC4=
X-Gm-Gg: ASbGncu1HRykleHIDAsyP1YCa9Eq6A23/Gu81haAxvGYvOMXR/6ixj/GYDuHQA6QmVd
	pVxBU4tNlx/ivZgm+4VAJCJllvNNolSbISFpzrFhfRyfGFwoZ9tijcydkvlgrdSQ4+5i84Ut4SI
	XgU0YnGSyWvU+P6OxUTpo8vtC3IJxM0r+TvH3Fkc5RTA0okaIh4o5kD6WDgQi8MZUpQQxm7MbNY
	esGEAOe9SL2cjgAp1yb7xgiDTRUvHAk7V1PdFM6GPcvNn6Jf0TfgLBY25zwmFIH0bE3vMO0Z2pw
	bcP/bqs187wB86Z8GQxH/DPLifbGsyURBQQx1y9N5gQZIx0uNcjRKYP5VZcblK2fC4iRhFG5bo2
	hskTT/BM9WgoMx0c17cyC56PqgZXYwpchW3rvt4cUSAw94AfUqA24wUU3DGUDxmK9G2mscD1DTk
	oksiRPDMaoTJyWC0FKku/cjyfz+PBQr2QaANtMq749STCmoLz20rtmBxxIS81LtivpLXiiYRor
X-Google-Smtp-Source: AGHT+IFNorj6zWqImhwwWOjeI9J8R98k1B5lKWbTueXGpH/Yi6prYwzd5ttspjMV2U34vx4aVZp67Q==
X-Received: by 2002:a05:6a20:9184:b0:352:eede:89cd with SMTP id adf61e73a8af0-363f5d24cabmr7398247637.17.1764839094004;
        Thu, 04 Dec 2025 01:04:54 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e2aead366fsm1445222b3a.51.2025.12.04.01.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 01:04:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vR5Gc-00000001rbZ-2gzZ;
	Thu, 04 Dec 2025 20:04:50 +1100
Date: Thu, 4 Dec 2025 20:04:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] rename xfs.h
Message-ID: <aTFOsmgaPOhtaDeL@dread.disaster.area>
References: <20251202133723.1928059-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202133723.1928059-1-hch@lst.de>

On Tue, Dec 02, 2025 at 02:37:19PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> currently one of the biggest difference between the kernel and xfsprogs
> for the shared libxfs files is that the all kernel source files first
> include xfs.h, while in xfsprogs they first include libxfs_priv.h.  The
> reason for that is that there is a public xfs.h header in xfsprogs that
> causes a namespace collision.
> 
> This patch renames xfs.h in the kernel tree to xfs_priv.h, a name that
> is still available in xfsprogs.h.  Any other name fitting that criteria
> should work just as well, I'm open to better suggestion if there are
> any.

fs/xfs/xfs.h is just a thin shim around fs/xfs/xfs_linux.h. Rather
than rename it, why not get rid of it and include xfs_linux.h
directly instead?  I don't think userspace has a xfs_linux.h header
file anywhere...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
