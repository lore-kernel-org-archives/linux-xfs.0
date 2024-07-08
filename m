Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E98776F1B
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jul 2024 10:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720433690; cv=none; b=MrrTnsOOz6nsJKYT6OwbPMlgzLF3UWLHq7PqtnX2bo/5ut6LqsJGFh0jYx34U+c+Ct0Wm2eCH4rQCWctEVYc4KlczxoEoxD9ZEMaTI/juE0IzWao5QBrwpCDirdfphPFNeKa4q6t5lgZxJ+VZ8US3zYCjc3AF1++4qhSIiARyRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720433690; c=relaxed/simple;
	bh=SkWEHtSDPfXsyLQ1VAkX/uYzEH+1I/9hiZephDJ7+KI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0PoO9RHAch5PkFPDX81ZBVqH2kjeFxk2o8iibliYCAtwrXokuELVa2AMqB2aDgnJ857k+li69496FarkDef7wLh92qhjI47PwRap6gl/joe8pSii9E21kkKqOz8+6eIqfULzHI/IL8Hoh05UBYwUB6rYxS3KkBiAucb+otBxHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ttOvH8Ce; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ttOvH8Ce"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-24c9f892aeaso1823731fac.2
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jul 2024 03:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720433687; x=1721038487; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8o4FeBTkQydEY+E5Ft9ergtCpLoarVxrr2b76p2ARdE=;
        b=ttOvH8Ceg7X7g8zwWCa5c2nAM8Mf5a9A6s7VILm8t+Zb/ug2x24s79sKi7UOx82QvE
         P7SPRuQoYYbDomxDfRiM8iDjfeHl0O9Gltw9Q28TqxeYDu6JX+TJrVPoJjHrtnmRQCLQ
         lEPq7KQV5/lwA9cwYI7v9uY3pTZCKXaiMGzMfSFWK0QQKVgYxTFBb5RlAX6P8wbcQzUh
         3wPfN3K2AhOGUltm1T93z/gLb+N2PBy2VsmT05gTBTErFPvhnD3Rib3u7VWTbiUss+sU
         qjqtlcGWAPsNx1+Itn/O9GqQwuYgE1dhcnZy5C605FS+L/V6X8pLJNLnEcZWR1qvhdi8
         ordA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720433687; x=1721038487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8o4FeBTkQydEY+E5Ft9ergtCpLoarVxrr2b76p2ARdE=;
        b=i2o47tgRLMxUWsKxeZ8Y+iUO1qfghxxtg1mL0byd65KUZnpk42qOwFiIJ8bHJvYEi2
         n7lcNVi7CMPzo6l1eSkgehAFBM9nWBCj23JafQ24RENu4YsybWd+WVV2M6BqrAfT5mWw
         CpZU6lkwmu6U63ftjPAzG/94Mn3Nvdin3AULGbR7TixHcYpJujnFUn3kIl4tF7I2ejKd
         iEqGFcTCmjQLo79Gp3cDETqi3gWB8Zft6TRfO4jG3kwMYH43JdPjzXCXxnI6JS4zvq1t
         p/UiVWk3O9L87rKCaGjHyQkp0yPYDrj2/jRM7f/lYxcqk7f9jnzKRwQKz1Tk6q5LFhOm
         DfKw==
X-Gm-Message-State: AOJu0Yx+P08Vt5B7AJ0IgCeM4LGKq0plduPQEq9OKYtCGiIyGnKTkbzT
	fXMp5wrNB5l1wgpGCWn6u4j1h1KQixYJ3HOKRnYSY+TeXcXoudjw/GUewgZGDec=
X-Google-Smtp-Source: AGHT+IE/zS6WEa6AYR9d5DtByxCxkrGdmxNX7wGLzq43cS2MXgaaIKi+XNyuyDfoV7t+ibOfdSJHMw==
X-Received: by 2002:a05:6870:5b81:b0:25e:15c1:257e with SMTP id 586e51a60fabf-25e2b9de8cfmr11531140fac.6.1720433687408;
        Mon, 08 Jul 2024 03:14:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b03a9d996sm7596909b3a.96.2024.07.08.03.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 03:14:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sQlOO-008PAB-1z;
	Mon, 08 Jul 2024 20:14:44 +1000
Date: Mon, 8 Jul 2024 20:14:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: Alex Shi <seakeel@gmail.com>
Cc: linux-xfs@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: xfs deadlock on mm-unstable kernel?
Message-ID: <Zou8FCgPKqqWXKyS@dread.disaster.area>
References: <e5814465-b39a-44d8-aa3d-427773c9ae16@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5814465-b39a-44d8-aa3d-427773c9ae16@gmail.com>

On Mon, Jul 08, 2024 at 04:36:08PM +0800, Alex Shi wrote:
>   372.297234][ T3001] ============================================
> [  372.297530][ T3001] WARNING: possible recursive locking detected
> [  372.297827][ T3001] 6.10.0-rc6-00453-g2be3de2b70e6 #64 Not tainted
> [  372.298137][ T3001] --------------------------------------------
> [  372.298436][ T3001] cc1/3001 is trying to acquire lock:
> [  372.298701][ T3001] ffff88802cb910d8 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_reclaim_inode+0x59e/0x710
> [  372.299242][ T3001] 
> [  372.299242][ T3001] but task is already holding lock:
> [  372.299679][ T3001] ffff88800e145e58 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x4d/0x60
> [  372.300258][ T3001] 
> [  372.300258][ T3001] other info that might help us debug this:
> [  372.300650][ T3001]  Possible unsafe locking scenario:
> [  372.300650][ T3001] 
> [  372.301031][ T3001]        CPU0
> [  372.301231][ T3001]        ----
> [  372.301386][ T3001]   lock(&xfs_dir_ilock_class);
> [  372.301623][ T3001]   lock(&xfs_dir_ilock_class);
> [  372.301860][ T3001] 
> [  372.301860][ T3001]  *** DEADLOCK ***
> [  372.301860][ T3001] 
> [  372.302325][ T3001]  May be due to missing lock nesting notation
> [  372.302325][ T3001] 
> [  372.302723][ T3001] 3 locks held by cc1/3001:
> [  372.302944][ T3001]  #0: ffff88800e146078 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{3:3}, at: walk_component+0x2a5/0x500
> [  372.303554][ T3001]  #1: ffff88800e145e58 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x4d/0x60
> [  372.304183][ T3001]  #2: ffff8880040190e0 (&type->s_umount_key#48){++++}-{3:3}, at: super_cache_scan+0x82/0x4e0

False positive. Inodes above allocation must be actively referenced,
and inodes accees by xfs_reclaim_inode() must have no references and
been evicted and destroyed by the VFS. So there is no way that an
unreferenced inode being locked for reclaim in xfs_reclaim_inode()
can deadlock against the refrenced inode locked by the inode lookup
code.

Unfortunately, we don't have enough lockdep subclasses available to
annotate this correctly - we're already using all
MAX_LOCKDEP_SUBCLASSES to tell lockdep about all the ways we can
nest inode locks. That leaves us no space to add a "reclaim"
annotation for locking done from super_cache_scan() paths that would
avoid these false positives....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
