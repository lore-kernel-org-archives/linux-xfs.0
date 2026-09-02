Received: from mta1.migadu.com (out-133.mta1.migadu.com [95.215.58.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7DD4A9D45
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363443; cv=none; b=DluJvhg4iLif/nuHoagHJ2DrGoVIx8UHMKZASLEqOZtYBEHxpIxTCWp4a/hQ4iZg9l9myR/I4+W4CbiSodfoYPu+K8CuxtexzSIxry8JYvZ/xHg996VBJ4oc1ky22gy1poqrj90i2OnSxIfXp7kKHfXeYwLeP+zR/ZclIk8AyJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363443; c=relaxed/simple;
	bh=es/Uhjm8/c1u5ug4tjOA3nWWmmojdUXhgoapLjGTZa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kuu2tPPaBtnRD6qNy7hghufi95vAIUndOFj5/dwDenevQrgWLNiozYJ90dooIzzS4bESm1KVlMXbB9tqu94Od9rxMjlAn0XtasgM2VvQEH3py625aMm67MHOs9sUw0agIx1eyYfkJbdb15ThYHXNVveOo+UAeD78S9HPGGYHfFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a7q4GQL8; arc=none smtp.client-ip=95.215.58.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a7q4GQL8"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=es/Uhjm8/c1u5ug4tjOA3nWWmmojdUXhgoapLjGTZa4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363427; v=1; x=1788968227;
 b=a7q4GQL8xiDQwqXLM6Un6pDy1Sd5mVjnfuVQ2Jjcco3TvjqpE3EvWmUDFhI03fxUAhcHFjKt
 XLJgus0CHdSsvQ40iZRg3cRGBSK10pne+6PkfUaOhnRfnHrRAG1LqXfNm8XXUROf+vYgsUjeAjE
 Y1aMXzpvzR3geMDPWxFTC5dQ=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e468d896e5d8b7d1;
	Wed, 02 Sep 2026 15:37:07 +0000
X-Mizu-Trace-ID: e468d896e5d8b7d1
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:37:03 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, 
	qi.zheng@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: replace PF_KCOMPACTD flag with kthread_func()
 check
Message-ID: <aphCit_ohMGmCe-2@linux.dev>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-5-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-5-wangkefeng.wang@huawei.com>

On Wed, Sep 02, 2026 at 09:16:53PM +0800, Kefeng Wang wrote:
> PF_KCOMPACTD was introduced by commit ce6d9c1c2b5c ("NFS: fix
> nfs_release_folio() to not deadlock via kcompactd writeback") so
> nfs_release_folio() could detect kcompactd context and skip
> writeback.  The flag is only consumed by current_is_kcompactd(),
> whose sole caller is nfs_release_folio().
> 
> Replace the flag-based check with kthread_func(current) == kcompactd,
> freeing the 0x00010000 PF flag bit.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
