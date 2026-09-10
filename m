Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F395438F651
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 15:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789055264; cv=none; b=gCuG57OZdjWe2IMcTzmszSTsPQGqvSET0T81RiTBMEnZwDGDde7s9+MN+p35SIcvN6QIh1qNcFQFVaUaI3IoifxlM8LBXiR1Z405UWPgO1oD3GvTEbmeZ0hiczACmNH1p5Y0QD1MHy6qMpTe0Nbhke5C0ZSlViDplTXCzyakURA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789055264; c=relaxed/simple;
	bh=0+sxsAA/KszmbS0Y2uuZRM3am7zRasodMYDmegXpTsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCqFnXO56QxGNRhC3VYmil8P97IXrIMe4Q/A1kw1DgYls0FxDRAciNd6eek08LS5Ekzxwx0+ErMacnquzSSHuDJi0Y6qyrKgRKB9peLqpMTC826B/TOE5VvzP+ZtVS0uoc3fH4aW62263bfaZV3eepT5K2rEJBe+/023bfH1dpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jAxsHCD0; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jAxsHCD0"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d942c7cc2fso61793375ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 08:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789055262; x=1789660062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=68qGyetPcVC60nUYsKlBN4PB3E0Z8TnNr33/7f2ZQn8=;
        b=jAxsHCD0TuKCV1qoV0rBOVvyX/rsrxbeEGVfNDSJR6ZlqGGhjPsg0Jk/a/mTVfcb93
         snClXFLHk+lA6p66rkwIexMir3fPwWS+D1wPYYOaNDqFthBRQSnjEfMaVjii66JcyHr8
         +A8g4zDvnVh3Qrgfwe64oDpIpn1O5BDraIfYONfX/H8oh2wTxJmrAhU8uti2McU04N15
         g4/rOdEtkidwpdl1+cmQ+z8S82+0ukwKxJ7NrW6C4R38YEAdTI+iTbMq4PBpduaGZYDH
         6AaWFs1/gRHNJh/KKo7D+5AAUL35c9pIvAc77lQGiu/3KO1CQ9y6YBElNTq7usINDFRn
         WFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789055262; x=1789660062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=68qGyetPcVC60nUYsKlBN4PB3E0Z8TnNr33/7f2ZQn8=;
        b=fvXXEZn3ukc4Qy7GngOybqGw9vLUCVJjiMd06Flv/b6Z6HALFK/XK58sCOozfxcgxD
         yB4cphGbp07WWq4WVitORBApLu9nwQUoDrKOnOsdpJ6mxBs5k77VxXw4vEXIFTgfVbqX
         0B18ElT8dhhZxFf1/0BM8DYusrEV6w/zlARX6KUC4vrbvcW7QwcMFCKnb3yUs3ZOXFuR
         T14FAnXH4lgF8DmQJI0sFkdr7WxuMySJpWkjC7Gb/acU0i8cSIFEOOGJ61l2s4yv695H
         yrIoOLwMWZrejR4r1OH7/Snjjxj3eZy7WMFgR3H96xlaXahzIb9fehwrJ884w7GpksPB
         QtmQ==
X-Forwarded-Encrypted: i=1; AKwUvByvGPf0uuStZddUB+5/uP9xw0Bez17m4AZKnXBtYw82RjBQX0N/DyBhULkExQ8podKxTRvjPxSh9wA=@vger.kernel.org
X-Gm-Message-State: AFuF++ls7bBwjoy14brwk1fxLc8Wp+6R8QF07dpvZeMrwAGwVENEZyXH
	bGDitsEPH/yvIodWWdenLsL+WzXNf6WPJJqjxsICDZ8F2JydCzX2yuwL
X-Gm-Gg: AYBFou0RJMRGc1R3XEAkl6saG955YPEd0YXTF9lf+GV+W0zy0tB+ESkzDxvuEXVMrRu
	Ts2xFvxRGWG8q8UUcYZ972SwusQG0oBcp1G+qxA4uLd0oA3X8lyAL+Sucf5FvCL0/yyc773lqr8
	02c+KOd52VCFBQhya6TyEGwqLXdHO7/IK5jLIiAnQuuGp+MuE9CEQGt2uUa6/HWqbYnQIVZJDEF
	FEMc1xH4pWDFgaSOFDvsfUMyyadGzAG16L3AkP3bMnzH2g/GwUzkeSwyAorQUYuPItpxD3LcRwt
	7vEghnrFBHdw9LfrZZaPyV4hezpOwNXejUAF2R2RQJsBQlEb40PfkFzqjxb66kqntUm2SQlOSfa
	WSkxhU6IlZG40KPzEcyM3CvSIG+dQ8P4pQw9KpqLS2GIveenPqmHy/DWjynEd2vW0Uyv/Ir6tF8
	JYaHpL6jHh5iSGqeEQYKVlNOFIH5W7/VZHwLuT10NCGJnWOnY7J3WZlSL4o+kEhybULf1rMHfYT
	PVf
X-Received: by 2002:a17:902:ef50:b0:2db:5052:fd6f with SMTP id d9443c01a7336-2db505300a7mr385282565ad.17.1789055261972;
        Thu, 10 Sep 2026 08:47:41 -0700 (PDT)
Received: from Default ([2409:40f4:10fa:e40a:bc1a:13c8:1537:bf44])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339befe870sm58564958eec.30.2026.09.10.08.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 08:47:40 -0700 (PDT)
From: Jeffin Philip <jeffinphilip14@gmail.com>
To: dgc@kernel.org
Cc: cem@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	syzbot+a4fde844548510369112@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	jeffinphilip14@gmail.com
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Write in xlog_cil_ail_insert
Date: Thu, 10 Sep 2026 21:17:25 +0530
Message-ID: <20260910154725.18960-1-jeffinphilip14@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aqI6v-_dc2DDSbgB@dread>
References: <aqI6v-_dc2DDSbgB@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Sep 09, 2026, Dave Chinner wrote:

>The short term fix is to slap a bandaid on xfs_buf_submit() to wait
>for unpin before erroring out a pinned buffer on shutdown. That,
>however, doesn't fix the underlying lack of full lifecycle reference
>counts for log items.
>
>The long term fix is have the AIL require a reference count to be
>held on log items it tracks, and only have that refcount removed
>when the item is removed from the AIL. That's a much bigger rework
>of the code. 
>
>FYI, I've attached two document below - the design for
>generic full lifecycle log item reference counting, and the design
>for converting the inode log item to be dynamic similar to the buf
>log item so we don't end up with millions of ILIs that are never
>used left sitting around in memory until it's owner inode is
>reclaimed.

I read the documents and have started writing the wrappers. Is anyone
else working on it?

Thanks,
Jeffin.
