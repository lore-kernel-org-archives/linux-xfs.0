Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793999496;
	b=2Sa3ajVTqXyAQyIQrwmZhcShzm0JazqUWe/r1rRjSb9U0i27X262d+BPa4IWon2vutj+
	 JJzxkewrjmo4dAQMHCjOvS5s3pGtwHXC8+EJoSKu6n3PPwvNa0z2ZRxD50naYL7iGxN6L
	 IsUcgVzKDQ728u9ksRc7mPqzkGWjsw00l0gCjWa9xwfmQOlcmIsFs32vaplBoB3UlXe8q
	 UXB2m6JFQYnEtwXLiGz4XF/cg9uylfprYlJPq/YL0nS6xD3u1h6tNsiD6pO+xbeQh5Obp
	 MgUl0dn8EVRi5OzEvulSZC1HZq2MZaA+skdBhM8YaztXRr4cN9jUvVD7utUTNRDasWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793999496;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bbrhdyUz5qdgRRQLPbAvT937IlfjVVEaF0bmYaM2kio=;
	b=ou1mGcy1xgp7NgZtt7cOMxNrg+5zYUVtrA8DOdPHRZmRFpKOBj2/Xs1N2aa9AuFyPmUQ
	 xbgvvAruud/x5C2QWARGeF3zrEkMCqzKnKk2Uw65VujpAGRfsP0/s0rdmaRrHP4r+t3vu
	 Fes+ivbXhPGjZ11pcb5BJy5bO0k7mhnNkCQJXeFxvTGnkDQLJ7oDUtKhpaB7wjJeYHz8r
	 2jdJGSsCFLruxDQpSVbH4itjdk37gdDhUewOUz5Mb9t5BGxVqZo/cV9GXESGZ8SH3+zKb
	 eJK4R4QgZgzSrYkyi1DLq+q1/JFOBQN+Bxwli0VsvIeI07pPbxb0BAWdfcVxryghI5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Q2BAyV3m;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Oqi47ZbF;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAFF606A326
	for <linux-xfs@vger.kernel.org>; Fri,  6 Nov 2026 21:11:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFAFF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Q2BAyV3m;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Oqi47ZbF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793999494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bbrhdyUz5qdgRRQLPbAvT937IlfjVVEaF0bmYaM2kio=;
	b=Q2BAyV3mbDzpz3No+UnwwLB9ZeWFSKOzxtojFXY00eLXQYOCNMR7K7sxDKj5rCiyXyFxfL
	n2smfCm9g57k+fTFA/cTZCbyDM0oDmRnKP8/Cm2fdIKsFcr37KGiKFWVpsJz4MG9upokK1
	otJEOM4pePxFwuR7qNMz5VFI7kG9eLc=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-W9GkNh86MJqJQiS-iffObg-1; Fri, 06 Nov 2026 16:11:33 -0500
X-MC-Unique: W9GkNh86MJqJQiS-iffObg-1
X-Mimecast-MFC-AGG-ID: W9GkNh86MJqJQiS-iffObg_1793999493
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-843cf077bf7so1725034a34.2
        for <linux-xfs@vger.kernel.org>; Fri, 06 Nov 2026 13:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793999492; x=1794604292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bbrhdyUz5qdgRRQLPbAvT937IlfjVVEaF0bmYaM2kio=;
        b=Oqi47ZbFYak/idTHbT07GNereYZgBrHFMss990oAVKnlXgRN+l1a85f52BJ/qsL2t+
         yF//r9vFqb9fNZmT/GEL0cQUm4Nb90qcFBNdgnq6rxFztVhDj30wKikvWjUufep6L/lb
         o75kBWyZqFsEoUNsoN7siLtLotIcdQfV9Wpzg59x3s7A0AKzDgrIeKOyzy6ajk3wYKLL
         jocdcozXVThkHEA83TfqjWfJFJDUrIXtm9UkiKDsJ38fTMAXlKuxHfMsT3yi7C1ikC8u
         vakvdS7o6TNgjugZ2IkoC894BWoK3183zXamaWd6hv53LXsZCaUoGPgXmEjYVtVoOpGe
         fbww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793999492; x=1794604292;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bbrhdyUz5qdgRRQLPbAvT937IlfjVVEaF0bmYaM2kio=;
        b=T2/Lo0Y+TLmTgez+Q6w5Y7WUxSfLDsa0DAm+x7db0QMXYMcldK9TrJN2t0CkaeDpdG
         34n/0w9Ocx9JdCPCDjGPRlylbATda/zLylRQy7mesvpjox4GW3KCwbtey3GIUYeNhuPM
         11i7tWIRwyYJYWynGO4dCzeP1a2eM1iOXYldFSz5Pl7jEBs+xJ8Fzg5rhSxYS2m2YM4o
         iVl4o1FhG4zvEXclxWZusM7Z/u+CvZjMyQxhQgtX2niz2RfsMkCxEjui+CyU0G0PmBbm
         2sHt1dYlSgMGU5Uw46SrgN0WKclaGYEjuPzqRWNJ2sxvirdkGnFFXeJsp12nbVRnCiAi
         A6Fg==
X-Gm-Message-State: APuU4Z/kMpUl/fiYCL6m9wzUvA+i4Q1DGVQgnE8uWeWXSuFpu9Q1Ck6E
	M+ginoDisOKZX4fIV4DwCPGvInXINKAIENkM0Np0fdrjM1LD9s9yJyJSMBxIIP2rmfF3ScBDuWb
	O3YVFvX4ttkisUSNjlQ6/jaN58YpuKHEvSO6gZ2ql0RontX6VvZ0PfJzKDywltTppE51DQPw5WU
	chZWW1Wj5XMGhJ9W2JHQsbFR2+khBn1Ff/QRMk6XFyPsdx
X-Gm-Gg: AYBFou24NOJy+418pTg1BE2QSwx69GD/rqxED9OPvut90WG7j4bqUJNkap6BvmJiYuT
	QsyjaLaVBLSWFwAz8mTQD2p9EmcLSrNNkgM8spEMiN2zmqFFZXxA8BXFO4UzHTKqHJsCdh7umAn
	rVa+bfxKqrUD4YhUIrRf6wpTllsZDsSWFRWCMMWrfM+YjQ7fPmBsifJvUGrJLzFnSO6Mj2aHX02
	wBWeWfcypIJxdvdtl6yoHqGZvusONANe5GKNK+9F0zmx/7BKrTNP1jLghY9vdnZ+a8lvlMnXWLx
	MbJ3K/quYRA9mVkJh8TfIwg638i2rkF0koxbtM8nsGCtpYEPH5e2IbuFm5qwB0IUoLaZyNxZRS1
	jDyaWynS7oex8hn7UmleLxMTP+87DOD/dZF2JfA4l3EF02ITRjNzsL4xTFVv/NF/Ahud2CTVw/x
	t1ILWdIQAX/sJ5kg==
X-Received: by 2002:a05:6830:82f4:b0:85f:12ab:5e52 with SMTP id 46e09a7af769-85f1d171ef9mr3187184a34.27.1793999492541;
        Fri, 06 Nov 2026 13:11:32 -0800 (PST)
X-Received: by 2002:a05:6830:82f4:b0:85f:12ab:5e52 with SMTP id 46e09a7af769-85f1d171ef9mr3187156a34.27.1793999491980;
        Fri, 06 Nov 2026 13:11:31 -0800 (PST)
Received: from big24.xxmyappdomainxx.com (174-20-5-40.mpls.qwest.net. [174.20.5.40])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85f1dd2bbb3sm3429304a34.18.2026.11.06.13.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 13:11:31 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libxfs: capture error return of cache_node_allocate()
Date: Fri,  6 Nov 2026 15:11:29 -0600
Message-ID: <20261106211129.3042825-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I guess during the revisions of this series I managed to lose the
actual error return of the cache node allocation failure, which pretty
much defeated the purpose of the change. Fix that.

Fixes: 92d45f83 ("libxfs: Return -ENOMEM on actual cache node allocation failures")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/cache.c b/libxfs/cache.c
index 5cf6bef1..81509cee 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -475,7 +475,7 @@ next_object:
 		/*
 		 * not found, allocate a new entry
 		 */
-		cache_node_allocate(cache, key, &node);
+		error = cache_node_allocate(cache, key, &node);
 		if (node)
 			break;
 
-- 
2.56.0

