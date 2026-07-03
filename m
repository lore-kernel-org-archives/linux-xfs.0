Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9073D9520
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 13:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783086425; cv=pass; b=hizk6V07Us1dU4su2WmOVr6TVaOpq0tHth16cU7mRdxOEbkkGjd9/+jGC3kfuS26jntalV3zOmqI0jhQXOx0v8ix1efA6XWLoszpe2NpM1/mKy71DTK1F2WhjhbSqIge+L6ecS0OQluujyRKZuTCX7QkQY9UKhd7m6gK/HO+D3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783086425; c=relaxed/simple;
	bh=G0Cun/sv5TG4it8HOQFdrnlDKaUupn6OAuYwGu89JEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tGFbvw6W49QzHxj8n31bIYF89IcsPUR4IM+trEEfgOrEIMXAkGVhHFcuuGTvGSclY2WXjDF06x33LFBYYu8zLOZbh/l8xVUW+2TwXfJf/xNxDC9wsMCjPOIz3zQWNPA5L0oE2wahEBh/udkVVROcUS8fsVYn1JNIQ+RZ2KTyVZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BsHuSI9Z; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BsHuSI9Z"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c12a430d71dso55300366b.3
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jul 2026 06:47:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783086422; cv=none;
        d=google.com; s=arc-20260327;
        b=iosKMbcafnMeSgkF4Ncyv4DYJBH9VpWFp3EujNbUi89nKW0Y4wr5KjgyV0vI5mYoZl
         8aRikqlRtA2fiqKzRro28NJef6qNtiholmqL1SOEBRmg/5nWC9Byzd7hHaoVB60ypvsf
         Rhr8EfQQrOCOisDE/mLn+VMyEhlFSosnXeF9r1wjOA+/Khkbx8ej2lCSk5JnUP/E2E56
         tWayZEpND+ejY6jdZuI0NCDdlygvtZ5Uko0D9bV8agKPUaFWAsHUJy0M15HFk02YCWv2
         NpVovdwpnhk+EXX5PpXeQEkDVxO5TLSXDZfCyMif2Mzdl0EzsAII9qTH93d+exsGKDKC
         L0zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G0Cun/sv5TG4it8HOQFdrnlDKaUupn6OAuYwGu89JEQ=;
        fh=SfZDTf7rKSybVYl9uMHnzRWFvK/MRQAjFYHujxRjJPg=;
        b=GfNVsPxs6Q3jQbcVG3x/furomEJ8Tk/J4GH23faiY9zBZaqSUOM/IS2xm9JEFOLkd9
         4VWRT2zFkHOTsUva5b2bCmcaZg7NzXKgtgQZCT9DSop7Cvr9BwAH9kqtP8UlPZFl3vIt
         8JyKoVGlM8n3/to4AxPfVUKBFF8pFUaICErHePcrx75foMCNec0NllDYQ9aYQA/n/dn9
         qhLjviuxsrAsYQa2DBaY1tuDUJC4Y+Dr3nFhHeSMD8l6+X/TDi0k6ktlmuOlaUqW0eGr
         WmtHkTZ485PKXEqMnAnTKc2N/iMI6lSet/ZEVzOvIJ8cly0qeJ2IxPY9EggJd9iSh5Sc
         GajQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783086422; x=1783691222; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0Cun/sv5TG4it8HOQFdrnlDKaUupn6OAuYwGu89JEQ=;
        b=BsHuSI9Z2atWPA1RAOvtGdfEu3m8HCv6u7nm6v1YFkJD6ca1qI52bFcvERVTkU5oVx
         gDejIKa4FRNs1w8xlep+JepXVwhYSSHpoZyJJSc7gh9Ftbd7GJTNUDzTgsjpGWGIG7Gh
         vkIqQSXRGwXnvyZ2W1pSQ2qbW/MLf3QySAt9CECPwfJOQ/qWsp1Q3zXS8mkn8oXIzlcV
         wEWemWHFsied28qjfwQC+KLLAEk3uOyY29m3b3Ae7MHeTWTuzc1H6L+NVC6Cvldh5hzI
         MRBx4zkeIla3IWCpu+3UlxdtQjwGkAbjUjJgtJvAqwakSN1xfUrROcDhmnqRF1pdzNo7
         R3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783086422; x=1783691222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G0Cun/sv5TG4it8HOQFdrnlDKaUupn6OAuYwGu89JEQ=;
        b=CrkBjIMk8NkBMwt8tTIlTcGqIpGWfH/TrmYCbUVKJedqSlHgGsBWsf/x4l894l61ZR
         NpN+ikVwgQ8tpqM1yGwv4TDOtbJ1Jcxvil1H7mz08+/mBJx+2G14VR9vwPECQg2CkYwc
         PDaGI1ABTgPWX7kivaHxHX/opREsM7kh2HTGbmpnNYKxTqUGyXFI8IuRXbxV6XLQZvmm
         S1HJeYAKpOKqSn7G3ycTTIc98HYpmSt4mQBAYvm88NM8BF4NwMFmFRiR8Rxq+VFs82Bn
         VMW5d2oDinKM6ToI93/gy+p5pWU2LYgagQTP3PVLHVquxKjk+hLP0LWhV4b9zJNKVrio
         FoUw==
X-Forwarded-Encrypted: i=1; AHgh+Rq7+pkTLnGztUvjhdGHfWT0pYMy7BlLNwZ5m7lwbYAJjPS5G2BarJhMWo8O7QkwaStgPAzELFKBfAg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYLKTm6PJoTSbjC854OArnxfNT/4Uyo+VQQxwtcQsy1+PqI+2m
	Nn/kgT+XEpROcEulZbPpJ3H11EofIguFxvcUJ6aj8jWg/NviS4iKwsdrR89zMr8nxGWFhyVXEQQ
	aUqL+NNMDQFNZPS3lKAqaVrxNiTIujR4=
X-Gm-Gg: AfdE7cm9NbyldPyXgUbLmk1qefl6W50m+4TZSiR97bMuMIP0tIQJRX67DbXdum8cr06
	M255HRPsDQegefWMEi/qqTtQBEWGvFlbxN3bQdjtT/pBcGezd/um49gXUoNw3Lsx5j5sLtVQXsr
	LSMyG+PGiyaElAKQR6T1HAxyJn4LUZMHqmMJC7cC51cuYx4gBx92IT4xIf/6Iz5t3Gt5k0DOOoa
	5dGr8R3gAbSuNkEaopAS8P+O0Fnc6W8khJebxNAgTlESflmMxQIU0BVghbBKJuZQkSQH+5qEQ==
X-Received: by 2002:a05:6938:a08e:20b0:c0f:de3c:dce with SMTP id
 a640c23a62f3a-c12aa136d83mr322721266b.41.1783086422164; Fri, 03 Jul 2026
 06:47:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701163310.GB6517@frogsfrogsfrogs> <stable-reply-xfs-235-fstests-66y-20260702213502@kernel.org>
In-Reply-To: <stable-reply-xfs-235-fstests-66y-20260702213502@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 3 Jul 2026 15:46:50 +0200
X-Gm-Features: AVVi8Ce43HwF7-ts3rhOcPkeuNZOA4woXfj768vFVH3SS2Roxor3ADq11c4OZCc
Message-ID: <CAOQ4uxg8AsBL=hrHY8H+U3gPM8aHg1C2-WDXnCAe3CFCOsBQ9g@mail.gmail.com>
Subject: Re: [PATCH 6.6 0/4] fix kernel crash for xfs/235 test
To: Sasha Levin <sashal@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, Carlos Maiolino <cem@kernel.org>, 
	Fedor Pchelkin <pchelkin@ispras.ru>, stable@vger.kernel.org, xfs-stable@lists.linux.dev, 
	Christoph Hellwig <hch@lst.de>, Catherine Hoang <catherine.hoang@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lvc-project@linuxtesting.org, 
	linux-xfs@vger.kernel.org, Leah Rumancik <leah.rumancik@gmail.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 3, 2026 at 6:07=E2=80=AFAM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> On Wed, Jul 01, 2026 at 09:33:10AM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 30, 2026 at 07:39:32PM -0400, Hamza Mahfooz wrote:
> > > Any idea on potential paths forward for getting this series in
> > > particular into 6.6.y?
> >
> > Run fstests, and if there are no new regressions, ask sasha/greg to
> > queue it.
>
> Thanks Darrick.
>
> Hamza, could you apply the four patches on top of the current 6.6.y
> tree, run fstests, and report the results here? The series was written
> against 6.6.84-rc2 about 15 months ago, so a fresh run against today's
> 6.6.y would both satisfy Darrick's condition and confirm the series
> still behaves on the current tree.
>
> Once a clean fstests run is reported I'll queue the series up for 6.6.

To be clear, it is not likely to expect a clean run.
What we want to expect is no regression from 6.6.y to patches 6.6.y.
A run of test group auto (-g auto) is the minimal sanity requirement.

TBH, this series is quite subtle, so this bare minimum sanity is not much,
but it's enough to make sure no silly backports mistakes were made and
it's probably better off than leaving the known bug in LTS.

Thanks,
Amir.
