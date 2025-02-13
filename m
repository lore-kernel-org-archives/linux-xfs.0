Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059E7266185
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477772; cv=none; b=CVVVvdcayfxvGffwh0bnQgQf4XyQ4UEU5Y4Baq3FZN+TEflGeWX3cCqDTmg2SIkt+MNkjiVF1ccgjVdx3QMdWRQanfCqhdW9jxAHL/3cOVVYtOLIm08CMSze4UPH9rL+bgv66yaq6izbo21RThnNHxjjXN5rR6rHsKpNgkNW3v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477772; c=relaxed/simple;
	bh=YPqxkeHt2mmQV6xNhpuDuyV7Kz3D11AdUuw03o+Rb7I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QAamKXsLf1zcWjg5zPUjuS0S68JfhtqWalxt2a+xmt+lUPdV8ucuhDF+t9TWYqDhL2sqYybtdJP6shE7092GcITqNnLeCSQteazzA9yv7n891getZkNcN5tNKjVTdIyFJGRwL2lXKemYHuylYE2avXd0oEnxh5ci7IJsoSGIcD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YG2eF8M9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YG2eF8M9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbTVlhXmZxgU8mJL+L4bgYmknZkQN7LeUyXKA8ggmbs=;
	b=YG2eF8M9Sgc32P0hyU9y5fXsjaBLiwxi23oVaiP3411pOdduJOf1uZcCerWVynJxk+kIVS
	yzc3OBsZRwOuMXLrs3+DDdG23Gt4A15z44VhN4oUyilq2XnQZxqKl8sNUGg4WrGeuxIMvf
	nNQjrVhEKloH9yGAsY9984crc0x5r+o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-XG7OUCKsPPar9r7bVPp_Fg-1; Thu, 13 Feb 2025 15:16:08 -0500
X-MC-Unique: XG7OUCKsPPar9r7bVPp_Fg-1
X-Mimecast-MFC-AGG-ID: XG7OUCKsPPar9r7bVPp_Fg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43933bdcce0so10382945e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 12:16:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477767; x=1740082567;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZbTVlhXmZxgU8mJL+L4bgYmknZkQN7LeUyXKA8ggmbs=;
        b=c9mUcjzXC73h+b63S9Yv/zppdZ5bQLVa/xuOo6PVcLiYQvDGDRYEnwPWHRcUOEGmgj
         78Cbnn+8lkxbmQyP5WEe6QxRQwpC5Ynktx/Su+CziUHCo5QV99Vc7CEHPW5B3MkWeaIE
         QPlCM1EGSsllBvhiistrNRat8NXGO791HlKlGT/nFk268BxIlAOHk7MUxmfYqzSs7QRp
         VHoR2iqaQoIlXb9UtywwhWV5ugs2yF1eHwcQPAkdb8QBbSb9x+Caops8JmfgzE5hvvLP
         E6o3Mb0gBGwj2klIPfGftAKzb0Qq57xXSOki9p9S7tarMlcTeirI6iDkkmJ+GO/rhhvh
         B+fA==
X-Gm-Message-State: AOJu0YysJxkY76/sPmIaCcx3O/GCgsfLSkgF1F2K/SOfxz1j1F1YrA5j
	Ln0AWeIIXjxtRziaFpqrUfUTLy/SLJX09Dx4kR3hv3UzXk7bJ4IIV+u+m2pbsKu4SZ4mrFWtxJw
	pdqrj9jSvesZHafLTjGmotna7TIsJk5QQ/6qP5g6VD23YokUeNsptJ5Az
X-Gm-Gg: ASbGnctdosuVF4CwM9BQZyNWbgMSFNaJnAzfXN7ff5KvIshHRBTz87/ewDoNZfFYS/z
	Nd9lmfDDD1I6Cf5xoCqSZ987ZtVaHQIDjqAnpUXwgzqDyxiqDW/aO215lB5jSqeEshYlqj4HOe6
	Q3lgg0ZmgUV3NFoC86MbMKu8AcTHjDXgcw9Ub9S1C1u6OfzSYOQ+Fji/XzsasqpYGiowGqnD3W4
	Zy07BB94Dp5mn79vrRRQRcspubVMk751sqtm3nXSEr8VW3n0jLRZuzeA2dCt5pWR60Uud7ctEji
	XuoEIdG/kAr2kbNwQ6+eVVZWltNhnoM=
X-Received: by 2002:a05:600c:1ca6:b0:439:677d:89a9 with SMTP id 5b1f17b1804b1-439677d8d8cmr2857565e9.31.1739477767403;
        Thu, 13 Feb 2025 12:16:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGr+G5uVnyUwqNZ4yFhjyppktYxqxzXe8nUOl2f5OudyzKPRbOyKhsfGVC81Dr3c2jZw9WpFg==
X-Received: by 2002:a05:600c:1ca6:b0:439:677d:89a9 with SMTP id 5b1f17b1804b1-439677d8d8cmr2857335e9.31.1739477766983;
        Thu, 13 Feb 2025 12:16:06 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d237sm57520895e9.21.2025.02.13.12.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:16:06 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 13 Feb 2025 21:14:32 +0100
Subject: [PATCH v4 10/10] gitignore: ignore a few newly generated files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250213-update-release-v4-10-c06883a8bbd6@kernel.org>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
In-Reply-To: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=690; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=YPqxkeHt2mmQV6xNhpuDuyV7Kz3D11AdUuw03o+Rb7I=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0tcF/ZrJLro/4eXc/NKDn1Y1Xqiu3rm7ideEjSnre
 Ghc4HFe1ZyOUhYGMS4GWTFFlnXSWlOTiqTyjxjUyMPMYWUCGcLAxSkAEzlTxsjw7oRMpVKGgcC1
 OS+FC4o6xJgnBt0JZZo8paqmY8pnO+XFjAy74mWfX/q7XHZ1d0/TwTWVp5/PW/SWM+V3zOv1V2z
 CLubyAQApS0kn
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

These files are generated from corresponding *.in templates.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 .gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index 756867124a021b195a10fc2a8a598f16aa6514c4..5d971200d5bfb285e680427de193f81d8ab77c06 100644
--- a/.gitignore
+++ b/.gitignore
@@ -65,12 +65,14 @@ cscope.*
 /mdrestore/xfs_mdrestore
 /mkfs/fstyp
 /mkfs/mkfs.xfs
+/mkfs/xfs_protofile
 /quota/xfs_quota
 /repair/xfs_repair
 /rtcp/xfs_rtcp
 /spaceman/xfs_spaceman
 /scrub/xfs_scrub
 /scrub/xfs_scrub_all
+/scrub/xfs_scrub_all.timer
 /scrub/xfs_scrub_fail
 /scrub/*.cron
 /scrub/*.service

-- 
2.47.2

