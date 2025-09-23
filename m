Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE9E32129B
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 10:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758625146; cv=none; b=NJ1GEhvXcN+U5QoDgmktyBt+kVp0EMRkkqYHU696GSiKrsvLD/6B12J/0anqTDUcj4+k6KPE2NEJ3MkYUt2zvdTBojBxRECvuep9qOq4W8h/GjERv9oVc2igFuK0MaSIhOKcd73ejsqwb283E7+/iDTSQ45V2FaAqxKPIccmW70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758625146; c=relaxed/simple;
	bh=JllJBNVkryNBCdrJQPmCJJebL4qgT+0NkNM1dIglkHM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cI4eaXHFFl9hFCQxq7M3nr92MqKVwFs/y4tM28qUfEpI5VbjNa0QMcuo2RupbreCVejhFO5ynRsB8HmxUyPJhYcDy05PIacaMqyQAuTr2NW6pG1yUFiNY6CW1PmRWzhTkzRhkOi1hK01nljaY2ZqkG13n+YlvFd5VoZrtc/km5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=bFF1pL6T; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="bFF1pL6T"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b5e88d9994so58965301cf.1
        for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 03:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758625142; x=1759229942; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JllJBNVkryNBCdrJQPmCJJebL4qgT+0NkNM1dIglkHM=;
        b=bFF1pL6TV8vVkhQxmjXvPuIYhFk3EfIH2fIG0kCgZ7+T8VWHj1tEYSSlFQLAovR4rY
         fJkUMwm3t2wnBf2BoUrBNnQ4XrKi+uvUW59kOFLiOL7YQ8LltWhxx7y3dZG8UCcOxLjI
         VUNz0F2AAz+N2vFLy3ldnD4ku9s3UBUPT7Kus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758625142; x=1759229942;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JllJBNVkryNBCdrJQPmCJJebL4qgT+0NkNM1dIglkHM=;
        b=DZJJDuAWgqGDMAnu/LEPIBFWY95IwJkQ0mh0v/xw+6cOQG2+wB2HPXf+3vmxBUaPxy
         dtx/ERIGrKtPzUofodILFwkLXyazPa1h//ku+haNASOPDwzaRLf5yyeVsReeBnjcvwGm
         2ypamzKpAF26R/F4rzAZzcPaXmoNwLwzxaLFmHIftHy+KQCPNwXXTBSY4V2LiHUX7gEJ
         O8o5zoumXAlE4wd0iY39+iyz54+CruLiEtXsnncta1TEuaXJp7IXDSbE/f4wo0+yYbPo
         jM4UoMp6Q9ReBP+cN6IjH1rB/4hsUS+CR6rfY3cn+j2i7PQUBls4z2q73vUmO5Ubui9m
         jdxA==
X-Forwarded-Encrypted: i=1; AJvYcCVg895Fln2usbyCkZjrhibBx25MT2iaVU5F6hf5njlpTm/xgAgMvbp7DG8v1H7Ml2SOp7osbNthTTU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr6r3A5E/d77qA93L960yOeg4KLf45tjFwAmcSR0hyhkpnsYYF
	E5gxIKuIDN3KR5erBEuizuh7CD4LHFb5WrNdLZmFkA+RfR0S2rqGlpdaEQk0lyLjsu5zgxYNnyo
	zmk1HvezXoxdE6PDzDOMBvIf4qrvuuhgE+j0bP+4SWQ==
X-Gm-Gg: ASbGnctd6ub/gy5evfZMf+aQnMO/YxtHJjLwiYPUSfq+/OvXdQeE5/WeeNG6j6LfGH4
	8E7Jhe4BNxn8+KP4w93wUByg+A4LGQ7VgMLMigcIt+GJu3kgJpVyZC0Ez1Jaz2K6IDBkaKmMj5L
	el0/ysP5E0xP5NYjqEBDTtD8W9DTud0ZdT7P+ZNSHTml3humyqSx6vqXSq8QRAgcjcs1nB7mF4P
	+VfXS772UuV43lGbYhD6q0weE/zic9QsCJpr9I=
X-Google-Smtp-Source: AGHT+IGVYXFgdT8RYP/th1Bh23LqAzV6VHWIO9kC7E6vKNdXOCdqI74v14xmoLK1WCY+JGm/7UIQQfhOLJ8Z3U9D8YA=
X-Received: by 2002:a05:622a:5a8b:b0:4cc:25b8:f1a with SMTP id
 d75a77b69052e-4d36fc02d66mr25346611cf.43.1758625141850; Tue, 23 Sep 2025
 03:59:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs> <175798150199.381990.15729961810179681221.stgit@frogsfrogsfrogs>
In-Reply-To: <175798150199.381990.15729961810179681221.stgit@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Sep 2025 12:58:50 +0200
X-Gm-Features: AS18NWAl-NDDKNv7TZPiJHjt5dfPYp31tw1Z8Xx012NqtqWC-lxHUdlrAfy00Ck
Message-ID: <CAJfpegvGY8HLEzJFX=j6Mk-hwyeaOBUkSnyEH21US+Xjud_2fw@mail.gmail.com>
Subject: Re: [PATCH 8/8] fuse: enable FUSE_SYNCFS for all fuseblk servers
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: bernd@bsbernd.com, linux-xfs@vger.kernel.org, John@groves.net, 
	linux-fsdevel@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Sept 2025 at 02:26, Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Turn on syncfs for all fuseblk servers so that the ones in the know can
> flush cached intermediate data and logs to disk.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Applied, thanks.

Miklos
