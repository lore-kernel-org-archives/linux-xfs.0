Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CD91A0AFE
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 18:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725994032; cv=none; b=aV/n6Tg+wDDnCTv0uEm3U0YBngDGfSneQK/t4Xy5wsARQ05cfO7hd9OnXg0wOO49jH9WvtJ8OZT/jPDhw4JgmP+v4VvDyLgGH/fqJHh6QuKpJtjP7rkSNQlV555ayLmnKC16VNnelGiUhYnVXzdieAqM/2oKW0gM8eqM1dqvdLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725994032; c=relaxed/simple;
	bh=y6+jU1nkaFCJb5CtmFh3MI53xVH1yh3eKGITi0k/9LU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=auLll5OIR3MBOk+61LkMIvWsCS3lp99CTXOmNuhKWVs5dfbtuBCeBeqO4rNbXLhIWdjOPrPOq+msdJc8kYvZRpUkJcU1z5y6f6rJ+lKs0AjnaD0CIOlc4t2xdleH4BSwl060IDcT+ryMNHfvXwVOqbjSjtb4580/RJ2sLQRYnm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dt7R/5Gy; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dt7R/5Gy"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-374c4c6cb29so5255902f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 11:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1725994029; x=1726598829; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LPcgYLqFkVUYW17im6jAp29G4Hv8TcuOuscbjSMgOgo=;
        b=Dt7R/5GyZqQ5wA8zQTpIAH2C8c8FoRtpfzIk1YzIhSiNz0k8f0hW9OPF61Kr/Z4KF2
         5qh1Xk5QimVNRBnrAKDMl+veC55+A0NerxsSsmQKDCFH/fXdlHIc66f6oLa43Lw2t8YK
         pSaNNKFGMS++agXg4iFe3CIEdDAGqIY2pp6YQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725994029; x=1726598829;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LPcgYLqFkVUYW17im6jAp29G4Hv8TcuOuscbjSMgOgo=;
        b=HdoV3hS4USZSFe8ASXJEgkstek6HVq9LWhcWQs9FryqUxd0Ns4wYDHR0W8iwTCW9vI
         8VAzhGqKGrJGJmVPN5AYUr2JRy2oSbP2yJvbCFTWIoIDjEjwjgRbpK+L6xi/Cs5yNjD4
         kkR7DFhdJ4qsDDJoTEw+T6Z5RSAGyBVNT16NMoFjTGfJyoH7+NzlUar964/7Gsl/vDYC
         rI73XLuManj0LeoEGroe3xu3Kvf2ME7bMa5xYK8WcV+d9Njk4vqKm3W+32jceM8pSfvE
         1BtSP2zXnCt2lk7OjfJmRvdHjmJsh6hPDqp/fhQG2291AF87XcKALeJssQxW/uaZE8T6
         BOjg==
X-Forwarded-Encrypted: i=1; AJvYcCXSil8NOOKHkBO3wH8aXDeHTTpkcyTkXv0oBAbQeE8hCyIFcOFxAsRVTdgWxsEjfr/lcs4rm2Zsn7E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrp04UgJML5hG9zX5EwSYSMIrXqSRjU0sSc4t5nj9Q4njsF4rA
	sxlke6L6xY26mRlNFKqP4rxIUCB2LAIAw+AgMf3x/QZhGENiupPRJ5li2VQY/7ULWPRn8XgfcnT
	xnOV4Kw==
X-Google-Smtp-Source: AGHT+IEMFydTe3iM84YHrmUt1EyceCU1RJijjZI1rKICbnJellBPEir9LNfRD4Hau8ypM3ry0W4Trw==
X-Received: by 2002:adf:e3cc:0:b0:374:c847:831 with SMTP id ffacd0b85a97d-37892466e52mr9073704f8f.55.1725994028467;
        Tue, 10 Sep 2024 11:47:08 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25835cc9sm508735166b.26.2024.09.10.11.47.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 11:47:07 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a8a706236bfso345342566b.0
        for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 11:47:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWeuRcxMCFBMkgP0Y36NegTDlu4CGHsMQCliILtuDHkxWAYxt16YqZx/0t+F9G2ZFz5fsF/7wiptus=@vger.kernel.org
X-Received: by 2002:a05:6402:26c9:b0:5c0:8eb1:2800 with SMTP id
 4fb4d7f45d1cf-5c3dc78b469mr11458506a12.11.1725994026812; Tue, 10 Sep 2024
 11:47:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0a43155c-b56d-4f85-bb46-dce2a4e5af59@kernel.org>
 <d2c82922-675e-470f-a4d3-d24c4aecf2e8@kernel.org> <ee565fda-b230-4fb3-8122-e0a9248ef1d1@kernel.org>
 <7fedb8c2-931f-406b-b46e-83bf3f452136@kernel.org> <c9096ee9-0297-4ae3-9d15-5d314cb4f96f@kernel.dk>
In-Reply-To: <c9096ee9-0297-4ae3-9d15-5d314cb4f96f@kernel.dk>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Tue, 10 Sep 2024 11:46:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj6o-GwyT=7nEfmHKz0FcipfSQwV9ii1Oc1rarMTUZDjQ@mail.gmail.com>
Message-ID: <CAHk-=wj6o-GwyT=7nEfmHKz0FcipfSQwV9ii1Oc1rarMTUZDjQ@mail.gmail.com>
Subject: Re: Regression v6.11 booting cannot mount harddisks (xfs)
To: Jens Axboe <axboe@kernel.dk>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Netdev <netdev@vger.kernel.org>, linux-ide@vger.kernel.org, cassel@kernel.org, 
	handan.babu@oracle.com, djwong@kernel.org, 
	Linux-XFS <linux-xfs@vger.kernel.org>, hdegoede@redhat.com, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Sept 2024 at 11:38, Jens Axboe <axboe@kernel.dk> wrote:
>
> Curious, does your init scripts attempt to load a modular scheduler
> for your root drive?

Ahh, that sounds more likely than my idea.

               Linus
