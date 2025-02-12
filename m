Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CD227180B;
	Wed, 12 Feb 2025 18:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739385086; cv=none; b=lmb99a8GVNtYpKblBSNuAwFROsr7LWtyU90K0bXTrb/9qmmyrmpkYGVAQiPv9aHxeunywqDtn6HoQeixOCcohpYbKGTcor2Hr4vMOYsA32x5XHv8BEYkkYYJQa29Koym3+Gn9c0W0hXFIuHKJocsSDT4TVIunBqbqA+HQPLqnj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739385086; c=relaxed/simple;
	bh=whHmJxLlmHZe3eoL8ODIdqmfo12n5YdUmAgqoTcVN6k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XInoi+UG+Rlyf0oy8h+oMNPbzuBh4VI86BwEOISccb85LZhE3e6rUu+4q7Id0PDay45jkuik3EwqxB6pAIZeddGF1fR0ap7yhZSSNxOlU5HxSuRxrsphJ+dLqEh5l7um0vk4h/fgNs1fmDzyhPhEC5ReDGk3ZmZ6gvE09tn6lVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PzYCT4tr; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PzYCT4tr"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4719768caf7so28283751cf.3;
        Wed, 12 Feb 2025 10:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739385084; x=1739989884; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=awfLidEoU16uBciKu7RZVBnSTAH8ZmdZhG2jJUtXbOY=;
        b=PzYCT4trWpH0pubC+tSKTRntRxlf3IjDuoB0i8N6DHaho2bV2rTeQXayTH2EqEP22G
         JLscHC+8VRmyQMES1qeSm51YwEk6Hmu5rcjIrMIaUt5BSLm/rIbsdC+OCRGPglW+z1yJ
         Az726C0pqs3+6SywHo+5WV6Iwr3RBG+9jdOFCgRRdIxOAC+HfDn5X2jux8Lm9iUWlnZg
         b6AH2QnjrHOI7d0CtiBI5rURuGgpPnQadD9UjP3b7ls4fp51MjfosFXGzYaqDQV8GQDJ
         Ujo+93fET2p6+F31TR43Y7k+z4e7h8x61MkFzocHgm/rFu04kc8WRU11d7MTavRhrgWU
         32hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739385084; x=1739989884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=awfLidEoU16uBciKu7RZVBnSTAH8ZmdZhG2jJUtXbOY=;
        b=LZQTeAOviEv2e3DCQLkCyyNJm5DZHl85h8cBS6Q9fMehS8654QFWWRu95TckYK4Hmz
         bVtQlQB5d7Fx464N+N68r2/ZXDrARKg8veZrvvyPpf6J4+YzS7m8xALIQHCK25kNvam1
         KqqHhwxdSBINJ4l231fd2Ssa8pTwr7cYUohFQTkWsC2zvLZ8iDg1HoBrQft4/dw/HQLi
         fRJdqdhD4TdmpDpbUDR2pYOq0PkIaCv3LPsqo1DTHnRSKbrO48zwWgK0mvGaEMQ8EHbj
         IpdkWRNOWoNPbpCNVC/T+mVaqfs1lyWUExmfiyFt69IWpnJuHH4Xh4alySqNIFko8GdN
         D83A==
X-Forwarded-Encrypted: i=1; AJvYcCUDTJsk5tfr7aXzf1nPxCGYq+DRIfNKhty3NEF0NS5bEUPBWXy+dZSVWNckxqOC2tXFf+PB5714@vger.kernel.org, AJvYcCWiiP4h4P8wZSLIcW8L9/8M8kCl5zoFEkjyOu3H/x2122+e58fAdMenWfaLFpHLa5zxbgSnUjlr6klQ@vger.kernel.org
X-Gm-Message-State: AOJu0YyPaYcfdG4OZd7NRoPRiE9il9Nbsawdcn2c3KOzzanG+shJ13Ss
	rzN1mDV24LoBg+Xvj1j9CWA/JG94RHOAzxvuh+2V1RscFSNMLewm73Qri4aEIMDTeu572t80lnx
	llmNisxwd982oiuKej7POrMCODdAGF9I9
X-Gm-Gg: ASbGncsiZBOqyg/olEB305rjrCL07RgbsIADsqLfKl7+VVX5aK4yv01seFsQng50yBf
	I53yRqBwH5gOr5cOTT17t7oGG9zSYDSPPthmomHo9hWnOJYp8Yqr94quYnMW0tixKlrayPOBxT2
	QwWOXlZQHnZU0=
X-Google-Smtp-Source: AGHT+IEyy4XIkiGLj6Qt2gnC9U9cQ4upLpl+MLkiyjEe0Hfw1zBPS/y8PvZAsieG8HTOd+CmHzabWKxMwnWIRz9FbR8=
X-Received: by 2002:a05:622a:418e:b0:471:bd5e:d5dd with SMTP id
 d75a77b69052e-471bd5ed804mr21243151cf.16.1739385083698; Wed, 12 Feb 2025
 10:31:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs> <173933094492.1758477.14479485917819478634.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094492.1758477.14479485917819478634.stgit@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 12 Feb 2025 10:31:13 -0800
X-Gm-Features: AWEUYZkecs6pyIy4xGOvusDpwdvdUnpE33Dmd46b-dJVIHzVLNyColq2yNohlnQ
Message-ID: <CAJnrk1aH9PO8jrqp9TsKquUgW0Shp-1Qrf5AyGGYH0FAa7HKeQ@mail.gmail.com>
Subject: Re: [PATCH 09/34] generic/759,760: fix MADV_COLLAPSE detection and inclusion
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2025 at 7:33=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> On systems with "old" C libraries such as glibc 2.36 in Debian 12, the
> MADV_COLLAPSE flag might not be defined in any of the header files
> pulled in by sys/mman.h, which means that the fsx binary might not get
> built with any of the MADV_COLLAPSE code.  If the kernel supports THP,
> the test will fail with:
>
> >  QA output created by 760
> >  fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -h
> > -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -h
> > -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -=
h
> > +mapped writes DISABLED
> > +MADV_COLLAPSE not supported. Can't support -h
>
> Fix both tests to detect fsx binaries that don't support MADV_COLLAPSE,
> then fix fsx.c to include the mman.h from the kernel headers (aka
> linux/mman.h) so that we can actually test IOs to and from THPs if the
> kernel is newer than the rest of userspace.
>
> Cc: <fstests@vger.kernel.org> # v2025.02.02
> Cc: joannelkoong@gmail.com
> Fixes: 627289232371e3 ("generic: add tests for read/writes from hugepages=
-backed buffers")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  common/rc         |    5 +++++
>  ltp/fsx.c         |    1 +
>  tests/generic/759 |    1 +
>  tests/generic/760 |    1 +
>  4 files changed, 8 insertions(+)
>
>
> diff --git a/common/rc b/common/rc
> index 07646927bad523..b7736173e6e839 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4976,6 +4976,11 @@ _get_page_size()
>         echo $(getconf PAGE_SIZE)
>  }
>
> +_require_hugepage_fsx()
> +{
> +       $here/ltp/fsx -N 0 -h $TEST_DIR 2>&1 | grep -q 'MADV_COLLAPSE not=
 supported' && \
> +               _notrun "fsx binary does not support MADV_COLLAPSE"
> +}
>
>  run_fsx()
>  {
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 634c496ffe9317..cf9502a74c17a7 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -20,6 +20,7 @@
>  #include <strings.h>
>  #include <sys/file.h>
>  #include <sys/mman.h>
> +#include <linux/mman.h>
>  #include <sys/uio.h>
>  #include <stdbool.h>
>  #ifdef HAVE_ERR_H
> diff --git a/tests/generic/759 b/tests/generic/759
> index 6c74478aa8a0e0..a7dec155056abc 100755
> --- a/tests/generic/759
> +++ b/tests/generic/759
> @@ -13,6 +13,7 @@ _begin_fstest rw auto quick
>
>  _require_test
>  _require_thp
> +_require_hugepage_fsx
>
>  run_fsx -N 10000            -l 500000 -h
>  run_fsx -N 10000  -o 8192   -l 500000 -h
> diff --git a/tests/generic/760 b/tests/generic/760
> index c71a196222ad3b..4781a8d1eec4ec 100755
> --- a/tests/generic/760
> +++ b/tests/generic/760
> @@ -14,6 +14,7 @@ _begin_fstest rw auto quick
>  _require_test
>  _require_odirect
>  _require_thp
> +_require_hugepage_fsx
>
>  psize=3D`$here/src/feature -s`
>  bsize=3D`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
>
