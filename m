Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD05288C3F;
	Mon, 16 Jun 2025 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096384; cv=none; b=ILCqVI9L1BVZqgWS8y9SejmM59/ZP20VUx+Tmjcf+vNaFcX1pOVeWLbqfbeGLDZ/wmZ0+qivanQbmBIa9M4g5CvQLnHLDng/jjQewHfsrvQUUcNkrMHg8g5c9CtdFhDyEqrBF7PanqIiM5ToclIItRmRyIVOefAs58X0PhhzmAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096384; c=relaxed/simple;
	bh=Vo5mo9vffi2431wb1UkgIWg4IctaULbsZ7jNpGoHmCE=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=TbhBLe8EBDnQYfhjQRwfh7Jrn/4npvF8cDN0KeK+WruA1ysFa++q4rviAGeZTwwJwIRiMTSZqeV2JOchdyQ9WjomJlFsRHu4quHdEV7AXZkotgGnF/jYCkmpjd8ROPV5dLACNrsN9ugn9vHZNaA+P8yUgITeMyV0wjqRbcNmrV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 898D45C5F2;
	Mon, 16 Jun 2025 17:52:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id C4B8A2000D;
	Mon, 16 Jun 2025 17:52:53 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0v-00000001KWB-3UXx;
	Mon, 16 Jun 2025 13:52:57 -0400
Message-ID: <20250616175257.685241532@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:53 -0400
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
Subject: [PATCH v2 07/13] xfs: remove unused event xfs_attr_node_removename
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: C4B8A2000D
X-Rspamd-Server: rspamout08
X-Stat-Signature: 5etnophfocss3zrbamigozesq9fk4zym
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+R5SfIYIgziOAj6/kWMcHHQpJ4CFrBYiU=
X-HE-Tag: 1750096373-289213
X-HE-Meta: U2FsdGVkX19n/hgMdBzOoOt1SFLDFSt9pnEXKyinc2yCdcqHDTBH9Dqm4PTZCnhOyt7bDpzZ0wO27gQcl2fXfpfDBppldFGdkPyEciZLfS9lKpL3IzhknrC4LpqSZibCpSmfT1u57U3+FgBIcuR+uJo63UUwjoNH9lolEadjbA5YoboXl3TFEYAzOZo0Br55MkOfzdkqZQg4ys4WLaE3bJ9RBFum22awQFmK9QPcmC3hEHUs68uRSlLDGgAY8YogCwLaZMv1jbD5wQ5TYbfxnBoCYuC6dKsX9E4epqY8C3wgXx/4gh2wdIHb+Hk1S5G6joCAQpbty8VuBseeNhRYhmz8Tm3e0JCxpD9D+w7ZQ8CZArDQ5gIDU4hqfehaY04JTMB6vajrRe6WK3zjx3rYdQ==

From: Steven Rostedt <rostedt@goodmis.org>

When xfs_attri_remove_iter() was removed, so was the call to the trace
event xfs_attr_node_removename. As trace events can take up to 5K in
memory for text and meta data regardless if they are used or not, they
should not be created when unused. Remove the unused event.

Fixes: 59782a236b622 ("xfs: remove xfs_attri_remove_iter")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d41513c76652..41a46f7d3fd6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2465,7 +2465,6 @@ DEFINE_ATTR_EVENT(xfs_attr_leaf_toosmall);
 DEFINE_ATTR_EVENT(xfs_attr_node_addname);
 DEFINE_ATTR_EVENT(xfs_attr_node_get);
 DEFINE_ATTR_EVENT(xfs_attr_node_replace);
-DEFINE_ATTR_EVENT(xfs_attr_node_removename);
 
 DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
 
-- 
2.47.2


