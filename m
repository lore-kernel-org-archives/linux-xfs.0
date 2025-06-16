Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD7328A1FB;
	Mon, 16 Jun 2025 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096384; cv=none; b=iuvjd3uNTEKtuZeSR9e5nDcipFR1ZnbuQK0VuoosedFknlZBXj6/qtZxmMcwpvXh0DI/A0IHQBVCPeZhG8KKH5XEVSP5sfH9BNqv0SYrfB0vLR9r3cSpCAXkyLbtnp+XNjWyjfzMnV9CjG9gAakDRdVs01x57b1b/JrAkzE0f3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096384; c=relaxed/simple;
	bh=i+CoklhNPTZlyBGELwP5bgp/Wx8ljmmgLCWiZeodKzo=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=H2JtaJBTx+aXGlq6CMU9j5i4T453kloqDBhLZPoMY0siQ6YQx7umWmrfqLmC9oejQX379u14dO8wZJM7v/tdo9kfypyTWTfoB7qCJqDaxTUgh33M6nsZP7/pfp5f2w125/cEnpYnJnMjAdHRwJTetdO/GmlQYslD8QOoF1LOoyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE7A3160B21;
	Mon, 16 Jun 2025 17:52:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 1F0C420025;
	Mon, 16 Jun 2025 17:52:54 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0w-00000001KX9-0j0E;
	Mon, 16 Jun 2025 13:52:58 -0400
Message-ID: <20250616175258.024016837@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Carlos  Maiolino <cem@kernel.org>,
 Christoph Hellwig <hch@lst.de>,
 "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2 09/13] xfs: remove unused event xfs_alloc_near_nominleft
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 1F0C420025
X-Stat-Signature: n3a5bwfaoscfibin975f3cy44cikygbg
X-Rspamd-Server: rspamout05
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/IAnkaE8ud73P6we2ApRJ90HVFxyCEstw=
X-HE-Tag: 1750096374-701067
X-HE-Meta: U2FsdGVkX1/DSoo6pXCozlPWTe7Ctr3VwfFOXe5KFNbjQK3QrR5caycVfAvX51SVkDc5yxxRdS0oXryM1ZRTaz82VtsHgW6qJMMgsxkjk2Y9RF5kK9XAKJfwJHnVcmLqeOJB3dCkkG72skTsrNbLCWqR61QPT1K5qTV52NCbxxtgkETTnNNVs3StrW/b7sF8kd1zFqpGhrJ6qPykwGjlEW0R4TPlkAv3DWAai5fCPPa8FYg835v+PZN1UqB0/cOAj7W8W2iMSycngDFC4uVaD87iURz9LrvUdb62u2x4ciJcmpQycvhu7sVzY/SD/M8saj7CZcpIcjVeEQbFeM4q7rayi6JYEWkaMweebPpl0hSjxZC+5njwkDsPji8AtPOaCVXLR2xIf7l3nbeC4hkutg==

From: Steven Rostedt <rostedt@goodmis.org>

When the function xfs_alloc_space_available() was restructured, it removed
the only calls to the trace event xfs_alloc_near_nominleft. As trace
events take up to 5K of memory for text and meta data for each event, they
should not be created when not used. Remove this unused event.

Fixes: 54fee133ad59 ("xfs: adjust allocation length in xfs_alloc_space_available")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d4004e21d0c5..e629ee44a9a1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2263,7 +2263,6 @@ DEFINE_EVENT(xfs_alloc_class, name, \
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
-- 
2.47.2


