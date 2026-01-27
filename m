Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD4D355057
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525782; cv=pass; b=DOx7YjMtX/aIiJrpJYhD6mdk0B+G3yxMkQa1gWfiZPf5zZLOofyQgq2qcUy3hbdtVE9/KIoc3S8stSDoPwPBB19cpXfr3SFFT3MrY4wPEmI3adxjieYjUsCyDk/7uvHIKNJwJ5yKmtSSGIpF3hcMrzOtYiWu6V8vfeQqZKrCCyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525782; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d4Oc7DJnre30EreG7odyGVqx85wwBopUqhF+13OQzc5w6bqDszba53NW+Ey0z92Iv15q4QUQ42D7b0hM+5iKfEhVOgylvSusxGLCZKOssQQN6G7Sm7m9aIJH9gCVo3cbBkCZ+v26hUxSx+FfnT5rcrQSXd5U5bJSS7G0jJsROGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GJyRaMh2; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJyRaMh2"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-65812261842so10910723a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 06:56:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525779; cv=none;
        d=google.com; s=arc-20240605;
        b=Y7bWREZiR32NAF9xnVcpbuIJ0lhhlR2gWU79025nrDGvtv+xmgCvT0X1tMJhA8A6bg
         AhW8hkitLNYdQAieNO5peUDoag6EL1lRQl/e4iaIhuSVQdo5LWuWhvJMJjdqQ63w9Lge
         DfpnTkZQmLUDwZtuC4blsT/9a7P+APvhEv/nTVEBLQvcVKvT8qhvrUCMXiKCfTil4oKD
         MEqaFTAyz3yZAcU2M06v4cZqehIEHYTHUCZDnq6gj7SMd2GCHpwvBMd4+Aae/HiofjeM
         anK07ONGA70uPioK6d4CpEW4U40I+5ak8EjS72QhIDLq7xtBwl25+ZWHWuP4r7ZItoP5
         rsDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=vNsy7zP55kIdjpukW+l8rT/A/mBv8GrlpT7KcQLbuQU=;
        b=h8vnkyQzCnfJYcbddwytT5mogh2yxGVOe6hHNndkQ1ljsJQ6kdcUNlNEJU0WNSlK2Z
         DfF/LwxUxlnV8vfiEFGsD1+OH8/iqGbWDjtRJkGJUm0P28RM1BcIdjU4QbISUcBHcyXf
         uA3nAOuHgfed0xX80YM+GoJ9EcQKWqC1zxoFH73TKtr/Ml/XVDw4ANmAzrYc/B3QdEsp
         n8RV408J8xLngioeVbcR2vQVKEvdzYmjuf0YFOzF+mw350rC9r8XXvNjRNR8Z1mdfKs/
         aVX575dwmRKIrJP2/UjSFfJ+hQrjpmbAc/gC4B404/injYq7QxR22zLBcntOoCdB3B4y
         X+DA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525779; x=1770130579; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=GJyRaMh2hh7lb0M6VyaLLCzza/TMpZb1J86mIXRz6Yo20W+MPiXlQXGJyYHnUXVkp2
         4zkzhhX11FCyyF9Abwz+RCL5VQG+LmQWGIn6OIyV+pBxqlVaREMv/fwfgyPXNUKlvUGn
         VhTG189FB0jZ/deo4BlehOKXXAPjW4NL+qpTQtbQNcqL0smfb6UV6XgOmFRQtphMx2kF
         hQaoFjkg7D4x61jWPPSyRXvnksvG8Dc8WF9cxHB+kIDz0GL8eETd6FS25ZiMGuG7ImFA
         3GxrYvGl2AlZHWlkCxtysaxXYit0C9fPSMKsRQINM2hdqHHRN/ige7H/a32G907gH39Y
         MoCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525779; x=1770130579;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=T8KZnZovEZjZyvX/T9tWmcueOCGFUQhxEe7eqM56ot/OeceKsVoRmHCPc4ZjvkTm1y
         I31NoBEmrCCBtGgWD6uaYLhlj/hJf54spY3SCHwvGKkQ0W4PLaL0U0eMdN5Tl9pHxoZ3
         GD1NGUtL4rf0cppuB98kEdPaiDYLBto9IT6QrUMUfK5njMGxQUPczeN9CC9F8yVrz7qF
         0scLC/MZ+gZ/BueZPILB7SmiN3lb3UlndTf92GQOxDMQPakhMLwu3EpuUMH2Q/IUbTEI
         smEdsuuPQidKM7OHFeZQIuWLt/jIy9Kk5Ewv3ZqSWlgObHaW8qgVVuWwapfNk7CMIH95
         OWHg==
X-Forwarded-Encrypted: i=1; AJvYcCVqDQ7Rf9amtZxH/Ve9gGEGc4FGdOGiK05B2mp+IpeABcxzllHth/cHH35MGpS6m0HRbSR4dSEBnfk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZdmyXnEr1bB7qPgGmkn0qRlurHRoYWojRdpCWjMHtBT7KfwqE
	x2Op2fNPDCNHLBlhSL3EpPcez0dTAE2iC25dhVCne9O+zlcBWW7aQ3MX/AmAJjeAXfMmhYuwPmk
	x9Hnm6dTG0IRWvJxOGkqwyAbVk8jSZQ==
X-Gm-Gg: AZuq6aIneqavKhVfsaPFY/+8b1/e0KeKYbajm4jTbnYNLjLJ5ZdrFUffuuHFK7hIWML
	srL8YpnvJgh7BmP+OEGvMmw3UoSg7dPkZm73AkhpYDwXp86Q3XX0lEXLnoUkUgsLHOkUwUQqt0f
	wRoobpBPZH9fw941ZvgPGdrn9LeEuC9z2QjfgtSSTL4j+Vbkgu3N44nWgo50hAovsssKX7vcDQG
	iioqsbvEgxRmmU5OMUI/2k80eGro6Lgx4Z5zYPmLwOAvwUmoxQFFaYMnYIscGdTVw7ILoePu+Rr
	1JxLhHAH5xEaz9XHXz8GLPJDg3uDrptANavOsIHlcYOg3nCh+XOZm5KR1GZn2VheCZ7m
X-Received: by 2002:a17:907:2d08:b0:b76:d8cc:dfd9 with SMTP id
 a640c23a62f3a-b8daca2128fmr161899866b.18.1769525779240; Tue, 27 Jan 2026
 06:56:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-3-hch@lst.de>
In-Reply-To: <20260121064339.206019-3-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:25:39 +0530
X-Gm-Features: AZwV_QiAoKA4QtWy_y0NR6iP_vvxOusoftdbzNUmcHtGTAMptU2eKdF9ySt53aI
Message-ID: <CACzX3AtY6PBV58jXS=jwD-o6Dd=m_3HkB=jRp-3Xt4Ab_U+RSw@mail.gmail.com>
Subject: Re: [PATCH 02/15] block: factor out a bio_integrity_setup_default helper
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
