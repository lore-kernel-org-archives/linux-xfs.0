Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF4F288CB5;
	Mon, 16 Jun 2025 17:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096386; cv=none; b=CVqajuLXT9+aRBSL84LI4k2gzk03A2gJZBlzSvki+Z9Ln82SmQgoPYfyL+V1+Fq1IVHlZg2UqskDFIfTOCyRL55jXzy00XRX5GgzvJs6W9781X2WwzsQUE3n+0YzS/l7rKu0vFTP2AfM1LNL4GZyPo5SLPhqMZlW4k4hFftpjy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096386; c=relaxed/simple;
	bh=NKxXMIXzsSM7kZFMLFM188WPZyVP6ERPHjmDt7Sjzjs=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=fpHQuu932OxxyUbPy77WaGW8PpIZ/uvoxOWmghbAGFmV3gWwclWc72QjDmoiLNMoAL4zWaq3Skg4UInXs3tJchCiUvDxYqJpdExT13KPNvusgXXKulgLIfMCDacUXk3/jCKL+jMfIyeihSZASGUmOaEhRUVYQFfiuj96fFORNaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 415D6101344;
	Mon, 16 Jun 2025 17:52:56 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 8CF2C30;
	Mon, 16 Jun 2025 17:52:54 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0w-00000001KYc-2opA;
	Mon, 16 Jun 2025 13:52:58 -0400
Message-ID: <20250616175258.528614307@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:58 -0400
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
Subject: [PATCH v2 12/13] xfs: only create event xfs_file_compat_ioctl when CONFIG_COMPAT is
 configure
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: bnkzq5i39athu4785ruc1wcg5jzjpyxf
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 8CF2C30
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+QZfLrgkevSGG6U4TZA9OYfpnsSZdbJIs=
X-HE-Tag: 1750096374-221371
X-HE-Meta: U2FsdGVkX19px8Fb8CkmNOiT1mEhlKTs0+8gaUgB8JXJqdaV4kFMqKW0pxevEZdglKLijc1+Xx4sDGHqlQ+8wkRiO5VyWNfrSLWT83FApzx/xlzL+Lo2dyK4fdgy/Fi6lK8ReI3xvUnIOK6Av6HNYgrOlTKtTk+9Jjt3gOTyQFO9yzoX4X0Y+Jy10Phl6AO+5O9PehVjceE4CorDoZfLEVULnXEFu8ADrSe+12MKRMT7SHXtP2gZA58ElcDPce543jIFtqNGzmFFjSQ40HOMofWl6Uqof7gquiJWvsBsSbKoGFpfxtIu0Hlf5iM1DkOgKb/L085+uV1sELqTr5Ayho2Cb5V7rWEHcBRXji2cDfXBOwLYz3qc9Tf1Dd/yzs+lFBwbiPFva8RW2V5p8J9HSw==

From: Steven Rostedt <rostedt@goodmis.org>

The trace event xfs_file_compat_ioctl is only used when CONFIG_COMPAT is
configured in the build. As trace events can take up to 5K in memory for
text and meta data regardless if they are used, they should not be created
when unused. Add #ifdef CONFIG_COMPAT around the event so that it is only
created when that is configured.

Fixes: cca28fb83d9e6 ("xfs: split xfs_itrace_entry")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7977af7c6873..448dea97a052 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1083,7 +1083,9 @@ DEFINE_INODE_EVENT(xfs_get_acl);
 #endif
 DEFINE_INODE_EVENT(xfs_vm_bmap);
 DEFINE_INODE_EVENT(xfs_file_ioctl);
+#ifdef CONFIG_COMPAT
 DEFINE_INODE_EVENT(xfs_file_compat_ioctl);
+#endif
 DEFINE_INODE_EVENT(xfs_ioctl_setattr);
 DEFINE_INODE_EVENT(xfs_dir_fsync);
 DEFINE_INODE_EVENT(xfs_file_fsync);
-- 
2.47.2


