Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A4A456E15
	for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2026 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826355; cv=pass; b=mIVryy9eudFf46bGftnH252RloSqf0vsJMHf+h/qjOgxCtE3G5jjbfpLpeCIJ0nK/IFUm/W/ouwb2c8zS/n5RGb5dpdJ0e8qIKAwwqQsWk+AFhXJO1RaVzy32m1rSHasSvFNbKZfZNh8FH2r4aU7xbKyjwEVnlfKAns8WJwCQuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826355; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UbXtOd1ZUFrlyVsNt9PoDz55svYOU14pWi37CJG394U6V5rYSCrP0H8F9jbvufsLGkIr1vtIDNzC1iWo+U+8naeKsTMr0jdtht9FRhdYFSNfcSV62I0FruyKg9/zb3+K8yjr3CYxs0clN4/OT8BbCKoF+2SyH2yTp2HshKOEh+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l8pkA7oJ; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l8pkA7oJ"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c1c24ec9525so138594466b.1
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2026 10:05:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784826348; cv=none;
        d=google.com; s=arc-20260327;
        b=XbAwvXKz0VayGQcz8+WfXfGtpbkquPDxD50aP1yH1qw/YKEA26pM+XFJQs8uDzz989
         4/bRcG3LqzOpJxMAPrB39L5xiuR0Pi3IUWeBq+IKi2MSehG5KaZqsRvYCWmvTgWMQ1kB
         C5/d+jaW300fKVa1CXstJ7b0IbwEka+bXw+9LITUxhDnoeXO2XYD5V3F+LIFC3nNGOod
         gKUt+3ZCWVvysHaY4vT/rQ8HFuEmNJ8+39DnDzWeXRrLN+O+wu8Ew4YFVQMhqnWS4k8B
         JeN4yqIRKgQ05/fRyj2R2SYtWeBcyMTVvGtk8vyAO862PWWIr50o3E/ge9/NzfNIbIxI
         m7eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=+3d91G0OPNvsoLxeILayIK8kWUUkJiZUTLkdzDyY5lw=;
        b=jQ0Z3nXo+b0llMmikATD0z+EYtPF12C//24lIEMwWBnZO7JyYJpHICuV4eJKCBqyG0
         UYEsthKuKpPllnVAd3mh/mP9HaVkGZRYdA9+Fqiy66bJkthmxlrxcalMIRvX3zFxlVem
         Zs9PpG9IGjC8asz5yfBMqIVnwW3UCMo5qr0L7tPUfNcsljXxQ+CrX6WC75PGaH0QNXv4
         MMbIQ2EjC+QBxV9u0VNvvE21egkkg7bgxjSkPP3W+JL6oeUPuNbIxSqR494WzI9jVHUW
         3/2L8pbr2X3fodDbTxKwKoP0sLvo9mtlZ8SJ3HB+nCTms67F8mczqzy/0tGBR9+PQpUU
         MZww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784826348; x=1785431148; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=l8pkA7oJLih8TzuvTDGh7j0dMOl6Eb9Nrun3ybHk91qSM1/ZqamVq51elv79Ndy4aN
         L4+7SrUjtKtmoGwa1tNEQxBxhuWfYLqVZwNrhC81cIf7IR1JoLsJZ1znekQ/5tZrvHQT
         M1IvSMRdCj29VDkj0qw7igjvkqLE8fVDl5sdnQrGoXo14i8HrALrM0LPwQCIxY8u3uPg
         y86xoHXl1TJOzQYuCunnpAnCcpNVXX/P0WDUKNre1PTW3TtLNrKUYMUAMjOEQUN7fwqk
         9FiLydcKYQpgYmvsHWElZNb9x5pvHnfoXzL7wbr1bKgxb8J16ovuFAZezrsKvJL/OK87
         JR6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826348; x=1785431148;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=T+1x24jIglO9rnEYavf3vWr1M8oHb39CCLZgUKe8kt3RslrjAblA1MOnn9n20iC+52
         eCyA4jxX8AIT3vp4qEJshu6RDlRALj2sgvKWGrGhqkm4bwnBCJpuK+0PpdNTqYM2lR+D
         HWuBzlmC7iW7rg8AdoSvo8d6EPoRAgFT3aI0WzUfQulRFx1Y4yGXCqX0nj9+t++WwGDa
         u68SUQLKeaMhqOSJQk+1MVFnNFsL3qpTP/5AjmgFZkgTzVc1o2nGj+WjCev9IlAvq0uj
         mGR70Cy7T4lKM7f1JEzgX0wgQ1uI0tJDCjIQiKntKAcd9pl4EVQadPjeKBRkwhv4ux83
         YMYA==
X-Forwarded-Encrypted: i=1; AHgh+RrObWVrdA+QKU+tTrlYWarYN1JGT0sAcgSJs3KM/ub1wThuzVIrlSlsGWVHWegQfcPbVBi9AVGyd1E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxaDS+KNVjUYJPz61slaMxrxL/WU7+SVC0l9R54k0iO7/IVjYj
	uJndq4oZ3lT95mZXDg1wvFWFfVcAiBR2Is/XDMjnVXcvT7lD77nYo2fslRHnaCm1LyLPeuo3h2L
	Y0wJ0+27HMyOTxxPNzGOpXk8YKM9nIw==
X-Gm-Gg: AR+sD11J3CLQTAKiP7NhO37FrZN0jY3/bafQXeaY6+/aXoSmlOUlWTAuuoNk5+bLW87
	0h7rpHAwlM5rCNnFDrlwNl0U3cPylNgC4HwQnDmDeVeCpiPDKzE4nPX04AQO8nufuYj71PiX0n6
	IW0BOSHX6DctC5kHSRLBNl74b7LQQm+DYYk0RcGTzEHlb8kiAncm+mp6emHGtUdVRxxJlGvVNRy
	YaA7K1Ol0m7bDTT4lSF2bZC9Rjc71LJFyqV9SdQZPEBSrPfvFlFao1lbXsYeRx9LiO8edlGnM09
	nCEiNVmzV2pb84nMYzW0DJvhyi3jjrsTUDw3UVEJMGw=
X-Received: by 2002:a17:906:9fce:b0:c16:a9e0:d5eb with SMTP id
 a640c23a62f3a-c1c509a83b2mr202122866b.56.1784826348034; Thu, 23 Jul 2026
 10:05:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723145000.116419-1-hch@lst.de> <20260723145000.116419-5-hch@lst.de>
In-Reply-To: <20260723145000.116419-5-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 23 Jul 2026 22:35:08 +0530
X-Gm-Features: AUfX_mx42CjHuGi597hWO-eDmQkzzqIKaOn08um8jFHZz68xIGpeWOmFM7SNP0w
Message-ID: <CACzX3AsOLiKnG=spMY5uHOJX06QB759HY6fh7Z+=zBgjwEPfZg@mail.gmail.com>
Subject: Re: [PATCH 04/22] block: handle nogenerate/noverify properly in fs-integrity
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>, 
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
