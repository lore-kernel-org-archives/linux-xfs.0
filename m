Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD035299A83;
	Thu, 12 Jun 2025 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749748256; cv=none; b=ExpOP21HiMJlVjw5oAWGVDCtq9KNco9/fcd1gNKIiUnpRN0GHpLdEpH+2HqWICKzM1IIYCC89RzR+jehQcSjk8DhIL+Z2TwS4HLdJWGVRw6vLmoo67uktvpUFOpRk6GdNJ+WCGGiyCWMgoNODXMOzdlU19xsladQBjRJKJPCgPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749748256; c=relaxed/simple;
	bh=QmUgJY91IsgedZOIxe947RbcBLJnjsxKwg/n+broCvk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=XHgtJaCIUCYpasF2T8vc1iwwMexurfxorvhmcPEoBBa3dpIxvW92o4CIfDKxhH23u7bpD+nye67FZKWfQNQkcihj9nFMUpbOM/2cUhi76c0ZLJNOUVl8+4tCZHPsgo8r5taRjvNe8bP/Ha4zQEaGaFjbAkCvTPpnj2JYZQe4On8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 499C0121B49;
	Thu, 12 Jun 2025 17:10:24 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id A130D2002D;
	Thu, 12 Jun 2025 17:10:22 +0000 (UTC)
Date: Thu, 12 Jun 2025 13:10:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Subject: Unused event xfs_growfs_check_rtgeom
Message-ID: <20250612131021.114e6ec8@batman.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A130D2002D
X-Stat-Signature: urdo41qkgkibkgfqmtzin6a3n6niceb4
X-Rspamd-Server: rspamout06
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX199sc+tXBmqI8BO6c6k37AAlisKGGKWNvY=
X-HE-Tag: 1749748222-455376
X-HE-Meta: U2FsdGVkX1/BilQKQ8cDjxBpENW65zCgbHuc4+c3modMdomoYuptpUrVUrU694vrTvYQ3vpFNoKfclnzjpG65k8RmOvjcAqbM8DtyKSvxFnX9zijLAv+8naBujxSJlAdqso7PdNONgCshKOej9z8KEQkbGgReZce09DAu4rYTSFMV6xto0SzubXasssKBXvr1fADkscuqmzNSUYzGV0R+5HesR8QyfCT+b42m85VzLX6nR5sYcixJLMN4lYnQLHH4jVqlAkuMHLu1X6M5t8FCBvAuLk2PQnSrAd5aIdBtmRWqXsBMQagCEA6+dAaf3Ya

I have code that will cause a warning if a trace event or tracepoint is
created but not used. Trace events can take up to 5K of memory in text
and meta data per event. There's a lot of events in the XFS file system
that are not used, but one in particular was added by commit
59a57acbce282 ("xfs: check that the rtrmapbt maxlevels doesn't increase
when growing fs"). That event is xfs_growfs_check_rtgeom, but it was
never called.

It looks like it was just an oversight. I'm holding off from deleting
it as it may still be valid but just never been added. It was added
relatively recently.

-- Steve
