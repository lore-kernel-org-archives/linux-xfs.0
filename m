Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1929038E744
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807661; cv=none; b=FdaqpWsY+pYtRqpEJIN+tlLByAkHg5iTcH/7baSahHdMaqfr0oUNBBWHApTnBKx+hfFbyLX2EhBQh4VQpubK3vfg7yskFLHgdvEjtVs6hIv5gMTBT4tfaiAKO6C1ON5c2bqETkgxsjYqWyT/s8jbUnThVbfySl+k0VWIH+5vO9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807661; c=relaxed/simple;
	bh=HO3qn6E2mu4iKLp4ae70vUhOoqfZurpCVV09CRALkRY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbmGcEEkVRx7CY0duPWZsDhVjF0pJ5QTR7Nh8jwxWVdAFehr1P+9Pw5V2v8WiJjFUfFQX1aAR2XK+J2sszeMtcHC4ZKEZAyVtpMEEQxi51ZNJe1fog2aX9YVaihhmqKG5eVWkfenqF740pjXtDikg4fhN3prkkwVd8KjmYkrljU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=dCv/3NfJ; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="dCv/3NfJ"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-71e6eb6494eso13046687b3.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807658; x=1756412458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PY21hOB+0muSrNOgrHptmS8Lc85J39c8M537N7BFIe4=;
        b=dCv/3NfJMgy1NTV8aXZrLV/VPd0uX758F5uGHu9mHnNHwSlwt/MIuKV2zIZR+3f44p
         CgRLBav/0nvbZL/DjqQYgNjgx9bR5rpCCwso3sA7wRUgN/MLnQvhynz9I2vfkwqBKH4E
         k8aRe0hfz3ZVFlgs6QTvihs2AHjV2m0Kvl+mgoHxUo2wOM/o40ailVZ8olI2KZaUe1l5
         jI0Eze4T00ZTynCE0WFtOnu+XPRzUVtIsH9HGF5/OghSBpQU/VVcd48gG4vRDoILinN6
         5SXFamskA3rOryXuW1EYRvAlritNNFHbX1mCVu5yoHgeaQmSXsJ4FQw6zQQDlnB+tN9q
         MZ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807658; x=1756412458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PY21hOB+0muSrNOgrHptmS8Lc85J39c8M537N7BFIe4=;
        b=Af24p32tWHTR2+R2bYuDVdseKXWmsPflvQljpQGVWyZKlhghdoeuTh74FuF8Ll82d9
         GvI9KfPSVjlJDIn9OACWBXiFzGEkbtrp6o+v9lR2m9BheoLY96SA+cde55P+Ma4DxoP9
         0auAopW9O1jVcw30UNw89FRZExsPNPSqGuHNGOIYI9E88m8pac/w6YbhRUv4gQ2JzxIH
         kqkvQcRGwcFzxofG52iesP0sNx08IRgPhnG9YyUDRxlVLUlsDqNZXUY3rOp6gQtI5v9B
         fRYVy6trnXlcPSam08XyQk4gVd3PSjLpCtniCQQIxB8wZnbvwxUhVAigtGD+DXkwlC9M
         AQNg==
X-Forwarded-Encrypted: i=1; AJvYcCU3lqNP4thQG6/PKcEwCQ1kNQyFFC3aj4P3dI/1oEFNbT30rit29NPoBRcL9NtTRsBDrms6ZjMsEQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5NmUoHKwxaMPtTRudgqoNarcoSZYA6WkK5ct/KNEAdsuQ5iAZ
	GjJznbQtRVbvHtdmKaechs2ZuCIzJT0a/yVhR85qlyQEh2oRLhpf1SXTfTEyhYmfeEw=
X-Gm-Gg: ASbGncsL5q9n1ysE31fFnhHtOF/ehiG+39wUPfyB6445FK1aF81pkSGZVbgrpRhri3P
	tO7dDm5mVfD29NO08XLEjspmTYhdhh/xHbQ66xcuypkF3nXxxWk1v0zyd6LOSl0ikX/psiJbl1X
	6xjfZqL5a7W8cs8bdf9+uceVKPfAnBPP8YYuYkEt3GJ5Tfus4U9lQ6jmB0ekE0QzLXEgLku29RR
	jpRnF60nJuf9k4AAttEwOLGAO8QPywbdd8oLa/C6sXK3QJ8cKRJqxaxulhCSYu9AsEuuvP0hw3X
	S7eTXE4Y98x23dtIElBk9ScG/lquHStYWwmQAZzuai9km3drrjQBSRYcdo7ALOVpbFefCBrT52g
	GQVljl6Dn/9fD6+mQNen6iczxXvdiyeL1FVhLbN5ZjSdRMMGpOBYYtEpqhkDNkJkGtaBQ9g==
X-Google-Smtp-Source: AGHT+IEIFJCVTu1EDZBPKF7Wn7HgQkKCR2Ee9oTaJqcUfdrFVpYc/qrWl5B/CxZoKQkUQjNMeDd4HA==
X-Received: by 2002:a05:690c:b1e:b0:71c:8de:8846 with SMTP id 00721157ae682-71fdc2a890dmr6082907b3.6.1755807657866;
        Thu, 21 Aug 2025 13:20:57 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e6deeb6easm46112717b3.33.2025.08.21.13.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:57 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 28/50] fs: change evict_dentries_for_decrypted_inodes to use refcount
Date: Thu, 21 Aug 2025 16:18:39 -0400
Message-ID: <a1eaf8cd138a75f087654700e9295a399403ead8.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of checking for I_WILL_FREE|I_FREEING simply use the refcount to
make sure we have a live inode.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/crypto/keyring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 7557f6a88b8f..969db498149a 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -956,13 +956,16 @@ static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
 
 	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
 		inode = ci->ci_inode;
+
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
+		if (inode->i_state & I_NEW) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		__iget(inode);
 		spin_unlock(&inode->i_lock);
+
+		if (!igrab(inode))
+			continue;
 		spin_unlock(&mk->mk_decrypted_inodes_lock);
 
 		shrink_dcache_inode(inode);
-- 
2.49.0

