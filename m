Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796721C700D;
	Mon, 16 Jun 2025 19:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750101535; cv=none; b=Zf79Q5Bg2odi8Zbo5tGnmu7TxQs1rxqw6ULzUBOgQfT7uJZUK07i5ssSJ9C2a7CeTfryTbxSGzpvS870SPmqzpD5fOAC/4pT8Igvi7a6Qtyyb0LfOdHoaf6wKKA/+bk+TcCXcidk8hb+i2tHXq+mJEoh1c/k2Q3+Us8getYO+Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750101535; c=relaxed/simple;
	bh=EpxFWOeKKzby0k/IoO779qDJQTpZINzLmss4VsjsOO4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COZKo8NQMBEiwCcig7Wc0gEUtewOsTZwVJ3M1gSL3jxg6K1UAJ7sz/PzLpmqP5QHJOVat+b8bG+vEVcyTueWFUu6dBVImkIQNYfUVaee3glHQ+PqISX/cEZBDoS0i0vKu3yMXUndFyfSbh/jzWTBgpR5QoV8GQfi2R1t2lru+fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0750416032C;
	Mon, 16 Jun 2025 19:18:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id C50A46000C;
	Mon, 16 Jun 2025 19:18:49 +0000 (UTC)
Date: Mon, 16 Jun 2025 15:18:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>, Carlos  Maiolino
 <cem@kernel.org>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong"
 <djwong@kernel.org>
Subject: Re: [PATCH v2 00/13] xfs: tracing: remove unused event
 xfs_reflink_cow_found
Message-ID: <20250616151848.36ddcee5@batman.local.home>
In-Reply-To: <20250616175146.813055227@goodmis.org>
References: <20250616175146.813055227@goodmis.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C50A46000C
X-Rspamd-Server: rspamout08
X-Stat-Signature: t8djaqg6jmxc3r9qw4a4cdjrsbrwpznt
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19sFy0mMt69Phvj+J8Y/DQjMU5FGDu9ueY=
X-HE-Tag: 1750101529-661037
X-HE-Meta: U2FsdGVkX19WkZNorP5ucOpv6p01Ousfxni3d9I9O6JFDXYkkCSBUjIBDSGuoT07HgwIoEeRO4OcxARt7CeH36+t4981QWdE9DKFdDZPY8+OlCMOYziQTfg7ck4g2iXgxYhgvHNOoGqKF02FST9REKID5i+Wkwnc9RvJjDhCqAXBCzgyv4Ng1VDduqPZCs8pyXXTxxZ45KLvWTlo+LaUjhY0ERK+KM+xIiOksvhe+VCcliubHDThRrfdZPA1MoALQez8xEKvysSP9R4rr2ks7gEslofQtc/QTvtfHAegTt6gPh24EiUFUqaSgARKwHDHV0XXDC2MDjhurUBlQKxAQyLReROr9Fv6Iu5poGEURYLJHT6ijZdPAcJwEBmDYgpNmlShi+NhmlJl+Vja5tFOKg==


Bah, I hate the multiple clipboards of the Linux desktop. I had cut and
pasted the above subject line in one clipboard and then cut the subject
I wanted in another, and unfortunately pasted the former :-p

This is what the subject was supposed to be:

  "xfs: remove unused trace events"


On Mon, 16 Jun 2025 13:51:46 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Trace events take up to 5K in memory for text and meta data. I have code that
> will trigger a warning when it detects unused tracepoints[1]. The XFS file
> system contains many events that are not called. Most of them used to be called
> but due to code refactoring the calls were removed but the trace events stayed
> behind.
> 
> Some events were added but never used. If they were recent, I just reported
> them, but if they were older, this series simply removes them.
> 
> One is called only when CONFIG_COMPACT is defined, so an #ifdef was placed
> around it.
> 
> Finally, one event is supposed to be a trace event class, but was created with
> the TRACE_EVENT() macro and not the DECLARE_EVENT_CLASS() macro. This works
> because a TRACE_EVENT() is simply a DECLARE_EVENT_CLASS() and DEFINE_EVENT()
> where the class and event have the same name. But as this was a mistake, the
> event created should not exist.
> 
> [1] https://patchwork.kernel.org/project/linux-trace-kernel/cover/20250612235827.011358765@goodmis.org/
> 
> Changes since v1: https://lore.kernel.org/linux-trace-kernel/20250612212405.877692069@goodmis.org/

And this should have been to the lore link and not patchwork:

  https://lore.kernel.org/linux-trace-kernel/20250612235827.011358765@goodmis.org/

-- Steve
