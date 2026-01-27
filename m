Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50B735CBA6
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525839; cv=pass; b=PlINqJnXfwjOujkEjHIdajFfBspekX1mO3n/ZMYTry8ZDPEoKqUtfMJIa8yXJku0Vei6eOnFB85Rs6oYdgzzn7xXqOCOn5Bh8Ozc/0IFYVySeTHdpXqU36BDsKcP8sYYOCwWbrAv64E3ToMTmYsrltpWTcbE6EUeQRKE4daV1ZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525839; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ecgeuyd2BajS6St0QwMHyhCeA5347zgarkr/yMaZSezsgbeIOC31yUTnj55ULm8tX5FY4cxfNbKQ7/+4JTO1tscj8GJb/jlukQPeb6opQapDy8GeqiY6/FYxZe6Z5qK34mu0m5/bsRpIziYdOxqs+9B6loQyiosEIYe7KkJ/lGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GkJCOcjr; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GkJCOcjr"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b87003e998bso1170433066b.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 06:57:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525836; cv=none;
        d=google.com; s=arc-20240605;
        b=lf706GCWNaXpdeaLoKBwV0i8ZWlshpQoE3Ih2vMAqAori6DZEDQUlWoK7/CkJJfgNC
         W8aunIzfdy2yQfjKzEppBz1bA2KZwSLgLBlRzSinQqJn4u3TcIqnoSlWCImolZXjttuS
         cC6HcTG1ZbwXDUFBMlqRRFBLBal6eb/XOB31jTFfG4xXzcp6MX1CMjVTSYsynfLrcF3r
         s/HWzONjSqSAT01j0SDGfiOUWUwIZcSe8CIYIBrNs4tGa4ReLuqaVLhVfAU8vRzHe2Np
         x1jkJT8mZXiyXTvNGjGPjWmuWdRBkURTgvFW3qWkwOelW+JLJj5NGzOr7bfw5zHwsX4t
         261g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=J0oASaz5vylWCZOeOYv44uiFFT27FOgSNSAH6kTBuRM=;
        b=YDVGiZzzWsQJ+DSySqwiLdaJqHsL7AX/+U1MohUxIFq2RoDGmGUvycXOOQWkIJcaV4
         4/Xumko47FBiwk+MdnaCruX7/fuLgE6iQUUi+2MwVGFuXDGeNWWeVJJDZ+B8guiSRMsH
         MiWjkW+brRYtAoNUL9rbx9Mijy80aw/tsKTnHQflHYLy36iPelpG0EDQDmPupRMxS2HS
         44vvPmFghfRADRwAig6dj7j0SamK1yZcuBc93Ew1cGs/wuFqtERs1AZrfBSv4dlDEX0N
         2fAMNodWCd5wKI4kq08M4LE1DGedKx/GPZqb3wWNje8GuLz3VQkhmaMqrN7KCGbmUUsT
         MBlQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525836; x=1770130636; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=GkJCOcjr7X6KtcJY30ZuRa7/aqsS/tRsv4aPAPpaAiZMpEVLO9XG6pGd1y8SdczMQh
         48lapHpLy5vrAlwftRyXgbyLbQcKKsaSXQbfwWt6Kxmqzd/wh+EX8sFvSj3y/Aue/laF
         bb0bOnlBVkLoY9FW0D/z6hnvYseVG5ZQ3WaQ+Cki+krMSnAYAI6jr+vj2O6vJYEJSJPN
         ZGSSpHo8KY4IcPo15gm9nnDfwafNPcnpQ9/Q51lugcNdmuTOuIB3LTP8urRE2l8e/UtV
         qaCO+HITT1EK8JGVGZYVVKVsMJ3/j5VMH5zmptVF5TlqtMzAfzttrbMVGycHzDXTIccu
         Gy1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525836; x=1770130636;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=aK0290KQGU8NlFSUAT3lNFZZvhp2yfIvmh/5aJ2Irx97L7RKQACpwy3NriG8QciDIo
         rFR0kiAgM0bNqkn465+VhxXzghAhdSElYxiY6NnPTsn9rKUOVKb97fGVv6szeaGXsVbl
         Ce7It4ILY7qLwCBgqEEqX9WSxc4OdqWmbP/A+/k8nfXKBAZycsKiVPSEmdqW8C0M+DcS
         tUdODr0gjFSSJCFJYK0c9+4RCxY705KcIRB2USU/wFK0uMHn3WvrTKiUnPDnDOgGTJs/
         GC+ztT3N6ufrboyeXPKvHjJ4DzoJYJLdK7C37n2bS7bONmGhiLWXa+/lBHhcsxevRnwS
         ETlA==
X-Forwarded-Encrypted: i=1; AJvYcCWrPBDHgKM5UfrYfyEmFY7Skds/9tvtBOjVhGdnmo7vGA6gssdqwoocd7x251XATT2N949ArX6jUFQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOxtu5yiwvoW5ldNqtigsGNfU+Qs7blNVJBLixVaBORDz2qQZz
	iWwv/a55q6xNozm5N6OSa0PkT3OUuYSrWyOj/1Q5YsuCYH6sXYbSYZxTtyKBJ0qfCIqfLB8Cho2
	MY9bX/Y17uju11dnNthJjZ2Zfi+iZDPfKi/UngA==
X-Gm-Gg: AZuq6aKzeUvHGFaLCkk34oJcF6voEz7MFdXBflytG8itJkepDaOwUqKQIc2IT8H/gCu
	1gs2d787eym3vodHDG7YyP02rN/G0i04I2E1Aim9gNt4dl6XtEqLHf8QkmjpZjDxW6zDnIbMtgV
	V9IFq4fhbW+eGhqOpCvr8qlr3kR9Zf+NSg8pf8gKZz3uTrP9tvF+R4UB1PlFRcGF1OzYDyqtlAk
	97LZuMeuLztClOSFH+Fv8IYFJr8G2HOITokC8rSDZch+GQv2UWm0xFXY9SBWytTjl58FdlSBoDo
	u7CJUhIhxUBTK+tP/zVoyNrgQuEWykQyJ+cEHE2E9zMs3R7aB4ecQlhVpw==
X-Received: by 2002:a17:907:3c94:b0:b88:4ff8:1300 with SMTP id
 a640c23a62f3a-b8daca89e5emr131696566b.26.1769525835895; Tue, 27 Jan 2026
 06:57:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-6-hch@lst.de>
In-Reply-To: <20260121064339.206019-6-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:26:37 +0530
X-Gm-Features: AZwV_Qh-bXQokozgO9CYibn8UPXNXVRECr1GxeaPZ8jRlXI3X_4jeQcXdNJkNL8
Message-ID: <CACzX3Avvr4e2LR9P_XDVtAXaU_KJqnO2SeUMc8Gh19H8-BpwgQ@mail.gmail.com>
Subject: Re: [PATCH 05/15] block: make max_integrity_io_size public
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
