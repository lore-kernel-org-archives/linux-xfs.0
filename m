Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497895B1F9
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802044; cv=none; b=JBpOKkssBvLTfLdU523AGzIbM0hfxTLpHiFjuqvh253a3xSDoc4X/FRQ65UIEAPQW2yEr5R5i72JgSaeGha395Kqxg4aL4Pce8QsQ+zB0j87M4xr+yvbzcivwzws5BqRDxTAFsRj8ZcQ69aY6/YShe3Z14GuzJxYZJ0PinmVMTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802044; c=relaxed/simple;
	bh=cMY+4+mYBW1VYFJ6gEs40wCD7deEYiySWEj4OnrVNWQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QjwZf7YFek7Q2a8ZMYxjT7uxL4rcbwgB05Q04+goLH8uVdnA81n3hS50OCoc8GebDywNSBMf2uvFcAd+ZpStIQN43aEzmr09wWWRJ0eGJ7deHXeUsFVRcbx5QRpn6rJktf9JIOd+BnEn3BEUJePzR+as0hC3sONvZswmdANs75Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=N7yuhrvl; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="N7yuhrvl"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e034607879so8223455ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802043; x=1711406843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=3zsqxD2/0okU7C5M6IfGhexrIXXpp6tXoPYnUrHakoo=;
        b=N7yuhrvl5duuvSx1P1m3bA0iiC3t8e2VamcdTdm1shqnn7TCQtZXxko68DK/TaEo/U
         n38/7pk0IBGYbtiIqFNTmeEQIvuOUWvHLX5vIGeIaQkQnCzhZ9qGc8bAd3JvIYhvOGq2
         CEmrkRrCa/jPOPcNa3lGPHahPl9inESOqQVgESAVLYlHJEQZRxkb+mRy93iI0t7oTHAH
         x3w0NbVC5fFemMXpKw9YPQMGHlWjNMPul2SN9zyRIpfPvTQyAIoWcrzVVVuq8w4E8TNp
         9Dv+eAuuUVyDMOoQ4dahoPfYS6m4r3YpD1rVYm6Hk1Ort9I0PsAkCPFNNbqB84dZVhR+
         f7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802043; x=1711406843;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3zsqxD2/0okU7C5M6IfGhexrIXXpp6tXoPYnUrHakoo=;
        b=fN2VPebYCXh7yKwv0FS4YcOQoyhbxfQ3s6sFhCjMLvsJ7NK4rUWo6xQavsL7mNz+WU
         qbHJJZRgZgsO56yrwiAZ06KCvJo52Fe4CZLdgFysfL0hqBnQpYP+VIX4862uL9Nl/WLK
         bm7lCNZNHwQanZkhmfab/bQcX7Euh0NMcnw196w+hPVwQ6bUG8t5Q1U1AQeZzYHQe96R
         bsZfNbLMCpuKFsLQNMbm4R9Lpj45DhtJMm2OwzCqWyWgLfSqvDixl1hz4FFqvdEYoGhX
         k7F6Hbj+D0noPvFbsKpCw4IgcesHRA9saLji1CzGyPjvSCXrIpRQb6jaY2kNcO5eZUjE
         PdNA==
X-Gm-Message-State: AOJu0YzkH4Z8lRTZlpqhg37813QLuwLO7Tdxv54MQmRvqoNF+epoSBRU
	2E8X+czcxqiDUO5eGObjlMqualWZcN2PFtum+uDsou3m7DEAgFEyq7cfO7ky8bAgyojgIP9Wp85
	J
X-Google-Smtp-Source: AGHT+IHktBo7ku1hYsWG8mfMzI0m+t/WwLaWu143Log8/mvZ64GwSOjvDtkqaHRzPiFB11rzhfNymw==
X-Received: by 2002:a17:903:124b:b0:1de:ff81:f650 with SMTP id u11-20020a170903124b00b001deff81f650mr1251754plh.10.1710802042513;
        Mon, 18 Mar 2024 15:47:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id lh13-20020a170903290d00b001dddccd955asm9865335plb.307.2024.03.18.15.47.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:47:20 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLlF-003o0D-2f
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLlF-0000000E82f-1Kpy
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/9] xfs: use large folios for buffers
Date: Tue, 19 Mar 2024 09:45:51 +1100
Message-ID: <20240318224715.3367463-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The XFS buffer cache supports metadata buffers up to 64kB, and it
does so by aggregating multiple pages into a single contiguous
memory region using vmapping. This is expensive (both the setup and
the runtime TLB mapping cost), and would be unnecessary if we could
allocate large contiguous memory regions for the buffers in the
first place.

Enter multi-page folios.

This patchset converts the buffer cache to use the folio API, then
enhances it to optimisitically use large folios where possible. It
retains the old "vmap an array of single page folios" functionality
as a fallback when large folio allocation fails. This means that,
like page cache support for large folios, we aren't dependent on
large folio allocation succeeding all the time.

This relegates the single page array allocation mechanism to the
"slow path" that we don't have to care so much about performance of
this path anymore. This might allow us to simplify it a bit in
future.

One of the issues with the folio conversion is that we use a couple
of APIs that take struct page ** (i.e. pointers to page pointer
arrays) and there aren't folio counterparts. These are the bulk page
allocator and vm_map_ram(). In the cases where they are used, we
cast &bp->b_folios[] to (struct page **) knowing that this array
will only contain single page folios and that single page folios and
struct page are the same structure and so have the same address.
This is a bit of a hack, so I've ported Christoph's vmalloc()-only
fallback patchset on top of these folio changes to remove both the
bulk page allocator and the calls to vm_map_ram(). This greatly
simplies the allocation and freeing fallback paths, so it's a win
all around.

The other issue I tripped over in doing this conversion is that the
discontiguous buffer straddling code in the buf log item dirty
region tracking is broken. We don't actually exercise that code on
existing configurations, and I tripped over it when tracking down a
bug in the folio conversion. I fixed it and short-circuted the check
for contiguous buffers, but that left the code still in place and
not executed. However, Christoph's unmapped buffer removal patch
gets rid of unmapped buffers, and so we never straddle pages in
buffers anymore and so that code goes away entirely by the end of
the patch set. More wins!

Apart from those small complexities that are resolved by the end of
the patchset, the conversion and enhancement is relatively straight
forward.  It passes fstests on both 512 and 4096 byte sector size
storage (512 byte sectors exercise the XBF_KMEM path which has
non-zero bp->b_offset values) and doesn't appear to cause any
problems with large 64kB directory buffers on 4kB page machines.

Version 2:
- use get_order() instead of open coding
- append in Christoph's unmapped buffer removal
- rework Christoph's vmalloc-instead-of-vm_map_ram to apply to the
  large folio based code. This greatly simplifies everything.

Version 1:
https://lore.kernel.org/linux-xfs/20240118222216.4131379-1-david@fromorbit.com/
