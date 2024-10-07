Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D041DE3C8
	for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2024 19:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728330496; cv=none; b=LeJZqZKc1WGcB3g6xc+jTWQ0sTo3YfMK61n363HAlVgRr1yhw6+wNCbo4Oh5Xk1/g1sRTa+LJHDDl05XU1LsBj1rvdXj03fgTNAafusca6lgIvqUrKQjIp1FQ/EAhRAnh9CE8JUX4qQnmJWIlQgRX4XeVet90jdKMWcRlrGlc5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728330496; c=relaxed/simple;
	bh=2fDn/DwBhmvqarlEozdLa6LZbIY19Qzd4lOZBzgUwp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ya55wgp0du13I0i36yIBpIkZeUNUq9dZQMrHjhoNJh4tqCW7sGLPvpB8qJOaxEpSlTIUNb31qRGak2OLk4yHElhcWu/UPWrGZKDQmLKfjvKFG21HKJQBOQ9Pww3fe+M6gq8Jna3c8gS3n+rydmPRMoxQBBI1DWlxZdzy618hlHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=J3GtZFM5; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="J3GtZFM5"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fac3f1287bso52523381fa.1
        for <linux-xfs@vger.kernel.org>; Mon, 07 Oct 2024 12:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1728330491; x=1728935291; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8QHmh/5FLUBESM9GMETa6TLs+FmADwgJEmesHbkEPg=;
        b=J3GtZFM5OAczTWgGqEE5tfTw9m0wpJBiob3YyZOu/uEPZisVXnj+aI2votmA4+ROBo
         cv9g1jL/86rjnLrheTKLv/U/O1wvIn34gyhZOVAm8Pf/fUfHtFcDEEIRswVZJMA+hf4E
         F/80F3qCt/40K73OPAds4WdCCXMNDUeAxdz1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728330491; x=1728935291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8QHmh/5FLUBESM9GMETa6TLs+FmADwgJEmesHbkEPg=;
        b=tLlUoJ09J3kziNE7aBdcRTDMfXGDXplRxPsj0TvgbBeClyNjjhJiJDnPM0gNNT4NtB
         27nv7uLEgA7draFDMlR0RsX3td2T+1korKGIouZtbrTK4EKxMZJLthGoDg09Nn6dAyjS
         9eDie2U1+u061LLUuBp9ZDgdIQ/F/SgZd3YNT3HjL4x/1tGY4rRtLS5IyzVKW7QDsr3a
         lrLmJ6UYSnA39xuXFJE4L2WBORl3HvQfuT8I5Imolq69kSqUjmobGLa6d7Y73+Nxoa3D
         5ZIdJRxlMvHT1xQ7f2YyJfXcnjeZU+GrADZRV9R9YLzlrAcCsCRik7HIG/f5KQhBgUbo
         gREA==
X-Forwarded-Encrypted: i=1; AJvYcCWB0gtg/Tr0tlaOiVHSCYSWqXsQC0gIO1k+mOkSKB7K76JsAdg2VKmqoWneQr1OBoc5FTc4pcohOJY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybf6Wm07ES0VNI2doqd2QBVC6O6Ub0SY+RCBfqW4/DLu6f2CR4
	3RRL9RB87XyS61CRA5GyuPqffGokcZ43sq1759nqTh7IqnT7+V+GQjv54pBtcdtlT/xj7aStc/p
	AIenO4yChSNrrFQt/ItGqPiScn0RdhcxeaESN
X-Google-Smtp-Source: AGHT+IEDz9zMttsdJnvkPWpg6d68B0QiP9CLaYwmyVb9rOs3UfnSRT9DS70q5EMQiLLqRfrXwg9pwa7H0LfmgBwf9vU=
X-Received: by 2002:a2e:4e19:0:b0:2f1:5561:4b66 with SMTP id
 38308e7fff4ca-2faf3d7a84fmr54666581fa.44.1728330486720; Mon, 07 Oct 2024
 12:48:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240924223958.347475-1-kuntal.nayak@broadcom.com> <2024092725-chamber-compel-10b5@gregkh>
In-Reply-To: <2024092725-chamber-compel-10b5@gregkh>
From: Kuntal Nayak <kuntal.nayak@broadcom.com>
Date: Mon, 7 Oct 2024 12:47:54 -0700
Message-ID: <CAA4K+2aGYuRZW6prUi53vcEYhuCf4WvGEj384E-Ut-OJEm6wkA@mail.gmail.com>
Subject: Re: [PATCH v5.10] xfs: add bounds checking to xlog_recover_process_data
To: Greg KH <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org
Cc: leah.rumancik@gmail.com, linux-kernel@vger.kernel.org, 
	ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, 
	vasavi.sirnapalli@broadcom.com, lei lu <llfamsec@gmail.com>, 
	Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Chandan Babu R <chandanbabu@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you, Greg, for getting back to me. Following is the order for patches=
,

1. xfs: No need for inode number error injection in __xfs_dir3_data_check
2. xfs: don't walk off the end of a directory data block
3. xfs: add bounds checking to xlog_recover_process_data


Hello xfs-team, could you kindly assist me in reviewing the 3 patches
listed above for LTS v5.10?

------
Sincerely,
Kuntal

On Fri, Sep 27, 2024 at 1:00=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Tue, Sep 24, 2024 at 03:39:56PM -0700, Kuntal Nayak wrote:
> > From: lei lu <llfamsec@gmail.com>
> >
> > [ Upstream commit fb63435b7c7dc112b1ae1baea5486e0a6e27b196 ]
>
> Also, what is the ordering here?  Should I just guess?
