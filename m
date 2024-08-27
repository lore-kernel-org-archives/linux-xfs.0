Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DE33C08A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 22:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724796215; cv=none; b=X7o3vA17DGew461FwaVUqef8ZEtoiiQJIUt9LsioJhP+M+VsOB39OodQukHhgERFKvO2rO5u1li2AAVlgWWpSaU5MWaZFTfXHArucED6nmoZusybA1ToAHYzpf5USw2VsxQE6KwXw/ZNeJmdf6PxhZArd9F45h/WfmQm3r0WUow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724796215; c=relaxed/simple;
	bh=mLlww9nRHU0RN8k+KjJrM/fGMWW3h54jn1iIBxK8nvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ekHsJwwnFh3YD8N9Jb1vqHN3CC4S6tepAMcH2OWM2ZlJHjfR64uccjUYMFL0TKYvq7l6fhYtqoCzSqivAjkLgL6gE3grxTToragpzYkfuK4WD7mI1lk9h310NjBeII54pbnukAkCviOInuUvnupMw2n5Rzm7LXPhtASay4fzv58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=W+yxMLHN; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="W+yxMLHN"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7141b04e7b5so3745011b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 15:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724796213; x=1725401013; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BEXZ/7IkewqzyCV2cZYUBKCf+tm7qlJGwqZY4TyV+RI=;
        b=W+yxMLHNqs+hsvsoGwUfnT/SUAZSVy9YYmrUJxhDdcN0levE0Y5DXFq4rnNry44DEy
         vUej4BeSDpVaZT2Hg78Z7dhQa+0UHA3Gwsz+ly+vYUAhd+wUrwovhCOaAXQAynT4LZXw
         Y0QjyfEdPvw1bJG1g78SNp21D0Ah/uF+snq0Onw+uH2P2dJJt6OL/yWzI7vdPk2J5S1h
         lsOKePwUPXuicdbEEHnyGL/cQ2O1+NFMVWhM4Wd/Hjke8AJjzXBKM1YckHlhEm0NKC3b
         eATsumnSJTKZfHtlGyh4UQFY2TfkFjf8nZB9+gMqxyQu8sJ/npmAQwcWa50/4867IKA7
         3Xdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724796213; x=1725401013;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEXZ/7IkewqzyCV2cZYUBKCf+tm7qlJGwqZY4TyV+RI=;
        b=SdjL9XIhuuSOZ4PjlIHKEWTmUVMKxIF/saUhnMbOR3fv5NtfE0czYmSIM/bhUBDR0P
         iKHWUvZYp0r8ac0FOJwZdAj8CmtMWZjwfcJlHEo5SGgV32dE8e9UejtmTlgot76cA4Nt
         ZRn2SOiuZmsOf+4aTZs6r71AO4ulseCTnNH6oqyqNutPx7jEwcsh1kahFKwD3FDSqL9U
         c34RwoTQmWacRNYDqFp8HxzXkQoLKee4SUHMYTbOPJ1hJNq/o5meo2HBkCIlhPIsDp2/
         0Ad+FMCKklESP7KZaa7T153EpSL5ZRIw4UpM6cv4Lk2P4sxeE4iD1P85YBBaUrusNvyL
         K8zQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUE1ukoTq2cbFiZ0kkiq4+dSDayAw2QctkWNQTOSNwRcNQJs4OZ2M5rW6DddAzuzr8cbtgPkScEto=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww6t1WFsfto/Fs7NfwqRdSXs68vLUDOZhgtsxGtfIewuK5MNqn
	8Pf4osi9o/tNR3PB1W272lCilrqG33u/nbxPFNZoOVgsJl47gqmh+3z6U7CjBD4=
X-Google-Smtp-Source: AGHT+IEE/0f5HINArVXcCqoBoXuBBOAnar2qiBtM6OIF0s+/RtFucL1HUjeWiI9QvS6/0c/cXSGeFw==
X-Received: by 2002:a05:6a20:d526:b0:1c4:9166:ae3c with SMTP id adf61e73a8af0-1cc89d6ba69mr16062193637.14.1724796213194;
        Tue, 27 Aug 2024 15:03:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714342e09c3sm8975426b3a.122.2024.08.27.15.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 15:03:32 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sj4Hi-00F1J9-04;
	Wed, 28 Aug 2024 08:03:30 +1000
Date: Wed, 28 Aug 2024 08:03:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: fix a DEBUG-only assert failure in xfs/538 v2
Message-ID: <Zs5NMsd5WUn0ksBf@dread.disaster.area>
References: <20240824034100.1163020-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240824034100.1163020-1-hch@lst.de>

On Sat, Aug 24, 2024 at 05:40:06AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> when testing with very small rtgroups I've seen relatively frequent
> failures in xfs/538 where an assert about the da block type triggers
> that should be entirely impossible to trigger by the expected code
> flow.
> 
> It turns out for this two things had to come together:  a bug in the
> attr code to uses ENOSPC to signal a condition that is not related
> to run out free blocks, but which can also be triggered when we
> actually run out of free blocks, and a debug in the DEBUG only
> xfs_bmap_exact_minlen_extent_alloc allocator trigger only by the
> specific error injection used in this and a few other tests.
> 
> This series tries to fix both issues and clean up the surrounding
> code a bit to make it more obvious.
> 
> Changes since v1:
>  - fix build for !DEBUG builds
>  - improve a comment
>  - fix a comment typo
> 
> Diffstat;
>  xfs_attr.c      |  178 ++++++++++++++++++++++----------------------------------
>  xfs_attr_leaf.c |   40 ++++++------
>  xfs_attr_leaf.h |    2 
>  xfs_bmap.c      |  134 +++++++++++++-----------------------------
>  xfs_da_btree.c  |    5 -
>  5 files changed, 143 insertions(+), 216 deletions(-)

Series looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
