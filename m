Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7A52DCBE2;
	Thu, 12 Jun 2025 21:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763505; cv=none; b=Xo1pWKxB8GAuhtOm3wkUk1kAi0DrmxQPSDUYM8AnSf6cABun8cfTD2hwMmEYWfvqkAlBFq2o6pdgqBoeE4yu/1QxxQqyWQpSuXETaFMAcmmHOCMC5fL/SoRBIiRDWrPC+5LNckD2oaLhLRJ9kvCU0/fpePn+A7ofbCCJBGM3bg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763505; c=relaxed/simple;
	bh=Hj5p80U0BlS67DfChc9EawelY7e03EBTEBWaAhRRYE8=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Iy0KEVsq3pA7eor9G+8yIqIfeBLPv0IZwKuMVEsQJxx7x1zT3RQGFvKPk3AxZXL2Xd91wKsl0lDzs+EY8P40OrpN2nVt5ryHg6rYo4LD9hRTS68w0PwFMC2wnwMrYopnh0YSCRXSPYaQNyTim2zh1hx4mzY55tVgCeh4V318mwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1FB7140119;
	Thu, 12 Jun 2025 21:25:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id E682718;
	Thu, 12 Jun 2025 21:24:59 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRU-00000001tSS-1gQD;
	Thu, 12 Jun 2025 17:26:36 -0400
Message-ID: <20250612212636.252544787@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:15 -0400
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
Subject: [PATCH 10/14] xfs: Remove unused event xfs_alloc_near_nominleft
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: boocakeqhbte66cnjdanun73458yd44i
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: E682718
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18V/YH0dZYiTbPkq/nW6ZnltEr6uk4VF04=
X-HE-Tag: 1749763499-323208
X-HE-Meta: U2FsdGVkX1/0YKQ1caPnnqHOizesHT+WHJsXxpGH92zaw/rZaxkNicSm7SEe1Xv97AIBai5lbTs7f6DhV4vUyySXfGOzjct7phR+NI3qLUm3tdPj70ag1HzIM/hYBV8v5uxsT8PuaJJI6EtA4OMAbqrbE8rijwrJlsDFiU0M/HVYm7XI553Z9y0OSv9uNAWADqRmvNZeDZlPVk0TAGWybJ957mz3sMnNRPlUsMOLcukGvcj0+lfyU9GIF/9NBcsfxFaLX0BaYt4eNVCwbDaejpOi9LmCr5RXc4bmSxdUHN31egs63U7RlwXwUToLKZ56rRYOVmB6KMm2pIUB/7EkfbjntdfVNPPLa2GEdqW2jwMJ91ImkVY3TZfKwL+YwY6FKaSBPx/rc+diSz7yei3+Bg==

From: Steven Rostedt <rostedt@goodmis.org>

When the function xfs_alloc_space_available() was restructured, it removed
the only calls to the trace event xfs_alloc_near_nominleft. As trace
events take up to 5K of memory for text and meta data for each event, they
should not be created when not used. Remove this unused event.

Fixes: 54fee133ad59 ("xfs: adjust allocation length in xfs_alloc_space_available")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6ec483341bc4..277402801394 100644
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


