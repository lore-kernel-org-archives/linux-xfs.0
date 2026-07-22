Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2369A3CFF66
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 21:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754120; cv=pass; b=i2tCQgA7xeZ5Q7+lnXcxMkrWsd6L8Rheq9/pW1eLWF+RlpB29ekERbGopUChVR3by6Or9T/k5vQbvv5W7iTdzrAAA5GiKsX3AT6siWC76CsOXQ8QTA3K267Gj05gIKAdQo1BgwtlaIP+s71VWi7L9dkEF8gIdE00+D4sDKngf2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754120; c=relaxed/simple;
	bh=e2ewHyAnmUOsw1e/tN+fqYIkcR6yWRk7QczuTMtWyS4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oWNuEHy1J95OoTQQ6VM73Sr16lW/xmatLeSzwVc1ULPQaU3CDJrdl94bGHMDyd7RVOs8s4/mxIvgaTCPZSqdPt/VcA8b3EDSHCyQpw8TUe4gQcOD1R/mJTl5v/XXjYTH6fVNZjNzlEUmNF+LRu2RXXp7Mi/DZOzLtntZv5mxSlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NP/nXZGZ; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NP/nXZGZ"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f8773ce8dso903494f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 14:01:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784754117; cv=none;
        d=google.com; s=arc-20260327;
        b=UtshYon+UqOUB8C9RJWggLDrKkYIXLHVJWAgaws75fc7JWLw3CftAMxEtTe94Fbzdp
         3QO0I0rEQ2G0I1/RmPyySZOLBTogOynW1p1iytT3vwF327aTVE4TvOrnPL1J/KNYelGl
         U/u3c7XkPI4G5GAMNpz/eKWMaLxTjZe0E4gyv9B10358TRlJz0LD6PZGVTIGTvXRRxrW
         7w8Y37fzBcTgqCuGu2wJ06+bOEy/tlI8SvBA17/uBn/EtOAvIi+06pBzxgrry620f8F9
         Gr2kktASshapjkVyKj6Uyh6d9o+qR7VO9KjAfwVKlmwWIyf4Z+a+hS9imSGdduPiLMmL
         HE3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e2ewHyAnmUOsw1e/tN+fqYIkcR6yWRk7QczuTMtWyS4=;
        fh=a1uHH0Sal9zAhzMjVBGLfvyozRjHTeQOe/2f6kKoQv0=;
        b=b9+dbqewcTXMNUl6elBvomzXY0/N2BXRfvce8B5xJ67zSWjFIw0au1MEb8smDUdMzr
         bB0kyfF0E+txJs6bMp9mmyurZiCUoafNZMp8cSxxPqnz4VI6ukjAzXvJt9oZiVKpn9nI
         +xcT56Bl0ar1eG7hdqwahQdpy/7PHArk3cBGWaVShw9KrFjM9g9JKe0J7s9o7JtUZWZo
         G3WtvcpybaLMTdqcZPiue7ybrc5PX3FAPeYvtwwT3Rvi6nC1m0u+o/agYeSmqZ53vRRG
         vIu9a+p6L3v3cFHB3EdX40LL/X9hMENGqEueufgh3Uqoce+VfUINNwRh1NvFspex0UFq
         KydA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784754117; x=1785358917; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e2ewHyAnmUOsw1e/tN+fqYIkcR6yWRk7QczuTMtWyS4=;
        b=NP/nXZGZe6/PNwQFXkRX+7LBw95w4hc0FiI68g+ghXpgByhpNq/AyhODxBQTE/yOGv
         7OHVXF26DkgBOefTM2P8QAndTMIJKvy9dCOS+XSxgARN6kgawKJjFLZUCMySAO7NCdua
         3m0ax3CMMPE9T6EJ++gDPkesLKdg/7TD6ckFMikXlaMJ4Uc9Ng4g2fBwfZbHhbQAP3wc
         LmeJXC6r1Wo6w56SmQLBeD/jlSmrEikpP/C7WhjU0RNhh1YPXIeGtwfIJUweDboow246
         hnULxokRMb8HCk4kepfXbuwBTdS2OhXWMJgk+HsQxCcOkXBFK5LbbgzjrdwHFCH+8/Y9
         OPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784754117; x=1785358917;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e2ewHyAnmUOsw1e/tN+fqYIkcR6yWRk7QczuTMtWyS4=;
        b=Ow7kfED2hBSCXSQJvVkSj1oOt/wfwTFcOWCxQ66u+Ro9/RUfDrAaKhJo5yO2XvtPoc
         36Dz/p3aUXefwjhQgO3tgLz5KIrsRpwaq/0/9jDEepJG68QnOWRGEpHXvme4BiQZmIfe
         Xuz6xfx1jMdn3Hs8FAA/8qfAuP/O/XjeRRO1g6XzZ/bqUTya2rQ5G+I3obYeNSjm5TBR
         1yQsmlxyEKx/Rg0kR1gQJNnFNWEHsZIAtCfKCjoYTeofsCAZz/DySTjKWGadLrV5JYTw
         4CoeCBLF3CtGjp2YuJj/mcSZXkGy+BNdfHUo9qIIo8vdZYvRbnmQTsJdP0CMAEfC9Cns
         mGYA==
X-Forwarded-Encrypted: i=1; AHgh+Rp8s0kL9wZzo790RQO+nncMatCJm0lbPnUPcPScRo8A51OZpPhIeL8WK9udBqGMYP+B6snqkA2qfXI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKkv2xv8C3K8ZMLThxR0Y49i6VDuVO/+6DKXo7PTDOjwvSB/iL
	GOs2QzxovZk1e6SKuwv+/LwXxWKTtR3DU+QDfbMFiIp3Ex3sJTOYkk1XnQa/lTj/p+EkRhiTz4S
	+wI+5o+4TcJAf6pqpUPQx9phzeE0Z/SQtJs+r
X-Gm-Gg: AR+sD11uzsLdoog1XOsyVBUL4R1baAtU4baRsx2apGWqvuI8G8PtLKqxoT33NzpQ/Ci
	SjIL+Jh4obFGbrCAznNCLYZXSsb45qSBRPWiOAZ/MFtzcVla2kGu7z+z0n8x+wlVb1ZowuQkuxR
	EIELncA6Pk2RVal/lBBDfnwwiQ7ykJv/Xpr/xvZd/nsRnCbb5hTKn1fVXWWgZHNdVYswI4e1gRk
	xEGysx6Bcbyn9FLAYgMH36WAffcrs1E9ue1v7g5yM765o//KtbERP+ZwBsTbgRoWkgwBF6VKFq0
	lz4Cex/c26Whs8kbIO1FyiH6oDtLvDMs98VvZS28aSbqu7+Ea5v/iTiT
X-Received: by 2002:a05:6000:27cf:b0:47f:8fb6:c32f with SMTP id
 ffacd0b85a97d-47f8fb6c4fdmr41413f8f.24.1784754117241; Wed, 22 Jul 2026
 14:01:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722124931.3159664-1-hch@lst.de> <20260722124931.3159664-4-hch@lst.de>
In-Reply-To: <20260722124931.3159664-4-hch@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 22 Jul 2026 14:01:45 -0700
X-Gm-Features: AUfX_myFnH_OaKIVvcOPcgbNKPlzrgaHUDbZ760JNGIOLPsUeq3W4FF1lWRG3bc
Message-ID: <CAJnrk1Yp_X_qKgBFoQ2JwC8DgECZ09x5xsnj83iAQ8cDeXN2dg@mail.gmail.com>
Subject: Re: [PATCH 3/3] iomap: use GFP_NOWAIT when application for
 iomap_dio_simple allocations
To: Christoph Hellwig <hch@lst.de>
Cc: changfengnan@bytedance.com, "Darrick J. Wong" <djwong@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 5:49=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> For non-blocking iocbs we should avoid blocking allocation where
> possible, so switch to a GFP_NOWAIT allocation here.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
