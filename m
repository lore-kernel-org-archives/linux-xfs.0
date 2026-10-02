Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E19133A6F1
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 06:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790920895; cv=none; b=ksOfBPqyKQsGE/R8r2N/HnyM7/Y2cuC/gO3CUNx9GtRLx/NFYQt3kvGX1UoIo7r9Cyb6lwxbTMXJ/PR30jqwCeKq5xKp19OvifjekAHJuB8pVvk6+b+1R8WmB5ez9hA6O2G7VdIlOLHD8vY3GB+XZZNQLAv0LWB4j4+cne3/31s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790920895; c=relaxed/simple;
	bh=Zzl8GQMYT4ovWCoYqlximp5PJDij3vOuu7nwytPtyeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHcCamHt3dToEVVG7XMWMEA+7PwRVvJ68VBO/BE10Y0/iCx7XiYtsiB7fOudue2eGsnawargMMT7enTuzBzad+AT3vXOT1LQDGz7hvhaJeBfTqLyxK0G5jhb6LUJbNukwuXdr0MARvS01SMvsc9sHops01dEiyFOnBQPVtaLebw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m0gEpkWA; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0gEpkWA"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2db710396ffso4959505ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 01 Oct 2026 23:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790920893; x=1791525693; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bvzqwuTjdPy91zWm37KIYjrvoEq9pY5JTP911vnp5Bg=;
        b=m0gEpkWAEcEMiKCKafImmMAllmDHp7tF1YDuCG9bClKS817yH6g98rM+ifBUMFhco9
         XU+LXB4EZxHBk/OxGklmcd/mPfq8lqNu43EHcKShAPE+YQ5wLAMAMfCzU6HCaBMNy5C1
         hK8QUh3KmcUNgqOdjJDmllVDIhv8XnBxx0lf1oNSE2xPvjowHGs3CCctLMfRIe31sy7X
         TnY7mU91UYauds2srysRM8X8F/UMCYhKVafRSDxTVDksMdo1YCu+nrcMDh4sVuPvBfjC
         +Z03FQeEgmIyuonYAAueWYBUhHmnwO5+Z2U2QB/SvVTK6V0iaKUguHGe01zFHxllooyT
         ks/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790920893; x=1791525693;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bvzqwuTjdPy91zWm37KIYjrvoEq9pY5JTP911vnp5Bg=;
        b=iDnmvLwQj0RWZpAl8pW61ugp222O5Yh4mmv49WTqp0hfaGJbE6kX+2LunmHN87qZHr
         Gpai/d3aKkohzUCAmHjMg08SAzANtpaYTc4tV+TOoy9NlWAH8f9P72mWfyX0XJzVTOsI
         oPHVWOzzaYSd4yeiEyGqBbg4ut6sukxgMUj8DBv3Pn2FqCGjw7p/4Sy3bARiwbLAQGs1
         s+m0CuvKJRZiwPEDspJ5PLSR6RtC7Yet85dNJlrbvT4HQIu9uzMCEnEb3YbHdkaFnDWD
         tbAigFjjK+ieYkWQrpX+h0Hj0ij1fJMgctdfAl8byOpbqiliQhu37Ubb0iV0YMddKQrf
         tprA==
X-Forwarded-Encrypted: i=1; AKwUvBwrORgMfuBoFwI810Bb+AqGAkOJYtRTn5ElYhLdR0B1iQgDHMmBvV/TwaGkwogvW9661h2d4NXFmgA=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ1cvlTrqGXqIjKbyq40luTOCkDUXnDS5t/CtM1sExjUekYbIoh
	YGqXaVRN5+ARRl/Sb0m0C0hSiji4wYmr4V0Cmr+OsNnG8ux3scXIrMvk
X-Gm-Gg: AYBFou0URqYvFf1SEnxlJkv46oyQUJ6FZcs7ZHUw0htlruzdTdOmEG9+Ic3kpiSUol9
	4TzrmN7pU8J8TWHIGmG6uJKWS+uSL6yJcPVxCP9GjcPY4Dl7gs4eYnAW5e3APJt8drgYNfIHPIG
	7ZE7GD5Z++8hGutqezzmDTElsb3UAlYz3MXcLbhZVojstEC8LB0qjvwwI5+Eac+Mj1BTP1lgYQI
	UDlwgQyjrV1gWuu+0qZsiLTrU2QiKLS3GCD4hnYr+5y5mPnTeqLp29PByLloZCGDpLXz2grKhGn
	2LQP4Ii2UPQ/GZLh9lWGl2wfloXvzamE6vqnqfbwPer45UFdpivCiL1o81CgiZTRDeFNLWSYxz/
	uDHkhvjUP4HEz98c03hdEBPZ+pT9rAuh79e8+Q8VE6OJMsH/wpH2HY8tWGRzaHAIQ+7Yc32yJm7
	AdON9pvFPc10bs2hVtnmt5dyQ6o+aHqIxluTUbW766ntJqBNmTTlS1+aFagJWb
X-Received: by 2002:a17:90b:2644:b0:3a0:f2e1:8af9 with SMTP id 98e67ed59e1d1-3a4f3d124f2mr3588321a91.52.1790920893294;
        Thu, 01 Oct 2026 23:01:33 -0700 (PDT)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc9f721a6afsm519169a12.0.2026.10.01.23.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 23:01:32 -0700 (PDT)
Date: Fri, 2 Oct 2026 15:01:30 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org, codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu, linux-mm@kvack.org, ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] VFS/xfs/ntfs: drop parent lock across
 d_alloc_parallel() in d_add_ci()
Message-ID: <ar9IuknaJqrGoF-j@hyunchul-PC02>
References: <20260929034158.1455429-1-neilb@ownmail.net>
 <20260929034158.1455429-2-neilb@ownmail.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260929034158.1455429-2-neilb@ownmail.net>

On Tue, Sep 29, 2026 at 01:36:01PM +1000, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> A proposed change will invert the lock ordering between
> d_alloc_parallel() and inode_lock() on the parent.
> When that happens it will not be safe to call d_alloc_parallel() while
> holding the parent lock - even shared.
> 
> We don't need to keep the parent lock held when d_add_ci() is run - the
> VFS doesn't need it as dentry is exclusively held due to
> DCACHE_PAR_LOOKUP and the filesystem has finished its work.
> 
> So drop and reclaim the lock (shared or exclusive as determined by
> LOOKUP_SHARED) to avoid future deadlock.
> 
> Signed-off-by: NeilBrown <neil@brown.name>

For the NTFS part,

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
