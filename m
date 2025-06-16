Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD02728A3ED;
	Mon, 16 Jun 2025 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096384; cv=none; b=bsByR4pOdOCSu8pQ+trX7QHTAIEumVh5Q4kg1iOB43tpJOpnbgqzUebfa5M5dCz7gNnU7mIQEj62+y+vvQefQ3VmCcewb1GEhWfVU7S/k2txZEfxgwVIWf2pjzePGD66P13L2XmVPeVo5XiABhBSi/uL3kLt2H/6PNo7VBs3M3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096384; c=relaxed/simple;
	bh=zfx8UutfK6U5fkb1VSXEmOCFP9m3ucQdt45ECOKcJHs=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=uSPbGxbKFommGYXslDjJbFXQluNM+7qr07Q7Tkj+98eVLGiBy/Et8xYIYp4I4NmZsZ3jF3S5xbfq+RXiFa4VWsJMHF5urmYrKnOqLLXwQVJI0s3Brq/fmAQes2pg46pPTmsgy7AHLFQawjCNpUCfUTJY4ZUjEokEgLFAQH21GKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCFB81D6E88;
	Mon, 16 Jun 2025 17:52:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 1E9932002B;
	Mon, 16 Jun 2025 17:52:53 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0v-00000001KUF-0fs0;
	Mon, 16 Jun 2025 13:52:57 -0400
Message-ID: <20250616175257.010194747@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:49 -0400
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
Subject: [PATCH v2 03/13] xfs: remove unused event xfs_ioctl_clone
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: dywih7b5713ahwnm1wgkurnj1w5jmtrp
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 1E9932002B
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+jQIRgyWIno3h7K+HKQc6PFNOc3LbvdqI=
X-HE-Tag: 1750096373-164365
X-HE-Meta: U2FsdGVkX1/lmTovO10iDqOlt67EixerTXVHHBl1JpBj0hurA3NqB+ftQc8qxYGa3j2opuEWLgOI6VH/g+7eZpAMztqkqlXuDjVype3SPvRhv7CphsPPfTz5VMW30znKUV4H68bsFiMwmhddme8/A6ZGczMB+cshrCjphO42lGPEz7EL34rH8G4a/XDgCHZekazyyq23M0VKQhNR6Xnbw9RSHGuuFZSTGfbaPGplU1WRxlFB1xGjSlkqbMfv5vCxM4sdQwMwM9Q/NlEgXcJIeafAExw8pReMbIu0lt+J+a6mEwWAGJ1L9GA+DsC8Q/gxjoAvJlVS5sIVn39NkDSX2iF0jG2pjtxSbN6O+2CqaJn20pBMTnphawBB2cDTrWoX5+kGinOsgsML7o3bWDB9gQ==

From: Steven Rostedt <rostedt@goodmis.org>

The trace event xfs_ioctl_clone was added but never used. As trace events
can take up to 5K of memory in text and meta data regardless if they are
used or not, remove the unused trace event.

Fixes: 53aa1c34f4eb ("xfs: define tracepoints for reflink activities")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b78676f44750..993397f4767c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4210,32 +4210,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_dest);
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_compare_extents_error);
 
-/* ioctl tracepoints */
-TRACE_EVENT(xfs_ioctl_clone,
-	TP_PROTO(struct inode *src, struct inode *dest),
-	TP_ARGS(src, dest),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(unsigned long, src_ino)
-		__field(loff_t, src_isize)
-		__field(unsigned long, dest_ino)
-		__field(loff_t, dest_isize)
-	),
-	TP_fast_assign(
-		__entry->dev = src->i_sb->s_dev;
-		__entry->src_ino = src->i_ino;
-		__entry->src_isize = i_size_read(src);
-		__entry->dest_ino = dest->i_ino;
-		__entry->dest_isize = i_size_read(dest);
-	),
-	TP_printk("dev %d:%d ino 0x%lx isize 0x%llx -> ino 0x%lx isize 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->src_ino,
-		  __entry->src_isize,
-		  __entry->dest_ino,
-		  __entry->dest_isize)
-);
-
 /* unshare tracepoints */
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_unshare);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
-- 
2.47.2


