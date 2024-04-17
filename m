Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01025148843
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 16:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370780; cv=none; b=mk1zc1aYwVZurTKbrD8MklrIBXrmRtxUCF9l6JMDjRMtOqOZDm099pGKct5YH7gPugEBsOiDZEfocBA/ERFFWQF4K5YKeaRhiPtY+P2cOFB3XwJoZOG45AygdPkbhWBg/sZwAO4ZSX/+uPBQ+UxNxW03rPWZVIjrJqSt6ytilNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370780; c=relaxed/simple;
	bh=8bWnDcMrRQP5WPqjv9dJJ52jXx7DvWFF4yrfYqNbrgM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qVTHQsGmTMa0fSfFngCiSP2csA2XuNaMZH3S2egXhxM70V5SV66PEgTB29a45xVDgDcIEhuODNJZryQ9whBYzk/2U0zUrVBPAWKtwikYBbG06ITCjswd+GqDc1dJg7VANtCQGXh1Mmco0pktI0+4/uvP6O87w6vGpCdOWddS20w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MjV5pXgb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MjV5pXgb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713370777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hn3b1pj++GGeO1Uf2Gq4Okr8sTcR1DomkiN/SC1KpHY=;
	b=MjV5pXgbf3okOgnDXkDgSSJ5mvUOhESF+9QWnUrSEbFBMf1IgWrT18yyccgXFIAWvQr6iQ
	wXEdOQzRpyJ6jlJ7gCi4h07pTCjVvuPEKymDBrx9U3MS3R0Ug/a7+z0uYKh2Ryzo/m9FFK
	7R6v7kIoD//D0vfeme0aRegvFRUD6zo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-kwYGqdI6MuGYxljY5WGBGg-1; Wed, 17 Apr 2024 12:19:36 -0400
X-MC-Unique: kwYGqdI6MuGYxljY5WGBGg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a51beadf204so316710866b.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 09:19:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713370775; x=1713975575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hn3b1pj++GGeO1Uf2Gq4Okr8sTcR1DomkiN/SC1KpHY=;
        b=rRCnycQ8pcFTxbZ7CXBXT2SbgTVVwAyrCVzu8hMtFwn8/5CRA7fvqlikNWFnbQUzps
         nvnxEuBunjVsJKQfvW6Tl0Z6OJPEoeqXe4CY4Jo76lfNfk6HOOInmjtMUfoJp9FRuKif
         bupH64UBp8HbnG/OPGCwtdRjEs+dpzr4SnTSwYEkj4TiYRCrIptvOAtTZu67B/vEJJmO
         Ni5KzKtIu025g+7+3+1nh3OTzDSGOKQC5W19DrZqpIhvC4AZytncsNofqiQjpC8lpSUc
         25NjmtRM3+FRTIpkURESXNaM68Ky8VpbNOhNl+jhli0ZpJpy3JMJhFnJaT7W048aIBXq
         0o3g==
X-Forwarded-Encrypted: i=1; AJvYcCWrkwAHQ5MK4IWsBADqWZUGux3fWUromKyYkPQjyBBIi39NL22+3FcMRht/6B2VtBQ9+m9YhH7ys+Zg40nDD5Y6hLEHCxd7jZZI
X-Gm-Message-State: AOJu0YxiAOsESsaDAGtEKdX1kkz0Nf8PPWKK39PmW1CVV96lPpWGQEV7
	5HFg5Zmhcdyz/FZ8qrEmeZsoUJ9D2tWirdV7EB551PLfA5blFnf8UmC/vICmyuTzLykKQeE3Xn0
	DLHPbKVe+aRIMu8CrdtHASmva3E1NIDnOwhNXRNnNGaSHMBov8qy3hWWx
X-Received: by 2002:a17:906:f753:b0:a55:5516:39fa with SMTP id jp19-20020a170906f75300b00a55551639famr1723414ejb.64.1713370774943;
        Wed, 17 Apr 2024 09:19:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5NBhzpjEApGKdho30uo0LUWWQsDGIc3I075GFXU4oJX36VvXkasvRnbqF55B6HGQzStvGUQ==
X-Received: by 2002:a17:906:f753:b0:a55:5516:39fa with SMTP id jp19-20020a170906f75300b00a55551639famr1723389ejb.64.1713370774404;
        Wed, 17 Apr 2024 09:19:34 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id q23-20020a170906a09700b00a519ec0a965sm8243334ejy.49.2024.04.17.09.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 09:19:33 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 0/3] Refactoring and error handling from Coverity scan fixes
Date: Wed, 17 Apr 2024 18:19:28 +0200
Message-ID: <20240417161931.964526-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Just a few minor patches from feedback on coverity fixes.

v3:
- error message change to "invalid runtime"
v2:
- reduce unnecessary indentation in new flist_find_type() helper
- make new helper static
- add patch to handle strtol() errors
- set errno to zero to avoid catching random errnos

--
Andrey

--
Andrey

Andrey Albershteyn (3):
  xfs_fsr: replace atoi() with strtol()
  xfs_db: add helper for flist_find_type for clearer field matching
  xfs_repair: catch strtol() errors

 db/flist.c          | 60 ++++++++++++++++++++++++++++-----------------
 fsr/xfs_fsr.c       | 26 +++++++++++++++++---
 repair/xfs_repair.c | 40 +++++++++++++++++++++++++++++-
 3 files changed, 100 insertions(+), 26 deletions(-)

-- 
2.42.0

