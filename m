Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114D5183CA0
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 20:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726001759; cv=none; b=fhib53JocpKRoMUsGYe73Ol3xSY73LGUIW2/cA5OyGiGEaFEBe1POUBJ9PMKhBv8FtkIMM0n1EtUNYxvg8uAtxnYrqccJ59jZtXeIi5ckxFSZW76Sr2WHxAXTYrod3EbPT0rbFHnlPWNDfyMk6r+EUkIHJlpVEkmrpi1+PSqpKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726001759; c=relaxed/simple;
	bh=21E8ZSdDZyOJiD061b5jDUcHbdCC2nnjjDTxVeEYnuA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OyyLiUVy7Ne4zMuMJAceYxAl32CZaE7UxXRQLTPpHpwgsz+EOJ816NofDBawhhzDjxexCMXXFcZfOk/F0C+UhpMtKOt84hG+Sw1uGCOx1EK4FxDIxeBaIHdNJefetJd7aDckFE+S8mcNLR3MlwGea9aK5SzYQB3n7TnhU7hHjE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7AAfigT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7AAfigT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726001755;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z64cjPQ7ARZ7rg9e0WRemNHWozu1NXwz+vOz+nBIefM=;
	b=A7AAfigT7+yQtDA3zh0yvGrXRrJOmzjvDCYLwVSuQqnZ8rdGo7waZW02hI4sS8P6XWYdQ/
	L1Ss1l2m7LQDkOeQZ0T/+9M0Co0M8uxDTLeYTt8VF5l32QiXM0QV+WPDPm3KhopTE52YnU
	kRMPWt9ZFOOrP8CG+fMwSsUt2jZzyxI=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-xE5r4wz_N36bmodmqVCPBA-1; Tue, 10 Sep 2024 16:55:54 -0400
X-MC-Unique: xE5r4wz_N36bmodmqVCPBA-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-e1cfb9d655eso12289816276.0
        for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 13:55:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726001754; x=1726606554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z64cjPQ7ARZ7rg9e0WRemNHWozu1NXwz+vOz+nBIefM=;
        b=VPoXVkwe41XqEWAGQoKit1s2GmTTAvMF/A2i00pcv5XzXMu1O/nJ+pOWdUIr1ZhMKN
         77nWAT06EZNvHvDgVEy3Hboj6V/jMhF+c87sTI0uzsnlIvzAIY4+AqLBr3zKxqrtQcPh
         cSL765dkO23wLk6OielObpeP+YDfpliDsoffMygiMYu8vH34IvhZ2qFD4A6AX941DihK
         PigRMXqK/QKxnnk0id2Icu7sgZ7vGOKSyu9pSKiTOvVQOaUxTzmLtGITdjuBYkFrRyVg
         TYO+FoRjJEYkWXjIE3VW896PhVXtJa+5ubvj9GKwHYC/dnSZbf8Tv5qu+M2E2Fztycku
         F1BQ==
X-Gm-Message-State: AOJu0YwzD2lZOiIeU5GRlhLuWiAKmVqixKecU9YrVM8aibT1EwT1QNNW
	SSpGV+jhLRReEuS7C0UGBPW9DvaCtrhcZBJANY3Edc+4Zf43BqGn4sEfqpwt7cgST2deY/2Q8YR
	QC/oDpc7NLT8A0B5XcL79aK+M2V5V0RxNx6EdJXj41jvKcUVlI1k8I1iLfADpXsZ90TY/VPo5qm
	41qhLrRE5yTuho5Hq56gR66EB1xs3DhFFiAZmnzb3FTsZkOA==
X-Received: by 2002:a05:6902:983:b0:e1d:1b8a:ac4 with SMTP id 3f1490d57ef6-e1d348663c3mr13379277276.11.1726001753955;
        Tue, 10 Sep 2024 13:55:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbDk7k7N1gOLLhkOR987e9ETl1mx2sGMWF7VlPgYdOJ+kJnE7m7WvEEqfFsCW+O8EueUP3wg/sM/n6XRO+5nw=
X-Received: by 2002:a05:6902:983:b0:e1d:1b8a:ac4 with SMTP id
 3f1490d57ef6-e1d348663c3mr13379266276.11.1726001753670; Tue, 10 Sep 2024
 13:55:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <MW4PR84MB1660E875ADC85F675B7DE5BA889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <MW4PR84MB1660429406E16C5B4CE9711B889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <CAFMei7N0zgsxLnOcgvQ96d7Z1r=eWrtDtEuRuwQ_RmwbVk0p7w@mail.gmail.com> <MW4PR84MB1660E4CBA90C778F55E4DDF8889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <MW4PR84MB1660E4CBA90C778F55E4DDF8889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
Reply-To: nathans@redhat.com
From: Nathan Scott <nathans@redhat.com>
Date: Wed, 11 Sep 2024 06:55:42 +1000
Message-ID: <CAFMei7MFFjHL7-RdWje4Z+41Z=AV_pU852LqnVERecOhNYKC2w@mail.gmail.com>
Subject: Re: XFS Performance Metrics
To: "P M, Priya" <pm.priya@hpe.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Priya,

On Tue, Sep 10, 2024 at 7:02=E2=80=AFPM P M, Priya <pm.priya@hpe.com> wrote=
:
>
> Thanks Nathans. But I don=E2=80=99t find this package for my configuratio=
n
>
> apt-get install pcp-zeroconf
> Reading package lists... Done
> Building dependency tree... Done
> Reading state information... Done
> E: Unable to locate package pcp-zeroconf
> root@CZ241009TJ-1 Tue Sep 10 14:28:18:~#
>
> could  you suggest any other way.
>

You may have an older Debian system?  You could either upgrade to get
this zeroconf package, e.g. in bookworm
https://packages.debian.org/bookworm/pcp-zeroconf

Or you can install the base pcp package instead and configure it manually.
Feel free to move this discussion over to a PCP mailing list though or
slack channel, probably not of interest to many folk here I guess.

cheers.

--
Nathan

> -----Original Message-----
> From: Nathan Scott <nathans@redhat.com>
> Sent: Tuesday, September 10, 2024 1:34 PM
> To: P M, Priya <pm.priya@hpe.com>
> Cc: linux-xfs@vger.kernel.org
> Subject: Re: XFS Performance Metrics
>
> Hi Priya,
>
> On Tue, Sep 10, 2024 at 4:01=E2=80=AFPM P M, Priya <pm.priya@hpe.com> wro=
te:
> >
> > Hi,
> >
> > I am looking for performance metrics such as throughput, latency, and I=
OPS on an XFS filesystem. Do we have any built-in tools that can provide th=
ese details, or are there any syscalls that the application can use to obta=
in these performance metrics?
> >
>
> I recommend you start with Performance Co-Pilot (pcp.io) which makes the =
XFS kernel metrics available in an easily consumable form.  The simplest wa=
y is via:
>
> > [dnf or apt-get] install pcp-zeroconf
> > pminfo xfs vfs mem disk
>
> This makes available some 350+ XFS metrics which can be recorded, reporte=
d, visualised with grafana-pcp, and so on.
>
> cheers.
>
> --
> Nathan
>

