Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71A81D048B
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 12:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727871862; cv=none; b=NwVTaLL/WDzHrVOB9+TrtzyxvPVAWcuJslN4ssNivhu/TEiYh3jVPbhaOPtv4FOcMpArw+lalg2EoUZRX5BibjG1j2KXB761KlkBBYy3slegumaDbhxTBSdFvrTnOhHhWYEhyhe0nKoZpjr/YbcCTkCAcC7/VQgDZh+tHE0SqxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727871862; c=relaxed/simple;
	bh=6bXeKCsanUMt8vsnfk0ee0Gw9oQ7jHQbn09VlI9NjcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZJwmsb1MunuPIjOaIuHZERXWi1HarCTSyzndFF5o7JRbn56ml0w1cnmmoF2u3uS45g4nERXQpnPl6g/0Wpft9efq9vZEwV2kJw10vjkZEK6ODLOO2CFvefzuAbUZ9Pi1g7Po2dnS6q7bJW8LHon8u5zmCWnfAjMpQ/WxdpyOZXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=U3Vf3lDG; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="U3Vf3lDG"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20b90984971so33039015ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 05:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1727871860; x=1728476660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VTNeeOGHdCxE/aLNehqkFVEv3q3dYYmghT3WJcV4lE4=;
        b=U3Vf3lDGQz+p9EKSZnBGinh7G6jIbt1j/n7Kwskrr4q5HkYnvoPpO32/tjeElRBmcq
         CRORoyZsxcSgUfwKJOFW0ObOrpdwcxAwNU7ZT05IsUXkOanmV0les70Xa+JMbZBPoQjz
         r9Qe/9mcpRk3V98g2Km8M0Qh+lb3eI63Di5vwrr3h/M5U937SbGJde01yAKxRS2zF0ud
         J22JGbZLj2e68pynHwAjdc3/M/HzOdh5wTmOEZ7CSHPUrg0dbP+kNB4qI9/DM6mHAjIW
         KM5jPYSPGmtzvofuciXY+FZdVeVW+qDRD2OiOjtsQ+38JbJDQ6xugPSHIx1wXPR8OgzQ
         /Ofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727871860; x=1728476660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VTNeeOGHdCxE/aLNehqkFVEv3q3dYYmghT3WJcV4lE4=;
        b=WUG3ZGlTuq4WovPtIQYPNNaMFoEWHyBYlekBHERk2JOWXkdLVYeoTHK8nhx6Te35Q4
         B7MTOlJe9CT+AU6t3A1KMZLYqDHv1n0q8dwJ6Hnk4L9kb3EXltnUjnHF4iK6lVT9wa8k
         Zn3kxBJdErnlXxg3nCoq4a9Wrff9PoLgFq0UvinB3HjRaF/9OAZSA2alKuk3ZDCjulSo
         a2uXGSUv8aJ6enrxMOv29cjqAWa4GSAS5l5IKkdoO3XsSpfYceT4q2VpSoSbIBNoq1Jc
         tLFRZHfFxk0cFoBGJqJscq7cYJYAxSzcxqHQA4Z9/GGNK1kDF59CA1ocA/Lupvw9sCQl
         opnw==
X-Forwarded-Encrypted: i=1; AJvYcCVmh+uHrH571Pv1EhXjDHiJOKurgZimKqEbG6QXDdTZkJNn0pRl6RckgBpmFdTDVgNvu4bpaHwX4e4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4SWRXEBwMIjM3i8EYff0vBDWQo6YCGP8wUNMUasIiRZr4Uajk
	f9kowrctasyHIMczSn9wqExQw+wvLmryHgfgXuFfpHvxlRHfUujWBKAeZRg0/+o=
X-Google-Smtp-Source: AGHT+IHLY2EddxMnC8GOIHgO+9SXMorwEyuilBATFateviNAAQsWjVucg7195EwHnHLCsqszq+SKXQ==
X-Received: by 2002:a17:902:da92:b0:20b:b7b2:b6c5 with SMTP id d9443c01a7336-20bc5ae973amr45657185ad.54.1727871859880;
        Wed, 02 Oct 2024 05:24:19 -0700 (PDT)
Received: from localhost.localdomain ([143.92.64.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e33852sm83508625ad.199.2024.10.02.05.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 05:24:19 -0700 (PDT)
From: Tang Yizhou <yizhou.tang@shopee.com>
X-Google-Original-From: Tang Yizhou
To: willy@infradead.org,
	akpm@linux-foundation.org,
	chandan.babu@oracle.com
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Tang Yizhou <yizhou.tang@shopee.com>
Subject: [PATCH 2/3] mm/page-writeback.c: Fix comment of wb_domain_writeout_add()
Date: Wed,  2 Oct 2024 21:00:03 +0800
Message-Id: <20241002130004.69010-3-yizhou.tang@shopee.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241002130004.69010-1-yizhou.tang@shopee.com>
References: <20241002130004.69010-1-yizhou.tang@shopee.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tang Yizhou <yizhou.tang@shopee.com>

__bdi_writeout_inc() has undergone multiple renamings, but the comment
within the function body have not been updated accordingly. Update it
to reflect the latest wb_domain_writeout_add().

Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
---
 mm/page-writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a848e7f0719d..4f6efaa060bd 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -586,7 +586,7 @@ static void wb_domain_writeout_add(struct wb_domain *dom,
 	/* First event after period switching was turned off? */
 	if (unlikely(!dom->period_time)) {
 		/*
-		 * We can race with other __bdi_writeout_inc calls here but
+		 * We can race with other wb_domain_writeout_add calls here but
 		 * it does not cause any harm since the resulting time when
 		 * timer will fire and what is in writeout_period_time will be
 		 * roughly the same.
-- 
2.25.1

