Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1121CD01
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 03:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709002892; cv=none; b=CKVPPHcSlaiNLsZ1oxI+J5fm/Ml5/yfpdFjgsJw/bfq/tBEbtpUatBBfEIlSmuCsup6V301EOJry7QavEN/AJAto++JAPCrxhRDmW2EANlDFV769YsmUSzCZqUfCNqA5oA75xo7b5YhoQOVxP54+cPtTpz0Dy8Wc9prgczB3gYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709002892; c=relaxed/simple;
	bh=fWTNqBcZQqvQUVtWtWygJauLy8CzzHs2Jab9IUPLP7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WP4aDgV4lVr8lEIa0a1KuaKwWRuin5fyNH48sck7sSvQao0BWe5bFRY923olNnUuyhAn5oVWGqzFTK5sMfMFTH2bCb+8nzvWmD9GtC5iPCstGg44yApvHIfQ7fjG7Sd8WBARBNitmLoyOkGAcgaQbKqTptlGCycuboxHujB8tK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rZpWvJfH; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rZpWvJfH"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e459b39e2cso2244534b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 19:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709002890; x=1709607690; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8YJlK0PrG5SbE64Cqr1BeNiJaz5cqZqhLXP5LI17y80=;
        b=rZpWvJfH1PGUcrgQFs1J6qYQcUh5aDJgFPybuzDk0DTiEBqIlJua06yrrCHCKmdSdw
         KI/qlYINjN6Cz9rLsPvfSHX/n09bqRbCddnYaApOCabn5Q7CKtOTnw4ysyBtbi+QRCCy
         qH+ErSz5bNI/JOu/RtLaoAiJlBjthqkrD7pPtCEcNYzm6Sx4Sjz93Ubecml8bz3UC9JK
         EXblEQ5tGNcduN/7jHjfhtPyzDcu+lu/5pJrzt7JFLjA8ogpJqlk4QSJ4GX39U8r+Z5M
         0P8dvgpRsTYzjcjbDUM5jkoYKP6fc4uUgHA7YsTUvR1GJZT/V3fQzvE8n8WDsFKxBSL8
         qYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709002890; x=1709607690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8YJlK0PrG5SbE64Cqr1BeNiJaz5cqZqhLXP5LI17y80=;
        b=v9rCs0kc/qz54+se61KH1LU/91Y3JNzy3OeX0abY65s9emW6+1fAhMoft+ZaMMfkwB
         Df3pvj3yKLqZs8OPGK9gQKo9tS4iTTOV5rOevvyLyKF+fPe1HC3nBDzaJqV2EXZFL92u
         14HvZ4eOEZgCumrvYNxg6wHQZKUsuX/B1wb9riMrsfWhI3y8ZzE0Unj1WxTdZxCpYnix
         VtQyabhq/FWvUw3LTm7BaL+H2K3fXnPL19l/UhFkCKNnQUfTEa50OxtVoFz/1zzoNfDV
         b4WMLxJ2I0/yfCWJoyuU+9Gztl26WVEoM7UWkybCS1ttK829lPtm7AE3u58iI+OJ67vx
         NY/w==
X-Gm-Message-State: AOJu0Yx/7mBk258rHQIAGIivFURt/wHAaBxWgi/VDyhhbhv3CeR+xXsl
	3xuVAxoh/CTihlRyNfBQ4Cs3Fk895mwciC9XylJyYLshfMfmWG93CxbaOxLaD6e+NwtzbrrdFLU
	u
X-Google-Smtp-Source: AGHT+IFXm2AQcquFVRKrawdc5rGcckFanG+slCmfd0DIJqlim5TFT06Q5rlaLv/gkQR4SKHRWqJz5g==
X-Received: by 2002:a05:6a21:3941:b0:1a0:decd:1b6a with SMTP id ac1-20020a056a21394100b001a0decd1b6amr1519047pzc.16.1709002890149;
        Mon, 26 Feb 2024 19:01:30 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id h22-20020aa786d6000000b006e089bb3619sm4770836pfo.112.2024.02.26.19.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 19:01:29 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1renig-00C1uw-2R;
	Tue, 27 Feb 2024 14:01:26 +1100
Date: Tue, 27 Feb 2024 14:01:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: [PATCH v2 2/2] xfs: use kvfree() in xlog_cil_free_logvec()
Message-ID: <Zd1QhmIB/SzPDoDf@dread.disaster.area>
References: <20240227001135.718165-1-david@fromorbit.com>
 <20240227001135.718165-3-david@fromorbit.com>
 <20240227004621.GN616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227004621.GN616564@frogsfrogsfrogs>

From: Dave Chinner <dchinner@redhat.com>

The xfs_log_vec items are allocated by xlog_kvmalloc(), and so need
to be freed with kvfree. This was missed when coverting from the
kmem_free() API.

Reported-by: Chandan Babu R <chandanbabu@kernel.org>
Fixes: 49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---

Version 2:
- also fix kfree() in xlog_cil_process_intents().
- checked that kvfree() is used for all lip->li_lv_shadow freeing
  calls.

 fs/xfs/xfs_log_cil.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f15735d0296a..4d52854bcb29 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -877,7 +877,7 @@ xlog_cil_free_logvec(
 	while (!list_empty(lv_chain)) {
 		lv = list_first_entry(lv_chain, struct xfs_log_vec, lv_list);
 		list_del_init(&lv->lv_list);
-		kfree(lv);
+		kvfree(lv);
 	}
 }
 
@@ -1717,7 +1717,7 @@ xlog_cil_process_intents(
 		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
 		trace_xfs_cil_whiteout_mark(ilip);
 		len += ilip->li_lv->lv_bytes;
-		kfree(ilip->li_lv);
+		kvfree(ilip->li_lv);
 		ilip->li_lv = NULL;
 
 		xfs_trans_del_item(lip);
