Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5658053A399
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 22:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790894367; cv=pass; b=PUaKry6r4XwbnNmqZnobjL+muCpWCIHN019clvWs3TQwscjXOgCtxcqJvjuodi08IjPUt9zktMqVlBut91R/1f0e+SjTI2zAQ+gbxG2Upt96+8SRWwSdA6CquLMB6/IeUBXfTAI5XJOhuhl3QWhmeayKEwZJWrj6v4woXWG9Ln4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790894367; c=relaxed/simple;
	bh=ZQ8wMb3N5qPzoasGoPBrl9zXBlTwR04VTtQc11bY390=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DiNllul2+FPMuNe9JYj+OJ+LCBc5Nd39Dy2l/gFzyalth/HSh/g+1aIAblW1geyhp5UdShL0s3Wz9E7wUkuFQ6ZsnCpTAIJhrdN19agh43OTPaPsm6bG31eZMBq3VEeabK9oBLDNbIg2Nx4R8hCQcEetzIn69fwhuUvOBpwbQ/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eEt/Gxmc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jv6JyoUr; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eEt/Gxmc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jv6JyoUr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790894364;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9XLPokg9EX+WAcQb6+nB+7dHGgTkFwiCmfGp/17eeEE=;
	b=eEt/Gxmchi3doz2NSL66TeZAcwfErLPmWUItGblBzfvquQ0KxjzpAOqvUzu3oLgU9ZMqlt
	6VTy4WOzQ/N4S67OCJVf3F14y1B95Ab7COdwzEHnLcW0zVcc//nbximG/yQrbEymf1kNrv
	086YXFHgfSRhCn9ZQ1xQYxRc8ZiG/pY=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-sj5KQcA2NZqyYz_yQLc9Gg-1; Thu, 01 Oct 2026 18:39:22 -0400
X-MC-Unique: sj5KQcA2NZqyYz_yQLc9Gg-1
X-Mimecast-MFC-AGG-ID: sj5KQcA2NZqyYz_yQLc9Gg_1790894362
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-482966c4f4fso2869609fac.1
        for <linux-xfs@vger.kernel.org>; Thu, 01 Oct 2026 15:39:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790894362; cv=none;
        d=google.com; s=arc-20260327;
        b=iWC239g79yYND6C45p1DDVMvuruvVDCU8Ju18IHeDMvgh4EMAo+eATFvQNaR2egvqZ
         gpbGAwjK39agXFmfK2kWoOs2Zjsxf90qLVXjl3tIhL8njZPa7B1ti4FI/pfEL/62cOYq
         cKHI6sQr5aiJwWwlLUNkXDIcJEAkJT4zHmVdMRxMyq+PjYkJzr9w4UiDHCSXSrs5dOwV
         H+hUBTZVoZUoqElkZrjpN9M/h6swzhg/idH47Ef9AjFs5onhohwBEk1BWopsaeP/GKYF
         PxlPNc76t7NDgTKN/pW8O7CBwXIT2kDGqtDHsvtqs9p1HahkmzIOq49YmDyQxguj3U6J
         AXRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=9XLPokg9EX+WAcQb6+nB+7dHGgTkFwiCmfGp/17eeEE=;
        fh=MJ7PDith3ezTiccg8GZ+51sNYWhTwnC7hmulN3fFrSk=;
        b=V4qhyDq3ZLNRZSikc542XtjDptV9X7F5TKftXbRb+kYXifWBczOTr5cHevgDGszmhB
         c3I6GG5kCsfCZMvIaod1SbxOWhXJYhsBxS+CRCddeMIlcynOMjLZVEYlDdMleafp/1s7
         9RBNqLic5Cex07wUaDGyp9YSCpsZiFqh5CB2HPoaJazi5BCoEHqWuE1N00v40wcuL2a4
         //Ko2KsJsIIAliMdQuXWR8tfFp8rjFlH6iFdZuTyfGFAMVsLarPPyP/sE1YhcdcCixum
         u88/sMmoqTiehMq7sNdOr7I3D4Iu5c8axp5k9EKofiH4txLFaA+7a2YY71fqLDEyKwrW
         3abw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790894362; x=1791499162; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:reply-to:in-reply-to:references:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9XLPokg9EX+WAcQb6+nB+7dHGgTkFwiCmfGp/17eeEE=;
        b=Jv6JyoUrSfm7iNvOPA9c3YmVFT8kaxvLmK9KIrNIsPW23RIiMnwWKcOAr0r/8gIN1V
         RtOB10HfMms9kcdTl+4BL02YVKY37z5pEaPCPY+/y2wB5Ftnl04qfCgZRFS4EnZtksOe
         foy8V2IepJA2qS3Vq8QNBNL2XPRCHqFwEENhnkiIof3juv1YB2GlUyjNJ6UFaJEJ3GuT
         f6gM6CECuRVDfg95ylwR0Lag8ElGYKe6LEQ86T5zzmayv9sMZs2Pb3eIRwggq7V0UPgx
         KhZ6g16aimdRux4N0qq9NBQdAVaBswmyB4lI8In291r5GgcQqV8UsuoZ85PAGHKFFHgt
         bO2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790894362; x=1791499162;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9XLPokg9EX+WAcQb6+nB+7dHGgTkFwiCmfGp/17eeEE=;
        b=cqCtOYnGTWTzM+RWs7GArt+wdF9oXE75Wg9sTFamn28hhJIXeJ11xgHpD0HSydfE22
         YQQU2tJdknZtUwRqNjXiUyEH5/R2wKyVpcfc3PHS+GAyHw2SQEwzbWfdI8ElNSMkD/Y0
         0jjy7r4SiCw2fuk5kGPl/WGkFcmyVDRCNBg49k6mngiIa/gX77YTr7ooN04N3R2BY/3U
         DKFOeTIZtuonxV3a8xhhsbrpDUNLbOcwVgJo2KtDil6kqxq98NkY9Oc7N3bRQAMA+3cE
         1ZNenuCFSfs4tN/yZZ5deyibzyukn+57FlOWCT+fywmqwB5UBeeQSYOVPqGWAtbZJJIY
         v4aw==
X-Gm-Message-State: AFuF++nMDG8mut1n1bdmlGPzWRqir+uH/JAW7WwjK5ICdyIpBbdokPch
	NOn3uqhWrNMElj0GnJcZbZ+4g1jWfmz5y+UBTVOwD0vvbj5rclB1adM6+p1cKaJXFqzuhgvivpk
	homUu6v81ZMmOfW6Y/H06Kq7sePi1QFcPydGPMz8d5zBpY4tDJ0ugvvSDD5kWsSjVQAz2oqoZtf
	WAzA1xesyx+BcoIC8PumdaviCnkpNWXg8evsv+
X-Gm-Gg: AYBFou37M0pQzqYhbPrw7akYmMGBX5spGYTl/lgJV+Ea8PlRPQ4BC6eTZ/FfSU9s8B3
	g3iJGQ8SPryYNMlk0UzvHvZhTzabkbGtf2/ceVo27QArdWWAccFYU7woEUZjzz93W4PEqy/Rqyr
	/jpRuC762UgJ/fHgLMu4H16dxj/RQnzSyn/dyb5bu/QYv6dII5JGYfoN4uHYX1Q2nCCKOp6GZA6
	k1fJwOUcX6dfP0uQvXTRrVwLPoq5Mj8tNG/ar79Gk3xdQ==
X-Received: by 2002:a05:6808:2203:b0:4b2:8d83:436e with SMTP id 5614622812f47-4f3080f416cmr3486081b6e.8.1790894362103;
        Thu, 01 Oct 2026 15:39:22 -0700 (PDT)
X-Received: by 2002:a05:6808:2203:b0:4b2:8d83:436e with SMTP id
 5614622812f47-4f3080f416cmr3486071b6e.8.1790894361666; Thu, 01 Oct 2026
 15:39:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4103a3f702be0ccf0e6eeb34981b3d65@phys.ethz.ch>
In-Reply-To: <4103a3f702be0ccf0e6eeb34981b3d65@phys.ethz.ch>
Reply-To: nathans@redhat.com
From: Nathan Scott <nathans@redhat.com>
Date: Fri, 2 Oct 2026 08:39:08 +1000
X-Gm-Features: AclHuK90XvC9EmJpMFBc5u1cggrrrpVOAELR5lKi5nnmyhQEv2vpg_y19R1-C6w
Message-ID: <CAFMei7MchKT5CfDPOafJGjzxZ6L=Kr3vDSRHvYXDWK9THmuqcQ@mail.gmail.com>
Subject: Re: rw stat clarification
To: Stephan Mueller <stepmueller@phys.ethz.ch>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Stephan,

On Fri, Oct 2, 2026 at 12:08=E2=80=AFAM Stephan Mueller
<stepmueller@phys.ethz.ch> wrote:
>
> ...
> May I go ahead and make it
>
> rw #reads #writes
>

Nope, this is an ABI.  Userspace code has been written to this
interface for >20 years.

cheers.

--
Nathan

