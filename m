Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855B83DDDAD
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773845017; cv=none; b=OZngAHOx9CrJC2AlWuu6+PWiYEncn1cprIhqGkeAe05dcEpvcqauQY3RaIWoZ7IDp4k4K8plNmbr/nE20FPHYg0rV9kopRvy3Edt6bHMiJxW2CLZzUxCm9k+DXe9jEnFhiL8JGnq0FjdPZpjYTa6U2jfS9uCj48SdwE4xvlJ9zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773845017; c=relaxed/simple;
	bh=dG9vq7oddD2bvNMebFtSbZtYdvojnAgBogYqYR3B88Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fWyYDVM/PUN7J/k6tYMImu3HdLIS546Xvq42ATs49uf+YP03lU57AXftLK0uPkW3PQL9tuMyy8/ybIIe6D1dsH/TxUHK+xKTb499SAEdVFcXXIpHXYWpHJPAJDNlJeEfmBUoGJKYKTT/V6gcydkLjZVFsqGXNF+aujbVluoS95U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJBItg1d; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJBItg1d"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a871daa98fso52716685ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 07:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773845016; x=1774449816; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rFHoJF7IdM8JdCtHdsURCE/J8sW/qd9UjP/TVMBMarM=;
        b=nJBItg1dxmS6SahWoUogomFqsTW9cjN/3FZzs4GSuFcZJZxXliuVuLkYmmIV4Zrwnf
         XS3eGjEg2o5AN7ICnrA7mDcvC/TcO3Pp2rpamDuNGD+DDI2hP0bhMve4wnEAToA6nNjE
         vHXbUTwqScNs7wB5YgvG3RpyE4UEjTfNZ0ZB+kPmtnOicyz6+YR5RnlXHtlQbLDVaCJR
         7OCYBrYWKjhxso5GiRIJHaLTiC1Qox7TP0JvsxX0VIjZR1tFL2/oZtbMu1txdSVQhXSv
         xwz+BtN038wmtoAxZDpBwGg3WS/EYuIOnYMbHz2HjSWrPgqV4KGwQ+sXVPAtp/NLnWzB
         DT+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773845016; x=1774449816;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rFHoJF7IdM8JdCtHdsURCE/J8sW/qd9UjP/TVMBMarM=;
        b=S4CsmOend5uAqBneUrvRBU1xtaDic0qOk8tbQCZG7likdDcDQvklMfdMaSO+zM4uwh
         cBTxDyzC1w1UwcCriT2FlClxXOfHMf1LSWXsyBP5OxbOlCJz9orPSvMA6a/BMNop7G2g
         ifXBUp45zJ/2w9+n9VjGCnshqPzXJh/QQE2pzbMYwsQLU9PLznkc48o88ICf9bmaGT6O
         83tdrtfWxhTg8r8G122CojGBt4sfxJ5LCxPYOYmdcz/+/44veDlA8nGv6uxTMobe7bAT
         nN+qt/OlVQlQz4Jn+dsk5Lh1uJfU2vRGKl5zfuotdjJFGxBotGPMwe+SlFx42MJzu43B
         8b9Q==
X-Gm-Message-State: AOJu0YwEdz2YjOW3nkSgnZ1/CAAIjspSL+Zp3IPMN2/ybEw9Xp2VZNHl
	Cw8WcLCilxb20AJmqmGrxuSHL1Wka+KKxvTwKPwSyWt6qR4ZLdnUe2H7
X-Gm-Gg: ATEYQzw+nmcqAj8IagiSuRwXKIXVIX7pPhAzA9ZQQpdn2JtZbN3Ss4Qo77Igmgv3xBb
	jk6c6ZCXiD1boYTigFzMlSEEwjRBxdTcgCASinX4qd6j15EMV2JA1jSCLG4uUvtaI/ZS7zIjTxt
	cwEzzyHYic30kYxs2Q2xRNXff3xgOX4O9br5fudNwDY7mjZFVC3FwEJcHneIoP82H/s3iUM7+4y
	NSj+Ft/4kT6uAbyVCwddIVjefkaT2rdMd+ZeS0dCKHUhxiGQ9fqwc2wfoap+M3c1G6IYp5o2JhY
	8EwuDYB67AA+kXa/XAW0j3cOala+UEk3UEfaQZBm+4K2w1hg2ePIpe7GDyLKs0rva6jqenWl8dI
	x4gNuU0bPkIM6MY7YtYLUq7UhKWMn7mZ8WcTlaVP3caP+Gz/+WgAh/PDROnAoSU8IGG8sWGUefQ
	4yx/bR8yY1gH0XVPk0Osoj9LPQOBOgXan2
X-Received: by 2002:a17:902:d541:b0:2b0:5903:13fe with SMTP id d9443c01a7336-2b06e325bb6mr37485355ad.12.1773845015850;
        Wed, 18 Mar 2026 07:43:35 -0700 (PDT)
Received: from [192.168.0.120] ([49.207.193.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e5f0e8dsm27157915ad.51.2026.03.18.07.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 07:43:35 -0700 (PDT)
Message-ID: <0e20766d-5855-4514-a6bd-49e32261c162@gmail.com>
Date: Wed, 18 Mar 2026 20:13:28 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 0/4] xfs: Add support to shrink multiple empty rtgroups
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>, djwong@kernel.org,
 hch@infradead.org, cem@kernel.org, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 2/19/26 11:33, Nirjhar Roy (IBM) wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
>
> This work is based on a previous RFC[1] by Gao Xiang and various ideas
> proposed by Dave Chinner in the RFC[1].
>
> The patch begins with the re-introduction of some of the data
> structures that were removed, some code refactoring and
> finally the patch that implements the multi rtgroup shrink design.
> We can remove only those rtgroups which are empty.
> For non-empty rtgroups the rtextents can migrated to other rtgroups
> (assuming the required amount of space is available).
> I am working on the patch series [2](by Darrick and
> Dave) for completion of the data block migration from the end of the
> filesystem for emptying an realtime group. That will be a future work
> after this.
> The final patch has all the details including the definition of the
> terminologies and the overall design.
>
> The design is quite similar to the design of data AG removal implemented
> in the patch series[3] that I have posted earlier.
> The reason for keeping [3] on hold and posting this patch series is
> that (based on the discussion in [5], [6]), realtime devices won't have any
> metadata/inodes and migrating data from the end of realtime devices will
> be simpler. On the other hand there are challenges in moving metadata
> from regular AGs especially inodes.
>
> Please note that I have added RBs from Darrick in patch 1 which was
> given in [4].
>
> Instructions to test this patch:
> $ Apply the patch for xfsprogs sent with this series and install it.
> $ mkfs.xfs -f -m metadir=1  -r rtdev=/dev/loop2,extsize=4096,rgcount=4,size=1G \
> 	-d size=1G /dev/loop1
> $ mount -o rtdev=/dev/loop2 /dev/loop1 /mnt/scratch
> $ # shrink by 1.5 rtgroups
> $ xfs_growfs -R $(( 65536 * 2 + 32768 ))  /mnt1/scratch
>
> I have also sent the tests.
>
> [1] https://lore.kernel.org/all/20210414195240.1802221-1-hsiangkao@redhat.com/
> [2] https://lore.kernel.org/linux-xfs/173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs/
> [3] https://lore.kernel.org/linux-xfs/cover.1760640936.git.nirjhar.roy.lists@gmail.com/
> [4] https://lore.kernel.org/all/20250729202632.GF2672049@frogsfrogsfrogs/
> [5] https://lore.kernel.org/linux-xfs/aPnMk_2YNHLJU5wm@infradead.org/
> [6] https://lore.kernel.org/linux-xfs/aPiFBxhc34RNgu5h@infradead.org/

Hi Christoph and Darrick,
I am preparing a v2 incorporating all the initial review feedback 
received so far. In parallel, I am looking into adding shrinkfs support 
for zoned XFS  -  however, it would be great if we can discuss the 
current design and get a full review of the changes so far to get this 
work (shrinkfs for non-zoned realtime groups) into proper shape for the 
upcoming merge window first and submit zoned XFS shrinkfs support 
separately afterward. Do you think that make sense?

--NR

>
> Nirjhar Roy (IBM) (4):
>    xfs: Re-introduce xg_active_wq field in struct xfs_group
>    xfs: Introduce xfs_rtginodes_ensure_all()
>    xfs: Add a new state for shrinking
>    xfs: Add support to shrink multiple empty realtime groups
>
>   fs/xfs/libxfs/xfs_group.c     |  18 +-
>   fs/xfs/libxfs/xfs_group.h     |   4 +
>   fs/xfs/libxfs/xfs_rtgroup.c   | 105 ++++-
>   fs/xfs/libxfs/xfs_rtgroup.h   |  31 ++
>   fs/xfs/xfs_buf_item_recover.c |  25 +-
>   fs/xfs/xfs_extent_busy.c      |  30 ++
>   fs/xfs/xfs_extent_busy.h      |   2 +
>   fs/xfs/xfs_inode.c            |   8 +-
>   fs/xfs/xfs_mount.h            |   3 +
>   fs/xfs/xfs_rtalloc.c          | 824 +++++++++++++++++++++++++++++++++-
>   fs/xfs/xfs_trans.c            |   1 -
>   11 files changed, 1023 insertions(+), 28 deletions(-)
>
> --
> 2.43.5
>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

