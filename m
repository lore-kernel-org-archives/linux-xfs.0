Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B850CA5E
	for <linux-xfs@vger.kernel.org>; Sat,  4 Oct 2025 16:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759594100; cv=none; b=d/gah2w7uKdXKNeHZTMfb+SUTBzyQaCoO+/vXvDdU+V/U3HMfyyS8QyHXCe6LwdY86juhmIjedWuEJ2MCOXONx8oP61/TYAwdxBIp54e/pkOI/RsspqtPiR8akYjntjX6lYomNhpDRSESYjQD5JBKOkXMhM19jkfz9vvzK2EwEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759594100; c=relaxed/simple;
	bh=aDCrityIRTDTsNoHl3WYViJal3NAWy31CHFcAH4dMjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k7H4w1Vrdm5uJEQFbUwzm0/edhWOIa8rX4hq9HopIgfv3PehKytXr3Yh+DRF27ZC4d1v5Obj55MteCeSfVRxvkdEIqCL8qBeSGboyD/aEAleegMxCqI3O1LeP0ZBXbhvEMs822bOO0kkgDWhov07823hZSp/Ody9+PWAHSpLdfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=BxG6Pd3Y; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="BxG6Pd3Y"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-57b8fc6097fso4617531e87.1
        for <linux-xfs@vger.kernel.org>; Sat, 04 Oct 2025 09:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1759594097; x=1760198897; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NPv5+yIlETZdIyZrh1UyMYBPpswTX6QZU3krtJBLrPM=;
        b=BxG6Pd3Yj+KYxtOOfHjmqz5hyBn/IgShyvItnps7hZIKJYNrTvFuttKi8cmBN9tww6
         4wqIYCf6bk+xDtCxv/QfYelqcD7NPYexzH1upGwVvnBDFynJPvZu0RyDzxAUx56F+659
         WB8yyE4ogWi1Piz86n/lUU9NcxDsoRIe/DKYIxKQq9M4t265sGKq8vuWXmbPHtaX9kMQ
         TdjXQFjoKNDQ4BxPZ0GvVelCRdWSnvug77ti7UqsABiv7MJnr2ZIAgfpbVZ0b78o4LAJ
         GU4N5EazvijT02f/Qm1ZB/PLwdS0obbdrrktz4s4THPTkkIFETPG4zQuwMUWW7x2LZXt
         McXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759594097; x=1760198897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NPv5+yIlETZdIyZrh1UyMYBPpswTX6QZU3krtJBLrPM=;
        b=iOQnAReFBJIV/En6W4Lsu2KBTmVIo1ViSP9ufY/3CjvOy7WQbR6STJi2LuMT3c78Mu
         dtAqYKFa6MK7rwaP999Oi3NdK0i9RPdXk6OBzHGk3zETNV0EC2SaqJuWnHIb355dBeUu
         47t9pgQiTDSJPURBFHSjTQcgsk7+JA5rFirJhpbrvzd2Udw5rpJY4BysOcbL41VmpGdi
         AjYXa8wzBdCHUM2GyPhnjA04KHv0E+dTD7UVfSRy4EkXuANO+GpcDVXIsBKQWkQBHTNc
         EtsmxzogWOukjG1snKXFRDFAaEW9HEe9PePH8IQIKo3wM7UvDv7dnuSa5im8tNWkwDQ1
         2DyA==
X-Forwarded-Encrypted: i=1; AJvYcCUBdN4uYplGA7EC2VHlbMSt+rLkB0IjnEU/P5Dzyf+iDP9zqr8CCanWg+xyK3atzTeUiSZyhfA7L2I=@vger.kernel.org
X-Gm-Message-State: AOJu0YySNRj+7uklgmympNhm5SccoLVpPOafSDFVJsiNkY7s5Z8UsjqK
	QHlVOIrQ1SGu/7IlJ7iphiD7gUf6xwijTsCtTCdXGtvI7AAqUq99xN4NALoBH/DCPO6vTd79Ail
	9q5biSEUlGXnaEQflfNs8+MQ3PL+eP13XjDR+3snn
X-Gm-Gg: ASbGncvhWQ7acfYWEU+KkwsE1+VSpW04TwPU1JqyAvEKE/1FzIkisdJ69jDaVXSV+Yc
	DhCju9ZtuBeEe4lAMSzkKKydjcpzvwStthowcLCkZfmtnTf2skVKxqz9HNNfH5nkV9umaCfmj07
	79+9judfQtsDG5lqAm7lmifGiNUgQCpX1h5md69mn0qlkwwTK78WSpvTDxMB/Nbo59EYTEJ5zve
	JslIZSIdg6p0pPAj3kBWdcQvw1/uw==
X-Google-Smtp-Source: AGHT+IGywq3KGIlNKacCQ8JbyizpfyQvK1emwelk/96UFTAVvMbGyC8JTad2QnZqrGZIDwMlhQvVIiYjX9pd5ox8iFE=
X-Received: by 2002:a05:6512:3e1b:b0:55f:44b8:1ecf with SMTP id
 2adb3069b0e04-58cb96629bdmr2016577e87.9.1759594096459; Sat, 04 Oct 2025
 09:08:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251003093213.52624-1-xemul@scylladb.com> <aOCiCkFUOBWV_1yY@infradead.org>
In-Reply-To: <aOCiCkFUOBWV_1yY@infradead.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 4 Oct 2025 09:08:05 -0700
X-Gm-Features: AS18NWDrqxLuc9P3rGhxlQcFOsj5EYH3mdmKe5a0v88_ynW-8nVGsUXgkNOcJfc
Message-ID: <CALCETrVsD6Z42gO7S-oAbweN5OwV1OLqxztBkB58goSzccSZKw@mail.gmail.com>
Subject: Re: [PATCH] fs: Propagate FMODE_NOCMTIME flag to user-facing O_NOCMTIME
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Emelyanov <xemul@scylladb.com>, linux-fsdevel@vger.kernel.org, 
	"Raphael S . Carvalho" <raphaelsc@scylladb.com>, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 3, 2025 at 9:26=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> On Fri, Oct 03, 2025 at 12:32:13PM +0300, Pavel Emelyanov wrote:
> > The FMODE_NOCMTIME flag tells that ctime and mtime stamps are not
> > updated on IO. The flag was introduced long ago by 4d4be482a4 ([XFS]
> > add a FMODE flag to make XFS invisible I/O less hacky. Back then it
> > was suggested that this flag is propagated to a O_NOCMTIME one.
>
> skipping c/mtime is dangerous.  The XFS handle code allows it to
> support HSM where data is migrated out to tape, and requires
> CAP_SYS_ADMIN.  Allowing it for any file owner would expand the scope
> for too much as now everyone could skip timestamp updates.
>
> > It can be used by workloads that want to write a file but don't care
> > much about the preciese timestamp on it and can update it later with
> > utimens() call.
>
> The workload might not care, the rest of the system does.  ctime can't
> bet set to arbitrary values, so it is important for backups and as
> an audit trail.
>
> > There's another reason for having this patch. When performing AIO write=
,
> > the file_modified_flags() function checks whether or not to update inod=
e
> > times. In case update is needed and iocb carries the RWF_NOWAIT flag,
> > the check return EINTR error that quickly propagates into cb completion
> > without doing any IO. This restriction effectively prevents doing AIO
> > writes with nowait flag, as file modifications really imply time update=
.
>
> Well, we'll need to look into that, including maybe non-blockin
> timestamp updates.
>

It's been 12 years (!), but maybe it's time to reconsider this:

https://lore.kernel.org/all/cover.1377193658.git.luto@amacapital.net/

Nothing has fundamentally changed since then, but I bet enough little
things (folios!) have changed around this series that it won't apply
without considerably massaging.  I stopped working on it personally
because I moved the workload in question onto fast, fancy SSDs
resulting in my having bigger fish to fry.  I don't think I'll have
the bandwidth to pick it up any time soon, but maybe one of you folks
is interested :)  I never looked into the AIO path (I was interested
in the page_mkwrite path), but my series made it at least conceptually
possible to unconditionally mark the file as needing a cmtime update
when presently dirty data is written back, and I imagine that AIO
could use that too to avoid ever needing to bail out because an mtime
update would block.

To the extent that ctime is "important for backups", it's been *wrong*
for backups approximately forever -- one can read ctime, then read the
contents of a file, and get a new ctime and an old copy of the data
that preceeds the modification that logically triggered the ctime
value that was read.

--Andy
Andy Lutomirski
AMA Capital Management, LLC
