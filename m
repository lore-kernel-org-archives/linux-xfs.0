Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A932D788
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 13:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XDApVDuB"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a28b1095064so184612766b.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Jan 2024 05:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704461483; x=1705066283; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q6+KzCXM5YkP8A1jISM9ILSyDMeuUm71FZWWNzy0y2M=;
        b=XDApVDuBlC48n5Hut0vHkDRHA+TVBJ2eZJsqfMqlr/o8WW6EuRAKfd2C1p4RlZk+A3
         Cmv/2xgY6i0qHdMS5u9jLDCAdAWn/MY7n0TJGNncF78h+T2nEp/BN2bGXloH+0neIvrb
         I3UlZ0V13Nvpb1rlUN5MTnhEyWnMs8DZksURWcj/LsASr3n8FOU+xACbEbU6vAvxOTdQ
         jXxBuMFWntnElCQSMsWnyQUabV3G2mM+ZmzLTXHbiBLhnm7eLPCY5F1KxJ6sQRb/asEb
         tFsYU7UTqiYU8hOQ6ukv/07EsvU7kzBN+DqIYrKHiL+ET2OrJcaILDwUU+xpMyNV0q94
         MaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704461483; x=1705066283;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6+KzCXM5YkP8A1jISM9ILSyDMeuUm71FZWWNzy0y2M=;
        b=jPvPkQgE/ZCFnArYpcPyUYd0FEkmFj+ypeoKJ/Wqn38+zb5nyMvYT1RBKbdvmbe+dF
         lBQr5L2CJQxyx31I0T0xAHgXM72YZxTG6DMANZG0YdyYscPwNFO37Z5MvNK3WnZ2dq4z
         Iu+fWz0UNBvcaOlJsj1uz/Mg7xnUGNXeiXcvZO7tXURPcvIqZR1ul9ze3vxdaMs0UFha
         COHRc+BIFjtwLsZU5CsFW5NIh2hOQ5jHPUgo7jCaHvG0Pz+O1hyjFsU4Ahy0JLq48nS6
         8dMyush6aJjyJ2p4dxQpvbyh6Kprbkkc21jl4iBG0Gz10c0KuRPgryooPcb9EeZ6Fv7Y
         X0ng==
X-Gm-Message-State: AOJu0YxvY+sosA99gDL/W5U3SqJPNietOtD9y9WbsfyyJrtTuygPwC36
	x60dwnCEkf0CXRhp4qljrwMMWTdw3wcwRLxPXSsv7lUoaWs=
X-Google-Smtp-Source: AGHT+IH8gkWJE01hcy4oPnbpPL7DZNyghll3et9x5Ahxn9BSPZwDuas0VeMXAMtiJYd8iTuzi1PfIA==
X-Received: by 2002:a17:906:1107:b0:a28:ac5b:5814 with SMTP id h7-20020a170906110700b00a28ac5b5814mr612703eja.185.1704461483059;
        Fri, 05 Jan 2024 05:31:23 -0800 (PST)
Received: from localhost ([102.140.209.237])
        by smtp.gmail.com with ESMTPSA id j21-20020a170906255500b00a2990007447sm214277ejb.122.2024.01.05.05.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 05:31:22 -0800 (PST)
Date: Fri, 5 Jan 2024 16:31:19 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [bug report] xfs: check rt summary file geometry more thoroughly
Message-ID: <7ed30c07-2e61-4a73-a6a6-f7d15b75765f@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Darrick J. Wong,

The patch 04f0c3269b41: "xfs: check rt summary file geometry more
thoroughly" from Dec 15, 2023 (linux-next), leads to the following
Smatch static checker warning:

	fs/xfs/scrub/rtsummary.c:288 xchk_rtsum_compare()
	warn: missing error code? 'error'

fs/xfs/scrub/rtsummary.c
    268         for (off = 0; off < endoff; off++) {
    269                 union xfs_suminfo_raw        *ondisk_info;
    270 
    271                 /* Read a block's worth of ondisk rtsummary file. */
    272                 error = xfs_rtsummary_read_buf(&rts->args, off);
    273                 if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, off, &error))
    274                         return error;
    275 
    276                 /* Read a block's worth of computed rtsummary file. */
    277                 error = xfsum_copyout(sc, sumoff, rts->words, mp->m_blockwsize);
    278                 if (error) {
    279                         xfs_rtbuf_cache_relse(&rts->args);
    280                         return error;
    281                 }
    282 
    283                 ondisk_info = xfs_rsumblock_infoptr(&rts->args, 0);
    284                 if (memcmp(ondisk_info, rts->words,
    285                                         mp->m_blockwsize << XFS_WORDLOG) != 0) {
    286                         xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
    287                         xfs_rtbuf_cache_relse(&rts->args);
--> 288                         return error;
                                ^^^^^^^^^^^^^
This is zero.  Should be some kind of error code.

    289                 }
    290 
    291                 xfs_rtbuf_cache_relse(&rts->args);
    292                 sumoff += mp->m_blockwsize;
    293         }
    294 
    295         return 0;
    296 }

regards,
dan carpenter
