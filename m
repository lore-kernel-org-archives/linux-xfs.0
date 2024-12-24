Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E27538DC0
	for <linux-xfs@vger.kernel.org>; Tue, 24 Dec 2024 05:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735019244; cv=none; b=X8ftRkg14Auj3ei7Q7chJObWPyvFi2o9D/rqUWJQz00F2wsMN0xXehCzLgpGDCp5STmDSUc/4gX8AYSyGoy5gNznXPdlTCbK8jtjQG5X1HP8qFV1ZRWNNiXplcJ9fJ+Iy7QLfyIsRnbtTKSM/H7aeYj7dgvnjWhqubIMHfPSEa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735019244; c=relaxed/simple;
	bh=9CBKXqDJ3ENZZ1N0DRIxlhlNi1Yi7g4WvJjGusN4eyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mcgsm0bEXD6jj5UWfPeLWyLMVHo1cqoiqKWgoxC3v+FRUErAN61ceEv9xgjp6koCY1K8/YbbkeftBSzYSQQeXY2RrEDXxSHTgDRovVPqGJORlKGyMoHoEFN11ZssLiNckECbkjfscAOgGr77aDhIgtoJwV8V9VfuQZVF1Uoo8fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cg7PV/Iu; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cg7PV/Iu"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5401fb9fa03so4794068e87.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735019240; x=1735624040; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCmHS9DX6GC9rUsyCvSxvjnNqLlLFdPfsjohs9jUaQk=;
        b=cg7PV/Iui2vqkmQRq7SvLIj6vbxQk3Bc+CAtBRbxGLKIz/lEDemkv8U3ZE8KpGWrN+
         HD1LdYSAC52JqWgIKryg77Nztuk2+g50lkUJlAsX0J6uEZxxuxq9ezUcN4UsJmyIeqEr
         7cOPLaRKVdoMVVKglS7JdxoNPNVujnnQgDxa7mXEgs20T1vH8YIPW5Wd9OtecAkjXvw7
         TfW0Y2knlal7xJB7C+wKSnn1qQLk2RyfloRkVUPkg9o8HhHR8t8vZEK12fOCzJBA/1if
         V9M/vIIB+kdJIixZTSnIPWrHtAznzKIEaKHczesysOYCAdWGJ3qIjSD+IW+6zDLTsY2h
         EQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735019240; x=1735624040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jCmHS9DX6GC9rUsyCvSxvjnNqLlLFdPfsjohs9jUaQk=;
        b=P1R7l1UMdDNZQ0r73x23ZGATLBWaRHwksSL3hQWM+jG/qHUWHgZCkvlvD/kGt/PdNt
         /ZHQdOiuhwokqpOnLNwZdssu3jXonf3oMFBaDi+hCa9q1ALNinblOBaukQu5v7uAtjgV
         HRjOB4wmnyHR5+wrYGlvMniq/XIQu5pfxbaEuDgaCJWpRaYZRJmOYiy3q83XgLAonhs7
         vx2bSQW3+43ItjvwevZxcKyEOpjGOwX3oP2xK2d6bzyXazAEB31+vY/rZrZnUiR5JXAN
         I3VI7xWGYOpj9V6fzAaP7A3Jcn0LMlT6n37981z75VLOAPigfedRQdhrp42gj5d4jETX
         wAOA==
X-Gm-Message-State: AOJu0YwrXA4EosxkGYIptaqcbH7eJENr3YNjRsxbsuO8h/RPq3Sr6thZ
	zoQ8TS85UblbHj2ODxG0gMjAkMM2mw12duLJk3rE6/6jhUK0WWUqp5555WtoauaUCEIbd5o4XHf
	df/iGpO8Dmzq/RsxEfOG0Gfa7+hF5xxmm
X-Gm-Gg: ASbGncvm/KZNyYDvpKON+LatNVXaDbj57ql64+TlbJDsneFP00QYOypQSaf1X3ThWom
	5SBWRKy8iHt/Z+ozfE5VOQKQvi3VwSsCE5yexAvw=
X-Google-Smtp-Source: AGHT+IF09C62/USPrMYI9pacZ7xQ6tPyg54gMG2w5R9E6RbwGbpvZKfuLcU9kbmtBs7lY6s+lqt5fbgd5ungO5RjTEs=
X-Received: by 2002:a05:6512:4005:b0:541:32e5:654c with SMTP id
 2adb3069b0e04-5422133b6d6mr6049030e87.17.1735019240202; Mon, 23 Dec 2024
 21:47:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>
 <20241223215317.GR6174@frogsfrogsfrogs>
In-Reply-To: <20241223215317.GR6174@frogsfrogsfrogs>
From: Sai Chaitanya Mitta <mittachaitu@gmail.com>
Date: Tue, 24 Dec 2024 11:17:08 +0530
Message-ID: <CAN=PFfKDd=Y=14re01hY970JJNG7QCKUb6NOiZisQ0WWNmhcsw@mail.gmail.com>
Subject: Re: Approach to quickly zeroing large XFS file (or) tool to mark XFS
 file extents as written
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Darrick,
            Thanks for the quick response, we are exposing XFS file (create=
d
through fallocate -l <size> <path>) as block device through
SPDK bdev (https://github.com/spdk/spdk) over NVMe-oF, Now initiator will
connect to the target and provide a block device to database applications.
What I have observed is databases' applications are issuing flush IO post
each/couple of writes, this flush at backend at backend translates to
fsync (through aio/io_uring) operation on FD (which is time taking process)=
,
if we are doing no-op for flush IO then performance is 5x better compared t=
o
serving flush operation. Doing no-op for flush and if system shutdown abrup=
tly
then we are observing data loss (since metadata for new extents are not yet
persistent) to overcome this data loss issue and having better performance
below are the steps used:
1. Created file through fallocate using FALLOC_FL_ZERO_RANGE option
2. Explicitly zeroed file as mentioned in code (this marks all extents as
   written and there are no metadata changes related to data [what I observ=
ed],
   but there are atime and mtime updates of file).
3. Expose zeroed file to user as block device (as mentioned above).

Using above approach if system shutdown abruptly then I am not able
to reproduce data loss issue. So, planning to use above method to ensure
both data integrity and better performance

On Tue, Dec 24, 2024 at 3:23=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Mon, Dec 23, 2024 at 10:12:32PM +0530, Sai Chaitanya Mitta wrote:
> > Hi Team,
> >            Is there any method/tool available to explicitly mark XFS
> > file extents as written? One approach I
> > am aware is explicitly zeroing the entire file (this file may be even
> > in hundreds of GB in size) through
> > synchronous/asynchronous(aio/io_uring) mechanism but it is time taking
> > process for large files,
> > is there any optimization/approach we can do to explicitly zeroing
> > file/mark extents as written?
>
> Why do you need to mark them written?
>
> --D
>
> >
> > Synchronous Approach:
> >                     while offset < size {
> >                         let bytes_written =3D img_file
> >                             .write_at(&buf, offset)
> >                             .map_err(|e| {
> >                                 error!("Failed to zero out file: {}
> > error: {:?}", vol_name, e);
> >                             })?;
> >                         if offset =3D=3D size {
> >                             break;
> >                         }
> >                         offset =3D offset + bytes_written as u64;
> >                     }
> >                     img_file.sync_all();
> >
> > Asynchronous approach:
> >                    Currently used fio with libaio as ioengine but
> > results are almost same.
> >
> > --
> > Thanks& Regards,
> > M.Sai Chaithanya.
> >



--=20
Thanks& Regards,
M.Sai Chaithanya.
