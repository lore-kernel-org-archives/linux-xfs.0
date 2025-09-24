Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D83023A98E
	for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 18:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758738196; cv=none; b=BpnM+bM5gwUBQ7CXyQ0ju5aAYsqOpYnyiaAiPqNrXOSgnBkRmJQkf05CpVtRazWzHC/0Xpgnc6RH0swDBZhTbfTeuqyrqNjIwYZek//rXCbGj2RKJL++M4ffwMt7fR9UcmM/43rB3xNfBZB7G3HWspMO26iY5Bem12BjdNufos4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758738196; c=relaxed/simple;
	bh=r/pO+CZyHHxpu+YW1zwr7CM/wT81oD3rByhrRLtBYgk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YB9CtNKhb6+NoMAydqljTVsP+a0zi6K1/mdJjXQMMzNJAllefecyFD1XJmKXWHH4/hZixgnEaYxzn6nCiqRGMPlAVDxqyGd9fnv6/p4tg3z4Wxh74jbnmtLRA+sJlPz3ahoso0hb36X5asnXRsR1jWWtPY8Mk0fGCIohr4fcml4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NMFoieRM; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NMFoieRM"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b3d3f6360cso1653701cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 11:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758738193; x=1759342993; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/pO+CZyHHxpu+YW1zwr7CM/wT81oD3rByhrRLtBYgk=;
        b=NMFoieRMf70j0nmf7phGKZA8RP/pRvY15virdS7+eREcjXYe84y7Z70t2ZZDyj0XmO
         jxaZRgPnG84n/ZBFrjb0N+vyr2Ai50EYvZsQnPtRC/4GN8S6svv2/PvsVoFV6IaTKF99
         +34xIAjfPy12NT+EPAzgP+pDs/la+2Q9rsUjz/pid1pBokBAjJyKOF7pPUh07kZ9gsPe
         kGsJ3hmncjxHj3QlYu1j/09kKVJebS+VP/ftthqlDfrytccynMveH5lqD2thIWlpWogT
         NX/fxOV1WwlGjZSO1sDL0javZbtyLlzral7wG9bs4f8+fWy17Bf0kRnYwasZz6UNL59o
         QOag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758738193; x=1759342993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/pO+CZyHHxpu+YW1zwr7CM/wT81oD3rByhrRLtBYgk=;
        b=D9nPwGBfoliKsDz6OiqPY+/2ANXm7JGs9xcyCazuWCriSYhJzrJj1lVF1beKNSsSYr
         0PeQx5ZebOJTv/8BuPHgc12g95RLMykqwjZGD8zSEMZYgtKYD+UAZyK1mmEKdsLDdRx6
         IQLHap+wZnIUt3ppDjG+fIggY/+MCYcIUvmsMXsX1qnJq/tOMiH70BLd9ltbc8n23eVt
         W9tu/92Su6xYbTyNYxg5MnvAszOHcIWrs0+mLIUsa+m8ggHHK0fivCIGLQrxaE//mClV
         DPwH82Xw4Klc1ofEOJ2D1HxYuuIX4JRXGm7dUJpOI7sUp4+9aagL/tTzkxe2eI2lf6sJ
         h+kw==
X-Forwarded-Encrypted: i=1; AJvYcCXOZOW4FsgKvWmvc/sh+6LXgryBKMb+9DptcqmPizSxmTC1+ZK6s4aaBfzXLPyuuV1VYJKosDUj/rk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsFMG43oPN+Fmi6yMpt6tXwvmyW4D6ngQcQ1V/JXdmp+Hfss+g
	MqLavtbqwSw40/8eI6fvYMe7L5lKYZc8Po0Ig0KU3LbC2znBWcOgCJPpGbv4ykKbXoRaeOA/Wu1
	qcdGRYStWJRXScMEatrCk5N2SMB0USHU=
X-Gm-Gg: ASbGnctnRqugnD5DjnRbjBuAGIXYdhLNoyuuFS5OPkcwKL1+mbGuvPZF0ofOoWAvMVM
	eXfVHGZGr/yvksHU4qWB6S0aGhSwqly4cBSPccv8J4yrRJu/gPbGh61eybL1o3l0Ypihzvm/UPj
	pPOpXXAKuLXlvdX1nB2NFIciySAOyi9u5Rl6JtaQajw3yEU4ViyyqIuXu2+gDzRWJnzxCc65LK1
	cH8o1N9z4DZaivZmU9TtBi3HP6eSkP8v9vwjta2
X-Google-Smtp-Source: AGHT+IFb2hnIa33/rJNkCrkGQy65hGr9PbmGe9myzP3aURdvVIcxUKeZQP66X+68mdhz4LTVXyo8AURYpcXobTiuOWo=
X-Received: by 2002:a05:622a:1188:b0:4d8:afdb:1277 with SMTP id
 d75a77b69052e-4da4b428a11mr10874201cf.38.1758738192675; Wed, 24 Sep 2025
 11:23:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923002353.2961514-1-joannelkoong@gmail.com>
 <20250923002353.2961514-11-joannelkoong@gmail.com> <20250924002832.GN1587915@frogsfrogsfrogs>
In-Reply-To: <20250924002832.GN1587915@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 24 Sep 2025 11:23:02 -0700
X-Gm-Features: AS18NWCrgkvYY30dc-QDZpxRITAd1Rc6cqAqGzLtb2nb9C8hv8zV40q9qN2yU1Y
Message-ID: <CAJnrk1aLtP6fVCqfNTM+boFFnHQ4amB=614efyGS2vW2iauZ7Q@mail.gmail.com>
Subject: Re: [PATCH v4 10/15] iomap: add bias for async read requests
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, miklos@szeredi.hu, hch@infradead.org, 
	linux-block@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-doc@vger.kernel.org, hsiangkao@linux.alibaba.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 5:28=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Mon, Sep 22, 2025 at 05:23:48PM -0700, Joanne Koong wrote:
> > Non-block-based filesystems will be using iomap read/readahead. If they
> > handle reading in ranges asynchronously and fulfill those read requests
> > on an ongoing basis (instead of all together at the end), then there is
> > the possibility that the read on the folio may be prematurely ended if
> > earlier async requests complete before the later ones have been issued.
> >
> > For example if there is a large folio and a readahead request for 16
> > pages in that folio, if doing readahead on those 16 pages is split into
> > 4 async requests and the first request is sent off and then completed
> > before we have sent off the second request, then when the first request
> > calls iomap_finish_folio_read(), ifs->read_bytes_pending would be 0,
> > which would end the read and unlock the folio prematurely.
> >
> > To mitigate this, a "bias" is added to ifs->read_bytes_pending before
> > the first range is forwarded to the caller and removed after the last
> > range has been forwarded.
> >
> > iomap writeback does this with their async requests as well to prevent
> > prematurely ending writeback.
>
> I'm still waiting for responses to the old draft of this patch in the v3
> thread.

Ahh, thanks for clarifying that. I'll go back to that thread and get
some more alignment.

Thanks,
Joanne
>
> --D
