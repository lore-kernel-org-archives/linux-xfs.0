Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="SMRlyHpC"
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93073D5F
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 11:20:40 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-5cfa65de9ecso17833827b3.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 11:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1701112840; x=1701717640; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7lz0VBUYkCA7Kx1NWqS2WZCJC35ADqSHV6LKDgLTHFw=;
        b=SMRlyHpC8ue3IQGgrPRwHtmzGDf5v3tkNvcQRqLrZZhN7ZukTQrO5gtVG5e7qLIP0V
         REwfs0RRDFzBuYuy0/lKkKN3WxOCW05XHV1ig+cd4fhYy+MbhxSTP9hnDSnJOzMWajaF
         OP0w1eNKSWirYRL2yi6murGPMNjv3loqC6V6SRVLKkSQw90X00Ies0oYZR0TCkpQOPj8
         3VGVN66gXegTUzTpgoGCVCZB+lBp6lXBdz5VfFBrogwBgW3ZYt5EaxEYbBL6WdefJVrc
         gCqGMB/fhFn6ay9IGMPvb1sgwy0Id7dkjmZLDBDv1bTZLVNg3cGF0zqHCa1Y6YpZ4Imm
         LsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701112840; x=1701717640;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lz0VBUYkCA7Kx1NWqS2WZCJC35ADqSHV6LKDgLTHFw=;
        b=EOKf+jIHUw40SwRNNksoVKDN37UQj3RiFEqlVb+D4TOhrfrOTkqLM1aHu/275/TBji
         BfZvi3EKiBJn/tLkhFpe2WNL3GL1mnCSNcW1XtaZGPsj71enaLTahOVyIO+8muH6Zlnk
         69lzovuZ1o+54hyNL0um8RzmstMuHCfxjooYNQgskotRu8T0wYcEEeXwQu3ZkG0zVPvD
         XBLn4KE85TXLA7Tun5fE0IbmXUESwH5RCCaBG0Z33qwhdHa/16hlevdiyx+Itnlb/wW1
         rCQRBCXveh42ElKc0BlZhPI7tWleAzFUZS2WQQMFhwzRtuwSGmiYG80ZO87Txhd6S+oK
         S65Q==
X-Gm-Message-State: AOJu0YxCVxUL7YryOZfYFGGyQ+Y4hC7YnQ45hI4EFoarkPmrcAfqDc8V
	0n86k5bwmqOOBfPDO579qcai5g==
X-Google-Smtp-Source: AGHT+IELblu/nAnT6NTNLrViyrHmj+e3xGCNtbgpJFm8DcMJWcjE9oe9hHN3sjisYl8PjN6YkRs4lQ==
X-Received: by 2002:a25:ab82:0:b0:da0:3df5:29f5 with SMTP id v2-20020a25ab82000000b00da03df529f5mr11218973ybi.30.1701112839785;
        Mon, 27 Nov 2023 11:20:39 -0800 (PST)
Received: from localhost (076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id g129-20020a252087000000b00d9ab86bdaffsm3246016ybg.12.2023.11.27.11.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 11:20:39 -0800 (PST)
Date: Mon, 27 Nov 2023 14:20:38 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/13] iomap: move all remaining per-folio logic into
 xfs_writepage_map
Message-ID: <20231127192038.GI2366036@perftesting>
References: <20231126124720.1249310-1-hch@lst.de>
 <20231126124720.1249310-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126124720.1249310-7-hch@lst.de>

The subject should read "iomap: move all remaining per-folio logic into
 iomap_writepage_map".  Thanks,

Josef
