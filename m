Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D042E371F;
	Tue, 22 Jul 2025 23:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753228657; cv=none; b=mZ9NwizOCnOpryAVSX8HY5mPfeaBqlVnAUw2coNCpvfRDdEEbK0/c8DecxAaXplFHz1I/o+O+lQQee7btiQC+TsLquA8hyMWxuwx7mQZp5lCvzGLqbfIC9awExqHbpWz72DhhOTUEiRTDxIZaV2wJHqV10xW3DgSdvmawJ0PcWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753228657; c=relaxed/simple;
	bh=gdc9Pj3O0TVNUwzks1regqOQ1nAm4fPNuiICCyNuErw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rrN+df1zivVeXBtGG9VgMbIDdTpCVsestVkcGNLy0Zb1gnsqn6HqNlg4ejVhcrTfB4cIIiMsxyJED7z3eWi37VJfZCLWj0siYc/DihHx+yjnBLTpauh0tY7fVibcg2lpr2bs/oIjOzhpsu41PXGODcptam7dO8kLWi5IUMc4hrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42E58B9A60;
	Tue, 22 Jul 2025 23:57:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 043BF20026;
	Tue, 22 Jul 2025 23:57:30 +0000 (UTC)
Date: Tue, 22 Jul 2025 19:57:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Steven Rostedt <rostedt@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Masami
 Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Carlos Maiolino <cem@kernel.org>, Christoph
 Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/4] xfs: more unused events from linux-next
Message-ID: <20250722195730.7eb30450@gandalf.local.home>
In-Reply-To: <20250722232842.GV2672049@frogsfrogsfrogs>
References: <20250722201907.886429445@kernel.org>
 <20250722232842.GV2672049@frogsfrogsfrogs>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 311zefzwtnjtgff3zrpkcozbuexepcgo
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 043BF20026
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+piuJg9NgEvYhDBbotTcMmneiGZTH64vI=
X-HE-Tag: 1753228650-382034
X-HE-Meta: U2FsdGVkX1+JVXZJMOllzESOVmMVKNAo4z6kHJCIBFe+EdBWTgAjj6EZyz2CO1I74RFYjHDhUXXKnEugpRrHqomd3XPaGYp62MyYv2cvtusxxPZFu/u+r+9e6sDuhYar/LepdJMIwlA7zMi52xOasA7Lr4vaaKFKBIqq1BV+6PCk4guFw1Dnvgtaf7wk6YXgyLqPg4Ye60dCfahfSfYEottbi3ICnY4aVF5JDx5BsF/yoHt6ffdj+/dI1d0wREX5dhBRBq8yqBf/H0UgbNX+VoTRQlVlCMOSPXzkp6907TAgTdAI8tfvaMNH2edzDULYSGJ+DoHpwnyJTgFOdsp6qdM6EKfvc5vL

On Tue, 22 Jul 2025 16:28:42 -0700
"Darrick J. Wong" <djwong@kernel.org> wrote:

> On Tue, Jul 22, 2025 at 04:19:07PM -0400, Steven Rostedt wrote:
> > 
> > I reran the unused tracepoint code on the latest linux-next and found more
> > xfs trace events. One was recently added but the rest were there before. Not
> > sure how I missed them.
> > 
> > But anyway, here's a few more patches to remove unused xfs trace events.
> > 
> > Steven Rostedt (4):
> >       xfs: remove unused trace event xfs_dqreclaim_dirty
> >       xfs: remove unused trace event xfs_log_cil_return
> >       xfs: remove unused trace event xfs_discard_rtrelax
> >       xfs: remove unused trace event xfs_reflink_cow_enospc  
> 
> I can directly take responsibility for 1, 3, and 4 -- those aren't going
> to come back.  Patch 2 looks like an accidental add, and if anyone wants
> it they can always add it back.
> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks. I'm guessing this will also go through the xfs tree?

-- Steve
