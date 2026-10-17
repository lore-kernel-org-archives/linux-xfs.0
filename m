Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B0D2F745D
	for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2026 12:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792239011; cv=pass; b=aE2bpmobGNgAyeMyHWGRJEHC9uE+RtCfGYjpSerKI+bg0tKIXrmRAE8SCpczhUppuoGkSfVmz0+UTshqhAcJ9dmGxT1gYxGN2QdVcOxquHKg02ca/n5W762cMT4U9ac7sq+cKK9lxx5WiaBu0xMUpTdgplHQ7f0uMHIgJ0qQxww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792239011; c=relaxed/simple;
	bh=BwrF3E0OrRL1L1yYbAHLfnTY1slOtW5vccqin4kzIyo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=SakZ8tfjNH2dDESgPTbv7nN1Xjai3VZnusrSOT51Cjj9hzmBnCHhLrpPDM+MJObxpNr65t36gN7ner27jIYwKOFntJxxrmJ0UPhXQBUc8MW0XymOUSX907WZOEapOYwzp7WqtVZysOEmjQa+7CSFPuuJDDM01EsLHlLNd+d/BgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CB+7GZbC; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CB+7GZbC"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b0d5ddafbcso5800097b3.1
        for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2026 05:10:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792239009; cv=none;
        d=google.com; s=arc-20260327;
        b=lgxLkpWxGck8shWnmXACWY3GdUbNJxzZKl0GsL0GtrPwFCiaN9oXvJDC/bXWLM6cpM
         +Nr2eNCSzMxn+vGcro08zPGm+533e9hCpvDaEwF9PB5HP2OfL7VA1uJouZ8lwBvG73Pg
         fNkUunQqNN+58q1MItaWzsZb2iBhhLKKZ3SJq9EDouM6w0/nLJHVlEwdmw4xKX/rAtrR
         DwjP1p7hurZkldLV6a5cWh0tBx0/+Z8Eplxetgc3JLCCgDCrgGTmkzEE1JGnz0OUtEKO
         iVPNC8pQukoKO4gsMYWI78ft7DdgddntBj/Dcq3rzzDOczOB0lyaGwlVmQYhDMlWCPct
         h1gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Od26okssJET//ooRFBJ3pb/eMQWfi7kIRjynrJUl8UU=;
        fh=wbjSjw5kF9NkOuPT9zeX4W8zCpl+k6pDEybb7x/TW9U=;
        b=P0ScRCkzrhVgrC2Gw/txyNv4UidSz1GVNHOT8Jr5tJF5swDU5zPiLAABODaUpkU10N
         qY7a3ZM4Z53+MNSirPJedAH69cooIcuYw2b/SMKqxydo7qV8LJ0deHazjlq/zQZyegp6
         bZumnElos7qlQomjfsFVf+GNELzv5zVhXuoTjcOgmyS79jtYLpyGM++D2kLx83VYfjuo
         K+k1BcHlpo2vAICh/MHjaiD2VDI142VQnnvLEjdDjuGNTLCyM33xP49bX1gm9j1W9Hn0
         ixs5VkQT0Czm9inRRnXyiRf5WIG50QG9IDPkqFMF7+Qj0vYpN/C/533WmV4RPKLLc3Jn
         79/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792239009; x=1792843809; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Od26okssJET//ooRFBJ3pb/eMQWfi7kIRjynrJUl8UU=;
        b=CB+7GZbCgrICWdnPG66VYXC+OYOHfd0V+p10dZXQLecdSlOwCarlcCJni3TUvrDEDn
         sdt9V1qRdmPpZFOdfB0vTC43Cmy2qC7x4RgMRsgusNtQi7zBhgE4kUr/DtO5ZspWlIWo
         p2QBeJuWtLlNoZTaDy6UHtfVBJFpjmygkZ+AtC8hPVB0bGVRQSLLjJw8Q08cg9eKOymR
         AW2wexEV9SCpnF6WXzFg7ioDSqk7Oiyz02bIfTMZht/0qvKVaa7KUTeQb070A4AvoByR
         avHVUIeG3dA2nXPHTTLGP/TUvy5lEhh4WeVIERRGDGP79J6noJvdebcZgPJrdOgr6CTI
         lGRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792239009; x=1792843809;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Od26okssJET//ooRFBJ3pb/eMQWfi7kIRjynrJUl8UU=;
        b=0v4kz4B7OUTOJz/dRXQgUFJG5UtsG59LisRyGVYoOspErIHT8a56Ul9argAQyXO8k2
         ntXO98Swr2MpSyu+IhaXshdoVwtBoFNF7MB+rx9IpIBiJcEA1Znz/28VTlF2sgGIYpls
         EQ/HsixrX5YWOfHWyH80QDubnEpKTsuwY+Z0ZfdPV8UIc6yAWajuC2/2MAOWZxesBJ2Y
         A/XkFkELnERh125geGEOWKmdpsgetHr26e32GS0x7hc7cphXpiPlgDXOpSPJfxxv927S
         bt7vW9jaYvwrJ3rbKWwmRmDmxVLwzmP06wk8MjLhs7QanrxJc3rGjk/povhwDOnc0f35
         lq8g==
X-Gm-Message-State: AFq9FYJ9DBYo3jp24a40mTtQH7oOQmJcgOI/Qy3x0yxGCHApNbi0ei8Y
	zKFSoM6YoIJH2t63fiAD4RtIgELWqklCwb4gjDjJQYvS0NfbclPs/fjBSc5jo2nvqpJ4saRig/M
	95Nu4+fO5KnxBbFWhE9YJlR5bNAlcwOSaIJHCvJuyJw==
X-Gm-Gg: AYBFou0T8pqQDmXsngSPzfegL1OR5Bq0yiNulyKR+JUyqJwKR0vbw+7rbdD0J/eluIY
	lGW7Z2iGMLG/siGmI6Rfhpakfgj5PGxk+YcbepDTMd48SVwkNFHGEaVd0xm7aYoz9hsUyYwkU/d
	wO6ZdoejdFoXustxYTT4fNEUZ46U4Z7dRlAmz1Hv2UnXqali/V2c+CVt0ugzeTNaPkr3yflvv61
	qRs609jT1P+Hh6Z2OEXd8mahi1VW1Zq0md46hUfX2gKq8MpEm+hub5vDIV64fiY/S4en/95jcvu
	BiS1edcmKbUtYOdkrr6cFDtKm8d9d6+fW4UP/2mHqkolHqX+5ScPVRc=
X-Received: by 2002:a05:690c:e641:b0:8b0:df71:44cf with SMTP id
 00721157ae682-8b0f21ae8e5mr6456807b3.15.1792239008753; Sat, 17 Oct 2026
 05:10:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Chris Thomas <chris.alex.thomas@gmail.com>
Date: Sat, 17 Oct 2026 14:09:57 +0200
X-Gm-Features: AclHuK9ZkHV_uQ6ace4rov9GNVZ6HC_EiWRr9B1DpiJpPUgO-IzY7RkrH4Hnyzg
Message-ID: <CAGhPht=eDTJa45teW7xO_NvdpjybZdK3zFNCgd_YBFa=AxiTJQ@mail.gmail.com>
Subject: [PATCH] xfs_db: read a shortform parent pointer's value after its name
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, aalbersh@kernel.org
Content-Type: text/plain; charset="UTF-8"

list_sf_pptrs() passes pptr_emit() the value of each shortform attribute
entry at sfe->nameval + sfe->valuelen. The value follows the name, so it
starts at sfe->nameval + sfe->namelen, which is where libxfs reads it
(xfs_attr_shortform_getvalue) and where xfs_db's own "print a" decoder
reads it (db/attrshort.c).

Because a parent pointer's value is always 12 bytes, the record is decoded
from the right place only when the name is also exactly 12 bytes long. For
any other name, libxfs_parent_from_attr() rejects the bytes it is given and
pptr_emit() returns silently, so "parent" lists nothing and exits 0. The
leaf and node listings are not affected.

Reproducer, on a filesystem made entirely by mkfs, with xfsprogs built
from master (7.2.0):

  cat > proto <<'EOF'
  /dev/null
  0 0
  d--755 0 0
  a ---644 0 0 /dev/null
  twelve_chars ---644 0 0 /dev/null
  thirteen_char ---644 0 0 /dev/null
  $
  EOF
  truncate -s 512M img
  mkfs.xfs -q -f -n parent=1 -p proto img
  for n in a twelve_chars thirteen_char; do
          echo "/$n:"; xfs_db -r -c "path /$n" -c parent img
  done
  xfs_repair -n img; echo "xfs_repair -n: $?"

Each of the three files has one shortform parent pointer to the root
directory, and xfs_repair -n accepts the filesystem (exit status 0).

Before this patch only the 12-byte name is listed:

  /a:
  /twelve_chars:
                 128:0x00000000  12 twelve_chars
  /thirteen_char:

After it, all three are:

  /a:
                 128:0x00000000   1 a
  /twelve_chars:
                 128:0x00000000  12 twelve_chars
  /thirteen_char:
                 128:0x00000000  13 thirteen_char

Fixes: 34d3b1079425 ("xfs_db: add a parents command to list the
parents of a file")
Signed-off-by: Christopher Thomas <chris.thomas@antimatter-studios.com>
---
 db/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/namei.c b/db/namei.c
index 6e5d0ac..a734705 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -701,7 +701,7 @@ list_sf_pptrs(
  sfe = libxfs_attr_sf_firstentry(hdr);
  for (i = 0; i < hdr->count; i++) {
  pptr_emit(ip, sfe->flags, sfe->nameval, sfe->namelen,
- sfe->nameval + sfe->valuelen, sfe->valuelen);
+ sfe->nameval + sfe->namelen, sfe->valuelen);

  sfe = xfs_attr_sf_nextentry(sfe);
  }
