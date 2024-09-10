Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AA8142904
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 08:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725955444; cv=none; b=SdsrJ/JmmppMW7IM8uO+MWwij1wrBPyZT0t+wq6Im/g6h5EEw3pnOOLUBVsESxGKNADFh1dKcLjIT5ZSp+ItYBgb1MkoUqZAUH9n14RvtaUN+OpoTab2DtNvbUmms3cqFTZjNnsqwjg6W6tJotBbb8Z5fD1xV0aBkofwq85Fmbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725955444; c=relaxed/simple;
	bh=lqpDDcofhU6DCaJgY4kfjS0rANxXVbBJE6VhpQs0A1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KvUTfrVbXFVTrzVu+L+2iEFhCdVRteuGgGQLWgK22+luxUpACu94yz/0yGDF1GPK9DtfzNU3AuRzM2Ig2AO1z2RhWxwiPqj+8uhcE84LhPa/cPVmMCJNH/Oig35INVWjb2WN4RpZht8w7Ik5VP02BjiJFzLO8jRUewi8FxWNrp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zvgsxekj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zvgsxekj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725955441;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyQj0sEcKadGZ6MKzBe6EKQuYPEa8J/gaRp7DMCCZ9w=;
	b=Zvgsxekj8wVdVsJ+q9S8hbX8ffBS9OKr/W2Q6N9SBNqYX2FjYTm75drFKDpEvdpscMHweL
	Z0Vq6RoC7U+BLLvoEZgnm5Hx+v+Hp0cB2C1NQuGPBbkXXNp+NYIKlhYHz4YwLhscO5rlWz
	tPeWyvlJZhLY2DobeFSUi2c7W8iYXYI=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-XtZ4oIY9MmGJILNSG-LloQ-1; Tue, 10 Sep 2024 04:03:58 -0400
X-MC-Unique: XtZ4oIY9MmGJILNSG-LloQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6d9e31e66eeso185519397b3.1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 01:03:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725955438; x=1726560238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cyQj0sEcKadGZ6MKzBe6EKQuYPEa8J/gaRp7DMCCZ9w=;
        b=AZOMG7lcolfGUS5AzajnfG7B8sZHIRG82XPMCOurU9XcAsDiMxrhQcCPuKco+aTHnL
         grDOUWtKVGFV8Q4IhEFLuKHFz+TUCQHgqFqeqKL9WIrlo/ZmSq228WA4s/Jv2M0Dfr8w
         di6dxk3hBvqAh8QIon/yAcOM7BQJsnLQKIFiVSfkz32cUXvFyWCTcaYyHd/JxiMi+lM8
         YMBMjL/ycD5WCd7ehSyAOL1XtlReC1kTqMLb3rSN0RIlzy6WJNzlTcfDyqezqVO5VAbS
         Ra8sVi2e8dKw1MPtRNI/3OU+AItIWFRnw4QL+ckQA5ogg2lgFDbqeJ68+XTMJb99YtSU
         Q8uQ==
X-Gm-Message-State: AOJu0YyYz56LvqWLr1Dqg9lJ8ldy9pHtyglBX0FvJNq7902w/Ok2Wtmr
	PD4ajiSqxgMU+Cs9MMR20Zgdn9EqdswfsDS7l3lUi4/rEx+6wPvfhbrCLqM5+yRLu43m+0VWWEx
	HoJppaFho7IQ+CxJYLPne2q1UZPICuKXN59tPcCBPNGPIkuBZ4IAAChFsIRm5iCfxkZGHhEgsAt
	zWGzedLe2o4Qg6fZHjk/nLC3mIZiSkVp19r9gP4IdgnK8=
X-Received: by 2002:a05:690c:4801:b0:6be:523:af4d with SMTP id 00721157ae682-6db44da271bmr150497357b3.11.1725955438015;
        Tue, 10 Sep 2024 01:03:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQSMVlFEjk5ZgCZMxhzwOSlotaDXDiKFFdKA1AgULl9RqtNGGmWtHGd9kczUIqY8k6XIbRTNK6LNJO1+Qu9VI=
X-Received: by 2002:a05:690c:4801:b0:6be:523:af4d with SMTP id
 00721157ae682-6db44da271bmr150497267b3.11.1725955437759; Tue, 10 Sep 2024
 01:03:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <MW4PR84MB1660E875ADC85F675B7DE5BA889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <MW4PR84MB1660429406E16C5B4CE9711B889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <MW4PR84MB1660429406E16C5B4CE9711B889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
Reply-To: nathans@redhat.com
From: Nathan Scott <nathans@redhat.com>
Date: Tue, 10 Sep 2024 18:03:47 +1000
Message-ID: <CAFMei7N0zgsxLnOcgvQ96d7Z1r=eWrtDtEuRuwQ_RmwbVk0p7w@mail.gmail.com>
Subject: Re: XFS Performance Metrics
To: "P M, Priya" <pm.priya@hpe.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Priya,

On Tue, Sep 10, 2024 at 4:01=E2=80=AFPM P M, Priya <pm.priya@hpe.com> wrote=
:
>
> Hi,
>
> I am looking for performance metrics such as throughput, latency, and IOP=
S on an XFS filesystem. Do we have any built-in tools that can provide thes=
e details, or are there any syscalls that the application can use to obtain=
 these performance metrics?
>

I recommend you start with Performance Co-Pilot (pcp.io) which makes the XF=
S
kernel metrics available in an easily consumable form.  The simplest way is=
 via:

> [dnf or apt-get] install pcp-zeroconf
> pminfo xfs vfs mem disk

This makes available some 350+ XFS metrics which can be recorded, reported,
visualised with grafana-pcp, and so on.

cheers.

--
Nathan

