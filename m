Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF732D8DD6;
	Thu, 12 Jun 2025 21:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763504; cv=none; b=LS0qIvupMgrqu1h3NvXqW6N9CmL0C/FeuwuKJ9qmijeoUV72wJHZa2WbXFnDjCzvNU8fvCS+/Z0uInE0SLMe91n5KXSe5I2xoqb+F1819Vv01OAs1TfXkX6U/XD6/0gHh5HJ1l4svjfxzHo3W8zdkDPNcz2WX1SVOPDS7NF5IUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763504; c=relaxed/simple;
	bh=o2WvZF8/Wj9oS5PyPHIu/2Zv1oPNwLjyXdrg1kidN8I=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=is5SrhlacvjNde1O3wXVujGG9VXgzNvv+drhsogAybINe4L3M9GvuPR1A1T/tgBnnjXZrK/3XQvwwo5HcXA+qVS1Z4sHLP7bCvLpEL7NiPwz5C/PDPiO2UNNATx0ya96TCTDV2tLUwSz/z7wfp4ou6G82H35FqM2xRPU65EV7zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10BEC8020F;
	Thu, 12 Jun 2025 21:25:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 662232D;
	Thu, 12 Jun 2025 21:24:59 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRT-00000001tQU-33Xw;
	Thu, 12 Jun 2025 17:26:35 -0400
Message-ID: <20250612212635.579394128@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Carlos  Maiolino <cem@kernel.org>,
 Christoph Hellwig <hch@lst.de>,
 "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 06/14] xfs: Remove unused trace event xfs_attr_rmtval_set
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 662232D
X-Stat-Signature: b36rgichgih6d7pw7rib4uoe553zzq6u
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/lS2S6zOc8c8WQzcQZWnqJVZ+11fBpSv0=
X-HE-Tag: 1749763499-110801
X-HE-Meta: U2FsdGVkX19//A+Oqj6S60RE4zMlAbdDufoaeXQA1+JPbo0oiGL0sZgtZsNjGbqPgVcCKV8WYUezV56dAf0+myQjlU6aNgGOfWruNQdd7CyOHamajzNCnz+yZsd7OpEzbOLL0knTfNhDICrfa41n56giBulTZY8FdfVBIfTkfhLacae5d0e0sIzgNe6K2dyVfo4yPjBcHj9S0tnY8r8la1nKGv0Zz3fT482C5lX5tg1QFdE+t2pnkT7caO2998vs1oNbPaCkKD0BpB4xUvn1Ya/Egw0Ds228cuYGYP3ChPJeChvt6I28BsuImSJ6fCiGEKkomlgazpFurKeZ4pm5zKSwJ4UphOWIScrSuwUV3k7wWIpcDonxr/LeuzdV6pEFvs6sWYYWoH8B1SZ8Lh4MgQ==

From: Steven Rostedt <rostedt@goodmis.org>

When the function xfs_attr_rmtval_set() was removed, the call to the
corresponding trace event was also removed but the trace event itself was
not. As trace events can take up to 5K of memory in text and meta data
regardless if they are used or not they should not be created when not
used. Remove the unused trace event.

Fixes: 0e6acf29db6f ("xfs: Remove xfs_attr_rmtval_set")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fe22f791de6e..cdc639198bb9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2471,7 +2471,6 @@ DEFINE_ATTR_EVENT(xfs_attr_fillstate);
 DEFINE_ATTR_EVENT(xfs_attr_refillstate);
 
 DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
-DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
 
 #define DEFINE_DA_EVENT(name) \
 DEFINE_EVENT(xfs_da_class, name, \
-- 
2.47.2


