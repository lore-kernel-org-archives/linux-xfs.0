Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCDE2D0C90
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011711; cv=none; b=Z2ldXR1SfANg89pCAR7xa+Tb2LC+kA/L49dqOqZ2jhjRgKeX7b6W9yIgAM0TNE5szlt8g3RK9Jknou9CmR/4Zr/WUwEOxE8fsqyJfq7oaT7oOYhDlQUUMKZr8CqlV2+DGPGj+yc8/o3tZ31kWokLzB/MQMxMXvHqb58fOOWA5ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011711; c=relaxed/simple;
	bh=X52M+M0Gu8uj7Q5U4OGftAEHR/yURkFIRylrzOHz87s=;
	h=From:Date:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QckuNZHlotGQauocDyD1U8L74A59euegJh7zH8uHFQIMrFG15JY04s8nKp5md/d57kf536NiEpD/hP6gh4Apcm7C9lmNiiQeZqqLDKm/xNedxBvp/0etjGq3ZN5yfKsCTFBe/Md+FvoSU7cgQngsG4i9nlW87//RVQ1OpNn2/dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AWxgjFaF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AWxgjFaF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=OGzMvHi9ansEJrv9EtfShqrhANYagxncnWgYWIzetPQ=;
	b=AWxgjFaFWL71qmJW1yjCggyO/ErNxtXEUrOQol4qxUwX9lVM0ebWLKeO2259VqhkAEH0r5
	gfLeAzdK1+xXeEBg7SK82QrylRk0UpVLAPeoLzfyhsfVrjJX+jsGUHXPJqHDxVt5qXBbOQ
	55coFdNNeFvc/EfmAe5y9lhVGns+rTI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-KyQGngFFOTuwJhIdNid7vA-1; Thu, 09 Oct 2025 08:08:27 -0400
X-MC-Unique: KyQGngFFOTuwJhIdNid7vA-1
X-Mimecast-MFC-AGG-ID: KyQGngFFOTuwJhIdNid7vA_1760011707
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f6b44ab789so536715f8f.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:08:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011706; x=1760616506;
        h=content-disposition:mime-version:message-id:subject:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OGzMvHi9ansEJrv9EtfShqrhANYagxncnWgYWIzetPQ=;
        b=oi7P2JdTeI/zxPFUp+aEDgkEyR0nGK4VgRBAWt0QPjWqrWxXn+Hm3JvuXeQo+L7M+J
         WA7VBQqgaUVmrCoKeggzqjmPhPM0Dym171Q9Pp9x5ejMhHrPBoL9/7IjSY43IZl49Jco
         B5jXaUYbwjk27vtzDs7iccK+C9ljWwugoZXFkLvSXnnEPZ2hz6Ae6S96CJrcY9ouHpy4
         z8Ie34se4oYiV6ql7/r+tXan5+9keRW+B616/lNQqSsdBBDi+r//qPClZorq+eIQL0eh
         W3yvL2INSwOmtqMtQybffkFLtM9n35xPaGPPuKWAisxc/3EDbX56QVJH8mSCC6W5qai1
         8SRw==
X-Gm-Message-State: AOJu0YwFRCljAg+VjelJBXS1hJPuz+6g0HqFsSa6HQwCsXcgfJiBtKeS
	AggALCU5oIo34Kavj8PPFB4p2CHAvV4HgeXs0VyMqfffwxmimYiPOWxMf1EUXRPCOxgZYJQUYCh
	SkhD2H1BAIecW2Ek3P8oG++WGOXeubjRlMINKq/Cgn8QYqIesWG4vN31KZvPUa5sok9AsMzgjMv
	HfYEHfOSKRLUqiyTIQ3Ce11Z8T2g0dW+CWm7Z+wYTTFDok
X-Gm-Gg: ASbGncsWVK5egNxvnXvtnHxkhtU9uLSeLrYguG+0e53TEM3ZSzUdssl5ydMukq95d2j
	s0Dzdylkm2RQ3W2ulyiYW+8bAksIzXgACV6ywQXz9Ck+tfgY2d3beRUzotro8xiCxdi427W9gsO
	RcC9ZismScTegpheZELge30oGdRVTQAfz/986ai/3bxsnhDygARoJcvcxEEI0JCEdhOHB6uofbN
	5LRWaWxOG/D/BKtkH//fBZGj217hqOxr7MzUUVpvYvQAVsxFwACar1LyCBZpDXN0ESVpUd7mmi0
	Zh0AZFr9y1icZ47Uo3ET7pIxGHsEEOPY9B4zvhNJoCWeOeU0PqDGm+2IIRNDjcnwug==
X-Received: by 2002:a05:6000:240a:b0:3ee:1294:4784 with SMTP id ffacd0b85a97d-4266e7dfb39mr4519091f8f.37.1760011706149;
        Thu, 09 Oct 2025 05:08:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYryEFn75RdGJmcM10FF8Fj6lAiXZLNfrWGxpXfZBMAECoSw5GoEwnHTqjZE6SPn/CuyMmFA==
X-Received: by 2002:a05:6000:240a:b0:3ee:1294:4784 with SMTP id ffacd0b85a97d-4266e7dfb39mr4519052f8f.37.1760011705477;
        Thu, 09 Oct 2025 05:08:25 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e980dsm37555084f8f.36.2025.10.09.05.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:08:25 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 9 Oct 2025 14:08:24 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 0/12] xfsprogs: libxfs sync v6.17
Message-ID: <cover.1760011614.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey all,

This is libxfs sync with v6.17.
---
 0 files changed, 0 insertions(+), 0 deletions(-)


-- 
- Andrey

