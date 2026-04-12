Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B190265CA2
	for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2026 16:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776011576; cv=none; b=RhZl3ft9Qd3dcG86duvxQEPJAXk7W7IxS4V/7zHWIJauFFeIIK/C/e+6zGWTMv5k/AQ4XQA+T0UV1/Meqgcc5oUVYIhdz9YhaC6xzmRRamKezW8LBjFSyeLjaL14iaSvNYOD32erJta7kPozchEjmyf3ZJ7FO9s8s5t9h7/B7nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776011576; c=relaxed/simple;
	bh=OkSaRfVTCaTRfOMaVdIbPFpxDCeBnWJjGsnSFRqVwTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZVPC4RE+Rf3ThzfQu5B1eDpKHkPdkLgBxTFmvs7amIfp5WgnN/V2u3CLnN20xtyN80z1aRW+Exy5d+aMf8Y5MdyKavGl7f6l0kOPpbaHCRAZ2pMHsFxnwUQt9+5s5S65rSXsgErFEsnmSSnyYsO2eV+BOvKDwfraLUX28kKdWA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qxh3g+hi; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qxh3g+hi"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2d868d014a5so378654eec.1
        for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2026 09:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776011575; x=1776616375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0cSA5OkmM0TPnDu3ie7jfOPhfLh7tZ3ffN2xci0kb64=;
        b=Qxh3g+hiTwmn6b3KS5GKG1PcdoSAc47I1nK3hAf1CFGX7FAqxFKTt78MnwRWrTaYiO
         j2rAWtfeB2hGF8ED1AVQoxSBdK7nYyQRNF/OYez0+1l9/paoPBoRDSMUV95vBJldVFEw
         qoAJwFD9yFlEkvugRKQbPFVt/7AcyWqe6pMigI1JQH/ufas1OJ1yNq8D6owHSpGXoTU7
         FwJ9H7xN+nzT89C7upMqPqGqbm0y1EyxQQ3VsMv4ZRbLSe6idtE7tJNE1kBqrmtu7Zlk
         0qA9x+Vjup/HV0V9i0Tm/vRQJawduOS1W+3yvlJ48O/1s8fYtD289FgPfe6+IhvbD8v7
         1QIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776011575; x=1776616375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cSA5OkmM0TPnDu3ie7jfOPhfLh7tZ3ffN2xci0kb64=;
        b=OG4YyO/J5t9iFizpDrESCIzboTVTr0M58lGWAozrRmmQesGivu2r2ClloKmiKSj8ME
         h81D0+tnYkZu0HxcY00ORg7ehVSfQcUdOV7bf5BRzwfshJHbzqzazt+W1M9WIBwMZ8HZ
         m06H9FB/sSOGc+DUVTuFtxQZLorZ6kYL898htY9dqi3G1gUfZWquKF/wxUo0qsuD+HPv
         Pq2iw8pRr8+FMA2nGCA7ETsduy2aoOKcKHm38sQj4qDGS/eiJQ2LzY0J8ubp2UYC/2Cp
         Gno+pw9z7jiprnLqYFXPp8r2gUqknZXdLoAJK4FBLUSLr+RqJ0yZhSz9C/+b2P+0i10d
         q/AA==
X-Forwarded-Encrypted: i=1; AFNElJ9DprcCA+O67lFDsShY0Uc62xnvrp3+A2MqX0UDzqx4kQiqaS43lw7j8rIxIxfTuHGKD+nJ8gifrVs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgGeN3iNucP7qAQPOLgmIZ6kJ7wiVatM9SQHwWnd6jDq/XYTFv
	yd3mf9BC4IS1ed5fQt1LUR6BxvQlQobzohkqt+ynx2Ek11+r5NrBrH2d
X-Gm-Gg: AeBDievsXlrTg4qEwCJbL5X7QANVDs7mzRg/ZphgC69h0O4fPi5szBoRcdvGL/LrmXQ
	seWMd3vCIIx1Ma6w5YsTh35TaFU+KSZGSfp7pmvVx7DEsXXtLay4dclYloeS5QZ9XygrgX10eAr
	WZUGMErFNIO9tMVFkhO4ALOCGb0DzvQpnyS5x8f2knxHzCl6qfEmgDjherm8/TpPtSVHb7SNCZc
	L/wqgQlfcxAS9KQ0Jb5YIaw1m5VR7lgp5Srl5PTQZHmoevQcWLiONFuZELR97Juic/uF/a48+Az
	wv/wwiR+clPKi4sB2R20NySo5Iln/4WtbxSY10AekXVbyFUC4hnL0o7hxAvShAYSFEOrDSsOHFZ
	E9a3yFwaS88X259plmyaEeRtDznPIp2JoN5dRcWK4KRKuMgGNdZhB17pG7osLIX/15k8E5lo7sR
	DqtVQVENKwJfUyHew5BsaCoSLfWHqI7nt3+cA=
X-Received: by 2002:a05:7300:e828:b0:2ca:7eb4:3e0f with SMTP id 5a478bee46e88-2d586699913mr5322475eec.5.1776011574647;
        Sun, 12 Apr 2026 09:32:54 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d5630ac330sm12815917eec.29.2026.04.12.09.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 09:32:53 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Cc: alexjlzheng@tencent.com
Subject: [XFS] Question: can xfs_agfl_free_finish_item exhaust AGFL during bnobt/cntbt split?
Date: Mon, 13 Apr 2026 00:32:50 +0800
Message-ID: <20260412163252.3359028-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

I have a question about the deferred AGFL block freeing path and whether it is
safe from AGFL exhaustion during bnobt/cntbt btree splits.

When `xfs_agfl_free_finish_item` runs, it calls:

    xfs_agfl_free_finish_item
      -> xfs_free_agfl_block
           -> xfs_free_ag_extent   (fs/xfs/libxfs/xfs_alloc.c)

`xfs_free_ag_extent` directly manipulates bnobt and cntbt, and inserting a new
free extent record can trigger a btree split. A split will try to allocate a
block from the AGFL via `xfs_allocbt_alloc_block` -> `xfs_alloc_get_freelist`.
If the AGFL is empty at that point, `xfs_alloc_get_freelist` returns
NULLAGBLOCK and the split fails.

The normal extent-freeing path (`__xfs_free_extent`) guards against this by
calling `xfs_free_extent_fix_freelist` first, which invokes
`xfs_alloc_fix_freelist(..., XFS_ALLOC_FLAG_FREEING)` to ensure the AGFL holds
at least `xfs_alloc_min_freelist(mp, pag)` blocks before touching the btrees.

However, `xfs_agfl_free_finish_item` does not call fix_freelist at all.

The deferred AGFL frees are created by `xfs_alloc_fix_freelist` during its
shrink phase: blocks are removed from the AGFL immediately (pagf_flcount is
decremented synchronously by `xfs_alloc_get_freelist`), and their actual return
to the free space btrees is deferred via `xfs_defer_agfl_block`. After the
shrink loop, the AGFL sits at exactly `need` blocks.

But before `xfs_agfl_free_finish_item` executes, `xfs_defer_finish_noroll`
rolls the transaction. Other deferred operations that execute in between—for
example, regular extent frees (`XFS_DEFER_OPS_TYPE_FREE`) that themselves call
fix_freelist and may re-shrink the AGFL, or rmapbt operations—could consume
AGFL blocks and leave the count below `need` by the time our deferred AGFL free
runs.

So my question is: is there a guarantee that the AGFL will have enough blocks
to service any btree split needed by `xfs_free_ag_extent` inside
`xfs_agfl_free_finish_item`? If so, what mechanism provides that guarantee?
I don't see a fix_freelist call or any equivalent reservation in that code path.

Thanks,
Jinliang Zheng
