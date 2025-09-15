Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD58B2F4A1B
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 11:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757934752; cv=none; b=MVU8qtYAQ7+/ejKFWvmtLTukhFxcO8ToWPCDbJQGbRM9G3CDYkOKu5LqUC/avSGCLSUzh/pYGkysN4jsauv3kW7aAtJljglwPoi7p14bOZkjANYmWzDWHF3LXcB0iTG1H2t0C6uB7kKNxjNhaGbApwkkjKhyR+f/6W8Q8w9RimQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757934752; c=relaxed/simple;
	bh=VY3zkdhTGgC126uMIeS5gV6qogT1HLoj1i2dxU+5eik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvxt880JK8kPWliR0+6mhG3jErYNszW6qaFYAAAmmEFEYKT6OpapJiHOudYYlrrK7rzxk/sBVP0dyW0ELuCS3afmF8XVXNc2LJut5Z6IyQUG2PCqt0cV/G0eg7XwvEdDP+hFF20YSFJckYyBH3UIuQmNhvjaDrnJ6v04O6iWqHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JP7plFNw; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JP7plFNw"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b54b2428fafso2362486a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 04:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757934750; x=1758539550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4p12IzWrRO+GuzSOQKOoYoCmZLULC1GsuqYzZhikEms=;
        b=JP7plFNwh89sv86Cw8BHKTbfdRv709peLp0C+HGfWw1C2dzLaKCdUtqGhpBwHl071U
         0Kj3hH81bMd77qHnpLyC9pjnHFeEqivHqmU/CkdNLHSobUk7wTzPe/DbP2r/lumuxo9F
         3GzQcZz9xAnb8wL8E/RzUCoGGTb97dqWX8k61itKUMPIctsIFT53Xi6kkXruqA7tcXAN
         SXhEeVbX72Yw700IdW+2feK0Net0oN6LBOgFabC747IRusGp5O542r0GzgGOp1d7O/7L
         /wYy/HWGu81w9vCkaz/Z01PvBmixkjtWhaDTDqp4IDIJ1ded4CWth9GmKT1BpIVB8IoG
         b2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757934750; x=1758539550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4p12IzWrRO+GuzSOQKOoYoCmZLULC1GsuqYzZhikEms=;
        b=IWaaxB3mBltWWczvc5mQF+xViFHTP7/KhpMikWZ7fC1/IfF5AV8TVnerzEF7hu1T0S
         tX9bv0PpcbSrvQxqne+iBotMrVXqlggtbZrsb2iLeW+zT4wYkTMfpeWVJK/zon26bdIN
         b8CrcbtUxIM5dkAnv/DiGJPlAbp+HNA2PZYQ/YsbG1nwPd5lkizwbC9aRcXcoudNgYq5
         OikMleeOhjqcov7Y/VPAqt0HgOBMkJkC8gRopV1PbmzV992Rv7b44BPE4jTWyqgdMHBH
         mudFAjj4NJodsHzAcrGwdFK77j6niySmMQXDprkTdiTJ+x3y7colYUJ+aYzUKOpIlFsq
         E4Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXDmimYrpmv7qvP4voNgVyUiNoUrox57O9FX/z3rQ0q4AP9B1VAqgaZo5/pkgYpcar+eKL9vdyK9iM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNkEnqQWEOENiGo6zLVmAIlyZC6yb0+Y9t+HsKk0HDby+uXxN3
	XyCD1wu+wyDvf4/wJT7rSrp5THuyWreqsO+sF7OdQ/mXVGjYCurUMucE
X-Gm-Gg: ASbGnctlqiKL/jBZhhOxiCHnOK8bup+OyF4yJiVsdy0HcgBkLqEVl8fayuNowPXAymT
	KoDO9idlkvk9HNRsrm54fYe8HDKnh+PDy4m/EbuUvkQz/em7sRETp5b3VYlh+C95UuN/pY22hvJ
	Qv54FS02Yg9G/NKC3HtwoNHYgzeh1ly9UwKEkT1ToG9XCteSJzjcaMUt1EflBE8K0H/kW6hMyUb
	ttoOFefqgoNRiGeOV40CCSzzBzYa71G0p2lsnxDf+aCJ+zv2/rFzjxy8eoBa+dA7eet69zxCGNE
	9ZF+U6UGaIKvEL1wLwc7jK+ZQMZ+PGHypXTuiBKSDFhhhWc+uUFHze76ItU8/RPu/afidsXSD9L
	+B4Qz9IYmPyLjoW78XLVPACFXjj1ZNgnrtg==
X-Google-Smtp-Source: AGHT+IExDJoPLFyVEh3wqMlZXAiX0+tZkyl11B1SwSybUi3y+vj4NaoaTvhTCkhJAG90Odm2ARIFaQ==
X-Received: by 2002:a17:903:1746:b0:264:70da:7a3b with SMTP id d9443c01a7336-26470da7d17mr63606755ad.49.1757934749994;
        Mon, 15 Sep 2025 04:12:29 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-264ab88689fsm41411705ad.27.2025.09.15.04.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 04:12:29 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: kernel@pankajraghav.com
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com
Subject: Re: [PATCH 4/4] iomap: don't abandon the whole copy when we have iomap_folio_state
Date: Mon, 15 Sep 2025 19:12:28 +0800
Message-ID: <20250915111228.4142222-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <dhjvmhfpmyf5ncbutlev6mmtgxatnuorfiv7i4q55wpzl7jrvn@asxbr2hv3xfv>
References: <dhjvmhfpmyf5ncbutlev6mmtgxatnuorfiv7i4q55wpzl7jrvn@asxbr2hv3xfv>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 15 Sep 2025 12:50:54 +0200, kernel@pankajraghav.com wrote:
> > +static int iomap_trim_tail_partial(struct inode *inode, loff_t pos,
> > +		size_t copied, struct folio *folio)
> > +{
> > +	struct iomap_folio_state *ifs = folio->private;
> > +	unsigned block_size, last_blk, last_blk_bytes;
> > +
> > +	if (!ifs || !copied)
> > +		return 0;
> > +
> > +	block_size = 1 << inode->i_blkbits;
> > +	last_blk = offset_in_folio(folio, pos + copied - 1) >> inode->i_blkbits;
> > +	last_blk_bytes = (pos + copied) & (block_size - 1);
> > +
> > +	if (!ifs_block_is_uptodate(ifs, last_blk))
> > +		copied -= min(copied, last_blk_bytes);
> 
> If pos is aligned to block_size, is there a scenario where 
> copied < last_blk_bytes?

I believe there is no other scenario. The min() here is specifically to handle cases where
pos is not aligned to block_size. But please note that the pos here is unrelated to the pos
in iomap_adjust_read_range().

thanks,
Jinliang Zheng. :)

> 
> Trying to understand why you are using a min() here.
> --
> Pankaj
