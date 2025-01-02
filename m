Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126AA4A00;
	Thu,  2 Jan 2025 01:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735781906; cv=none; b=BZ1ae3FipEnNrPFpibhu1qIRk4k3DXD8GR0i1lO+FUTPV3g56Sd8xzGoC9ii+DyFBjSRP6WZ9PY3kaYKfCH3ILpOviZ9428+dK99eKpuIdUOh4OS29+BIxetsYsqz6n6kE7e6eFwCtPMF3V7DAseF95r5zNXPCsFp5qeONi+r/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735781906; c=relaxed/simple;
	bh=3LcJE0rHh/n/Gl7uQ1VMXImFk0aSBDDZDCLgAAjOS34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MHwCiyZ6dvdNQghrMFTlsA3BBhwNwZn8RXg+dT2V1Ilcm8EHF88R9Xwy6tfJGl0AB8kjJ3rLeGbrI+5GS5ZXcFGJVa6iLFMUgL0es5BkT+MiHC7TPvt/APlnlVbW3isv2YpBmzVnIeyjnZkbMAx2gRlsCCXShGACpEXpcyNiIKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QcNS4Bex; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QcNS4Bex"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-467a17055e6so123592541cf.3;
        Wed, 01 Jan 2025 17:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735781904; x=1736386704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7uVXZGA4N7myt30g5K5hU8rvzE1rH6GD1ou+jGmGGeM=;
        b=QcNS4BexVX8Hc6vLSWfk2UqYSQ/MyK0mc+n6XLpHEcFHUeaZBNJ3mKmnk8VhK+KvKV
         dTuNzC1Tae4tfRGuC/ZPIcgnv2fFpz/eRrPXyBt7v9nWI8O4uzH1i8q3/+zOYQjYGHxB
         9xS50hEq4zLgpBFIBEeRmMNIC3Qa/aXUDJIdF8nE/nb2VEpeAizemxjI6B8OCZ2VseNe
         opNBOpS1vl918rj0UNdMd3msbRTnnhoBOxCyX4pPT6N3Nree1RGIg8yKbsv6TQA0W8bi
         lv/ZhQJtG60nJ1H5g4L/TSepQhB+yntpdbEeCzX6/DmU2bIH/Jo9UwspM/wTkfwHwnaq
         zo2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735781904; x=1736386704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7uVXZGA4N7myt30g5K5hU8rvzE1rH6GD1ou+jGmGGeM=;
        b=E4wRSEzlmCQnjg6bVhE+IKrtxcdgMMgFhRf57Fw8ibQ/7FAqQHuG+/P9H7CkfMrM3r
         79RURAY5+ALc5PfAuQ7x6ikpwZGMhQnrkEfld2cqrLMPgXve1iLmg4alf4nxFrjykNWS
         Xgq+91pZ+ygN6bJQulnOV+fXLFC02wafXdAkV6ohbWG0TOcIpD/Ji4zhZhU0MgxpXLHx
         vbQniotrDYFEkIfJWHsWDb+IdqHvHNitgKdckt1jiptYZSARno6KXLzpouiQHMyjZ9cT
         k/vYVqmrg9h0xJTizq8pDd3SGfEUBC1/CqwWfVDEjcZdD/XeX+ivLCtPak9XeixxbKHh
         zbjg==
X-Forwarded-Encrypted: i=1; AJvYcCUJtuCMA6qDHB/YZL/VvnXAoTd/GkyQcoB8URUp+RgOABIHJElGGjhkXTrXpHq2JQ9jqu3qfmeB@vger.kernel.org, AJvYcCUTZxPgDrESoPwyTnK0iATuZQ03HtHT+0TvDslzf4gSJgSrmLQ1xlnxrzMUc/q8vtfrNkU7ZrdOSgb1@vger.kernel.org
X-Gm-Message-State: AOJu0YxKwtBcI5GX1TM/+yyELhtxxaPvbNFiPdbFTV9ECzfXrEOyZMfJ
	khqkQ3qoZGdfqQc+u/jEEb6zv4NQ2NHmMY8uvFpYfUxYSEOu558KxwvAJjj+RtQDBZ9cgalO6pN
	rBLpD7vLz8UIV+CyW144bphQ6vWM=
X-Gm-Gg: ASbGncuxBeiys14PylYQfNC9AYcnyAPxj+QbmdH8KD9vFUz6cFG4udy8QeidKNZCp90
	yy38sxncBCdfkZl4VXBtkCEDa3w+K7SMZ/Z2SUiz/eJEzJpDWz3zrpIHupASDGi2xFw==
X-Google-Smtp-Source: AGHT+IESdMTKKwaxrbP//GlVIfjn6S6CHc/DsTA4u1MEhIgLfQZhWOL0cN8LbKnh2DYX1lSCFRhw6ac+dEgDLSqLjbk=
X-Received: by 2002:ac8:5a16:0:b0:466:ab8f:8972 with SMTP id
 d75a77b69052e-46a4a8b868cmr714354731cf.3.1735781903839; Wed, 01 Jan 2025
 17:38:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241231232503.GU6174@frogsfrogsfrogs>
In-Reply-To: <20241231232503.GU6174@frogsfrogsfrogs>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Thu, 2 Jan 2025 09:37:47 +0800
Message-ID: <CANubcdXWHOtTW4PjJE1qjAJHEg48LS7MFc065gcQwoH7s0Ybqw@mail.gmail.com>
Subject: Re: [NYE PATCHCYCLONE] xfs: free space defrag and autonomous self healing
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Zorro Lang <zlang@redhat.com>, 
	Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@infradead.org>, 
	Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>, greg.marsden@oracle.com, 
	shirley.ma@oracle.com, konrad.wilk@oracle.com, 
	fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2025=E5=B9=B41=E6=9C=881=E6=97=
=A5=E5=91=A8=E4=B8=89 07:25=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi everyone,
>
> Thank you all for helping get online repair, parent pointers, and
> metadata directory trees, and realtime allocation groups merged this
> year!  We got a lot done in 2024.
>
> Having sent pull requests to Carlos for the last pieces of the realtime
> modernization project, I have exactly two worthwhile projects left in my
> development trees!  The stuff here isn't necessarily in mergeable state
> yet, but I still believe everyone ought to know what I'm up to.
>
> The first project implements (somewhat buggily; I never quite got back
> to dealing with moving eof blocks) free space defragmentation so that we
> can meaningfully shrink filesystems; garbage collect regions of the
> filesystem; or prepare for large allocations.  There's not much new
> kernel code other than exporting refcounts and gaining the ability to
> map free space.
>
> The second project initiates filesystem self healing routines whenever
> problems start to crop up, which means that it can run fully
> autonomously in the background.  The monitoring system uses some
> pseudo-file and seqbuf tricks that I lifted from kmo last winter.
>
> Both of these projects are largely userspace code.
>
> Also I threw in some xfs_repair code to do dangerous fs upgrades.
> Nobody should use these, ever.
>
> Maintainers: please do not merge, this is a dog-and-pony show to attract
> developer attention.
>

[Add Dave to the list]

Hi, Darrick and all,

Recently, I have been considering implementing the XFS shrink feature based
on the AF concept, which was mentioned in this link:

https://lore.kernel.org/linux-xfs/20241104014439.3786609-1-zhangshida@kylin=
os.cn/

In the lore link, it stated:
The rules used by AG are more about extending outwards.
whilst
The rules used by AF are more about restricting inwards.

where the AF concept implicitly and naturally involves the semantics of
compressing/shrinking(restricting).

AG(for xfs extend) and AF(for xfs shrink) are constructed in a symmetrical =
way,
in which it is more elegant and easier to build more complex features on it=
.

To elaborate further, for example, AG should not be seen as
independent entities in
the shrink context. That means each AG requires separate
managements(flags or something to indicate the state of that
AG/region), which would increase the system complexity compared to the
idea behind AF. AF views several AGs as a whole.

And when it comes to growfs, things start to get a little more
complicated, and AF
can handle it easily and naturally.

However talk is too cheap, to validate our point, we truly hope to have the
opportunity to participate in developing these features by integrating
the existing
infrastructure you have already established with the AF concept.

Best regards,
Shida



> --D
>
> PS: I'll be back after the holidays to look at the zoned/atomic/fsverity
> patches.  And finally rebase fstests to 2024-12-08.
>
