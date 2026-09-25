Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D654E80D7
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 19:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790365542; cv=none; b=rcare4cDvqe8it5UhChUk64HN3hVMve6ncadD7WfnPAZsey9RFwd3PNrwr82c5SNsyjaZ/tJo2+pGzGOaQ05kvaE9ITHbEFzqjv+RbcZvyornPkGTBxiGQYXx9MRAcvb+lso1fwgv5LMqvXRNDBfJ1/qmbOp9s1xDIZ7nQH3G0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790365542; c=relaxed/simple;
	bh=qrnU0FU3alSxdclT+3JyWq3EfCdXr+2ufWNZc8fCUDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ip37vaIKRo514opyjU4yo1ydaFB3b9/5hg/kzfsZJYMLuIeCHz0MlolhJB0hcjFkU6A/DQK6utVzAjm6HtJQ5e7UGWU8iFaRY8FHfbQ+/w+pYtPxo4XETNoRZ22z50P+dR6ScQzz4lxH4tVrjw0xlX/ZmYmFvxZAx/h7sdapxO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uf852oVq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fKTaR9nT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uf852oVq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fKTaR9nT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790365540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qrnU0FU3alSxdclT+3JyWq3EfCdXr+2ufWNZc8fCUDY=;
	b=Uf852oVqYfoTvZQ6t39hiYUONPw44e0qBpcSLCkqviZxj6y4hJuVE+xC7A3X/u42NGLQCi
	bkAt8IJtn86hRsspRbozMEG4dIIUfzFJX6vWPHytgvVqkotZDGgl93yGBlWayNoXHe/6te
	3NvoKrHxaUv5rhob41JV8ih4VduJJqk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-k7fggdabP56M5JlQEjdxOA-1; Fri, 25 Sep 2026 15:45:38 -0400
X-MC-Unique: k7fggdabP56M5JlQEjdxOA-1
X-Mimecast-MFC-AGG-ID: k7fggdabP56M5JlQEjdxOA_1790365538
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-936aa34873bso219789885a.3
        for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 12:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790365538; x=1790970338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qrnU0FU3alSxdclT+3JyWq3EfCdXr+2ufWNZc8fCUDY=;
        b=fKTaR9nTDVeYLLDaiRxuMi2IjkD1UYMrSAtQjorPTBR2ZfOq7pzqNyUyioRAcRaQas
         +2LsOGLI2MxtwyUNA4jt7YtI5v8od1C3ZdEVqilOpsXqWcBhFk7nuKSzVEBcbuG0Qovx
         SCb4u4aRsB/ikjxgoXy8i00zQlwTTpXX2B4TgAX8HNmkHBsaUbgegKRT/s9q/KDxRWN/
         ++7cwSiv1+2ursOEl52/D+xHZ4z++S22e9/52qG9rIJbabKwLOiY7niFts85iKlgUJDo
         ZSf7xZ5AZGwtbQK7/0MQEdaqm8GjhogyHtLpFNsC7rAKqgo0SmVybAlr+A1ZNyOLAkJl
         mCOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790365538; x=1790970338;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qrnU0FU3alSxdclT+3JyWq3EfCdXr+2ufWNZc8fCUDY=;
        b=h7iIfPYcxv67qskvYB8A5odDv3ZYT1XR2Su6L4HT1z/nYjCtsp8fJuNelOP4OEzr4j
         1dOA+hoq1QUAEXOslaG13isFNdBgkhA3enJ3mVIIzWKWflo42dO5dfCLgVC8HdxDBS/o
         YtVpFHvIWFjQIv3PVzEacAPcMVDZwzkEKLz5GizHQ+zO9cZTuqsMB2rP9nqr24USn+J/
         jG0865zXINhhRKcDyd+Gouq1uaSMLIvV9/wV+YIhV/QiIC2kvxl7BsjqGJuGfopCWOfE
         k6X3TtVu0YnLun1Rvb2w48ZkILTTuXMWIMkUR8eESPfp47WcdyVnG6YpLA91933EYmvH
         OPRA==
X-Gm-Message-State: AFuF++ngkQlCWM3ZKNWgolFwzqC5x8/DuEsWszkrbRB5iYqunu65cni0
	6BYvFXBn1NiLPKgxSoqESV8YPxeB46m9sPi9gc5SFRQec3slhk+VXjZ2M/+a/iikArhTzTzKYh3
	GDIUHP5Ma7g2oPV9C9UKXHLdEhcUHRRrdJ56/wlsIuiuZmC4+ZMnUZatfAl+W8Z3TGi4xB7SHj8
	meZMGctDqkMzwDm1fmlsRYKdh9Whui/Fq5qu3TBoWjVEvBZuk=
X-Gm-Gg: AYBFou2gGlkTuBMPD0Kv8Z78H/pKmoN6+9TWohEdnJvemZngw/4t2R2dfaamo64wrgJ
	tYyXVefpR++I2iKAZvG0dql6+HineWEikEqYJSUwobQDgeAy/iYgOi41wQkm0aPMu0T83GAEioL
	vcY58UT4mkybtjVQUV6MhmM9Wep2u5tpOH8lL3i9aKR6sr8odF/V2NZRQRSjtx5QncPKcb8QMn5
	axwRvQXapOP2vwldUJvueii9GWyiGXH919crM9/agjwvbRUQgYjvLJG2Ex3H33osPtM0CfpR3K5
	REhWYUqkyXLGATmF8zqyEQ6ssp49tp19WyFYcxjcyfGRQcL/wSb9YQOjVDA/D6rmr2qRz98LgXc
	rlWrRvRVVsYmesFJE5M9q0qcaDGzkjLAxUkSJrw==
X-Received: by 2002:a05:620a:19a0:b0:939:3885:3131 with SMTP id af79cd13be357-93c43b82c04mr664365685a.3.1790365538208;
        Fri, 25 Sep 2026 12:45:38 -0700 (PDT)
X-Received: by 2002:a05:620a:19a0:b0:939:3885:3131 with SMTP id af79cd13be357-93c43b82c04mr664359885a.3.1790365537523;
        Fri, 25 Sep 2026 12:45:37 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c474fcfc2sm227375785a.10.2026.09.25.12.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 12:45:37 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	aalbersh@kernel.org
Subject: [PATCH 0/3 V3] libxfs: better cache allocation error handling
Date: Fri, 25 Sep 2026 14:41:42 -0500
Message-ID: <20260925194535.397036-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

OK, 3rd try.

This is to handle an underlying problem that an actual ENOMEM cache
node allocation failure is indistinguishable from "current cache full"
and so ENOMEM may send us into a pointless cache-expansion loop which
ultimately overflows the cache size variable, rather than just reporting
the bad news up the chain to callers.

Darrick suggested "I think I'd almost rather we change cache_node_allocate
to return int and the cache node as an outparam since we do that elsewhere"

on the last review cycle, and so I've done that here, I agree that it
is cleaner.

The first patch is maybe too granular but for some reason this stuff
hurts my brain a little and I thought it helped with clarity; it's a
no-op change to cache_node_allocate's signature, returning an int
and passing the cache node as a param.

Second patch should actually catch and bubble up any low-level error.

3rd patch is defensive against a case which in theory should almost never
happen after the other fixes.

