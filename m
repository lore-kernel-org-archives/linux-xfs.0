Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFF814ABE
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 05:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779946296; cv=none; b=YXoA95Mo+FF8NfMoADON18QIkx9n5OiU3p+aCZQDifoJUHmNyTd6sxmR1L+8KCYGU2HpbXwAk7TTq+eePL/FzDZzRo8zbEqO+FQtSIQj/b2ZsTFrPg/1b8fy4r5hAkz2CEbBGSw+384yay26uz9oj6d3oERW/DpeFXr6OUeEw4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779946296; c=relaxed/simple;
	bh=4BnOYYTb7T97RMTGXTcfR2Md0+TeHYXB4VU6gbyex0I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Blm5zluuH9mhEcBGPdZPKjyp7QYHL6C9rvOk+pysti+2Ti3M64FeIXSv2H/mx01mS8d1CpMxKmtmMQuqH/YM+uRhY4jeetMnnLjR8pt5tqhw0iJmJcqFk9JZav870YRXwloxu4ZuTuY+o0u50VTtIdRGtuBMOx/NemGRb64FQJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jultqHbB; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jultqHbB"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2ba3e3c4f87so129876135ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 22:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779946294; x=1780551094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fFLT2sWkrj/RA6HeZzNRNeQFBEPLyGDvfOL2SeEC/uE=;
        b=jultqHbB+7fk9zDG9hPzFpt1aBRYNAD6e8BIUoi4gOso10uBHwKTTl6UJAMIHMt6uJ
         E1yaqggzh7v11NqJK33PKscyo44vVA/QCTk/x54rcAHE7Gl2QxC3vYkc5YQrW1rscJ8a
         2/U5EuiYXElm1139265B8bIbqX8l0uX0e7a33N72fAEAfRswSbeiAZ634WOKp7xq40zT
         bkdYyMcR0MRU27yAODvn9dgu7u266zjpT35IkyiiNURC+4mpS/gbPiW8r9QZvv8htGB5
         U2IZ7QtwtCgwUq1Aq/tMyfIoAMPzHiLt+l+7Rw/wZu26q6veBSmLim34cX2lwcrO2ll6
         IFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779946294; x=1780551094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fFLT2sWkrj/RA6HeZzNRNeQFBEPLyGDvfOL2SeEC/uE=;
        b=MZdnHn7NeiUQxRsCDpitOS1Ma2Guiy7Ak/x3O5FuTRAcBdv+zu/P74uTFfUIkoQ3Zs
         cxvu/08Q1PDz4EzIVYdWKcBpBpa7uiMKboD6X9v9DdmIfb94KA4LFSnep1yNnWFiFmr0
         K0Ug5bV6JMy3G9FnGGgAs3Vej6nuh4Qu9ck8IWMMWlLNgZNsmr7RwDu9Bn8KHIY2815t
         m7yQ7Bgdu6IACkn/hJRSZWav8maQyuexcf5I8xUMsv5E++hTE5rQQrq9iUzkXQEyRscK
         FLs2wDK7WjvV27UUO/ickRD1wwaklifnTZFmPwRYqdi08c2LkRYWrp8duAuHP40kyv3L
         mLsA==
X-Forwarded-Encrypted: i=1; AFNElJ+y/kxn2xfnlc91jhvwo5yfOsjI3Shi3rWsNs+4Xw0UFWgzBbfMm3AfddVGPclRIj7C+YSWkFETvYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjydT1a+UehtRC06MTwxyIM+i9pValXHmbsFCrAj0pxeiPLh0x
	ubqHV06rUB0BV9k+HuksMiQXVs056V/nNhMuITyUHdl0y+rspNp8A2ZQ
X-Gm-Gg: Acq92OEeh3Ir4stt+7kahZMJOk9EYnDbKLX+1ottipUfvxc3bLPiz60WIxswAdutz++
	GaDCzinjX6sBU6wqTFFfwziZy/Pyb3dUNVZd75Ymwm0moubL0nsYLPgPtcFuIEu0dgIJUXuWwck
	T2n3+4EciODBA9GYTTMqgLviragaGStQMAMYZGO3WsGr3gsBJF7S0hCP+6LVN9bSUQjP22PBjVJ
	mHaRIgYx/zYduZw9tgU8kt5dv5YKCxyn0L80ZZXrzsT/JK2nClBogancv1vLazADQHUBqLl0CdO
	nr71UAynRDXiqcNHTuNwwd2QD07wdm9p8fVAfDLTIO9WHJMrMPW5ghezk0flAHS5krkacOWZAOg
	M+8MxE8smMY7/TzCLoGC4pZqWyE0NPw2cYR99u0EvGJHmI34jBA5TopXJYkXqWvIlkRsaOHYNr3
	fHS8EBxsT7LmH3TTavVj/s/fy28bYuy+WOtd+86slcRA==
X-Received: by 2002:a17:903:240e:b0:2bd:907:2cf0 with SMTP id d9443c01a7336-2beb0632925mr287109895ad.32.1779946294313;
        Wed, 27 May 2026 22:31:34 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5695a75sm217440825ad.14.2026.05.27.22.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 22:31:33 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhang Cen <rollkingzzc@gmail.com>,
	zerocling0077@gmail.com,
	2045gemini@gmail.com
Subject: Re: [PATCH] xfs: drain inodegc before quota teardown on mount failure
Date: Thu, 28 May 2026 13:31:28 +0800
Message-Id: <20260528053128.3036120-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <agwh6darf9q52za7@infradead.org>
References: <agwh6darf9q52za7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Christoph,

Sorry, I missed this reply earlier and only noticed it now from the
public archive.

> How did you run into this?  Normal xfstests under a new sanitizer?

This was not from normal xfstests.  I reproduced it in a KASAN-enabled
QEMU guest with a disposable quota-enabled XFS image, then forced a late
mount failure after quota setup while tracing the inodegc and quota
teardown path.  The failing ordering was:

  xfs_qm_mount_quotas()
  late mount failure
  xfs_qm_unmount_quotas()
  xfs_qm_unmount() / xfs_qm_destroy_quotainfo()
  xfs_inodegc_flush()

with inodegc still able to reach the dqattach/dqget side during the
teardown window.

> This looks good.

Thanks.

> This is later in the teardown order than where I'd expect it. The
> first thing that can bring in quotainodes is xfs_qm_newmount.  I'd
> expect a new label placed above out_rtunmount to handle this.  Is
> there a reason I'm missing why this won't work?

No, I don't think you are missing anything.  A separate label above
out_rtunmount is the cleaner place for this.  I'll send a v2 that keeps
the out_agresv inodegc drain before xfs_qm_unmount_quotas(), adds an
out_qm_unmount label above out_rtunmount, and routes the later
post-quota failure paths through that label.

I'll also fix the trailer spacing in v2.

Thanks,
Zhang
