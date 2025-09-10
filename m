Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6C428EB
	for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 00:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757462773; cv=none; b=X0Fba5HzQzhs2xBPyXKzm5kDS5n7YZ7wzbXjiVjUKkUoJRApAhzQn5rxjudiNzbM/gcTwY5TwuAjQGjMce2MRZoPda8uHwNzurTH/aCcM5dE04eqp6mvE5NntTvYuUfzytaC1jKhkbo623Gp7X3jL9/CwIHwstQ1BrpT7tbvPL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757462773; c=relaxed/simple;
	bh=pj+KQqaL0ztaP+rExxN4WSiJMY4NtBHOsSfrrxdmDNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZamA14ikx+rIHwrlyAmmWEW8XofhWT4xLdTqqxNKosj6dDKwf1FFEOpqe16JLNPB0fgWgTNxgdiuzCFoH/7obgtHepIkAVXfe6AarQQzL20Evadkkf9cux955atlg0y9EWt00+X8JTXoc/D1oU8B4mAWo8mxTzErBgmAkeD5Rio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=dLT1E4XF; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="dLT1E4XF"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24b28de798cso41331685ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 09 Sep 2025 17:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1757462770; x=1758067570; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jb6OhCo34wndb4oX1LjQ0m53Mp1xcnFp6/Faw7eKfzk=;
        b=dLT1E4XFMCwgE7x+GpJO+0cfAMDEKClYzAT5mqnvpXPIc4Eh46MuBJU34T2jfSnN/6
         K5rMUzKf+/Jh9H18qfL7x62YXIfImiwiY3bSCTQRS0dfZmv0+YumEmLiXlyAnEbSNnWA
         aHtqA0UesbS4gWQ9JhQK+ZljRNfBI8cKsyka82UbsWxW/vmQWixpm92fFMl+41UPMXn6
         NDLXeOw+HQzPyivmQiGOyOkeJkbuhJP6yzm3pLyYa4x7+bzHGAbcHrZA4fV8RuML1QVQ
         k0NABBPky/TzqarQuqf3Na9fo9lDaBNlF2LB4fdUTb8uBeXvZq+7KMnKWRDgERN7WAO2
         Iw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757462770; x=1758067570;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jb6OhCo34wndb4oX1LjQ0m53Mp1xcnFp6/Faw7eKfzk=;
        b=erJZ7Krw0aDj8a5sLRt9Z4Nhq8tWfCmwoxXhY/k1HfBgfKrrjJl5EEc4iWhdzZ99rY
         9PTXEyPapHNn51Le6wpNXFdU8uq7Nsx/wAQlubMjqlifwRQQ5GFEX2Iv+Mi6wtpnaw9o
         JdnGLqlu2D9SlpRHrPLXBIqMdbHKxmr+k0uE5lUYYIlcUGqgPobLQWn8Ha62w3B/0FNU
         /Ju7w7kVvp75YTESerFIoAfhdnAiQF0JhMuRmbO324xyzKbeiRCRae8kMAYj17XMOPXf
         YeDVfhyMvX9NvQ9Ub8m4wtKtitWnRQvIiwEqLkJaFsWF2SJLyfpv4E5uKxUDeuQi2nvf
         /x0w==
X-Forwarded-Encrypted: i=1; AJvYcCWidV6og5ngnCle3ikyIOroJ5H2pf6QfTkegQtyRNXIaI2TLfCw53B7a3oZ1j8xIz/BH1nwCI2N9oE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHJhfoX08FSXdoaP0sLi0IZZitZIgz37jOGiSpL/9zA8ejCP7c
	eBo2hvqQDePc0bD8qIKbAHanU5loq1JtilikimpVn4BiUScnwMGqVH6Nu1kDRrzPu9Q=
X-Gm-Gg: ASbGnct6qAEd8YsE4IfMopf/FpLBopiAuk+7jG5QtHg8vDN58nPtrwui+ooXWTq+aVj
	ssvPuzEh3dDpvRAYzg8Mumxk4TIXXaKT5xcUA8fAfzo0VUxO+7cuFf9yzbWwrBDgIbUqYn9c2WM
	pI8fv51oBTzeOVP1djsR1DNOpMaXJOPn2KEub7nSou3M1OuXmHHmkuNxzmQb4Wgr24RtwSH7IUY
	Dwsnc/JIJTqLnZoOXcc3VjoNxa/22UAUsnfPvYj4peO+A3ZSS2Ls4iTWK8PDO9pbqfIXn+54FDq
	gDXuUxV/kwUM5Qz15BxXjHzyr3w48jjgJaOMmmj3me2UDGkOf8LtPT/fSxaoBn1NnA5b6xKn3mR
	wZxKVLjBu+XVnMzG9ozgjS34xxcl3YuCiq2+cUuODucFIWQO9ykvMq0nYt9R9Iph2cc2PqOszsn
	+krad/KdoS
X-Google-Smtp-Source: AGHT+IHNxvapy51meMxJ8w+5eRGODUgSk2PhE2XlKUycWhvMdp+3sHI2Ywy//f7t1LXbTjycHgNNSw==
X-Received: by 2002:a17:902:ef4f:b0:24c:7f03:61cb with SMTP id d9443c01a7336-25170394a4emr196787885ad.26.1757462770424;
        Tue, 09 Sep 2025 17:06:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a2acff3efsm8857175ad.123.2025.09.09.17.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 17:06:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uw8Lf-0000000HUZy-0CmR;
	Wed, 10 Sep 2025 10:06:07 +1000
Date: Wed, 10 Sep 2025 10:06:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Guanghao <wuguanghao3@huawei.com>
Cc: aalbersh@kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, yangyun50@huawei.com
Subject: Re: [PATCH] libfrog: obtain the actual available device when the
 root device is /dev/root
Message-ID: <aMDA7wJ5pO91Fewx@dread.disaster.area>
References: <6fb6fa53-a1e4-19f0-87e9-443975d2961c@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fb6fa53-a1e4-19f0-87e9-443975d2961c@huawei.com>

On Tue, Sep 09, 2025 at 07:29:02PM +0800, Wu Guanghao wrote:
> When starting a Fedora virtual machine using QEMU, if the device corresponding
> to the root directory is the entire disk or a disk partition, the device
> recorded in /proc/self/mounts will be /dev/root instead of the true device.

How does this /dev/root situation occur? My fedora VMs
show the real root device and not /dev/root in /proc/self/mounts,
so it's not clear to me why /dev/root is being reported here?

This smells of a custom boot sequence that is mounting the root
filesystem on a temporary initramfs /dev/root node (which then gets
removed once the initramfs is done) rather than using pivot_root to
move the real root fs into place once the real device nodes have
been initialised and the root fs mounted using them... 

> This can lead to the failure of executing commands such as xfs_growfs/xfs_info.
> 
> $ cat /proc/self/mounts
> /dev/root / xfs rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
> devtmpfs /dev devtmpfs rw,seclabel,relatime,size=4065432k,nr_inodes=1016358,mode=755 0 0
> ...

> 
> $ mount
> /dev/sda3 on / type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
> devtmpfs on /dev type devtmpfs (rw,relatime,seclabel,size=4065432k,nr_inodes=1016358,mode=755)
> ...
>
> $ xfs_growfs /
> xfs_growfs: / is not a mounted XFS filesystem
> 
> $ xfs_growfs /dev/sda3
> xfs_growfs: /dev/sda3 is not a mounted XFS filesystem
> 
> $ xfs_info /
> /: cannot find mount point.#
> 
> So, if the root device is found to be /dev/root, we need to obtain the
> corresponding real device first.

IMO, having a bogus device in /proc/self/mounts output is the
problem that needs to be fixed here. Working around a broken
/dev/root device in every userspace utility that reads
/proc/self/mounts does not feel like the right way to address this
problem.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
