Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BEC4BE437;
	Wed, 16 Sep 2026 22:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789598087; cv=none; b=FSG4b7vIDeGuecWl/Otq/BpbNiaemklRIg+s1EQFfC/FOqe1Kw7Ad0edHNuMKYvA3PT/aipXw4ARJATUdVk76AUb7y34vIZbhFVHeO+RmmbvXMg3IvyTCCdO0WJYpD1Csund1v5ohz+tHF3Z3k3ZJM9elZz2nrjUA5bFkpMWro0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789598087; c=relaxed/simple;
	bh=DSLXtCmUhCvUAXIPgXfUK+6z4ENxripk2JSIXAerMtg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ZaHAprvI2LiW4UaLJ49HhdQOd/JbPCT/cylD6nrnn8SMjMoMk/7xOVDIUzH2rXKrHhE6tuEp1zA9wzh9ZhXY4iVYN0oPaPYPFJOdX835heHECK8fmQSjER6S0uMVm6cEkUG2Iny536UykehSt/L47YKn3DWPeH9iTp9lAYFaYeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lYtE7NpR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lYtE7NpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8241F00898;
	Wed, 16 Sep 2026 22:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789598067;
	bh=K5HGV9rZHuGPaUvmcsvJ1HKNnHbuikTZmwdlniM6kvo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lYtE7NpReDeqKVQNw/98ReJ6SxlDMOQ/EcHsikRsCshszDuVl14Mr6Dbg+F3d2Juh
	 PpAR/zm/AEq+CpbMqaoiVt0iwDCwGb4v7MTXNtEEpGiGCKtdWNqr0sImp6J93F747s
	 OhAMWvV3FlxawJoxTSRnhyW9yyLFsFcKYM3sMAlM=
Date: Wed, 16 Sep 2026 15:34:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Salvatore Dipietro
 <dipiets@amazon.it>, abuehaze@amazon.com, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
 david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
 djwong@kernel.org, hch@infradead.org, hch@lst.de,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org, mhocko@suse.com,
 ritesh.list@gmail.com, rvvandan@amazon.com, stable@vger.kernel.org,
 surenb@google.com, willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-Id: <20260916153426.3265e2e152cebb6a8d66373d@linux-foundation.org>
In-Reply-To: <aqq8pWI0u1IZNWHT@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
	<20260910114602.926944-1-dipiets@amazon.it>
	<aqQlUr-1h07G8JWM@cmpxchg.org>
	<8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
	<aqq8pWI0u1IZNWHT@cmpxchg.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 16 Sep 2026 11:58:29 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
> > concerns can be dismissed and then indeed v4 is the better version.
> 
> It looks like a real issue to me, but one that already exists
> independent of Salvatore's change.

So I'm hearing that I should drop v5 and revert to v4?


