Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD4C35C1BA
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525870; cv=pass; b=fftnO6YqJiYt82yq7fIvQaNDkbrfYlhSCiHYLFjI4YQ+mgkhtujRyECF143nXYIP0zhtyVZufEW2gcoPWGqT38bjlpXt9g8vAQaZ76cvrpp0jDUwD+ldfFM3/lb66VNsFaauGX9qpq+Ah8k8gKb/HNjkdrcJGnRpfVoUVYch5us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525870; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hZcN0HiEqEr+Ky0csnf2Gfn9goMJqADCwPfIW58zTjcYRioph9eJ2kmQ2+KF+DsyKchM7EUu3ETqXcko4+A83Ft6LdnRQ+jSv9quLiSznM/dQ2aSfBzPEYGa7mfV1m0Jn/pMzLiFAxBUDL6RdViQ1ejGlDoo3soENIQoUoPgvDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fOOj5m9R; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fOOj5m9R"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64bea6c5819so8617470a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 06:57:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525867; cv=none;
        d=google.com; s=arc-20240605;
        b=UzxPnafKzohD2bVcvH9z1OGfHibY+4vwl3cJREzJJde5xHHkOi1CrjGXA8I4JItpNG
         b0iMyhu7G7ahR0TMl5wnbJPEQcjsbwu6eXDY22eowDPSUpbV2aZx2T6LuyEA1NuUjc1w
         PQhkv8BKjOhnjwzc4gwVYks+ui5GEdPgPP1gj6vizWHxKZaBsRo/VDDvw4RbDHzdw+QS
         ONOzJ/H4SBjoOo9Gyai4QN1AT6Oq65BT3iKutqHnnAnaZdi7FgaY6URcbgiy3/M910Mm
         K1D+hBuW3HtLcARTql0OfQszCQbWGQZAvkMZ+GQk+Y5m6cWH9COgSh2Cp6tiBWdAQixH
         7f8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=75q/oRnWm4dgOiTI0n3EY5j7fPLbIJEZIo1f3Z9kNik=;
        b=UzsoSjRdRVjl6aCJ7XkgS/6Q4L4OJWXHlmJeShbCCHUCuSNUpr/EFiqDCpSrHa3sTk
         k9fzUfCc4oWmFXnwWHZrdj6ubIvX4nPwrL5sZpGn6NNiQ0sNjqFlH9IS1A3LJN+CXCGR
         dZnzKfR4J6V8ag2Zyq6p/15uTXlV1pmUtKzgZb1+eLE6EulbidPtu3zCBiWQmWs3jVrN
         FzwU2bxyCbd/uwQt2cSNvCtKS7zcEJVX4bRBH14jwC1KNIpdSxIvv5XDw3vKl3y5V5Xo
         N0Qx3ObEnIpIQpQ/XiNQK3ZNYO8aq5Y/5asCx2KTN6A1cyj/BgRxanLv70AM31ZuRyK0
         /4bw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525867; x=1770130667; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=fOOj5m9Rr2zn8jmGi3sCVz5AXd+WDsjyCI3+teIiZNkBnZ6Z3To04LLAcmzfCyYy6H
         y1nJfTdZjf8rSyCf5wlPwsZtmQMK+ORo1MbltCQm/Q909Es+0LZEJM3/dg8XR7UyScZj
         edjx2X51oOqyTPAP1oGPGo7hFU/pt+19e86F5D4fHqtP2tEqAO1gAZgYqEscUruc7EaD
         c6DHElCxSfTwNrNaJSsYQp712jykxScyTyQ+WRSsNr28FOfEEf9Qi75NoF0RfcPMDMXd
         Sz1x4UrNCB2tJjIsZfjApDzYYGgoetHaVScquFNH1YDAyXv5t5vC0Ad4jMfNU7H1ezcx
         tflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525867; x=1770130667;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=R5FotDqne3wuaXX2C6GhCSQJio9enPbP1l1aojevCejlzCnTs/D0dKO9wtKLzgZyF8
         g1mDG3hA+ulF36YZzsUoJFz6q2+yqydOaYngApWSL2nAwz6Ph9AEzSM4ewuqd4EhDMIU
         g2a7o5hy4RW3XkLXTMEIbOvSxtrfXe64XYBV4/XK5/IbVF+x6zmO2Df/u0TOnTYpLLpc
         h3Bx7vyDeoalWDKGKxJp6hs4iUCd6Xbs5ktlSwW3v9T97I4KhhGFePizZNWNxnzDYQXe
         /B+ikw0nVYz4uLtBWH94mCGd5UuDPU0gxrXOmsQ7Gu5ItwfGgHDTg6xf1XMfymJJ4Ywk
         KGpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOvKaofLaliDNNjZSLWRjKOK+pzrZBOL3n9EIyN0LTbDizXlG0p2gBf5cE/qceWJOFhoM7A56XLWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxytpuNJMhYQTh7637GMJdL3OYvW9ZmHKsdilWSbRcJ18TUPQvi
	XCNOdkT4iGFlrst+wlHFH1LkDRFmryxISKqK6wyd7zv5zAUDcnUDh4wV57UPWIsrOSnBKMxExOf
	qbutNBYfQcsY2C0Zq7bIcOAyLRu6NlQ==
X-Gm-Gg: AZuq6aJGjoS+OLDi2Y7Hxb/qZDmuURd9IchPnMKqL9WSg7o4ecesNdAW/EQGbOtLJMU
	T7S7zJdGk8uyhkX2/A5+GHnCv2GafUv8PFOOYuNp0FD0GSTSlCW6sYY3UD5w6lt1kPH7QcbicHm
	mr03SwANLuDsbJTaBi2aoVLg8s4UkAapTEKeukrdYkjbjwgnh2+8pUgJKkTA/cygfXIuPfzihHg
	xoWX0F34rzNhcMbWQR0ZvYi5RDfSsl8eR8gyn+qn9BCrfomgaceC0jUFl/1yUBEYX3MXSCZvrQu
	Dyep4ezAoojwCorVfb+6KmSbH8cYfvYSQrNXLvflNOpoqwHE0Dj5mChHZ+1s+4ew28I/
X-Received: by 2002:a05:6402:3481:b0:653:9849:df10 with SMTP id
 4fb4d7f45d1cf-658a60a2a1fmr1194748a12.26.1769525867163; Tue, 27 Jan 2026
 06:57:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-7-hch@lst.de>
In-Reply-To: <20260121064339.206019-7-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:27:10 +0530
X-Gm-Features: AZwV_Qj4X0rX0yo1V91-mqj5DZP7DcX3ShOAwmDMBq59mWSXl3oyqbRMM9BDq0A
Message-ID: <CACzX3AuBQNjOtnmRFFXsyggUWqRB8eJrhpLwjUFzsLzVcKrSog@mail.gmail.com>
Subject: Re: [PATCH 06/15] block: add fs_bio_integrity helpers
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
