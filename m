Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0B719D07E;
	Mon, 16 Jun 2025 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750085496; cv=none; b=JdM2riUP2dwE+XdDpoBmSDeDBjLWWHjIKQ7iDgs54COalOR3DD8fPTdj3oJid8u+oTntTwOmfyZFeVmR8zmO6pcTXaWdNyZzgZnzHv1wVawa+7MC+xhwgBww9ASjzhl0apxck5/zKgzEePNJSDIIz++vXF/pfoHTWvWYseG3GDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750085496; c=relaxed/simple;
	bh=tQJikW5Zr1hDct+cq5tbqtDWdDTOPDXt6XW4m1kSBnk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ij6Xr6cDxhzSI8FE1i+seR1eXs5b60lMBLJx5MDDnT7IL6tDy/EC945k320C0QL8U7Y2KyRBrM3nXahq3fTgy04BMib3Qbq+PutC9rHGljweI1C0c561QPL+oGibAWpDe7+Kb1bFM0SWyscybYQ9C/s9YlYoqx0AhtaDzP1enZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8215C805F4;
	Mon, 16 Jun 2025 14:51:27 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 6E32A19;
	Mon, 16 Jun 2025 14:51:25 +0000 (UTC)
Date: Mon, 16 Jun 2025 10:51:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Carlos Maiolino <cem@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>
Subject: Re: [PATCH 02/14] xfs: Remove unused trace event
 xfs_attr_remove_iter_return
Message-ID: <20250616105124.65cbecb3@batman.local.home>
In-Reply-To: <20250616052645.GA1148@lst.de>
References: <20250612212405.877692069@goodmis.org>
	<20250612212634.914730119@goodmis.org>
	<20250616052645.GA1148@lst.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6E32A19
X-Stat-Signature: tbd7e4fwsw6nmmfhzmmm8yrts4go5orh
X-Rspamd-Server: rspamout06
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18dGI0cxui9EqPLSLOpmftqEmeQC43qfec=
X-HE-Tag: 1750085485-201666
X-HE-Meta: U2FsdGVkX1/a9uSDGbTrtnETeEFHxirlvPg2ooXlZr28sQgDw5SbhDw1ngiFu/pC/Rn54zPfttX5I59n6a52CxMryoaTWsYsDDbg+HkEWVe2XzbNJqC/fG6FXggu3LcLh0XqpozmeIc4f/38P6DqVYrbprjvmtEBnswDrGRl3x4mpz07uz761Qu2LfnaKtynaJ94VMRsrlmQy3X4fQj1UfSMnmtewBj8sF3sTo3k50i+U00zTLWJ8lbySlJo3IwGRyS0NepEJ0thAcvB7ACPtP+n7N9mWn7HLKs0K05FZ22a5zUz2DdoB5+MtL/KCacJ

On Mon, 16 Jun 2025 07:26:45 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Please lover case the start of the commit message after the subsystem

OK.

> prefix like other xfs commits.  The Subject line / one line summary
> is not a sentence.  Same for all the other pathes.
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks,

-- Steve
