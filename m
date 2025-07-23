Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6351D54D8;
	Wed, 23 Jul 2025 22:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753310141; cv=none; b=D0uhE6T/k4YX6O7e9QEehOA3qv3Ml8yP9SWkVBlx3UABIHnBCkm8FGjIKt2pxKFnJ8ExzYa4u6etVDGratsmKphjLSG48Dgm1FGYR4vwjHCKNwvvXI9ACSRLzoBRiT+2lyMX4nuYxq8NoYO/0UXHOqBvWFY+AuTfcnbNtntesoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753310141; c=relaxed/simple;
	bh=LG4/ggTmI7fOvQIVDlFfdloWY7zoYkd2hwnlAwEe1So=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lNeMquiXsMPhgT3HGJtYH4BVPOMQ7kTkFyQOke/ioi/5bu+ZrdLPRdTZVqJG8oiGLHToaLSXetp2NnJxluIE05ZoQIKOH5o/kp7KU/nnOhdMG+RsYuHbqqnaz3dAQqcFinqygIuurMOOX05UT7EqoJi4HG1ZH1mJkyyKkFU70so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD55EB6011;
	Wed, 23 Jul 2025 22:35:31 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id A6CCF2000E;
	Wed, 23 Jul 2025 22:35:29 +0000 (UTC)
Date: Wed, 23 Jul 2025 18:35:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Carlos Maiolino <cem@kernel.org>, Christoph
 Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/14] xfs: Remove unused trace events
Message-ID: <20250723183531.1c96dcc3@gandalf.local.home>
In-Reply-To: <20250613150855.GQ6156@frogsfrogsfrogs>
References: <20250612212405.877692069@goodmis.org>
	<20250613150855.GQ6156@frogsfrogsfrogs>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5rxr7kzwg8ed4siy7rgyzxd77teafota
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: A6CCF2000E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19VzsPzmz2ncop7NkHspHlB8DAHBbg5Cys=
X-HE-Tag: 1753310129-692861
X-HE-Meta: U2FsdGVkX1+81ZKtnH4qsxk4m5OWqqjMEyV/2SlolLYr9g7s0pmBPPLxRSamkKZCZ/ORyeOiiRXlqwMjaGjw8ZW51OptEW7/IPUfSkFPdE26lpDKO/W5yrUafBOUC3Jn6aQxb914V3g0FUe8jGWqMqt+Bk1eYiiaD44J7H705FjwI0PsRxXMcmf5nplgaExqoJaFVk2wF7xTbsnceqcTV1rwAF2iq/3eomTN4kB4IqT9VHgJhlXyaP0+sS5vYJ5rkjKAT63ml16gXYj5Jq0R+6Vqq7IPQ08q8CVnYeaLci8uR6BHZPPHW+FoXXHVw591q1Kx3ghbj7wyx6ZWyr8WP7kBC7zrQgn8

On Fri, 13 Jun 2025 08:08:55 -0700
"Darrick J. Wong" <djwong@kernel.org> wrote:

> > Each patch is a stand alone patch. If you ack them, I can take them in my
> > tree, or if you want, you can take them. I may be adding the warning code to
> > linux-next near the end of the cycle, so it would be good to have this cleaned
> > up before hand. As this is removing dead code, it may be even OK to send them
> > to Linus as a fix.  
> 
> ...oh, you /do/ have a program and it's coming down the pipeline.
> Excellent <tents fingers>. :)

Well, Linus didn't like its current implementation, so it may be a release
or two or three before that program gets upstream :-/

-- Steve
