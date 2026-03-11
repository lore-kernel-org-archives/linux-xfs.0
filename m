Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE2F362141
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 09:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773222946; cv=none; b=lBeIrL27PvjIqcpyttdaqY/rMlGM9xQ03D7uhznq15iXTEMaR2qVw/t9MtRAIjPchSCKOcwdxFr8AiTGujQvJlQ1iwnd6rYE+RBDAU3aCoewhypg2+zzm1wwaXxvtubCIW+o7ClWgZZraNPlY/0kHHT/DXe4M2TBVsgfZxmH91s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773222946; c=relaxed/simple;
	bh=PHGxFUxeU/8CEJ9f/a1uf4JM9nYM9jy8TCMggINjb0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p36aJUJ4v2AsWegbILWxAvLBMUZ/Hr+WLerYp6heOxFyrAMWOYZQ8h17p8V2/hy+iKTVLjDVfeEzleR8Mx9e9ceynZpwFlUAu7uTkyTwsrvVSX764LXt2Dt3fROxYLmu9fVZzG+kLqwtDkMK+xPsITXjtptssJ3zBsC0EGFqH1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZbCifSww; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MuFJ2zMT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZbCifSww";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MuFJ2zMT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773222944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=568arM3Ae5VjTzjIlVx9FCFrwJLVn/cH6C7/64HDZLg=;
	b=ZbCifSwwt2SxRj++KD8K3l6GDYnG78fFN7ckTzzmsN2V8mGLiASzIhoVGexpXfh3mRHbRj
	cjE5PaL53Tsten4zWuYSh6rerPtKBFUnx913p7F6VHDT4NlT26FWskg2OMNsTCSpQeJ/Fx
	z2P2DELIlIeBeA/JfVYXCvCgXV3f7Os=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-JQz0pemdP4uAXFEDbLmZqg-1; Wed, 11 Mar 2026 05:55:43 -0400
X-MC-Unique: JQz0pemdP4uAXFEDbLmZqg-1
X-Mimecast-MFC-AGG-ID: JQz0pemdP4uAXFEDbLmZqg_1773222942
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4852fbfc379so45186795e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 02:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773222941; x=1773827741; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=568arM3Ae5VjTzjIlVx9FCFrwJLVn/cH6C7/64HDZLg=;
        b=MuFJ2zMTUhW0j+rlfyKG8hIEl3HQGo74l6bTr0KTCPSmWPLeKh0WfdrG+d+98IPe2Q
         lIaADiD19zm2y+thg21qoYM721Kx7DrBjPktNamNekWvQvEW4+32EbuZ/TZi21YLzzlC
         vAwsQzgWL4N4F0pzEETpCGN5DyqlGYbLm2+9C4RsEfxk1nfYTFJ36txMoMPDyjfaVvcu
         uSbuIUg04ODT5eUjHGnR6nNZ65UCRzLgq2gwTBpf15Bd65yGzMddi2tEeQG+mYse5tXL
         5xolUSWiZDH/tXvLyULJr5lYDVOZBdGzCOUrp/KNesagTctqV+0XDTRlGBnBZNGAYMXo
         PRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773222941; x=1773827741;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=568arM3Ae5VjTzjIlVx9FCFrwJLVn/cH6C7/64HDZLg=;
        b=ftbmVYRlcQ3/CEEvLB09xaOs2HLJM8PpCwfznZ/ldmYHYI75dRx2c7E2wtwjdugZpI
         0i7DCw7bad6/RijKOuPRiGy8llyqg5874UzJeNpUNwbVgoj+fjDqAAl5h2kmW1LEHb7u
         XFxxEo2Cq9NScELiWdTqnaL7Gghh17e5aTRQkiGONuYOY4XEEWOyr/EP3C/7ub5FewCm
         k7llTk9O5ii1lOFVwq+5J1JR1JSGfzHEUOGMi6M45dBxKqMjpMBz6BMhPzGo3ME72DXr
         1YYv8ClTNTdwvhKru+oBO/h2EyMpThb/7VwlPaBp0TxhK7FZt1GASuAfOu9+SALFmrrV
         GXiA==
X-Forwarded-Encrypted: i=1; AJvYcCVf6QAJ06Zv1s8d83OM52kBBnPl2dW4ACwIjXnh3XBDS+7A8pyCnatQde2fanA12ugVopIQv2+yvO8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx/SPmU/3JlZgwnknZWWv7YMsIo3kMgUzqkZVerb/SZuvrRoOZ
	LGl2N7UoUDIIFoU/QgUxlVZyMznrGrGycUnZjbggqyR2GxbNNb8NFIaeCalslUUdLKipZI0JoOL
	eYWjfuPZ3dBCxP3K9/UIjjo8VLlwVkxLHG28nA+ENqwjcKTbXB/mlZhRsdVT2p0PhGhGP
X-Gm-Gg: ATEYQzy8AxyMXPiF0CkEVJYlklN7mOvju8GI4oV/r4YP716D63RoKqfcEIEWyAuKM24
	UvjeGE7zpEWH3QJ9iSxAYdyvB8XQXIF+rygUdi/WFX3Q95Kee2y85mTnALu/a9AP9HyVW9LdEAP
	R4lkY/5rtvNcbpHGGXsqsa+mO0ymaqXfkVcbeESF335Dp14284puQS0vrfkA5et2oYzP7ocg54i
	nrzhdJdAYJipXnLQ7PmJOfNCG3Nvhxmx90kE4NSfKhrHOlxVe3xwp06YyfjTUNzcqQVuuMM62K5
	P/VSs54xkSIOIC885rVp/FEN4CPcGiK6HCkBqbv/4CecRiNp1ZgXVzDvPriFcfiKTiENOF+I6CL
	W1qsUwgC8zq4=
X-Received: by 2002:a05:600c:1f87:b0:485:3fd1:9936 with SMTP id 5b1f17b1804b1-4854b0a4a9dmr30730635e9.5.1773222941488;
        Wed, 11 Mar 2026 02:55:41 -0700 (PDT)
X-Received: by 2002:a05:600c:1f87:b0:485:3fd1:9936 with SMTP id 5b1f17b1804b1-4854b0a4a9dmr30730325e9.5.1773222940958;
        Wed, 11 Mar 2026 02:55:40 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b66dedfsm41284855e9.12.2026.03.11.02.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 02:55:40 -0700 (PDT)
Date: Wed, 11 Mar 2026 10:55:40 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_io: fix fsmap help
Message-ID: <uhrachhijcna3ocol56fuzsiq2ygalqwkuftdqdirvrhjwen6j@yuwm2jd4f2a2>
References: <20260311092503.995666-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311092503.995666-1-hch@lst.de>

On 2026-03-11 10:25:00, Christoph Hellwig wrote:
> By default fsmap prints the reverse mapping for all devices.  Update the
> help text to correctly reflect that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

