Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B403A1CAAD
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 15:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718898584; cv=none; b=mMCHQNXItjU1ILhjpMULnOohkjJtbpS+ZyBjorfioqt2SxBRpz+sR2gxIDNr+vJN3BWusq1lkkGaV0tRu21dJcC27hcB0LEYT1PaRei6sJJFY56zQdzFAqMM4wu22nAux5NOVfQ6ElCHgTYIolmyY2HySOqJf48GFKn2FEmsWPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718898584; c=relaxed/simple;
	bh=EwvF/8jOvWy6bXSeasb7zxsDPivhiLPA7kupSqjUM8s=;
	h=Date:To:From:Message-Id; b=D8dRhJ1Cpdg+ivoISSkSGDl2Gwi8BRgS8n1Y9rqQFszvmq8oAS9E85acAjJt3C6q64L+uqqarTdStr+0XVn3hrUavVpTkqiTxdGXw0NN+KFB5K9XmpAq48nJPwjwY0u40VSk0gumjFp5/4IHVIxo7A4LRiyVPw+HYoabSEA8oU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fysieQkA; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fysieQkA"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70627716174so952739b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 08:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718898581; x=1719503381; darn=vger.kernel.org;
        h=message-id:from:to:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EwvF/8jOvWy6bXSeasb7zxsDPivhiLPA7kupSqjUM8s=;
        b=fysieQkAUFNBbkDb+JIBOnfK9ONETuZUXfGnsmYianuX1mxTrvsIIM9+LRcDuWsARy
         umwJ+WaX7jc7zz+1KKZGPuOkHl7eoYfpxhwSfwhsWh4PfxZXDUeaBNj4WYGf9PbahD2i
         KfkNcLN//dYYK4M1Y90VUh4GOV0g5pZ7XLSko6ySm28b8ZLCuDseO9IOA92fqPe56ok9
         XDadguZ11F6EDswseQ87K+Mlu9JYzsE0YJ9AGP5wsGS67c8BiW6Q2qUejGHHXQK9dHGp
         ES3q+4LQYsu19RIPSooyyVFlgIRMbg4/LgwN6XDwmP1CSkVrVKacg+236cLN1UtBTf8u
         3M1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718898581; x=1719503381;
        h=message-id:from:to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EwvF/8jOvWy6bXSeasb7zxsDPivhiLPA7kupSqjUM8s=;
        b=ILhi4EPqT/4andghZqCgO+a+3dUmQ659K1QikFn1UaQGN0X8I9b//Gwm7Sm9d4DHTg
         MiONV7GegKrqIKvsqQzI5Xcy0740/9BkBd6YZhnxGUnB380HZOA7pdrTu/G4/y74UIcp
         8UtZG0Dgl+1G4qx4aH0izAADeYKpFnjOmVXkSDI7KbBr11LKsCB0GyZA+s7P0Dzx/C3d
         B/vlnZX5PE8iz8uQf3WAw7Pqtt4KIZT5WT/R0DQBb1I4EvLiQZwYl7fBZUruTpklOsHn
         zfOleGJsT3kQbim78BkvmUGqh+hFOrEfORsU7AGeBDZYiipYg1cPBoMYwG+tD0QtD0V1
         2hpw==
X-Gm-Message-State: AOJu0YwjHtPT3U1tDLjAp0SglOLeQqxreRk3+MEgms/VHwVmz3Au0qbR
	G0L18NRCkZ4M3OYZxVCdZ1ipXYktyy9wItsVdReHqkC1Ypgz5sD+SiJ3MQ==
X-Google-Smtp-Source: AGHT+IEZ5JfS06A9iBIZjg1GZ9GTB0t62FmXp15kMfRuhtwwrzJ+N2lv9ewDSWhAl0cNhh7ZlWzOIQ==
X-Received: by 2002:a05:6a20:f394:b0:1b8:d79:55f3 with SMTP id adf61e73a8af0-1bcbb663a68mr5180275637.54.1718898581398;
        Thu, 20 Jun 2024 08:49:41 -0700 (PDT)
Received: from localhost (mx-ll-171.4.222-32.dynamic.3bb.co.th. [171.4.222.32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccba620fsm12541750b3a.220.2024.06.20.08.49.39
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:49:40 -0700 (PDT)
Date: Thu, 20 Jun 2024 22:49:32 +0700
To: linux-xfs@vger.kernel.org
From: Konst Mayer <cdlscpmv@gmail.com>
Message-Id: <2UXR5417C74F3.27N1XQP68WXAD@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Hello,

In our setup, we created a dedicated real-time section on top of RAID0
(backed by multiple SSDs). The rest of the filesystem resides on another
device.

When we ran the "fstrim" command on the mountpoint (mounted with -o
rtdev=/dev/md/raid), the discard does not propogate to the real-time
partition, and only the partition with metadata gets trimmed.

Is there a solution to this?

Best regards,
Konst
