Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B711A4E60
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 20:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725307907; cv=none; b=VtxNFl40LUO7ZBlwdyAJc/yEr8f6EzxbglYUcfG/ZUuyTc1vg9HYKOOPUVGRHNF/h6p/pOj7vW6WFVCH3Xvjx6yc20Fd5ff98Luo0YsoEHTQxOwukr2Sb2k97jBbVsmvETi1XyR2nAoq9dFpevNEvp62YaTOjcoNdJI88IY6iSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725307907; c=relaxed/simple;
	bh=RspLFM/fRiTvbWHWlGVe2GyINrZEmqOEbZKGEXzKlRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btedZQ09mifGZNkG8zqOy/Bgy6iLapKglfTGHE7fitMLuAyXSIDPRWYUQ6sDiO1rezahrGJj1Aru0ddabCM5QG+/JeJqzmJxV6bnAMp/3n7v3SISE401o6a66t9RpfbFoGNTUy9envacFJ4lkKnK3P6PsOqpKeMnzNINv7pyCnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HjEbqC7a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HjEbqC7a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725307903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=59F21+D3gZdhz5mExKDUmgO5lRbG40PbkCYVHrA0gAU=;
	b=HjEbqC7a26cmpxwTB0K/PojRv3tDMce6RpWhEWVvTkrD5158PIVqzwxXXA8CuHN/8cSi4X
	vDRHVgaqtkZ+0zZDoObg0JhS6c3wn1rWdMElOcEt4IApFDUUG8r/zktqleYAl6EkyqLswo
	ojTYAc6YyEqiXHhQN+jHFMtujiGp4wE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-Dq8_ybzsOeOQP8t7BTBjxQ-1; Mon, 02 Sep 2024 16:11:41 -0400
X-MC-Unique: Dq8_ybzsOeOQP8t7BTBjxQ-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2d882c11ce4so2475811a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 02 Sep 2024 13:11:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725307900; x=1725912700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59F21+D3gZdhz5mExKDUmgO5lRbG40PbkCYVHrA0gAU=;
        b=V/nVqqfXjZSAyQrvmOX2RX6hUshbDbObRL1zU9iR0rcMP0mtpewRhqhbr3erwkm90z
         DrdgoRpPgOX4nREVHCIglsL1CFAtjZxaBlMR4U1jxzuvxwS7tIgL0DcPmTy4Xt2ebBX9
         ZRzBdoFLKhnyQHhfOZwg2Z43ec2PTKf+eCzUjUM+LN/cnl9yHC+HX8/IgOUxEuL/qgPB
         B0wUAPZPugu3EqJJqbELNyUHf0gmvWw6bM88lo2h3PKl7WnB0H3Q1XVbp5KbcvjdWwRW
         vilVBPhbCEFddY4mEdVh4wx6tFMPY/OzyUM+paSpXVXVV85jlZgPNTpROPPEN+6OqR7u
         Y/KA==
X-Forwarded-Encrypted: i=1; AJvYcCXjjabXeUt85g1TP1B6PpUX1EDcLLrvBVy7uNOkAv7WfgqcC+BdwymQSaoMZXuADFWu0edEmLbZRuk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGTFswWTdnxmBfvo+sAi3dT1/mmHLvERpzGgPt3GDis5BdG90H
	6XH2rZ93Wc7ah9WhcjXV6ktgVXqMaKQJGKXEhiyavsXUwZ2Zaci71axdbVh/8iT5L4aVV1TSjzU
	081GjRaHQWz+6b9d7csVv3QYpac+MXgEl13fcwow9qb3Bjmc1Lzi7LtodXA==
X-Received: by 2002:a17:90a:f006:b0:2d8:8f24:bd86 with SMTP id 98e67ed59e1d1-2d8904c2fb8mr6927919a91.8.1725307900423;
        Mon, 02 Sep 2024 13:11:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjrn9klJ+pWZEkpsucFytkO/QH3kSVolLgb8sXeZcyczUVxlHsAJSlLW1AARVAsyYov1xp7A==
X-Received: by 2002:a17:90a:f006:b0:2d8:8f24:bd86 with SMTP id 98e67ed59e1d1-2d8904c2fb8mr6927892a91.8.1725307899842;
        Mon, 02 Sep 2024 13:11:39 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8f308b8ffsm1736593a91.4.2024.09.02.13.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 13:11:39 -0700 (PDT)
Date: Tue, 3 Sep 2024 04:11:35 +0800
From: Zorro Lang <zlang@redhat.com>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH v2 0/4] fstests/fsx: test coverage for eof zeroing
Message-ID: <20240902201135.c6llddmhrkbiuk7y@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240828181534.41054-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828181534.41054-1-bfoster@redhat.com>

On Wed, Aug 28, 2024 at 02:15:30PM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's v2 of the patches for improved test coverage (via fsx) for EOF
> related zeroing. The most notable change is that the discussion on v1
> uncovered that some of the existing fsx behavior was wrong wrt to
> simulated ops, so patch 1 is factored out as a standalone bug fix to
> address that.
> 
> Brian
> 
> v2:
> - Factored out patch 1 to fix simulation mode.
> - Use MAP_FAILED, don't inject data for simulated ops.
> - Rebase to latest master and renumber test.
> - Use run_fsx and -S 0 by default (timestamp seed).
> v1: https://lore.kernel.org/fstests/20240822144422.188462-1-bfoster@redhat.com/
> 
> Brian Foster (4):
>   fsx: don't skip file size and buf updates on simulated ops
>   fsx: factor out a file size update helper
>   fsx: support eof page pollution for eof zeroing test coverage
>   generic: test to run fsx eof pollution

Thanks for updating the fsx.c, fsstress and fsx are important test program in
fstests, it's always warm welcome improving them :) I'll merge this patchset
after a basic regression test.

Thanks,
Zorro

> 
>  ltp/fsx.c             | 134 ++++++++++++++++++++++++++++++++----------
>  tests/generic/363     |  23 ++++++++
>  tests/generic/363.out |   2 +
>  3 files changed, 127 insertions(+), 32 deletions(-)
>  create mode 100755 tests/generic/363
>  create mode 100644 tests/generic/363.out
> 
> -- 
> 2.45.0
> 
> 

