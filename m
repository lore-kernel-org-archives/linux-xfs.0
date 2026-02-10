Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C3723741
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 12:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770726948; cv=none; b=jeQpaQt71UNA2tt5Ip1tBqGlKJZ4XQxahHzZpFblupXhk1HsEeLMR2YpID2qY7Gnrh7c3upwoBVHVnHUNxLpnq+STzjIFEjgp3PoncXACRlhSPVvi1YdaFtnq1sUmgZNcB57QqfVsAjnDp1On5HIWxrj8/49wmMWIcFSwNZYhqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770726948; c=relaxed/simple;
	bh=usZ+CnwjAtjnc2/ecGgYgdg5OW75nsUBwOpL0K8R2fo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=L4VoCO0QakGwblihsPdSe5HkvJkaEcCB8gzFAaZyfSYGDKqidhZ9+w9gJQY+DEbg4q5lHekDEL5Xy7++nl0RnZ+59Hvbj/YQI65zGVWjf75cCA91XEwHqwNW9rZuIdCbEMhuhmpCLxZ4ibC0ESkYCuACluX/JAJGIANK5Rvsshc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eGxE+Yli; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eGxE+Yli"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-824923c7059so82951b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 04:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770726946; x=1771331746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N9qzfkrN6GZ8O41Hnp4OQHyIN4FEJF2qOqzyBorwMU0=;
        b=eGxE+YlisFTC463yhr+vqdAWeOIGvFnVgJdYANs0MRSO2gUQOffY1QUC+e23ZD1UvB
         8B2xSjTwGOFG1tKP2qsDmRWRIaAk5tWR+R37mId/sx7RBrFJzsaXCC95zuyb7RduJU1X
         gw1S/5HuYUrWnHR19chKfPvcgxy0qdPvnDgQJxTedZ/GSyD+iT60szj1AW+fKvqoEKsL
         +RnccX5oAhL7XT1aPgdCq/u4KDPEIXT3kPmjtxyVsvSx6V6GJxtDgWvqr6QHIZPUwRym
         QSVkKZgi7mYY7u1kA5KCg4FflTHftgT1VoXPW7deeI9U7Kkly3SQENO5pSncWAYDit8J
         517w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770726946; x=1771331746;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N9qzfkrN6GZ8O41Hnp4OQHyIN4FEJF2qOqzyBorwMU0=;
        b=i57tl/QT1if8LPu/DQ/v0mVHB2y6ls2mbqNcHZvK/Qk1K0tEfyIiDMacAHDCQHOu0Q
         UtKJtMUpN6xxpO5wWlop8GQeVaHR6JGaFOAU+CcTWqtU7EyaZetJvUPU+GvX6niyAihJ
         /bNyNGfFCEx/oRCOYRz66mK+eqSP/69EiEAEnfjI+g+CXB24hfSK02HkmNyVk/siIBei
         F8lbgSzwTsRWn+R/9ndyKc6L6djaS7Bphijy9fzqXr/6GKaWJdjNs/dA6RmjC9TKAcX8
         GbQlVy8Rmt3DuwgtJKld4QMuXysDKhb3Zq5hB0XFBWdyYm3BizDdSrod5Oy/SuPVweK8
         T4hQ==
X-Gm-Message-State: AOJu0YzLRFxddJQW0wuIOKA97vj0665vq9YwJlFCdvR6sE1UmqyomrYg
	z6Go+lx14cLqFMGkO9zjmfnecRulMnd/+9PzLOO6nysEpj3Xeq4Hz5P7wYXQOcjO
X-Gm-Gg: AZuq6aK47GngSFYC0dTaHgSSk6u3E5ecD0IFhTI7cCsQ9EbXxioVXNwggEieDwg1ofV
	VLLftfJzyvtH47poVogFj+i7L3zgvb0N31osnenIGGiW6xtId39B+P2QCF/CjAdjf91/rxOclnc
	rgRbUWNbEthEsMTjeVf8lubafYJIpI+SeNelbix+I6AksqnZKU5zwnvuSHeiDPAI01mqmWafoqf
	20nqN0vEOu+yaOoj0+3EB4sHBQ+0aAEkLudrhqVz39gMZ1ENVedbCbjoxKhPZtYxXZ2phubAkgK
	y96yVO3pWvIzcK4WsNAI+byGud/LzpAt/Kr1hD9BVGQE1PGdLSTYz7HzT8Fj77xxg+/eZbxB7pa
	2D5TB6wH203Ou17NUPXjKsjvFpLAsxx9RhYkb+aPtiBI/zu69K+LwWsbAADKRpM+ULtVKueIuUG
	DqNzBjOyEGzeoiMya94VWDeOMTGWMnCLMSlh0k0R+sLyZTNr8p4Dntj+QuIp/f/n+646NKqlR4v
	FEB4hKEiOQGAWE=
X-Received: by 2002:a05:6a00:ac04:b0:81e:dcb2:52cb with SMTP id d2e1a72fcca58-8244160a9bamr14128453b3a.2.1770726946424;
        Tue, 10 Feb 2026 04:35:46 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824418b7cc3sm13274706b3a.51.2026.02.10.04.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 04:35:45 -0800 (PST)
Message-ID: <acd9767b81950f1a14939d4e0ba30b1b4242aef4.camel@gmail.com>
Subject: Re: [patch v1 0/2]  Misc refactoring in XFS
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com
Date: Tue, 10 Feb 2026 18:05:41 +0530
In-Reply-To: <cover.1770128479.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770128479.git.nirjhar.roy.lists@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2026-02-06 at 21:07 +0530, Nirjhar Roy (IBM) wrote:
> This patchset contains 2 refactorings. Details are in the patches.
> Please note that the RB for patch 1 was given in [1].

Please ignore this series - there was some technical glitch in gmail while I was trying to send it.
I have re-sent in [2].

[2] - https://lore.kernel.org/all/cover.1770725429.git.nirjhar.roy.lists@gmail.com/
--NR

> 
> [1] https://lore.kernel.org/all/20250729202428.GE2672049@frogsfrogsfrogs/
> 
> Nirjhar Roy (IBM) (2):
>   xfs: Refactoring the nagcount and delta calculation
>   xfs: Use rtg_group() wrapper in xfs_zone_gc.c
> 
>  fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h |  3 +++
>  fs/xfs/xfs_fsops.c     | 17 ++---------------
>  fs/xfs/xfs_zone_gc.c   |  4 ++--
>  4 files changed, 35 insertions(+), 17 deletions(-)
> 

