Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2871EEA47;
	Fri, 13 Jun 2025 15:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829118; cv=none; b=W7d2IDVTsziDTXBstuxsEQqnamoTYSpKKUGisn6S9+rk4xmb11JOe+1LI77bN38aVrb/Xs2UfQiWaiKP7g4V/SdmidnWv20TlzDmpmVgYHoB1BDswG0SJFmEuUXRUfYb3pQl4f9qioAvXWUCfB4/flfpM/NvMGAr+abtFnqjJw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829118; c=relaxed/simple;
	bh=6AwxwhBCG0Df0FWNauAA4idiya3H5Vas5N8OdGukm6I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MwCE6ZC1loqehDKgIJB9ybUtBTpcw+B0U3Ljulr5VsZEVil1Rde33P6EMDFnA+DRX1Px0UWxeLEJEDRabJixKF/VMcELhGUT4C6hUT8i1Pv0KJmXbihxl2FdSd8COjdMtpKHhhoLxlt15y7V4IjYN026xQDLCfDT+8+FNrNXFbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1E911D6D27;
	Fri, 13 Jun 2025 15:38:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id A94AA6000B;
	Fri, 13 Jun 2025 15:38:32 +0000 (UTC)
Date: Fri, 13 Jun 2025 11:38:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Carlos  Maiolino <cem@kernel.org>, Christoph
 Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 01/14] xfs: tracing; Remove unused event
 xfs_reflink_cow_found
Message-ID: <20250613113831.543bdd22@batman.local.home>
In-Reply-To: <20250612212634.746367055@goodmis.org>
References: <20250612212405.877692069@goodmis.org>
	<20250612212634.746367055@goodmis.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A94AA6000B
X-Stat-Signature: qswdbtfoaxob59gfeu4nbx3jwja9sb5r
X-Rspamd-Server: rspamout07
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18kA1SAKVNriBHxWFxLzgcgkUwxsUbHo8E=
X-HE-Tag: 1749829112-723801
X-HE-Meta: U2FsdGVkX1/HfT2egRL7wxjDXIWW81tfX3vchuhujOFBty9nFqmzWkkFQ7UrX6helIh/QIzIBOuD9+1R/VLi5ujIp5SrgOC3UR8MYrXrsTVefaV/eGK9QarOF21LqWfz2wtu2zUNGPlvB2rODIRxUoh+uENwP3zyUmJWds+x+V6HeFImzlojCFh78mCLhQ0dbecLgeSaRZb4HGxgLfNeLtfnqzZwPVpYTe02wqXv2b/3Jkyo6eVq3Hgs49wWG0EQZd5lfffIBceataOA9fM3c79PY7icpTN1UqU8wHqPvJkRDV+lSBr/79Rw++brqTxIsbdHNrg1wwqhiHyfV8rNds8etOTKhpTp5zywgJhkyAHaZY+dyGg1i3BXVzV6FODx

On Thu, 12 Jun 2025 17:24:06 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Each trace event can take up to around 5K of text and meta data regardless
> if they are used or not. With the restructuring of the XFS COW handling,
> the tracepoint trace_xfs_reflink_cow_found() was removed but the trace
> event was still being created. Remove the creation of that trace event.
> 
> Fixes: db46e604adf8 ("xfs: merge COW handling into xfs_file_iomap_begin_delay")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  fs/xfs/xfs_trace.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 01d284a1c759..ae0ed0dd0a01 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4242,7 +4242,6 @@ DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
>  
>  /* copy on write */
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);
> -DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_found);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
>  

Hmm, it looks like this one is still used. I'll drop this patch.

-- Steve
