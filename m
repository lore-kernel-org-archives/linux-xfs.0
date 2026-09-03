Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C93353A6D
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 20:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788467819; cv=none; b=O7koTCNPy3ySZrAE23lnxTUrsEIwrmvs+dReDM8Num0DiCBmRC34tPHCLJbk4T02cF6wG8erNzBRxeicMfi/2t4XORIDgAnmg/39SMJhaKDsBfcZ6gvuD70vvdj4SsshW2KNZ2TyAI26ucKALH08EkZPTHFsFQ+QlzNbyA891v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788467819; c=relaxed/simple;
	bh=RnvcejmhrZ+0gvGQ3eVgfs1JrKNGT+mu8w9bNfmDnPU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=BlKSDVwOsYPdb9s8M5mqNsJHOLbNJjj88GejpsvD6iNO7PJFLYoZLH4BPlQFXMZMfGcMUhP4xrDwjEdHpOo+Jkr6QZeQiT4E+1vhV75gFOWP2QWbMmPRWclGVJK6fC/G1jwFvb8qbC8DxE8vF0KHZyc+4h9aBpAvqRQqA7s4iKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SBmkbY5M; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ljMUPDFK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBmkbY5M";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ljMUPDFK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788467803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xCadLlUi7rlbzcM3bvc2A64kD3i9uNEZS4K6KORkPPM=;
	b=SBmkbY5MdQ/JhFugRb5x6aWUuynf4HEuH8zEvV9SzcHUYjfUur3N5lACTzLm8BmV2Bj+iJ
	M6QbkLpXIfxul+kBqQ9A1MMwwEC6IVTHYmwNM/3zzFNxCX0Ro052/AodFo2fri/GsoS5v/
	l6OA2Dexyoj50/udxOOneUE5w7DoZWg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-exNTQfHtOH23gWUsqKNv6w-1; Thu, 03 Sep 2026 16:36:42 -0400
X-MC-Unique: exNTQfHtOH23gWUsqKNv6w-1
X-Mimecast-MFC-AGG-ID: exNTQfHtOH23gWUsqKNv6w_1788467801
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93903622880so257811685a.0
        for <linux-xfs@vger.kernel.org>; Thu, 03 Sep 2026 13:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788467801; x=1789072601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xCadLlUi7rlbzcM3bvc2A64kD3i9uNEZS4K6KORkPPM=;
        b=ljMUPDFK4xiTGtpBjhyGMgd8Z4f5wFEh8/ssnTsYbZ3vOXs+7yGqnhQggimlUt9MXn
         apc9mg9ObdpzUhmAicb0ftsZbmODsZnOSfhbrEcO5o2jBCGgb/qMUghbDkx5RUPtJO3B
         VbM6NbJgIn2UoFBY6RJZtsLeRJnEHs2FUyWww0IhgZCiz1eAJjSXU3naPKFSLp9W8y1W
         Hh0GnZO4f+zyBVjSAMNQxDEfx0/FyEJrfG2OFrAmcCawBYtV/D4kBQfGDPnGQPrEHMqF
         e9P05zr41wECvp9ms8eYX8lrC4guxI/J2NWR7dyrx7qQoI+PVEoS2DEnrEwaeW8uzC1E
         Zjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788467801; x=1789072601;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xCadLlUi7rlbzcM3bvc2A64kD3i9uNEZS4K6KORkPPM=;
        b=F7EkxDdBb4wt5KfT71jMvwAGNUnr1QoTqiha7Rd6ltKGOoS8m0GCpdc/BiFqqvigsZ
         loOLpNhuhtIyLMxX4luQ8j8iNNhETM5nErmDHXFiTiOnjKn6oPfCZ8pTcF1X+WmBG272
         zdYmgpq2j1Tlpjh+V7uSR3VVwKCEjTtM/yCvtsvkVUvA/wfkIlBrIX1ohvSj+9xm+6Ra
         aAlzG2og7khKrv7NugmLCYXqPrpAFCgjCIN5yKuO5ZdNFqa8opJuZZlh1RASdwEbX+OE
         S3+9ylmmunIEGWwiL6T+R2XsEHhZTPu4+B/xvYmUOjRhBrZ71oU2x8E7WAeakDUSmpgg
         1q/Q==
X-Gm-Message-State: AFuF++n1bHuG7jZpCyv78jzjoeOiQdRiNjwE+LW+Pp/glF4Pbmr0HdO5
	Tj0oVRX5e9inuhyw2mAIw1viZ0PnWqaWiGzbHlcfHyjPnYeShUwouV4lGI8lZ0eb8x46kzB3yx1
	74lQ9VxlstExMk7wcx6768vYm5vr6qUAFHl4PRcbHSqkYR0oUA3yLaFzu2sS1BFhiMrrV0iThhQ
	SjsUfdMorM8BnDAmb2Au/Y1MunHhdwlI6dtpF5nHtlA8LX
X-Gm-Gg: AYBFou1VxgsnCz6fiIXdx3cN7Gom/LDXfJSksD/JxnQcz85c9VO2tSs/indBdGFo4aK
	tIpf8H4dgSThiQ6DuVIUeAoFwBeEPYWZioJUyKXpdlGg0K59AL1VMUSU380gJw/LSWEPPuIUjnY
	V7YQiP8DOEzeRplKvZTlp0m5iAaAmhQRCWO85c9bkqwasw4Pve6AbieoH/4a4dSWObac4sB+JM3
	Z542ujtt8fj85qdDvQfQH2sWQ57csmarGGb0kE99Q89BEFePhndbLeBbxdORhaukij+4nIPJKf5
	YOSfXsZHn7rwKLrJ9dKnOsT6mCTj5dVAPpSvob66NtN4+wRXEOACVfCGPjLTd2iEIJbQG7Wi5g6
	adI8Ojz/++PSQApGG3N3QWRfsxHZT3g2BJCpRxJWE
X-Received: by 2002:a05:620a:2950:b0:92e:fed1:beba with SMTP id af79cd13be357-93981429bf4mr39353985a.3.1788467801479;
        Thu, 03 Sep 2026 13:36:41 -0700 (PDT)
X-Received: by 2002:a05:620a:2950:b0:92e:fed1:beba with SMTP id af79cd13be357-93981429bf4mr39348285a.3.1788467800725;
        Thu, 03 Sep 2026 13:36:40 -0700 (PDT)
Received: from big24.tailafb26a.ts.net (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397faf927bsm51152485a.8.2026.09.03.13.36.40
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 13:36:40 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 0/2 V2] xfs_repair: improve caching in the face of ENOMEM
Date: Thu,  3 Sep 2026 13:42:42 -0500
Message-ID: <20260903203638.1094907-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

V2:
- Flip the order of the patches; put the bugfix first and the
  cache expansion guard second, at which point it's just defensive.

- Be more explicit about an enomem return due to a real allocation
  failure; don't try to figure that out indirectly as before.

- Actually care about the return values as pointed out by djwong.

There are problems with how we react to cache allocation failures that
are more apparent before:
6b6239689e36 ("libxfs: unmap xmbuf pages to avoid disaster")
landed, but with enough pressure they show up again.

Two problems: cache_expand has no bounds checking, so call it enough
and c_maxcount will overflow, which typically results in an infinite
loop.

That can be triggered by the fact that today, an underlying ENOMEM
can look like a "cache too small" return, so we double when that
won't help at all. Do that enough times and kaboom.

I can trigger this with something like:

mkfs.xfs -d file,name=testfile.img,agcount=10000,size=1t
echo 1000 > /proc/sys/vm/max_map_count
xfs_repair -n -P -m 1280 testfile.img

to force an ENOMEM from the max map count, though the actual
max_map_count value needed varies depending on the machine I'm on,
for some reason.

These were quickly tested with ./check -g quick

