Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A054C2F5A10
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788660; cv=none; b=ZXZdd/0xEoU3VNh8bsZr0OR8YzVTQxG37E/m5ay9ftyEAdLU3p01QRuvxytaJj57YhKeetdBqStISCrQS3GQ9rhIFlvua0Nj6eJNZyAYsxTxXrHBxnU53b2+uKLpgc72Agdv7T/DYvBca3M+hYQQ92//lrC/1DrcGB5yAJErfPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788660; c=relaxed/simple;
	bh=W6LYl/ClOgnfGA2SoeKv0w5/4i3UBSi70YUs3pfb788=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HH7eDn5PJvrVOtJVFOQsFuQuPXK8B7G8bKkesQnWxZit9GirIJsysplsWP1tlunTZ8jFEg1zlJnGZUz07vOvGO6sFnqNqAOz2S+iPrNbPZf4Pr/+c/cFKJcNbEcstC8a1QpQ5zkxfQ/Ihx60THjDrVFVBZEWcvbAkkV6HSZFw6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FTssS1TK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FEjxnD99; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FTssS1TK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FEjxnD99"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oF37ATwdoYAwLqRZkqLFYSkCSkROHaEUWhLnsJiIeVU=;
	b=FTssS1TKleM2G6FZ5kKl/AuxtRte1h/CvqUK3Y8QinJm1k0uIqs94jaFyla3jC0yQ7oPXv
	GcjkSCh5SfaXRbHfoKetENgeqVFReDwhZnWmREN416IM0OCrd7s8npbmWKDK+pFekSqVya
	LtgWBr9y9rdxfxVR031lCrQKGP4RQPQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-Stm-pOymOm6KCU7mx5xBeA-1; Wed, 03 Dec 2025 14:04:16 -0500
X-MC-Unique: Stm-pOymOm6KCU7mx5xBeA-1
X-Mimecast-MFC-AGG-ID: Stm-pOymOm6KCU7mx5xBeA_1764788655
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4779da35d27so697435e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788654; x=1765393454; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oF37ATwdoYAwLqRZkqLFYSkCSkROHaEUWhLnsJiIeVU=;
        b=FEjxnD99fNu4LyTUcV637VVGsOfdO/anQuxP3zqP6wFl1VhoA3CQQSxRDz4mKcxGKz
         x1NPbR6aVZn45Sl9+pWTtRaz95GJB5ghHJsmvidICh0JrVtxZMyQpguLkGmDVSRkgv5o
         qmRvwoDJ27D50hF3gkgU98Ug0qMf9ks1+osf0WBfap1MYaNazjjnTcXLnWagIUJz05uB
         1MNaDp8BpKMAGBgXJL5DeLXEIDUjauD1BItJPyon71Phsqh1u3pRhdUeDvaH/ZGGvVP7
         UPbzC37zWsWKvn2iv/uOehI7ImsjZp0FrpXcK7Doz8mXzIJmVFgMtJ5icRnI+eF108SM
         jnpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788654; x=1765393454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oF37ATwdoYAwLqRZkqLFYSkCSkROHaEUWhLnsJiIeVU=;
        b=u43VB605tZco1hSITpJNUOh0jc11pZG3mcXty9HxoveO1J1UgzkcvlfIhEY+W/SwZ3
         lz4nz3q4WCVLQD/E4QeSnYWLKBb5qGE1XEWbRTwOxjYxUJV7IPSbvIk/fWApDEOnwN4p
         s5UFcy4PY5WmLAr9rwm/yOJ/4sY6u5rbiQfmdtJVPhLlbRPEIqGzdaKD+Aa9OIPmmeFW
         N5ErUEGwEAQhUt48LqPri66o/F9xfnn9Em9SeIHSnessT5htp8k47SL3JAlj0YyCIKn4
         OOIIgukStml02neyNCuLu+gy8/XnOSnSENeLatSVgmD8p70bkaCUmBT4M/fUy9RF0HZ9
         chaA==
X-Gm-Message-State: AOJu0Ywp+LG+NXRoSy9Xa0i7ayxNhbLt9nkKWJnFBjkw1TB6vTx8fgv/
	hpFdxcZ0bbz4QL1uNrlxNCSCalVstzL5peCvG4KF88i0HAtCrYrhJgyz5trnp82crwPNVZDMTmb
	um0duNbKQY6KnxwzKJKCxz7Iw94+SJbKSYthuhk4rLQzczDt3z51aQsaRzKzKbtzuMr3B6AIxVW
	TaW9VLnXYcjM8GNGhmt9pZKnzqL1pqMr91950BE+aj49NK
X-Gm-Gg: ASbGncuFDvoQ8GlvNS7hen817f6jdiTVn+HbNkk0OQ1ZbxiHKY9O27bI97QFl50L5gS
	rZBaSYH/YFHjmyE7jiUwW3st/7rNyz4ARagkwdxLP6qR2qHO2FGa9di1gtcQ6p9M4JcDRYZmRv0
	QuDi2lquAiAu1FLWuArYlN6qyEdOinmaLS0FZsqn8zYHT+yn8r0CbRFKTcik5NyVNONc9h1evUn
	yBpB3nYOAkK+ARoVjWXbBViHyzbW6vsIxCvR/xYoenGlhcRKsdDKqJZdiyDA5t1FtRh40jKcOxi
	jr8km7SmjIRsSG4p6ljYWj9/yxDFjKn1hXNfDYq/qP6WrBSDSg3R/yx8Rwqspjkilqqsny1cBac
	=
X-Received: by 2002:a05:600c:630c:b0:476:4efc:8ed4 with SMTP id 5b1f17b1804b1-4792f24d7bemr1844275e9.11.1764788654515;
        Wed, 03 Dec 2025 11:04:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IERy4C0Jq2vaKq1FKDb2MWVXx7dVav1L+p7m957/eEtZNlvcVP1CHQbu3ep9WoCh+iyV4FX+g==
X-Received: by 2002:a05:600c:630c:b0:476:4efc:8ed4 with SMTP id 5b1f17b1804b1-4792f24d7bemr1843855e9.11.1764788654002;
        Wed, 03 Dec 2025 11:04:14 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d6133sm44051605f8f.16.2025.12.03.11.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:04:13 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:04:13 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 2/33] xfs: remove deprecated sysctl knobs
Message-ID: <2rnjjqaepwrkc75wjngwvhfdckjzxc336xabfgp4dhftkqahbj@xcoekfan5p4h>
References: <cover.1764788517.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764788517.patch-series@thinky>

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 21d59d00221e4ecbcb597eec0021c667477d3335

These sysctl knobs were scheduled for removal in September 2025.  That
time has come, so remove them.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_inode_util.c | 11 -----------
 1 file changed, 0 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 2a7988d774..85d4af41d5 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -296,17 +296,6 @@
 		} else {
 			inode_init_owner(args->idmap, inode, dir, args->mode);
 		}
-
-		/*
-		 * If the group ID of the new file does not match the effective
-		 * group ID or one of the supplementary group IDs, the S_ISGID
-		 * bit is cleared (and only if the irix_sgid_inherit
-		 * compatibility variable is set).
-		 */
-		if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
-		    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
-			inode->i_mode &= ~S_ISGID;
-
 		ip->i_projid = xfs_get_initial_prid(pip);
 	}
 

-- 
- Andrey

