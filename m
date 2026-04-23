Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C0324E4A1
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 05:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776921644; cv=none; b=WqGmnPxLpp++iFlu7YmhmTd68r2Quda17i4U1ifW8wzoKSVWRFhIDmoCy+ni9BGbHQInpKrT95bu/Dnod1NYb6oGczlHCKSm1G8bHdiEKnfEoNh77wFiXeYcbsfYWarqWNcuU2sBqzvd7C2/qR37bEg/GEGt/ADYWeFKUtCSR/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776921644; c=relaxed/simple;
	bh=veocLgDgNUGiPFVbn5rQLuikntKrMSAnajySTD3BziU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fmrbMvH1/4YmoReiMC7kNQfHJYg85Zp3SZaBbe4MSbXvguJ7sNByEjyKIQxCEG9hYvasmN3U+q6yNbkA3YyDuGRalTNDxsMEvrqGciPj3YctOO1Vnpom1rJbLp/vr8pXB3r0EixTctgmFZG7bW6od6hxwGQlh9nKFKRjtc1BB24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=urGbQ1L1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="urGbQ1L1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F31C4AF0B
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 05:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776921644;
	bh=veocLgDgNUGiPFVbn5rQLuikntKrMSAnajySTD3BziU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=urGbQ1L1FtVrPVuHFKu2wUW+C2JojDLhdtfSXzCLMl19rFN/1lbaVeU16896z7aFS
	 khlEHBXkB92Vh2i6hEkabJ7n5ttTeR/OTGs4duBc8mpLW9jADLeYppFgz+nLBoG/LF
	 DCRy5TPREr7PVyN8mu1+VhsS9+pRTt9kYlPc2wlxeH+eIMRoQg/nnOq9YXau8gZwZh
	 2k3YndH/UUpDooAKRmZ1dnIY4jWtf1kuAi6m+k5lFWYytQdfkkqmxVmEGoQ9xIY1IB
	 tB1SJ1tf89cyhZlbG2Nhi4Of/Bq3E2JXhNMTDYRWvyFJvP5L9uiFalUUb8Wl5WhD8b
	 DUfzj+TBl3WNA==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6714f678bdaso10290299a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 22:20:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/Ep2ENPd8ZJE8bK0VaTlzoX0kJERag1ojSPIU/ocV0UTNKKdVtOv3Z/cj0EdItf7yPcHvBfavnkpc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yztzwq5FqLksjdNUIcDstQY+E42+bHgjTGNrbrfilJm/WdIrtcq
	/Li2IZQNi1qF7EEWW2sCS+nnxBM5FS8xE8ca26rsOnr7Ifu6REYwzrWSGnUAEgaYPPxMacBiJi/
	BvZvIhF3sBkuHHj+5R9FcJeqZo0W9mX8=
X-Received: by 2002:a05:6402:2b98:b0:672:a20b:3781 with SMTP id
 4fb4d7f45d1cf-672bfc12952mr10871100a12.0.1776921642902; Wed, 22 Apr 2026
 22:20:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422104627.8193-1-linkinjeon@kernel.org> <aejFTDGOnDbQ3OJK@casper.infradead.org>
 <CAKYAXd-RQrrpXH0R_Y87r53h0-KCDGVOtm5RaqTGETMEq-LYpg@mail.gmail.com>
 <20260422152832.GR7727@frogsfrogsfrogs> <bd33abf2-5024-4a1d-bb75-a0359d64da1b@linux.alibaba.com>
In-Reply-To: <bd33abf2-5024-4a1d-bb75-a0359d64da1b@linux.alibaba.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 23 Apr 2026 14:20:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8MioYXt9o6md2TaKrg4Y9KXycoDXZ5d1c2AYfbz0N-OQ@mail.gmail.com>
X-Gm-Features: AQROBzDeQv8yh636X0aPpYEp31jfK00vlKvcX1GZPlNy2s3IjY2PSQaco_jqu7A
Message-ID: <CAKYAXd8MioYXt9o6md2TaKrg4Y9KXycoDXZ5d1c2AYfbz0N-OQ@mail.gmail.com>
Subject: Re: [PATCH] ntfs: use page allocation for resident attribute inline data
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Matthew Wilcox <willy@infradead.org>, hyc.lee@gmail.com, 
	linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	linux-xfs@vger.kernel.org, Gao Xiang <xiang@kernel.org>
Content-Type: text/plain; charset="UTF-8"

> >
> > I think the check is wrong.  We rely on the filesystem to point
> > iomap::inline_data to kernel memory that is at least iomap::length bytes
> > in size.  If that crosses a PAGE_SIZE boundary that's fine, so long as
> > the caller actually mapped that much memory.  IOWs, if you have an
> > iomap:
> >
> > {pos = 0, inline_data = 0xB0000, length = 32768, ...}
> >
> > then we trust that you really did map all of the MDA text mode memory
> > and that memcpy'ing 100 bytes to pos 4090 is ok.
> >
> > (Perhaps this is a relic of the bs<=ps days?)
>
> Anyway, as said before, I think that particular assertion
> can be removed too.
Okay, I will submit the patch for this.
Thanks!
