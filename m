Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C5F35A39D
	for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2026 03:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776398111; cv=none; b=Q2cBSS6/ASiA6IDktHtA9UO7sX3zDpcBqYm4yQGBVB83aFzW+QV+hCX7M0LwkJofhasQZNJSaKz2uxHHIAeJTeRwYcY+bPKbFQe0tbQKMeg7yfMTrt0y2tmtypQpbKTJe6y0dCtaMxEDruOgbfceumzIvMHDeiNYqA2E+0M+frg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776398111; c=relaxed/simple;
	bh=kWo2dxku9CHGSFB/CWT8ruV748OtwxVoFRUxuaozMXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8rNUO9W0tQBRUmsLr3qnxjLnRXL531bW0/0CaHQN6fS2cCsvRHa64VmvIsHBu8pX+gtlqQfZ+VUBpJE6mWO8KLMz9ARrzCq+IC1I9myGAoY29m+9NgM/Rqy9bXFeoWJcPj034pRqnkC2gclQJ1R38yX+JkpGH+0RMEXhlj49Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Op8m8Qcl; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Op8m8Qcl"
Date: Fri, 17 Apr 2026 05:54:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776398107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dwa9Zzv5iIZJofmNxLAczBJ8wqidHriBciYAKIZ9f1E=;
	b=Op8m8QclxRKY0piahVBmp+0HeLdeSWMuFlErJUW24Gyx7omLw8WTSbgGqHdlLbNkqlviDI
	TuphMzWZiZFQe08p9jtxw+2RNHGoo7P1U7+/zAncg9+1O5PIFl/EG9VnppqL8RsKV74t2I
	nfsykl1krm8kz5hIt6U3hH7PjXrzsd0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <q5ksnnwwnjqyvzqrlx5u2zzsq2rs4uoirn4xvt6dfrdck7df5e@pxyaupfbdb3u>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT

Thanks for the patches.

> The implementation of write-through combines the buffered IO frontend
> with dio backend, which leads to some interesting interactions.
> I've added most of the design notes in respective patches. Please note
> that this is an initial RFC to iron out any early design issues. This is
> largely based on suggestions from Dave an Jan in [1] so thanks for the
> pointers!
> 
> 
> * Testing Notes (UPDATED) *
> 
> - I've added support for RWF_WRITETHROUGH to fsx and fsstress in
>   xfstests and these patches survive fsx with integrity verification as
>   well as fsstress parallel stressing.

Could you point me to your xfstests repo where you have added this
support? :)
I have been traveling the whole week. I can give the patches a spin in
my setup in the coming days.

> - -g quick with blocks size == page size and blocksize < pagesize shows
>   no new regressions.
> 
> 
> * Design TODOs (UPDATED) *
> 
> - Evaluate if we need to tag page cache dirty bit in xarray, since 
>   PG_Writeback is already set on the folio.
> - Look into a better way to refactor writethrough path by reusing common
>   parts of dio code.
> 
