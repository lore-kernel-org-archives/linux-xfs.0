Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B282D8DAE;
	Thu, 12 Jun 2025 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763505; cv=none; b=utBWWSxQmIWlxki63008ecy33mnX4HoU0hr8kl2NN0SYtsHdtyvpyZ8weYX2+Vd9WRniGngw4ZN5pUq6R+LuiK1W88tAAKzq60F3CT6HUcDa5v2fyKI8NpJos2W6Jzh7+ZSxoDlNcDRGPkfHM/NyldX+mdBgEPS15wh4Uzj+9NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763505; c=relaxed/simple;
	bh=xmWp2AqhrRKFMvXkEIvtGR29GmRkNQtA5ZxOZ4AiOv8=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=rETlY/Vz3SgNHT1HU29miQzCw22MrbYpoUNNXNwcjkK0Vmk3n9fOqfNBPbEa8RZgfABUwKNuCROM4NXxCafJHVYE99abSLsLVjHQw/wSncTOlWCIrmzav2/b67Tj+Hby2W/zLfcvoVQHc4iys04jIpFyQL9UHzj7n7WAuduUpYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6403D576ED;
	Thu, 12 Jun 2025 21:25:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id C828A20029;
	Thu, 12 Jun 2025 21:24:58 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRT-00000001tOV-0ELB;
	Thu, 12 Jun 2025 17:26:35 -0400
Message-ID: <20250612212634.914730119@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:07 -0400
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
Subject: [PATCH 02/14] xfs: Remove unused trace event xfs_attr_remove_iter_return
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: C828A20029
X-Stat-Signature: 9dccdcetd4piai7pgf9ws9f1qjy8ab6o
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/m6umyMGBbUBeuaqntx0trCsmwmvufSI4=
X-HE-Tag: 1749763498-405258
X-HE-Meta: U2FsdGVkX1+39QocuuAXLXwEmrmg67AdqbEj4bi4NTgYS4A+2jqapoR+BuBwwfMiW83/ERBLWc6CaPkGHUdKkrTixbQAip9brOR2WCp03GycTSd1h7ArI/qKBhqWm0DVyPPfb+Qq/aaZgIKu/XoBs1LQkaBJVZQ0s/8gCqb6/mRyH0LcFt40RnXpNwfogwryb0wCyj/LqwsZaRw9V4kyjxc/fSysfZQegLm00+kXZ1vBZsITEbluc13bR1uL2O68Sgy8PfmBXxx0Rnzy6sfgs1MnWErRb3znQgSMaggmiZtZ4EMehA0iFC9D3TfJp1wYjIxnckpgNXIpyzumpNAEYa7wyc33M9yQwXMmwzKWobGNEUrwLzaYV6SxlEvqL2oSm3W+F/lCj/VkOn/OK+sFZw==

From: Steven Rostedt <rostedt@goodmis.org>

When the function xfs_attri_remove_iter was removed, it did not remove the
trace event that it called. As a trace event can take up to 5K of memory for
text and meta data regardless of if it is used or not, remove this unused trace
event.

Fixes: 59782a236b62 ("xfs: remove xfs_attri_remove_iter")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ae0ed0dd0a01..67bdcab9ff47 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5076,7 +5076,6 @@ DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
-DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_alloc);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_defer_add);
-- 
2.47.2


