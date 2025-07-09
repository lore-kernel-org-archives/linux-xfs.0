Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740CE2D320E;
	Wed,  9 Jul 2025 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072956; cv=none; b=YVgrSAUDPta+C9ztoPJNyu56jHnqlLXjXmjOhkQFwX4iLnFwu+KoB9YYpJeKcG/bKW5xIv154Q9zp3W6ffsssmAqm2mrMoSjPYfbLKF0pYsvuk7ySTNyFGLQXoE/k+KkwIZeF2yyxK4jJpIzreQqCX2RvaKgM4VwFpSLV4WXFZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072956; c=relaxed/simple;
	bh=FuH/t6Fa+7Lm+Dj+i+9o2GEHu7PMV2e9Tkd/K3GrMKA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIpB/t69O3WoFMqmYcNbihUhbaRrk6FRYQl2Jd6kHtlpvh0o4xUkuqkZc5uJUAwKoBy8LoQpRQBwEnTN/C0aJmiBqYeSvOv6tNHE/Z4eBanxNPmwZZAfw2D/G6NKyVYy+yPmN5JQuXgqiA3XKR2ehIgZg2OVQbCYKqqjm8S1MJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 068231404C3;
	Wed,  9 Jul 2025 14:55:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id C418420030;
	Wed,  9 Jul 2025 14:55:49 +0000 (UTC)
Date: Wed, 9 Jul 2025 10:55:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, "Darrick J.
 Wong" <djwong@kernel.org>
Subject: Re: [PATCH v2 00/13] xfs: tracing: remove unused event
 xfs_reflink_cow_found
Message-ID: <20250709105548.2e2bf86c@batman.local.home>
In-Reply-To: <l56iobcpwdvdd5b7elwxcvp7btp2sfubqoxg7intx5wjzuj5bc@dc3v7mpgr5pa>
References: <20250616175146.813055227@goodmis.org>
	<uggqM4FTewFhLCJboUto49yP1wdr5erpnCdX-piLRMNV8IzM9h6Qv-nkmI6ieg6aAWOSRe9IiJvLS2R3yyCklQ==@protonmail.internalid>
	<20250708180932.1ffdca63@gandalf.local.home>
	<l56iobcpwdvdd5b7elwxcvp7btp2sfubqoxg7intx5wjzuj5bc@dc3v7mpgr5pa>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ccknmeksjuyehpdop68j47atzpipceze
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: C418420030
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+tboONSqvUwp4f0Tpak0w+3BIwaCMJpHE=
X-HE-Tag: 1752072949-601206
X-HE-Meta: U2FsdGVkX19dmTpf4JUuloMWeIXrW8AWgu3R79cEmUwK63M+5dsTskAnhWHXpbu80NS3Fad7sPqw0PiDh3rcl9ASc+w629nOzHWPgycI7pA6Kg0TghgOEohCykdTksewWIkqMPtgWLvTZxKC/yVmYSGAw2fbY4J8UWfgq2YzmJcXjgO91oPrIpWM51Fq4hMTCsrQJmW08Bp1x00zTOGrmgORvn1xEaEd1ctCZ7F2278soLVKxqURLZsJHKKH21I0Gg8ODKgheVxy0/7883eRibdjdu/uNrSQn084vQipzAwpD6MZGrchY0nPk5eHx6USjZ69s9M0Lo4LgVhrlKfKg3l5Gluoclet

On Wed, 9 Jul 2025 09:54:37 +0200
Carlos Maiolino <cem@kernel.org> wrote:

> On Tue, Jul 08, 2025 at 06:09:32PM -0400, Steven Rostedt wrote:
> > 
> > Should this go through the XFS tree, or should I take it?  
> 
> FWIW, I just realized that for whatever reason b4 chocked to send a
> 'Thank You' msg to you when I applied your patches. It sent to every
> submitter but you. That's why you didn't receive a 'personal' thanks :)

Ah, OK. Well, thanks, I think ;-)

-- Steve
