Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3023457333;
	Thu, 17 Oct 2024 02:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729131506; cv=none; b=SzM8Gd28hDqaTMojLnsJd5Vq8YR7WEcLIGC8HJ9i7DajFTDc6jdtuTyP7yiNLc8rNgLF1TCcHWNKyq7OeSCNCoLtH+O6RZ1cQ/1GQa9pVrlVu+ITzjEOcdRXSCyBuTRv6Bq53OvUpqHcgbodVTn/ei/PGjCwQdMcErWsnyscl+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729131506; c=relaxed/simple;
	bh=/5sg5vucji/rkByxjQpJHVoRYiCdCgoRUS24G3Eys2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PoqE3n/tt03jwJGvNbqIr2MaFzKAvostcXU5YpeGbKmS0x4At3WyNc3g38EimAL+yX+dTwEiE4J+ERD+O3rtrUcWZtxJZJ/RJNQvJ8zP73Ciq+TczP9zsbjbS6UV2pSR3ciE7kSqBS54Jk4FlOWqY5EstlPjI5qnDdkuxAvKTso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e3a+b3mf; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3a+b3mf"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539e4b7409fso466707e87.0;
        Wed, 16 Oct 2024 19:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729131501; x=1729736301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KH9rJWQgPZ7rdx5HRfQh9P8MfA44P4DgqHmGgy1QEeM=;
        b=e3a+b3mfeCY/7hoiVSCZ5bTY4VsjLusIWihFYopMkIcM9vpIRrrYLPsFsIcE/D9qTV
         MtgifUwYd26m6kvgdHXCZz5jZA9g+5yoXcI5BVKMQGNcppb8gBlpVhOR7vx4V7d41YgC
         7Qny1O9k2yswNWVhrPyAF0Hm0zXjymChSSF2MARJuJlwFo5nMWFHosrmcoNdGmeSpAXU
         QEtcuHcohTc7dPC372/4mKB+wmSg5BcTVXNGjOAl1qoVRKhvlvczJtzBeRgifYQJf1ue
         trCw4zpGnqWDR+tQfzIAGzK3Jl9YOKb4An1sr+BJ2/FkY/n1TwxiBNcX63ysCP2+hDBI
         +OTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729131501; x=1729736301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KH9rJWQgPZ7rdx5HRfQh9P8MfA44P4DgqHmGgy1QEeM=;
        b=OEqrsqsLn5HKrjD5Wdlk5IHUuYq3/zhsVz0D6evtYMFJIFOsj2TmFkSnN9aCc5dTjg
         eSkgdmIWvqwGh3YI8U/hk5fKRV0G7i4rSkLftgolHc9bsFDKlgmWBT60ZUAfPnIpRBJ7
         BPfIQNLcXoqwd4Je5fb5Zb3pTwfQRCkQ/xI110j0vE9QbkZ8hDRPMbkavGwsUF2s4/Rr
         XycrICyXf3gAXqA1sNBBg7PXaeJhlMI2t3ozb5IKcQRa+OfuN0m1qTiEkFvKLHNUhSiG
         Ll8n1yYPQYkrdc8nL6JgO46bHvIcx5V+MajzIKjJf0dzRBaolwnHN/bR8/gWA6pMSF8P
         o5bg==
X-Forwarded-Encrypted: i=1; AJvYcCUY7XsAMQCNl4bXnruXPQcZhGEgyk1HsmY6MhFcc+S1r/XQemzYRJXG3pRlxKoBGjJhKIbiXp1/KHgZeqQ=@vger.kernel.org, AJvYcCVlp9HJhIBtvM5KECAKOMG0mGHH/N4FNdB/MQy2zwbqdUOE+2l/6WD5FcFPgtcUsIT4XBNuChZ8FdC0@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8QmCsS2SNpQBsAmXSKsozeWbZq8vssvqRe8Zc2Xl5j9wEGqPQ
	apfw863rOJOTKTpT9fEKRaAnaqvpqTgpN/4c+K+pKFCNp6DUWQ9StS4bq994HvRpg5dmLSt/udL
	Hu84ze9ZkP2+qSXCf7d9o8DdolpHXS0fJ7Zft
X-Google-Smtp-Source: AGHT+IF2ZPwuxxOR0vVJPQ3cxf5tMQ8nCEvK26fjQsJdaNVdj7ni1S9dQiLuNXaE1QiHM1sb+kv7E9wzMwwzbX5Pxgg=
X-Received: by 2002:a05:6512:b8f:b0:539:fd75:2b6c with SMTP id
 2adb3069b0e04-53a0c732bbcmr436680e87.21.1729131500913; Wed, 16 Oct 2024
 19:18:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALy5rjUMnocsh80gPB+4UgaFS-Gsz5KAFnAN8Nj7m_oyohFfvg@mail.gmail.com>
 <ZxBafdsU6ioeTBmQ@dread.disaster.area>
In-Reply-To: <ZxBafdsU6ioeTBmQ@dread.disaster.area>
From: Xiongwei Song <sxwbruce@gmail.com>
Date: Thu, 17 Oct 2024 10:18:10 +0800
Message-ID: <CALy5rjX4xU0UtuQUZxD56LMpX=pseWwE0OSR4J2JH_Ce3bqAVg@mail.gmail.com>
Subject: Re: XFS performance degradation during running cp command with big
 test file
To: Dave Chinner <david@fromorbit.com>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Thank you so much for the response.

On Thu, Oct 17, 2024 at 8:29=E2=80=AFAM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Wed, Oct 16, 2024 at 07:09:29PM +0800, Xiongwei Song wrote:
> > Dear Experts,
> >
> > We are facing a performance degradation on the XFS partition. We
> > was trying to copy a big file(200GB ~ 250GB) from a path to /dev/null,
> > when performing cp command to 60s ~ 90s, the reading speed was
> > suddenly down. At the beginning, the reading speed was around
> > 1080MB/s, 60s later the speed was down to around 350MB/s. This
> > problem  is only found with XFS + Thick LUN.
>
> There are so many potential things that this could be caused by.
>
> > The test environment:
> > Storage Model: Dell unity XT 380 Think/Thin LUN
>
> How many CPUS, RAM, etc does this have?  What disks and what is the
> configuration of the fully provisioned LUN you are testing on?
>
> > Linux Version: 4.12.14
>
> You're running an ancient kernel, so the first thing to do is move
> to a much more recent kernel (e.g. 6.11) and see if the same
> behaviour occurs. If it does, then please answer all the other
> questions I've asked and provide the information from running the
> tests on the 6.11 kernel...
Ok, sure. I will try to upgrade the kernel version and run the test again.
But I don't own the test hardware. This issue can't be reproduced on any
machines, so I might not reply to you very quickly.  The worst situation is
I can't use the hardware any more. But once I get the test result I will ge=
t
back to you and answer all your questions as soon as possible.

Thank you again.

Regards,
Bruce

>
> > The steps to run test:
> > 1) Create a xfs partition with following commands
> >    parted -a opt /dev/sdb mklabel gpt mkpart sdb xfs 0% 100%
> >    mkfs.xfs /dev/sdbx
> >    mount /dev/sdbx /xfs
>
> What is the output of mkfs.xfs?
>
> Did you drop the page cache between the initial file create and
> the measured copy?
>
> what is the layout of the file you are copying from (ie. xfs_bmap
> -vvp <file> output)?
>
> > It seems the issue only can be triggered with XFS + Thick LUN,
> > no matter dd or cp to read the test file. We would like to learn
> > if there is something special with XFS in this test situation?
> > Is it known?
>
> It smells like the difference in bandwidth between the outside edge
> and the inside edge of a spinning disk, and XFS is switching
> allocation location of the very big file from the outside to the
> inside part way through the file (e.g. because the initial AG the
> file is located in is full)...
>
> > Do you have any thoughts or suggestions? Also, do you need vmstat
> > or iostat logs or blktrace or any other logs to address this issue?
>
> iostat and vmstat output in 1s increments would be useful.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
