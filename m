Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAE2188CB1
	for <linux-xfs@vger.kernel.org>; Mon, 30 Dec 2024 21:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735593989; cv=none; b=tgglr0RBdPK8sijYrPvg4kkOAHYGS/QcABSFYwD8K15cfQ5jqYszU8C0473wjOLrL2tM3wbNkSguN/lcgdGPIWbpllyC2a119zmRQJLslu1OPyjZiGIIaAYHf/tUKf8Pq+o0rO3jVq+7823/nWJy7dqc6ZfdDQOVPLApGmXCXoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735593989; c=relaxed/simple;
	bh=DNxA5OwBk2sPQzIjF89hL8H4lFGhqArMhMr0RH1DCes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOZTuBW7/Cbmtd/YCaQBWv84QTaZGRFBVMRedTDuXPe21mk4lN3ZNOsLHRn4oTGSjygu4FloiRMSQ2xU2DY+LvHH494tFtKDHzduQrXeIQ/yagVlZYMPp8t/0Lw8F5p7g/7Q83fSYxRTjvI4q7LhDKgSTxBKiAKl+KobKSNh5Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AxE8o0il; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AxE8o0il"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2f4448bf96fso9756420a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Dec 2024 13:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735593986; x=1736198786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULBFfNOHsM6cs4yHp6Mo3nx1wmv0fWNPmkecg0AFJa4=;
        b=AxE8o0ilh9FH+txXW4lylSYId4dN6YWaV7XwxhQ46+1fzLmYmnxdY98IUPSo1W4brx
         Qxv5lPUI7BQdKbPbwZr4ToG+rw7Rjmo2UrnU2Fdi2rXrxDM3BedhZUshgGRfe7lLj6Vn
         RHF18zO+2ylVbWUxiMXv66Q83TodiUhziJ9LLQ75vgbo+De59u+gVE9uos++mAqM+uvv
         mlRVupAOn5ptF+ql3aJP37r1laVKaBj+EGe9jTTVLKdMeCb7k7E81bXbKP+oBP22A2DV
         4Am2OcoX0ixMBiugYXPaV2q7uXn08uSOTNSWqmVzza72gzQQMBu7LGBkBZVkeFAZ9VAw
         UMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735593986; x=1736198786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ULBFfNOHsM6cs4yHp6Mo3nx1wmv0fWNPmkecg0AFJa4=;
        b=LTc4DeAh+gwDIAZWcQ63rs8UK/YW7z1/9fs7MY0bq5boS8J+chTZVzI8C3LICBt1ti
         6ZoGBAossZ43PGNLuIgNLiRlFFkqJ3H884SjLTTkV67Q2zetGv8MfWgtzaLusvtCRJzy
         0WmCFuKG1IZ4MFBsu5ge6BI0g+P4tTz0OfjpsLJuRF17nCAzHbrCvyVY0afVR2ZcGIB0
         oUFZlf1NdecPjMX5pc+TTbN6wD3jP0MBvwVNoINi2eJQlM3TOWVR/sjXR7Kr0aGTIpPv
         uc8IZhqDdraeUSlTODD5k6MRVTRmIUzIcO61eXFRgNDXXk46NoS3gY5MzZ0suUODuCjD
         d8jQ==
X-Gm-Message-State: AOJu0YzyWYTFXOz29z0vWWnFryXGOFqEV5Ubxzd1fQJ6mSPIDIUv9HyT
	S9HRisdpVjcgOQg/rzXB34gRoaU5qzlYW+klfDDnHqT0ttyHLXIEXx735L9jY8o=
X-Gm-Gg: ASbGnctvRYMI+zznnMNz4M6IX0AfxLwpgd1c/TH8a3b9KSNoGXeWH4XUrkNECfVW7C0
	ezqamc79zDHgTz+5+BtOm51kliGD+99V+34BiJv5i7NXnF/u++62f8T+SVfjtumjJVP5n86i5xD
	f2Wi9UX7gygRUM0W2NT5dUMVE/gBKz+nZXRR76rra+FqzF0dLVcAVMLVfhrPx9y9rm23+bMkx51
	SvvJCPtjVzLVH/jNmWphwJrorm1c6nuV5W295BLi8gEtLmHPRYbPGQydmXZCiR0LJc9MNu1rusa
	23Vq5fhlQr3kJg1gus64N9E=
X-Google-Smtp-Source: AGHT+IEkkz/ZKhvjoEoM3pWCid+8mPptC+oG7w9AmHtZM/Uti83RhWlQRLnweFOH6pRnKSASqc85Jg==
X-Received: by 2002:a17:90a:d88c:b0:2ee:b6c5:1de7 with SMTP id 98e67ed59e1d1-2f452deb516mr51556150a91.2.1735593986412;
        Mon, 30 Dec 2024 13:26:26 -0800 (PST)
Received: from perforce2 (75-4-202-173.lightspeed.sntcca.sbcglobal.net. [75.4.202.173])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed8304absm25641924a91.24.2024.12.30.13.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2024 13:26:25 -0800 (PST)
Received: by perforce2 (sSMTP sendmail emulation); Mon, 30 Dec 2024 13:26:23 -0800
From: Marco Nelissen <marco.nelissen@gmail.com>
To: bugzilla-daemon@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [Bug 219504] New: XFS crashes with kernel Version > 6.1.91. Perhaps Changes in kernel 6.1.92 for XFS/iomap causing the problems?
Date: Mon, 30 Dec 2024 13:26:23 -0800
Message-ID: <20241230212623.893046-1-marco.nelissen@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <bug-219504-201763@https.bugzilla.kernel.org/>
References: <bug-219504-201763@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I think this might be the same problem I'm running in to, which only seems
to happen on 32-bit kernels, starting with commit f43dc4dc3eff0.
Problem is still present in 6.13.

Easy repro steps are as follows:

hash mkfs.xfs || apt install -y xfsprogs
rm -f xfsimg.bin
truncate -s 6G xfsimg.bin  # I can reproduce this with an xfs image, but not with ext4
mkfs.xfs xfsimg.bin
mkdir -p xfs
mount xfsimg.bin xfs
truncate -s 5G xfs/diskimg.bin
mkfs.ext4 xfs/diskimg.bin  # this can probably be any fs type, it happens with fat too
mkdir -p mnt
mount xfs/diskimg.bin mnt
dd if=/dev/zero of=mnt/file.bin bs=1M of=mnt/file.bin bs=1M

The above almost immediately prints a warning to the kernel log, after
which there is a kworker thread hogging the CPU
