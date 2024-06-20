Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D24D1AF6BE
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 15:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718898782; cv=none; b=s5QFmKXX0mKLZKVGU4pxUQc8F6DPsfammB1rqJOGBzoy4HsswmSAVLI4tOlbW+3myuDvoPfBn8ZzXEKTiPl9yjFxbkp6IYwBvvjDPpf1XE8hEf4r0TVdgzWUiZ83pNyDEhG5sHa9rnGyDyBmXq73B/p6qbeiUsVA1t5gPaH3rkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718898782; c=relaxed/simple;
	bh=XAqrGSZdew4vjVCKdxI4RFz4s55c1y23IoEGsZAsWDA=;
	h=Date:To:Subject:From:References:In-Reply-To:Message-Id; b=TTML+qQQaE1apaFdqtvIpOHYMShuOLx3lhGP3UQgNYqe+MYAEA62nVf6CDp6/55J1EhgEpWuCXONyizOhKTn8Sfq7eGlAq8worqn5JfWoBt2V/pM0jKhlJFMXZ0U+R7VuK0KpW4mslJUU72xgDvQA42J8qZ3hcVGmLIEcYcrgI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cJPhIgOi; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cJPhIgOi"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7023b6d810bso828095b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 08:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718898780; x=1719503580; darn=vger.kernel.org;
        h=message-id:in-reply-to:references:from:subject:to:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/aNzmLnpDwnWZJsAicDQorMJ3LGC+lycWwpU7+Iv86I=;
        b=cJPhIgOikeAnitL8iYvb6R073iKpSOcLuLrqvibmKo+wS+6VVtH0BEWU4tkf2Ij1X8
         2cdVORu2ObuY+Y7YvBdkefYOAdN/dxjBz99O+Hv6Wjut2q1un7yIUjbF3C7osCOQgqMI
         +EdHMh1i4yhPr3MbwxYS59uiWfXCF1S/vG4qycdyShI83viN3z825tQroWE/Txp7IG0o
         8MMz3y6kM3yUPR7ok/KHfXnlnQHlYdLihZHJz+2bvM79DENC+2BGjKOYVYAM72sXldmz
         4FEZwwtwje23Gqhh03/+9uS+QeN5A+WnE3tyf9Vkk3McZXuO05S1Nr6bMmMynGmi/z+Z
         87BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718898780; x=1719503580;
        h=message-id:in-reply-to:references:from:subject:to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/aNzmLnpDwnWZJsAicDQorMJ3LGC+lycWwpU7+Iv86I=;
        b=u19YhqSsK8WnoKR1EFxZIZPl9BS/j1r2STsLO15/IWDQNtyUQJCnmJuo2+fa0dTNRk
         yMoUUp9zEV3w+wYSvq7UAzOafXdiwuKOjAeNqtBdyyvmt1EQAZbuGpmWKhRuQa4BtyY9
         Wh9kd6H2VWzCk5RspiTdeltX/+kZS0v4o0d6yjK06AX6dB+B1YmVUUPIXDH4nPquh+1N
         R9vJJ68V/Q8wW5pGx2Jcz4vHHBm9dk5Ibegy6eCY0GdMGQP9HC8G1/+rQZpF6Ms0hTOn
         3jBF++TUEJl6LjXFWrhIE9v/VlYfvnVxVBb0myCc2W7LkIp5jP51xuDRhjhOKy1SE4hk
         TcCg==
X-Gm-Message-State: AOJu0YwZZXWYHzpA+E8GxMBFSp5pbWvecH1ZXYvjcqkKXe40sbHTO6Ck
	y052DA7xGO8QbGpq8gBVhwespfhUTVzVUA9cHhfIWclACBXfEjZtK/HFdg==
X-Google-Smtp-Source: AGHT+IFwDrGQnTNm/UVOXEpCrznVl7eblHF3Fw5o141QLHbhqSyI+v6fUX/CbGuk/W08nPZZFjBJdA==
X-Received: by 2002:aa7:8504:0:b0:705:baac:3244 with SMTP id d2e1a72fcca58-70629c6c6cfmr5571481b3a.19.1718898780110;
        Thu, 20 Jun 2024 08:53:00 -0700 (PDT)
Received: from localhost (mx-ll-171.4.222-32.dynamic.3bb.co.th. [171.4.222.32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc91dc0asm12524839b3a.34.2024.06.20.08.52.59
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:52:59 -0700 (PDT)
Date: Thu, 20 Jun 2024 22:52:52 +0700
To: linux-xfs@vger.kernel.org
Subject: TRIM does not propagate real-time sections
From: Konst Mayer <cdlscpmv@gmail.com>
References: <2UXR5417C74F3.27N1XQP68WXAD@gmail.com>
In-Reply-To: <2UXR5417C74F3.27N1XQP68WXAD@gmail.com>
Message-Id: <2W73T39BGMHNW.28KW9QVYJD5M1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

We are using Linux 5.15, by the way.

Konst Mayer <cdlscpmv@gmail.com> wrote:
> Hello,
> 
> In our setup, we created a dedicated real-time section on top of RAID0
> (backed by multiple SSDs). The rest of the filesystem resides on another
> device.
> 
> When we ran the "fstrim" command on the mountpoint (mounted with -o
> rtdev=/dev/md/raid), the discard does not propogate to the real-time
> partition, and only the partition with metadata gets trimmed.
> 
> Is there a solution to this?
> 
> Best regards,
> Konst
