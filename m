Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9438021506C;
	Thu,  9 Jan 2025 10:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736418371; cv=none; b=ah42lGJmGuNY/lIFeGSRp+2V4QloELPIX9FTxoxy2y8GWfaHi6HNrUD8xZp05EpJB8zc0HaSwxCNbZ2+H6A3qMYAl10qYcSKoL0wrTtRkin2bPuyUzN8jQEoX6JTrkYFFr6ay2q9lBgVSCvQv7n5XBG/gje26i9qKQTXrI8StP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736418371; c=relaxed/simple;
	bh=W/d4njES+q4nyoastFdj/N+Zrj2q72umBcZ433tlX1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K39upne8/JuysiKSClFeoVSVaoLngLQTE1ZKJ5W+ZoaUzgLi/gi/JYO/mhhxAbGMvOOArSnGsyXIeFl03njGsP8c7QP5vaB8Dv0iGqVgCGcdar12WL7FhEWEdBWZRnDtCcFC+f68Iv8uCbBX+ghuuYVJMtc9c7UHizwZ6lbQIig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qt/yOQwe; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qt/yOQwe"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d3f28881d6so1009969a12.1;
        Thu, 09 Jan 2025 02:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736418368; x=1737023168; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9k3Jb/YpcpuV4kNu4t+BcImi8dp9P1uXMqQ55im/F1w=;
        b=Qt/yOQwezB+jy2ezhh/mqmDDdxT7yr61owcfPQYCL1wxIH768BXqEpfzUtXqPwBWP6
         rxYAzfutEqQ3HfwFyf/xcWSiku1fFJbbwiWCFDkwku4oa/kgn3shFBrCcYONmVCtWIS8
         jIAGX3eeun9cM/Yn1NzsYXhJ5z4zch6axVsWAoUBl9oifVrnMEI3CGGrCaz5P7cnZtN9
         wEuOR22RmoQ2ujua+pMrDFBPARBA1+E/RACohVz0ssJQfUgH1nOlDPxa96QLliMYILqa
         WBh8Do4y7mfS6zM5KA/sofFPVx+7GWl0W2EhXhDW8z/G4gUlQtpWD3FDO++jMhdrrbWL
         7BwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736418368; x=1737023168;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9k3Jb/YpcpuV4kNu4t+BcImi8dp9P1uXMqQ55im/F1w=;
        b=fBc9rmdBP7aTef+RLGsYEuNQtxSDD3kT7ZjI2niQaHGZqf2NwWDFKFcm3A2c5BCJ1B
         yctQpfpqRsqL/yJAP21JqkO72mAVGBnb3OSccAjyzVp/iD47Gj2nC7AVvgaQLLMH3niH
         ZedmPnekyuCi/oTHWMhnDy90XsN1hYGH3va85F2Mf1dDdKm9TaQ5y8cfk+ESKo/qZJgO
         LxbiGF8Jd98aFJunWnisIhm0QblboNl2LxmQj+bj/JdLRwXYt2s26zkMzFBxz4DYwOsk
         oM6r2Ynx72bOizNXTxROODUtpA336AuuZDsCBkkYJkU3Ke4/eORoY2/YlFGH56d8ryr4
         vmhA==
X-Forwarded-Encrypted: i=1; AJvYcCUa68uVzueG5cbnCK7xD6qn4k90YLJDYLG4ko1ryYc9fAQUWZpknbityZJ2V6QsCI16HRbtY2UFkTtT@vger.kernel.org, AJvYcCVN/xOOKXIv70wrEx3ISCQkOTFs8t8vG29LZxRLUWSincKlG21VQjVXhHf7QU63xNeWkoB8QbIFEdei0/4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4m4qFawLwuIqhcsER5aoiQhFj/asdfekMZoGYvfVzAG865aBD
	3hWuP5/tI70O3gn9++L4Fdk6TQGuiq8aWhw/Hhym5jjLHj8PVI28zy4yCXfAu+x6r+e2+g0o2cf
	2UOniNard0vRzCcvD+BD/aVnObWw=
X-Gm-Gg: ASbGncuZKfMD7ofVn7j47cr0ABL65jltQPBQXXkdclBzfJI2jbsNsjwC/GJRDTCXzYi
	cPITaftaqOHLkFHyixtKc8F8lQ1kXSwCjwlhuRg==
X-Google-Smtp-Source: AGHT+IEE8dnuabfh8XConchEbVxgnJDl47Qpk98vIum1KnQbe7H5CvaGmiUV4oVRAS2UYLRNBdVt7S3hZUE2hnW8a/k=
X-Received: by 2002:a05:6402:50d4:b0:5d0:9054:b119 with SMTP id
 4fb4d7f45d1cf-5d972e63dd4mr13083254a12.21.1736418367468; Thu, 09 Jan 2025
 02:26:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241226061602.2222985-1-chizhiling@163.com> <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com> <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com> <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com> <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
 <b8a7a2f7-1abe-492a-97f8-a04985ccc9ba@163.com>
In-Reply-To: <b8a7a2f7-1abe-492a-97f8-a04985ccc9ba@163.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 9 Jan 2025 11:25:55 +0100
X-Gm-Features: AbW1kvam4UTNGnWxK5XAvEgku0C8aLMjIv5U8DLkXi6pA-XyCZ98h2dWw_ewKPw
Message-ID: <CAOQ4uxje241QhUeNe=V8KKY+5a27eYd2dc3s+OiCXMPW5WZyPQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Chi Zhiling <chizhiling@163.com>
Cc: John Garry <john.g.garry@oracle.com>, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, 
	cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chi Zhiling <chizhiling@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> > One more thing I should mention.
> > You do not need to wait for atomic large writes patches to land.
> > There is nothing stopping you from implementing the suggested
> > solution based on the xfs code already in master (v6.13-rc1),
> > which has support for the RWF_ATOMIC flag for writes.

Only I missed the fact that there is not yet a plan to support
atomic buffered writes :-/

> >
> > It just means that the API will not be usable for applications that
> > want to do IO larger than block size, but concurrent read/write
>                                ^
> To be precise, this is the page size, not the block size, right?
>

fs block size:

        if (iocb->ki_flags & IOCB_ATOMIC) {
                /*
                 * Currently only atomic writing of a single FS block is
                 * supported. It would be possible to atomic write smaller than
                 * a FS block, but there is no requirement to support this.
                 * Note that iomap also does not support this yet.
                 */
                if (ocount != ip->i_mount->m_sb.sb_blocksize)
                        return -EINVAL;
                ret = generic_atomic_write_valid(iocb, from);
                if (ret)
                        return ret;
        }

> > performance of 4K IO could be improved already.
>
> Great, which means that IO operations aligned within a single page
> can be executed concurrently, because the folio lock already
> provides atomicity guarantees.
>
> If the write does not exceed the boundary of a page, we can
> downgrade the iolock to XFS_IOLOCK_SHARED. It seems to be safe
> and will not change the current behavior.
>
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -454,6 +454,11 @@ xfs_file_write_checks(
>          if (error)
>                  return error;
>
> +       if ( iocb->ki_pos >> PAGE_SHIFT == (iocb->ki_pos + count) >>
> PAGE_SHIFT) {
> +               *iolock = XFS_IOLOCK_SHARED;
> +       }
> +
>          /*
>           * For changing security info in file_remove_privs() we need
> i_rwsem
>           * exclusively.
>

I think that may be possible, but you should do it in the buffered write
code as the patch below.
xfs_file_write_checks() is called from code paths like
xfs_file_dio_write_unaligned() where you should not demote to shared lock.


> >
> > It's possible that all you need to do is:
> >
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index c488ae26b23d0..2542f15496488 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -777,9 +777,10 @@ xfs_file_buffered_write(
> >          ssize_t                 ret;
> >          bool                    cleared_space = false;
> >          unsigned int            iolock;
> > +       bool                    atomic_write = iocb->ki_flags & IOCB_ATOMIC;
> >
> >   write_retry:
> > -       iolock = XFS_IOLOCK_EXCL;
> > +       iolock = atomic_write ? XFS_IOLOCK_SHARED : XFS_IOLOCK_EXCL;
> >          ret = xfs_ilock_iocb(iocb, iolock);
> > --
> >
> > xfs_file_write_checks() afterwards already takes care of promoting
> > XFS_IOLOCK_SHARED to XFS_IOLOCK_EXCL for extending writes.
>
> Yeah, for writes that exceed the PAGE boundary, we can also promote
> the lock to XFS_IOLOCK_EXCL. Otherwise, I am concerned that it may
> lead to old data being retained in the file.
>
> For example, two processes writing four pages of data to the same area.
>
> process A           process B
> --------------------------------
> write AA--
> <sleep>
>                      new write BBBB
> write --AA
>
> The final data is BBAA.
>

What is the use case for which you are trying to fix performance?
Is it a use case with single block IO? if not then it does not help to implement
a partial solution for single block size IO.

Thanks,
Amir.
