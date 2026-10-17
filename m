Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D56838654F
	for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2026 01:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792202168; cv=none; b=mLJjykwWwGtSFvU/4MxfmUEKfrImFj94TyIAbR2h/r4pbEcAnlZeHxcyXyDAF5Gf8ilb2Z6J9U4DjSLgjgmhiHUc0J/A8Fy3wm4CT05jLdsev9E4qF3jTVru3zYf2kDt78QaDMXnnNfGtk2B11zpZ/oL02yi8jHME1nV+htL40w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792202168; c=relaxed/simple;
	bh=Fe8zxGQq/7dCid2W89W5GWhcTNqPOSQenj/BB/O4q7E=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YghOGK5dg/Rged8i6fnwPT9nfAY4ZfXGBAOOxHQ4qRenCYH/raa7rZeQqLCWmVZbs2ZVv/heES+NUMViFxPCDlIHvsguzzckdYqE+h3QdUH28t36lgMoUPTsT+seu5u8SqgjNeFyRcM/e9wdJt314hP0d82t1JJ7rUV5kuFND2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=njj0NpxP; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="njj0NpxP"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e608cd460eso2215205ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 18:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792202166; x=1792806966; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:date:subject:cc:to:from:message-id:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fe8zxGQq/7dCid2W89W5GWhcTNqPOSQenj/BB/O4q7E=;
        b=njj0NpxP7PMMY9QiiCHu2ZMK5ZNDmcqLnqXiLZCzhA26eiXXHdA0CikuUD+zuPTfNw
         phtEfb42sCyThPfhrO6X5q6PkzLVvJjplFoZcMaGNqv8hPNvY/AJs7ZvwOLxNKh/IBsh
         gAzjDTJVHVj/FWyo6gbPWWDf48MecKc9682oSwdSyReHfgXgVbzhHMa1kcoV97p2lKZV
         FeKdHc+Mv1hp9GOWMLtc17PvFkpTKVdPXnmg5tSM/f/wfm/VQw5ZwV2WlfzXpMC0R+re
         TDpPD2mOEzyg81PHtX9pDJ5IcMFC7XM3gWYYsC5w8m8MWjpsNv/yXxbZ18+4oywd5MGG
         10dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792202166; x=1792806966;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:date:subject:cc:to:from:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fe8zxGQq/7dCid2W89W5GWhcTNqPOSQenj/BB/O4q7E=;
        b=bX9eBEUEmvrbUr6+9PGhmikK30bEu08U+o9F+RKWQoUVRSTWMLq6ToQvFtSivGlrFH
         qZWsZXpk2y6ivusRmmwUZYtTS2Ee3aGtZWhdLxgsAYxK0GnSaoobNTQ2F9uFxmaRecHQ
         hGg6V6Qt7rpLpMj8gbN/oAJ5xVriDjqjKBFRRjqskypGbIxx6g+tPerpQJwDwwrPPUj9
         2tKFC6KEit6xH2mNZeVPk95mA3KoJg5Dcfw0vxw6sp/b5q0iYyJ9+qFuhJ0FlW78UXmz
         PDeP7DsErQTXeGUiil/Bt0hkduxY3fYkOHrARw6VEDTaX0vC2k1cNR0MDL2XEoAvSfsm
         6KBQ==
X-Forwarded-Encrypted: i=1; AKwUvBxtMsCuuVo76WE7o7wTPXYpuxXPti5TZofm4HjhbEkSIrKQ6MF3SShTQfow+XbDHeT/tHZ6cAptkOg=@vger.kernel.org
X-Gm-Message-State: AFq9FYL5r0uLkLUHVZhopv2V6wd8f/DdWT7rQpYQLlwKkIDINqLUCn85
	nOVx/nUOjKP092rb6YVoUh6F+l8DoZt0TLvFec9QuOokbqhDZA1SxYX0
X-Gm-Gg: AYBFou27pWVZ52mdSTCtQ3GjFBpYK8pSfC1QoH4qhAFEBxKtiklqDHlMSakB8yYTxgc
	wAaxw8fpu9rfDaPhpO63sAGzqp/sTF6Ni2QbdXYeJ25EXki2Lex6XsoPI09E78KbjmGLTWGyinJ
	E/D+K+XoL4Lo91wHiRCAmubxRHSbFTLfe9gNZedOqR5FSEUZAFFuHuUTZeHD05A53QJHg20Wad3
	EtBUDzbnSqYGg719yAmexSzHIMlJJaBVN7m6lMVEi+i1rsyFlSOtHuEprVnf0u809+c1hW2oUc4
	ydaH7Xt9IAUxrXBn2NjqgZaGGX9dBTcQ96GzApJYfNNY9tIqaBQjXFlKrb4CwZcMfPK+gjcCcYm
	whOJTaLrsx7SGRU681tYGrIHjtRCECMDoeGxpB1+Lj6LHS8NKQ6aXJoJc/vuwkEocTAkHfvqIf4
	lc269Wz9L7BWQXjV/IISphTSF8jrOVPopUDtba8KZHRdDWhN5F85rl7cB66F5qJYxJAoUKmAAsh
	OkudKkKiSH0Q8GVBrkqTA==
X-Received: by 2002:a17:90a:c110:b0:3ab:f38:2b43 with SMTP id 98e67ed59e1d1-3aceeeabd7dmr1165560a91.34.1792202165738;
        Fri, 16 Oct 2026 18:56:05 -0700 (PDT)
Received: from DESKTOP-UCPRL76.localdomain ([113.200.174.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94794dd9sm11245327a91.12.2026.10.16.18.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 18:56:05 -0700 (PDT)
Message-ID: <6ad2d5b5.969afe5a.ee04c.f286@mx.google.com>
From: Zheng Shuhao <viennaoffh@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix slab-use-after-free in xrep_newbt_free()
Date: Sat, 17 Oct 2026 09:56:00 +0800
In-Reply-To: <20261016152359.GA107986@frogsfrogsfrogs>
References: <20261016085536.591-1-viennaoffh@gmail.com>
 <20261016152359.GA107986@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Darrick,

Thanks. Re: "What if some other thread initiates the shutdown?"

That is what I tested. The paused autoreap dfps are freed by the failed
xrep_defer_finish() in the repair thread, no matter which thread sets the
shutdown. xfs_defer_finish_noroll()'s out_shutdown path forces the
shutdown before xfs_defer_cancel_list(), which frees every
xfs_defer_pending on the scrub transaction, including the paused autoreap
EFIs. resv->autoreap.dfp is dangling by the time junkit runs.

If the shutdown is already set before repair starts, the dfps may still be
alive, but unpausing them is a no-op: deferred work cannot progress on a
dead log, and scrub teardown cancels the transaction and frees the dfps.
Any EFI that reached the log is replayed at mount, which is exactly the
intended autoreap behavior for a repair that never committed its new
btree.

The guard cannot miss the dangling case, because the cancel that frees the
dfps happens after the shutdown is forced.

Testing: helper threads issue XFS_IOC_GOINGDOWN (LOGFLUSH and NOLOGFLUSH)
after the xfs_defer_item_pause trace event -- 1 to 8 threads, 0-100 ms
delays -- while the main thread force-rebuilds a bmap btree. Unpatched:
KASAN UAF every time in xrep_newbt_free() -> xfs_defer_item_unpause().
Patched: no splats, scrub returns -EIO; after remount the log replays,
free block count is unchanged, data reads back intact, xfs_repair -n is
clean. Healthy forced rebuilds still do the normal pause/unpause.

Thanks,
Zheng Shuhao
