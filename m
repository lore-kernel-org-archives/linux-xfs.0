Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766234ABBB2
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 18:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790014064; cv=none; b=C3I2srQbvBB0LliZwCH0tzyY8ZUWGmjcOrHy7n0Dw4DdFMBGa2S7UUxxwI3x6/FKR6PqdOdSwgXxA1i9nO9rJNA6TjdUZskQBzoK8PJH4Z9/tPkty1w8z5KsmIynFcZd3TtbhV8cVKtOonvhGPTSYLMXVZb6Pa+sxMbH2EYdw2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790014064; c=relaxed/simple;
	bh=+T0UsfU3X4YjOf5Y2LRAUCr1O+PNBgrbP5i3+Ui+Rro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZESp1BCLh4AiRXFwvjKxraFGOyUsWxJdGdx39sTO8lNnKeDcoYAzAG+009T0kHQxJuuUqJDFxC2OUZHRv+ssmT/ygaKlvzze9kpXPWnw9fyQBYoovZKpYQMT1tP8Sk4HFJSiAJyaGrGGul2o1l9Hn3FsbRF3PVzhbgolWJu7cCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C6zMeiQp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C6zMeiQp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790014061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ddb+dnisDk6IFrtpOihrh9CoT4KAmSKdN6ihcGxdhtE=;
	b=C6zMeiQpWa4yAcVL3tv3vstlReb2A7H0SM7+4S7R1dLQDNDX0A/FPLk8LovOBHtOdmusKT
	rEu7I44ErYrM4PqkUo8ku+AztpdSf8n6JkQ8cHfZpl/FpOz4MyZQbNhICNxpzA/NYumaGj
	KW8w2Nu6hIb7qNAQdHjBKcWBumvLFq8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-rQ9njAx6OLyzvpB4FR5SlA-1; Mon,
 21 Sep 2026 14:07:39 -0400
X-MC-Unique: rQ9njAx6OLyzvpB4FR5SlA-1
X-Mimecast-MFC-AGG-ID: rQ9njAx6OLyzvpB4FR5SlA_1790014057
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71C611955D78;
	Mon, 21 Sep 2026 18:07:37 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A7F2195604C;
	Mon, 21 Sep 2026 18:07:35 +0000 (UTC)
Date: Mon, 21 Sep 2026 14:07:33 -0400
From: Brian Foster <bfoster@redhat.com>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] iomap: fix error handling regressions
Message-ID: <arFyZbS_pTpplxWw@bfoster>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921083133.2960-1-parri.andrea@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Sep 21, 2026 at 10:31:30AM +0200, Andrea Parri wrote:
> Fix three independent error handling regressions in iomap:
> 
>  - clear the writeback context after a failed ->writeback_submit() call,
>    preventing an already completed ioend from being submitted again;
>  - preserve an iomap iteration error when iomap_fiemap() has a pending
>    extent to emit; and
>  - preserve a direct I/O data path error when sub-block tail zeroing
>    succeeds.
> 
> The fixes have no ordering dependencies and can be applied or backported
> independently.  Each issue was reproduced before and after its respective
> fix.
> 

These all look reasonable to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Andrea Parri (3):
>   iomap: don't resubmit an ioend after ->writeback_submit() failed
>   iomap: don't lose a fiemap iteration error when emitting the last
>     extent
>   iomap: don't lose a failed direct I/O bio's error when zeroing the
>     tail
> 
>  fs/iomap/direct-io.c | 11 ++++++++---
>  fs/iomap/fiemap.c    |  8 ++++----
>  fs/iomap/ioend.c     | 10 +++++++++-
>  3 files changed, 21 insertions(+), 8 deletions(-)
> 
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5
> -- 
> 2.53.0
> 

