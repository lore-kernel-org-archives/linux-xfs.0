Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794101076;
	b=PtkL0RXcUECwduKuBAJyV7hLakxYOB5ww3gmXq5+bn92DYfq99aP1ERwHuHjBPAvUPmY
	 mvjiujJfoKr2tG6DDmD0lCmCrzx4rRTZQ/EvW8kgjHNiVNGR4P6Z6NUmdeI+alWtdkOe0
	 +ruB1O3WbSm6lbHMZGOmXx2ASXfmhOJHma8VCzzFDD7YzfPkB9I9ue8zQ0ofWAtQOgnIm
	 Czm76a3r8/z/6GgST4AdWlr9Lysbnizi6xyjcc/Ir5AxD8ck8jKgR7Qko8vSpkD2OG0qH
	 Q8qhT9Kit2gzNnvtOThusEnjwtn4ax4+tmjkFiAeO01hqHDonebdIAbOj7uTyMQdslw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794101076;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=KK3Fq05Nfl9D5uQTn0U9knr+7nrtHIbp74CNcfFGaug=;
	b=QpqbPJf/3ETCn/qpNAASXIYMv7Y06AtlvZvNh6XANoXOOelPNrpFCyARsumJzNEKAISK
	 HIVMfBPlz+zZpppnd+M/yiD/LcKVcNmegw6WeihszXm1DDRjqXqGxHutw5JpvAtqWxIhz
	 W5kgy/a2Yx/nMFD+ys1SaqkKRSBbfCZp6L/CfnUa6ZTvt50AG+cz6smxHye+YsUMRAkFf
	 /Pj5C3OOOz+N2IGf/JdgWR1ZjPcRTmAJ/Q1tTWuIYNTKU/lF/DkiI00PGhkZM7Ensi6q9
	 GhWMzhLi+6Oe2AWVRfkTPzdl1VNwMYME9ZgD5KXnjDVSzhsOqWBsfjgc241H85TQdqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sTm5yvA1;
	arc=none smtp.remote-ip=209.85.128.179
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D96606A326
	for <linux-xfs@vger.kernel.org>; Sun,  8 Nov 2026 01:24:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4D96606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sTm5yvA1
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b32daac9d7so847147b3.0
        for <linux-xfs@vger.kernel.org>; Sat, 07 Nov 2026 17:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794101075; x=1794705875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KK3Fq05Nfl9D5uQTn0U9knr+7nrtHIbp74CNcfFGaug=;
        b=sTm5yvA11VIHc9Ld9H92CHbEWmPrHiA6MfYOD8DZ35q3fJ5a7fcpyiFuKJjH+qolnu
         VliiVEICPEIsAz0k9GF5XC9Qdv7xOFWPIiYuWmKziHNfw9E26qbhwcnCkDllkKZgpuks
         ETGQK0RyisdS/Cbxn+N+cl3FksovV+eRJdFZC4UrWNzvE2+6kG+SfyrrIjFADxgUhvhV
         4IUDpX4pEwkhyeN8I0OpzL9LpFZLgTO3EIBE+N9U23RZQOauqvXYOAd7Kym4bQPYg2dq
         dGJeGc0gtIp9o2MsK1T17uz9mgvTjsGMx+fS0lYidQbTO31hJ8LpEVvf0757zoCitsjo
         FJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794101075; x=1794705875;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KK3Fq05Nfl9D5uQTn0U9knr+7nrtHIbp74CNcfFGaug=;
        b=0YWOg1c6uDOoeYXERhCFTh178Y5+Zg+COu1Dp04EppRcuVT1spu3OrMhI2sH7mg0CY
         Y6Wec1/z4+UUbylg8OgB/gQYR7DRiD+jBFa8d1aa6GcrTU2BCSlSjbri94IG+qYIdHb0
         RvvS6qvmUXkCZP9S2WwzvqRhPen/Z548eCqs1df628BQT9L7YCDUsrnqVZDaM+AEycBn
         HnIBeGDGzwtqtGAL9E3zPx642ZEw5qK9UcyIp1UkPU+EINdDeYsLMIH+JeVBe9+KljQe
         5t7CC5Gpo7oKRGScCLhAL/2685Qrzk3bTt4BwO9yLgg+sukR+qUNqmlqF2I1E4hypBKR
         6qfw==
X-Gm-Message-State: APuU4Z9yzvmmtcoGsQ3DGQz9MEoA2sGrmBAj01At8/JGu+k61G2cB4KK
	7AQS/+nvU7hLFg6AG0p0nAW2MhqiF7BRILjREkScSEWZlbWn8S1GsyHOtqH5XA==
X-Gm-Gg: AYBFou0E2fjuiCqBwQVr7GQg7bKtmz1hzLK/9CQ0wm0+5J1rY60La93j4/CSlW+fPDk
	LNxtToYIDSXUnTu23KlSvi4QIpjHwfCZwZVj++472SEBjIPh2i23z9IqCgzfqJ6o9iMnmZAz5m/
	8twa50Fu7P8I3iS93D7TwBtNSKEyoT6e56MHSHXPTj5jsnHPhPo5IL5SUI9BceNR6rXjOy0R4KY
	oSKGonFR5WSG1d/+0wtzPXWpqtRFLzdFnOlNSXljw5dF481PGgP43c4GaiQi2Yt78IgRf/PgYck
	/ku/FIbSKr/rF5jgN5t1Q14/j1pTRd81ty1/MXejq/X4d7UKzO1QLKs0iqGQLQ0p51O6vVqWPet
	uvFW1DTT+ZXCxLwU3nZsNQyBH0dxn7gzNRv+4P3zAtXqk7zRJRyEtQKCxnDbHadxTeRYkyay/dl
	BdJGYtEKRskEVhAtCMO56y5p4eSQ8WA0YIIv2J8iO0MkQpfA77rQYhgPMBHX0/Ong2ujCVYmwpf
	I19fDcBUiyhiMiszuQngV/d9i2KZME9Z+0ZrtbVCVYevuJdhf5OG0mFovpZuihMXQW7PuSWuGi1
	qPMJb1PaQ6vvglzlMTsDG8wMIy3xwyTEtvFw
X-Received: by 2002:a05:690c:c505:b0:8b3:51f0:d4b8 with SMTP id 00721157ae682-8b356966220mr19466407b3.31.1794101074950;
        Sat, 07 Nov 2026 17:24:34 -0800 (PST)
Received: from diego.local ([186.151.96.233])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b36bb86036sm4910457b3.18.2026.11.07.17.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 17:24:34 -0800 (PST)
From: Diego Rivera <diego.rivera.cr@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	cem@kernel.org,
	djwong@kernel.org,
	Diego Rivera <diego.rivera.cr@gmail.com>
Subject: [PATCH xfsdump 0/2] allow dump levels 0-254
Date: Sat,  7 Nov 2026 19:24:07 -0600
Message-ID: <20261108012410.3156325-1-diego.rivera.cr@gmail.com>
X-Mailer: git-send-email 2.43.0
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

xfsdump limits dump levels to 0-9. Nothing on media or in the
inventory imposes that: the media file header stores the level as an
int32_t and the inventory session header as a byte. The limit is the
LEVEL_MAX policy constant in dump/content.c, plus an assert in
xfsrestore's label display that the level is a single digit. Linux
dump(8) has accepted any integer level for years.

This can be very useful in environments for which frequent incrementals
are desirable, but the current ten levels (0-9) are simply too narrow.

 1/2  makes xfsrestore print levels of any size
 2/2  raises xfsdump's limit to 254, the most the inventory byte can
      hold with 255 kept as the -I level= "any level" marker. The
      level written into the media header is capped at 9 so that
      released xfsrestore, whose assert would otherwise abort, can
      still restore these dumps (reporting them as level 9); the real
      level goes into the adjacent 4 bytes of alignment padding, which
      xfsdump always zeroed.

No on-disk layout changes and no inventory format change. Dumps at
levels 0-9 are byte-for-byte what xfsdump writes today, and existing
dumps and inventories decode unchanged.

Testing: built with gcc 13.3 against xfsprogs 6.6 headers, with no
new warnings. On a 6.8 kernel, fstests -g dump gives the same results
with and without this series (29 pass; 14 not run: the tape tests and
xfs/287). A new fstests test, xfs/842 (sent separately), passes with
the series and is skipped with xfsdump 3.3.0.

An end-to-end script also checked compatibility with 3.3.0. A chain of
incrementals at levels 0-12, 100, 253 and 254 restores correctly with
the new xfsrestore and with 3.3.0 xfsrestore, which reports every level
above 9 as 9. Dumps from 3.3.0 xfsdump restore correctly with the new
xfsrestore. 3.3.0 xfsdump sharing the inventory lists the real levels
and still bases its incrementals on levels below its own. For
comparison, a dump carrying the raw level 10 in cih_level makes 3.3.0
xfsrestore (assertions enabled) abort in display_dump_label().

Tool use: this series was developed with an AI coding assistant
(Claude Opus 5.5, Anthropic). It traced the level limit through
xfsdump, xfsrestore, xfsinvutil and the inventory code, and drafted
the code, man page change and changelogs from a request to lift the
0-9 limit without changing on-disk formats or breaking older
xfsrestore. I reviewed all of it and found no need to change any of it.
The changes center on the self-imposed enforcement of the 0-9 level
limit itself and on displaying levels of any size safely. The coding
tool ran all the tests in a QEMU VM, and I reviewed both the code and
the test results.

Diego Rivera (2):
  xfsrestore: don't assume single-digit dump levels in dump labels
  xfsdump: allow dump levels up to 254

 common/arch_xlate.c    |  2 +-
 common/content_inode.h | 60 +++++++++++++++++++++++++++++++++++++++---
 dump/content.c         | 23 +++++++++++++---
 inventory/inventory.h  |  7 ++++-
 man/man8/xfsdump.8     | 10 +++++--
 restore/content.c      | 11 ++++----
 6 files changed, 96 insertions(+), 17 deletions(-)


base-commit: 04051066b6c66218717cb6cbfd51e96df393d183
-- 
2.43.0

