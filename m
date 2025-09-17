Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F7A2F7AA8
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 17:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758129755; cv=none; b=IJMzYSMCQl9wHL3cRG0caPc8d47qR+S1RH+MPqN9UuPR7MFGN9B8NSu9QRdtgPbmls7cnNsbGhiQhQ3KX68D5GdixyR9YkZwSJHtkLHCj7tiqRrCjgi+gMtVaKdVqtSeM6PRyOLVlN+97EnSR4D0AdIZtGbBWkjyIVeSQnhXuBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758129755; c=relaxed/simple;
	bh=RSDxu9t+D5UuL/HojUmVJ3BjyA67oJoFD+owjBDORPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HRTcIlg32aqyIFkAsbQBLeNBFtnNmDKYUcNph4smlmMj/4dNpY0hPiqBmWN8/T89IqQBSdxxsqWHUWeWn8mz54kTaoWo9HqxMbgh8v8yqjSaw0uZAVxo7iCvoD8CxWHIRxllYo221AOJxmqA6Qo9SarR2SkzL5iI0etX9J06tHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AAfPS9Vm; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AAfPS9Vm"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b7ae45a91cso437621cf.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 10:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758129753; x=1758734553; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9gdUx6S6T0XeY4RpC698Oo7BCydPLt/+wzQmQWUkBN0=;
        b=AAfPS9VmpTuHwUhnVtagpZK8y6KCd+JaUtMpOQcJVcLoE3f3YKLPrfxUqmtGd9dhKM
         Qa65n2d+Y+arXSHgbDkYXwWLcRKvsa4AYzLDFZJI9jvMAeakLRnx0NXGaMd6lbqrNEf5
         NQy4TVQBTshfQrHhXAYet33hFLmIIQgNghY4m2QJ0JdRV1kXXA6OhD9vj7H0LPjPr62y
         GQREd2MdAdP9PVle0kcERZqlCu9VcJNuTCtoEVBsK0UiGcyF+FNq/u7XqnFJEs7S5Yjj
         LbsdK11dYB4Vzho6EHsqk3Dh/D6pnUzV7G1DgOx5dcQjYxoVjToDD5lCyDoU5qkemvpj
         m2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758129753; x=1758734553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9gdUx6S6T0XeY4RpC698Oo7BCydPLt/+wzQmQWUkBN0=;
        b=kTr9c89iDP+RlroG/IaKUcKwA8OwEOk854R9zynZAYDUPy4BcFjgJ+onLCCCCRFia3
         jmyd4hp+chMcMHAgqT/k0NEJNsf56+l+4SDWQd+64XkqHR2KFUnk7ukFV4MI7+rBC75D
         sJ4OsDFReYt9zvo8jJXFknT/hVkG7iiVTLtRqEm47/bgU4q0Y6aPV1THBV72WkIrmOtO
         vxOaraTzqinjcUJRf4enOsbzWMtbOgosEv9gGM4I2jWFgt+khGMZ1QqfNg6yKr9dHFUd
         iEnCt/47iQvbK9+RjbabAN07GyBfEpM4vbFzLeUt4TOeJ+FXf4OP1rGVFMwUi147L6F3
         k2Qg==
X-Forwarded-Encrypted: i=1; AJvYcCU1FVmMMPzi8WUrjjmAXKD6L2ABfgDeUlhxWKe8BPEZLj6Z9wVmjCv61pyGW3wnI66/KD2CldBRppA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwviWBMpvLwYbpsDO8NMVOeVK38y6+m8lFF5Ov8TBi6sTnf9O5g
	YcbtsiwNlDilUhma8OyO1eEhchrWKkDrdg4cc86Q2WxIJlIwclBvoicXGvLniFid1oGK8qdh2+j
	ftWwhMJ/uBilV3B6HdOVnzC9VuvZdYh0=
X-Gm-Gg: ASbGncscUyQwRZO5cdD3Oy/nw761NO6emXdzq25tNXM68lj9Ny5hzhHjwbcI/MU676P
	E5G4e9fyBp+Fg39FV3ZW/twE6mcR7KVi2y6x/wtjtYtfMsKMxnbbATUGlgntn9WUnLvofO5CGz8
	kIkXa1Zv5mEUJHErFNDyqIokbSHBGU9cHR2zNHRpluFNthkY9IiWJo2P2OcvtEbVDhXctX03Rtv
	85ftMtPZQsGMyQZnq9kPD2sJJQCELOpBcvqsiBZ357GaGzDLhjSk3X/qt9KwA==
X-Google-Smtp-Source: AGHT+IGhw/RAdL+Qq2ErhT+RqzctdlfmfkoP0agP9mEGuC3CqxOJ5ZYts1MnMGTbJhwI9M6YjxB3u2up4luyGrjSUu4=
X-Received: by 2002:a05:622a:3d4:b0:4b7:9b8f:77f2 with SMTP id
 d75a77b69052e-4ba69d34e9cmr44802521cf.39.1758129752501; Wed, 17 Sep 2025
 10:22:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798150680.382479.9087542564560468560.stgit@frogsfrogsfrogs> <175798150731.382479.12549018102254808407.stgit@frogsfrogsfrogs>
In-Reply-To: <175798150731.382479.12549018102254808407.stgit@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 17 Sep 2025 10:22:21 -0700
X-Gm-Features: AS18NWBMZSYluzPeM3z2iS9vBZBge3HQ1yV3N-msM09MJyDe4NdK72RgXGvQGco
Message-ID: <CAJnrk1ZhMnkEWqp4yhuAk6vC4xw1VcAXfYBsvLXNu7G1isWZpg@mail.gmail.com>
Subject: Re: [PATCH 1/5] fuse: allow synchronous FUSE_INIT
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: miklos@szeredi.hu, mszeredi@redhat.com, bernd@bsbernd.com, 
	linux-xfs@vger.kernel.org, John@groves.net, linux-fsdevel@vger.kernel.org, 
	neal@gompa.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 5:26=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> From: Miklos Szeredi <mszeredi@redhat.com>
>
> FUSE_INIT has always been asynchronous with mount.  That means that the
> server processed this request after the mount syscall returned.
>
> This means that FUSE_INIT can't supply the root inode's ID, hence it
> currently has a hardcoded value.  There are other limitations such as not
> being able to perform getxattr during mount, which is needed by selinux.
>
> To remove these limitations allow server to process FUSE_INIT while
> initializing the in-core super block for the fuse filesystem.  This can
> only be done if the server is prepared to handle this, so add
> FUSE_DEV_IOC_SYNC_INIT ioctl, which
>
>  a) lets the server know whether this feature is supported, returning
>  ENOTTY othewrwise.
>
>  b) lets the kernel know to perform a synchronous initialization
>
> The implementation is slightly tricky, since fuse_dev/fuse_conn are set u=
p
> only during super block creation.  This is solved by setting the private
> data of the fuse device file to a special value ((struct fuse_dev *) 1) a=
nd
> waiting for this to be turned into a proper fuse_dev before commecing wit=
h
> operations on the device file.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/fuse/fuse_dev_i.h      |   13 +++++++-
>  fs/fuse/fuse_i.h          |    5 ++-
>  include/uapi/linux/fuse.h |    1 +
>  fs/fuse/cuse.c            |    3 +-
>  fs/fuse/dev.c             |   74 +++++++++++++++++++++++++++++++++------=
------
>  fs/fuse/dev_uring.c       |    4 +-
>  fs/fuse/inode.c           |   50 ++++++++++++++++++++++++------
>  7 files changed, 115 insertions(+), 35 deletions(-)

btw, I think an updated version of this has already been merged into
the fuse for-next tree (commit dfb84c330794)

Thanks,
Joanne
