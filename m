Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AA715AF6
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 12:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c+slzhRc"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3bbe78dbd1aso626953b6e.1
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 04:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704977578; x=1705582378; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2OKu3tBHkZFXz/bMi18MdiJAIyXXR+MIRlo68CWhftE=;
        b=c+slzhRcq1lf5h9Gu8uBT6QEU8oINZJ9TPNlGyVrqYJde1t+zSlAwTPBzrzK3c7bij
         iwic+/wVlAW/ezP5tz/1QLuD7devwWYBGRTHsu7Aw38GaoqWqglo6E0xn8LS1lDL7yOG
         OwER6cHTpU+K/nZ9GeEOSwPT4etbKzGt6I9zN4WYx36v7nvzOYorHf24uaXLqb5Q2ET0
         klpRvZTaJcPtUdQ2glwwwAFA6riTaKwtISf2f9MGW+gZo7/gjEVfnHn7nzKh8cBkvnEh
         AVu0g795BJk1IwtgHpX05Vt10mOp2Laue8pjed6+DHctpTi51rYGrMj1zK7fSA2CFeOv
         Sskw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704977578; x=1705582378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2OKu3tBHkZFXz/bMi18MdiJAIyXXR+MIRlo68CWhftE=;
        b=HLTB8VgtRp/xEjEHd8+ClDjvqIA5xxm2gVohPtaVhVDLzJ62dvfjhVz8eJFSoewENS
         7dp2CfSt9/1qMiaa7Ylqjlkn5/talKHqZaJ7drMYyFiWzPnVNP//6VGCucBlqp8hSw5s
         xelNf8b0Ojl7nuDxxgMbisknIGimvhWIS0IDJIjxrqjGrtv7UjlHbegcKn47G43nE9hi
         QBO6wmT6M23t8tHmstUOCpFWLIh6f7xAWqifOk08MtT7PamUSmZEEPUElbfGsMSjeDgc
         0USHIFEi9/Puo/O18IPkAjYN7T19gqVF0TC4jdAhke1uPg6n8DixkEpCbKtF7niNOOX1
         0Mag==
X-Gm-Message-State: AOJu0Yxn4knVe2ozIN6A/yC6oX8Xtag31zaf7SGw1WfcGGQogpVps5Ci
	YYm4FKNd/K1c9beaZQDx/Ejg4FMtIOCLASYxg9E=
X-Google-Smtp-Source: AGHT+IEWtp2tk9k2Tx1VFBbmxGeCI0WeYQrbvk4oBsp4p26sfuvJEZGcb+BnUwtpNt2YhwnWL2iP90CY4Jyq9AawwiA=
X-Received: by 2002:a4a:d08d:0:b0:598:81b7:4d25 with SMTP id
 i13-20020a4ad08d000000b0059881b74d25mr2151511oor.1.1704977578258; Thu, 11 Jan
 2024 04:52:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240110071347.3711925-1-wenjian1@xiaomi.com> <ZZ8OaNnp6b/PJzsb@dread.disaster.area>
In-Reply-To: <ZZ8OaNnp6b/PJzsb@dread.disaster.area>
From: Jian Wen <wenjianhn@gmail.com>
Date: Thu, 11 Jan 2024 20:52:22 +0800
Message-ID: <CAMXzGWJU+a2s-tbpzdmPTCg9Et7UpDdpdBEjkiUUvAV5kxTjig@mail.gmail.com>
Subject: Re: [PATCH] xfs: explicitly call cond_resched in xfs_itruncate_extents_flags
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de, 
	dchinner@redhat.com, Jian Wen <wenjian1@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 11, 2024 at 5:38=E2=80=AFAM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Wed, Jan 10, 2024 at 03:13:47PM +0800, Jian Wen wrote:
> > From: Jian Wen <wenjianhn@gmail.com>
> >
> > Deleting a file with lots of extents may cause a soft lockup if the
> > preemption model is none(CONFIG_PREEMPT_NONE=3Dy or preempt=3Dnone is s=
et
> > in the kernel cmdline). Alibaba cloud kernel and Oracle UEK container
> > kernel are affected by the issue, since they select CONFIG_PREEMPT_NONE=
=3Dy.
>
> Time for them to move to CONFIG_PREEMPT_DYNAMIC?
I had asked one of them to support CONFIG_PREEMPT_DYNAMIC before
sending the patch.
>
> Also there has been recent action towards removing
> CONFIG_PREEMPT_NONE/VOLUNTARY and cond_resched() altogether because
> the lazy preemption model coming present in the RTPREEMPT patchset
> solves the performance issues with full preemption that PREEMPT_NONE
> works around...
>
> https://lwn.net/Articles/944686/
> https://lwn.net/Articles/945422/
>
> Further, Thomas Gleixner has stated in those discussions that:
>
>         "Though definitely I'm putting a permanent NAK in place for
>          any attempts to duct tape the preempt=3DNONE model any
>          further by sprinkling more cond*() and whatever warts
>          around."
>
> https://lwn.net/ml/linux-kernel/87jzshhexi.ffs@tglx/
>
> > Explicitly call cond_resched in xfs_itruncate_extents_flags avoid
> > the below softlockup warning.
>
> IOWs, this is no longer considered an acceptible solution by core
> kernel maintainers.
Understood. I will only build a hotfix for our production kernel then.
>
> Regardless of these policy issues, the code change:
>
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c0f1c89786c2..194381e10472 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -4,6 +4,7 @@
> >   * All Rights Reserved.
> >   */
> >  #include <linux/iversion.h>
> > +#include <linux/sched.h>
>
> Global includes like this go in fs/xfs/xfs_linux.h, but I don't
> think that's even necessary because we have cond_resched() calls
> elsewhere in XFS with the same include list as xfs_inode.c...
>
> >  #include "xfs.h"
> >  #include "xfs_fs.h"
> > @@ -1383,6 +1384,8 @@ xfs_itruncate_extents_flags(
> >               error =3D xfs_defer_finish(&tp);
> >               if (error)
> >                       goto out;
> > +
> > +             cond_resched();
> >       }
>
> Shouldn't this go in xfs_defer_finish() so that we capture all the
> cases where we loop indefinitely over a range continually rolling a
> permanent transaction via xfs_defer_finish()?
It seems xfs_collapse_file_space and xfs_insert_file_space also need
to yield CPU.
I don't have use cases for them yet.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
