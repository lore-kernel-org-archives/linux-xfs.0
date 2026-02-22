Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EC035D60E
	for <linux-xfs@vger.kernel.org>; Sun, 22 Feb 2026 23:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771803426; cv=none; b=J1Aic65848UCQ3MCcXWtHSPXyHrz9hgma9kBnniXH8fIkn5HPekooK/5mOnI36YwvI2mOn5NTNQZCFiV3FJ5AhseDRVcnWdZHrTCXIpi/t1QphiJFVPNkd8fQ1cZw1QbwH6ffmD9D6cB8YbxhWQG/cK0rDwe8cUgkofD7l6farY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771803426; c=relaxed/simple;
	bh=c5Kg3KMnsJS3sTik9bjBjDGurmNUp8RGzyPPFfEFmWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lw5SF/JoqbI4c1dTaBYZHVB/UKX4TqWXMoapWyLFX/6j9eChwBeDearu2QqNfshYzo8Q+w7J2ehYxxYiRu2LWQ8oMFvfOU/saHazNAq9qemJWrQwbcYkxfQ7ySalu+rUt5ieiqmVdHXTa7Vk5qaJB2ZS7J4nXX9FZ+6xk/uhLag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jmzNs2So; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jmzNs2So"
Date: Sun, 22 Feb 2026 15:36:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771803412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ybdV4563dtS4ZOEJOasBlah8k8g9tI2C0k/Ph+ecmnQ=;
	b=jmzNs2SoD9+RFFddxf4oFJZOTAgJDRPiWKMADSlzPRz1xaIQL6NpjmJr516CT11xADF0Lk
	8AEwwQXmBGTiFzH4ztm4iliD7eR1HfJc1g2gRrN+/cHmTeEDQp28M0hMQcCtLw2vrNgx+D
	PwW6nbXK22WWy2SyFObMjPIkJAF6vIA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Carlos Maiolino <cem@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Ritesh Harjani <riteshh@linux.ibm.com>, ojaswin@linux.ibm.com, Muchun Song <muchun.song@linux.dev>, 
	Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Hao Li <hao.li@linux.dev>
Subject: Re: [next-20260216]NULL pointer dereference in drain_obj_stock()
 (RCU free path)
Message-ID: <aZuR6_Mm9uqt_6Fp@linux.dev>
References: <ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com>
 <aZReMzl-S9KM_snh@nidhogg.toxiclabs.cc>
 <b4288fae-f805-42ff-a823-f6b66748ecfe@suse.cz>
 <ccdcd672-b5e1-45bc-86f3-791af553f0d8@linux.ibm.com>
 <aZrstwhqX6bSpjtz@hyeyoo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZrstwhqX6bSpjtz@hyeyoo>
X-Migadu-Flow: FLOW_OUT

On Sun, Feb 22, 2026 at 08:47:03PM +0900, Harry Yoo wrote:
[...]
> 
> It seems it crashed while dereferencing objcg->ref->data->count.
> I think that implies that obj_cgroup_release()->percpu_ref_exit()
> is already called due to the refcount reaching zero and set
> ref->data = NULL.
> 
> Wait, was the stock->objcg ever a valid objcg?
> I think it should be valid when refilling the obj stock, otherwise
> it should have crashed in refill_obj_stock() -> obj_cgroup_get() path
> in the first place, rather than crashing when draining.
> 
> And that sounds like we're somehow calling obj_cgroup_put() more times
> than obj_cgroup_get().
> 
> Anyway, this is my theory that it may be due to mis-refcounting of objcgs.
> 

I have not looked deeper into recent slub changes (sheafs or obj_exts savings)
but one thing looks weird to me:

allocate_slab() // for cache with SLAB_OBJ_EXT_IN_OBJ
	-> alloc_slab_obj_exts_early()
		-> slab_set_stride(slab, s->size)
	-> account_slab()
		-> alloc_slab_obj_exts()
			-> slab_set_stride(slab, sizeof(struct slabobj_ext));

Unconditional overwrite of stride. Not sure if it is issue or even related to
this crash but looks odd.
