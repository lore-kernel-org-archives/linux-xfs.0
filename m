Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C42C3D6493
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 03:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789099086; cv=pass; b=MljVbqjfwW7ndGtX4/Re9wLkozoHCK/kYfAwfqUChKn1fzWKdpMfciO7Vnaz+Ca7rZci3IxPb44+3IiWY47dXAuuZerVp9rKg9Hph5lTXdNypx92sJGgvl1lxQ/uInwjpQXO/54VlDEIKrfv5Q9pQUacRp81mJ0/Wgyc8epQKbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789099086; c=relaxed/simple;
	bh=Jbz0JditIMqXliVHM+HmY267N4tGyAWcdvJ4Qd8Aco8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f/WNn+IleWkLB5f67QQG2HtUCZI/x2MSSf7QKNe6DmOBi51AoRMow6E5+H99ErhME8/d1VYcvodPuAZmavwp8ioQITy94R4USQXyHFBxRjqaXT/JfWvmI3QKNrSqifcLhr86ZcwW1a47CvrQRrWYHyC1MCS6tF1bdpa7zSP+Itk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CMT0v5ND; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CMT0v5ND"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c25420fe973so85159866b.0
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 20:58:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789099083; cv=none;
        d=google.com; s=arc-20260327;
        b=HLYelRzs/gb/tSoo70Y9PUEJoAPL9KrNM7o1dSp2b9y6rxdSgooaQOYDmwJAM4oh2K
         yO2ZBCyqoWRIv8E79IleB7OzxrK5JuX5pN/bRhnH+AWy3mziVV4u3Zc+El19la8vT6so
         xL9QcyHfK+MCAVEoIEnrTl9RfUV5PdQwP/mssKhEcq0kRLkwpXoicNoW20yige0gbyyc
         4JMk3psj6l4RDYeYAI87GU5VwTxK8UTxDT0fCs3DVlaqsGnUlgT2V4iLW2pVdlNmD6DJ
         U+A+o1KwKD4zl+KXU6Te6fILD6oneCWMSBhHyccZcU3lFTUeZivrwB2t15yha7BVZOuX
         Vokw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Jbz0JditIMqXliVHM+HmY267N4tGyAWcdvJ4Qd8Aco8=;
        fh=7YMxtYFY/SKZnzB6YPPkbF+pOjpvIGvVLClgNYU4CNY=;
        b=YUVNKZz6X6gWMgY1xIAV5MKnnwkh6E3j6AYTIwhtdnu+IzIg/XH/4McZaIPC3cGP5g
         UUv9tZPTVJlxeUNFJ+DwABBDbk0GevT29i5OCm4Jke6Mw2E/AfdKS7ixbDRzb+FZ1qvW
         IuC504jgoCJYQ5rIu0BHzjbr3ffJ8VbKrfV7KUoK6Ni3/V/XiIRkww59fUYXlduA8nuj
         KrBdjYDg/JBf7DdaCD3QAfJBiCqkuMO1XLMIbgMvsZrcHRbOl72GMI7Rf8T4s3bGcm6Q
         IcNmgVDr03gM03cJaGZ+uCAgm8pTDNfh3hxaCLmVi3ORPNk+cyyvnRUJHnl7tyEn1Z9B
         TeyQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789099083; x=1789703883; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jbz0JditIMqXliVHM+HmY267N4tGyAWcdvJ4Qd8Aco8=;
        b=CMT0v5NDPn2VfGnpcuasyIOxqomgXCrVtbNq/6TMcEWMsihAheeAzZ/wK6u38YaOBD
         64NA8diXb6jNnARj4K+5x1iT8b2cviRKfs1mCx+qBpTvU6rZ8ddkl5u6evWkUpqug06G
         +nyGxdI89HdzqYjGoW54dmZ7ehCjn6JE01jGiyFDQG77dRU+ukX7LZ81hw4gRqB8oy36
         5h9D4uWC0hOSQtCg7f+UaphcfOmdCHZKuke4Hnl8mvJqzrpG0qPb4g+CQ3+4G02fqFYq
         zaEAZ8egsoV54BXeoxB19YknSdf/45+xifKWaof7+gxAbw0BXcTa8zNDrN74f5h7Vb5M
         MzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789099083; x=1789703883;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Jbz0JditIMqXliVHM+HmY267N4tGyAWcdvJ4Qd8Aco8=;
        b=e2nLhT29ak/2+2Y1TGpM8+9PwzSC+UtCeZY/59ZuVl6ZsoIl6DVvXf3XaMnetox42s
         A9yUZd2uxkgOON9L1sZFm1tsjS2Q9WizP6yf5ZK86wo8dPg0EFdZv/Z9VC3l8+EP3d39
         y7/XtfVR8jkVGwTmQP/TOKGpfXALIXbCj8WAkgNp/nGmstqRYcJ5SglPeKaTngPAc66U
         JFfLNgE/+sN1jk3JEkWMXUe7HG7zmHS9UxOdcV4b0oZXvh+56XAQjSbKSXrGtt8ipumt
         y05llVdoZcnFObgfA3A6TDbxB0IBuuQQLquK58tTXl6CPyO3knclaBO72haoCB8GfyAn
         80lw==
X-Forwarded-Encrypted: i=1; AKwUvBxPLNarFktnQDqAtrQ7S7gab4K2IpYGiygVqBPu4OZSf2b0Oft2y6q83eJP/OlC5yciEHNEG4MkENc=@vger.kernel.org
X-Gm-Message-State: AFuF++mRRVGQOO5qNiF5acjdBkhvYw+o5MG2TiqUuuE/YOrt9EP5KOvr
	rEQnZufXoP9A7hLVHusG3/gBeaNc+KKNCtFkeO7A2YsqdMcUBXHEhbIFUDgKehNS/sR71gOjnQd
	r9cEG4FoaKUf81DCfPx1YI3FKg4nqKQ==
X-Gm-Gg: AYBFou3J14FdBYZYV+CT33U8dG7r8pPbW8DtRpEUIY0ELpbSJJz2uh5SXJSPHYuj3v6
	Gq6P/qXcfcTV7d9mDFc+xY7YqcfEz5CaEzGftI2QFiecqW7pbXOgvQFgQexLYW4I+hljysT0DZA
	YQPbuiH231dIjoWDaGpJoxbM9VUSZjLLiurBsRu+pPbeR91mMSC5Z51EjjDkJfeectG00GlKDvh
	+x10HNRyUpImfkL5AjQ7c+nN4Cnz3PrpDTlgQvAYbQ4NX6TuaVO/pv1wmlYTzH9/vQ4CbtAm8/Q
	BqeqKp+oMd0E2iOyIWfW94ZDZdmdhhXzcx37SmXoqIdg4BvqzP417/r0AQSSXfUiFD4vXpY0e+o
	n4X3mR293/7v9md0UmpXnPDipsE6H5OKT0BxQ
X-Received: by 2002:a17:907:ea89:b0:c26:2da7:347f with SMTP id
 a640c23a62f3a-c29661fc502mr78725166b.0.1789099083258; Thu, 10 Sep 2026
 20:58:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260909060924.1102037-1-hch@lst.de>
In-Reply-To: <20260909060924.1102037-1-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 11 Sep 2026 09:27:25 +0530
X-Gm-Features: AcwNN1VdycSrLLrtn8Jejfnce-6s5eyTxlcZ22co8XHRGHweLJX6Z-Wohcful58
Message-ID: <CACzX3AuraKdrv+VQ5MNT3XcLZiLkZVarpLY1-jfwQdcmRxa8JA@mail.gmail.com>
Subject: Re: lazy bounce buffering for checksummed reads v3
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>, 
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

For the series:
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
