Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3C93BE148
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 10:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781691692; cv=none; b=uPvFclaK7t2ffaZ3YMgQLQVadXpWsKEAHdpwEz5YZfa904r6TnCiBD1h6uWKZaptRmKpIAfqHXbRuwW8mruxpXXQrDqq7upDoJ3bU3wbydQwWXpEDVRukKR2RrQhLXXsuft6G+xsAQOzvZcubDi0vYPIq5uyDg4DwGrWtHvM04E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781691692; c=relaxed/simple;
	bh=vujU5rHlqYWrj9YhV6y7ENbtZAnzEi8I2k16rdnfosY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAm41uDBL4Yia5AiO8Snuxo9TOF1SvML6yStKidOSGHM8uEC+BYaMCUIHdLN6Ao8fIoW+Vb55g+QtQHNIKylBFVq9MMeR4lNeIwvwysaR+bZT5pMn9B3nqvla3IKlL6UcN5BFTBem365qsv+9CNXbsP4qi+ZwK3COQkIJYquOP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a8T++37t; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GzGwVXUZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a8T++37t";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GzGwVXUZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781691685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gkXFJRqi/zdPWr/k1b5K2MwrxEVdtfYz/Q1qcQuUSuI=;
	b=a8T++37t6b2dLa55fygZbW8fxaxSPQIKUO94v6hwHI4ZL/gqDvuPsai/WwreW9s+Wy2TNg
	71J6LdvTdlLXadMmjleqmM0sixyHGXVMQOae+C/rwnh6pf9kl+xx/YnteSYfnjLLwFrSwv
	1YyWPjp+C4CW6Ly66VhbzKiiDUB5hm0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-4quljjsxO-eL7b-_vSCiEQ-1; Wed, 17 Jun 2026 06:21:24 -0400
X-MC-Unique: 4quljjsxO-eL7b-_vSCiEQ-1
X-Mimecast-MFC-AGG-ID: 4quljjsxO-eL7b-_vSCiEQ_1781691683
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490b0682d2fso49077935e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 03:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781691683; x=1782296483; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gkXFJRqi/zdPWr/k1b5K2MwrxEVdtfYz/Q1qcQuUSuI=;
        b=GzGwVXUZ+oi9wDwukTQkIRfMLxfpTZOAaaXwlSUpVdQ5bJZhjZDeL7RSihTNbJTDAq
         SGWrkxW2zFL5AC/t6K26ZUTgRUJdGOpj3ANPl05EXHUgldZIy/07/IMxtrQPVyZI2xw6
         jS7zq0swaprkdJwm5/H2hGMP9UNIAm9Cz7J/icQCJUNSTNY2MU4MRoTCfBidpKVk60G/
         GSSMe4d+yNq2te2zAimW5qKwW19xb/2mF6aOo8vExCX2OdVNIQZpsP1tyY/uPzNKAgXv
         hjgPbN/9/XD/D0AXx8Bf0t4XfR4IaKjkCCDzTGIRUvyT9TnmFQrqqIRnQUV5Eh5Mtvqq
         ux8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781691683; x=1782296483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gkXFJRqi/zdPWr/k1b5K2MwrxEVdtfYz/Q1qcQuUSuI=;
        b=Fa5H8aIj9bxuSsvN1B86/xa7MOy6oOsrggDjszz49KPgJb4Dni3TbFvaPELnOBtd1f
         lyy0ElQ6XPgQKBbi0xReX+aYivRqoBoeDKJqVhaxELIZc8c8AADB4qYVF7xD96FCPKsZ
         5LWb5NJzQUOZWbPvFO+xz7lbTolljzs3xNiC/SwAtX/xMuubv/7r2uLjvD0t8cZSN8Hv
         ww8K4jEVWDwwNLMsGIO2G+WqgnJnGxYJ/X3XHLs1cbO7iU+KocHWF9w8/aaf5eZGs9M8
         7cQWsPn0+OBvWwpzhYofAG9X9L3OHT+Bq4l8amibRjlx+e/NxvukLXGi+PeiLM0jf3Sb
         rjzQ==
X-Forwarded-Encrypted: i=1; AFNElJ+xxQ1eFy9d1rAjpYRIo0eZWNqLAKGZIKhvHXECdY4pipKfFQ039EuUFK09mGntNEnFUh+7dgmKEwc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywhrhs9v3+JaBB+a5sJEwT6lXWxrWVrmXzDxyjAJ39pyN1O2l8C
	Gn8sDimVyx2D/fTEMEhX8dZdmXDKxsYJOQbtEA/WUugG9mAKwpytQ6vG4QdxuvOfcX/ATBRWoiE
	yUOGsnZOzyOr5cQNcX6jjVUPKqzMi+2VNHd5IbkX8y0V/cTOLSzoKcZb+e4iu
X-Gm-Gg: Acq92OH37U/TGxa92dS2uLSg2gxMFeHysi2iOZN3cdA6sSw7/noMRRnm6kXN7dxm0yf
	TtqFjsEZuHO4UFQt3DIAvVAH5pzgJY8L0OiDopjd9bJIypK5Ukad2lVZsLnGQ+frkC+kbsJKe0s
	Uk/t8O+WiyDVvdon7QR+sXtD6du3dmpXjYZr8M9tWwh2NhOo/+XgXlEFFtYlEpAGWvFnGjHGvIQ
	FekPAYCozqoYtna/HIu79ySp6x5KGZ05vq6Bk60UIrJt9DefMgE2/2KnRjT176sUeZxsk1BDU40
	v19uL9YSREudRgOMUTbJ39ZSf2YkPmqK3pmYHf2k3bDpA42vXPLDgZZbKajiASsgPoRDimE91iH
	D3bnw8tHOA+K2lBI9Vmej1DuPoE32RpPz9XKq62ewiQ/d5g==
X-Received: by 2002:a05:600c:3b0f:b0:491:731c:892a with SMTP id 5b1f17b1804b1-492333df11bmr53880065e9.35.1781691683053;
        Wed, 17 Jun 2026 03:21:23 -0700 (PDT)
X-Received: by 2002:a05:600c:3b0f:b0:491:731c:892a with SMTP id 5b1f17b1804b1-492333df11bmr53879015e9.35.1781691682397;
        Wed, 17 Jun 2026 03:21:22 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a0e9e4sm134555765e9.0.2026.06.17.03.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 03:21:21 -0700 (PDT)
Date: Wed, 17 Jun 2026 12:21:21 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 7/6] xfs_healer: don't put the slice file in LDIRT
Message-ID: <ajJ1E7UJK_AulakX@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
 <20260611143357.GJ6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611143357.GJ6078@frogsfrogsfrogs>

On 2026-06-11 07:33:57, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The slice file isn't generated, it's merely copied as-is when installed.
> Therefore it shouldn't be in LDIRT.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

