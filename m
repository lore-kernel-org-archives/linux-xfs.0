Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460BC237180;
	Thu,  5 Feb 2026 19:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770320570; cv=none; b=VR7ydH0fhcYPXxL2XAszY/OrVNmBu2rGkqSPLLk+t0nssDdOg5Yr3VvBUcJ+jg6v0i9Lwcoe0U076Qyo/1sWxFImknXXeXE2iL9eysru8/f+ZkzDC7QzRp46XuGqekOvr20BQWo2KnwPZBitR/XE50sMpqyZrZMJDcRukqQQ3xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770320570; c=relaxed/simple;
	bh=yGbjG/3x17Gc8ursq9S4mbSj7b2C4VF9UohLgcoN0UI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EOg+dUwRKT24MqUuKYBXS/RH/uyHdQZPmvxAjN5sZwiVZWpZaxi0NMJReqdvfL+0WuxJLkY7NUPTFJ0IJDDKC5+AIYU2s/G9Y0e0oEEsDBzl8ZUwLsoPFTS33S7kGV6zPdqGJYARUMV93JZ8Fuox8UY+371PepMZESDdAdq6RKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=NDgwXnos; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="NDgwXnos"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615JBZ862007036;
	Thu, 5 Feb 2026 11:42:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=LHRvTXfg8AbW1lXErrTD00I8bbUcnPJ8/ywKnH2zqZw=; b=NDgwXnosaKwf
	duCJnkOix1Q8t3LsjJqUutfJXOKFYRmYnfqMyTgz/Hp5MaujhdDZLSA1vpw6lbXh
	oq+n1+4h0SRGhEXH3/ntwbUQ9wOrGgEzuYk1EQHKvTcE8BdrFQQOWeeHW/x+4dcD
	0xgmqjKkXmmOr9L6tkpBcr8vnL3KQjPULMcX/PKS18CTZ0uoqvkgyr3bpfLuNAFD
	NByR/rhO/sngBJ0hYfQZTkpjRntodi/34gQVp1VMbN+E5RP+R3R4wsfu5H1eIeVv
	Y9qW/Vi1PSZtGe5j3U9SpXbJi01pFSfpQhK9biA9rkvV9LB3q3c7Wxw5UhZmopq3
	8db4/qj/pA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c50qtgtm0-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 05 Feb 2026 11:42:43 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Thu, 5 Feb 2026 19:42:28 +0000
From: Chris Mason <clm@meta.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <r772577952@gmail.com>, <stable@vger.kernel.org>,
        <hch@lst.de>, <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] xfs: only call xf{array,blob}_destroy if we have a valid pointer
Date: Thu, 5 Feb 2026 11:40:27 -0800
Message-ID: <20260205194211.2307232-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <176897723586.207608.15038929489815852871.stgit@frogsfrogsfrogs>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs> <176897723586.207608.15038929489815852871.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=FMsWBuos c=1 sm=1 tr=0 ts=6984f2b3 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=dnfRgSOjAGpcwWFSCwIA:9
X-Proofpoint-GUID: GAZ8RJT2CftIGwfIF13ZTVH2bAIgBYUB
X-Proofpoint-ORIG-GUID: GAZ8RJT2CftIGwfIF13ZTVH2bAIgBYUB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDE0OSBTYWx0ZWRfX8vP+o/AVqulL
 +ZJpAlAoRNqjMTAtwx1h1omhHoT9uh7htBC+mE3kbV1i0LuS+e2uv/c/SdFmpKEmJE9MnACcDhE
 F9xLpP/MNld5q1qlU19TgT7TrJM0q2Q43Cr/N+8Ho7B2VUFbZCG+Ti7BOyC5nIrwBRlnTq/JR0j
 7yctaXZBHfWYV38QVBMDFHJJjW9BFG6fGcxnfyDJZkL4t5DJAYJ7mp7mKtBMGjOWF2JSYBWzlsI
 x/lfwSfK43GZIgZca5mbJ4uipyDNh7u4Z8KLjxkTxkyJHsZjr0vRWsPdqxlV3WVXp+6ZBRMaFEl
 E8kkKmZJBkla74Fu2raBbN/oNwmzcDMjcNnTCNf3FNYUnrKSN3tvR2FW8nsGz9MnaDkDWA+GdR/
 rcT/Wxi8hLv3X5uET4w3ZtDcPkzEm32WPwSQrYQB1LqpRZCDd07hi1ws55wCZ5cG13lhyYwiqpC
 yzgxmtGdxdC3/v2h6qA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_04,2026-02-05_03,2025-10-01_01

"Darrick J. Wong" <djwong@kernel.org> wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Only call the xfarray and xfblob destructor if we have a valid pointer,
> and be sure to null out that pointer afterwards.  Note that this patch
> fixes a large number of commits, most of which were merged between 6.9
> and 6.10.

Hi everyone,

I'm trying out my AI review prompts on a few more trees, and I ran it
on the fuse-iomap-cache branch:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=fuse-iomap-cache

This was the latest email lore could find, apologies if I grabbed the wrong one.

Hopefully the review below is useful, please let me know if there are places it
has gone wildly wrong.  I kept the header to make it obvious exactly which
commit I'd run through.

I was really going for the fuse patches, but this ended up in my git
rev-list output, and it looks valid to me:

commit 1e4e64674c788423e24610612e4981eb1dc9b28b
Author: Darrick J. Wong <djwong@kernel.org>

xfs: only call xf{array,blob}_destroy if we have a valid pointer

This patch adds null pointer checks before calling xfarray_destroy and
xfblob_destroy functions across multiple XFS scrub/repair teardown
functions, and nulls out the pointers afterwards to prevent dangling
pointer issues.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.12
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")

> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index a2f6a7f71d839..6e3fef36d6614 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c

[ ... ]

> diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
> index 7a21b688a4715..d5a55eabf6801 100644
> --- a/fs/xfs/scrub/dir_repair.c
> +++ b/fs/xfs/scrub/dir_repair.c
> @@ -172,8 +172,12 @@ xrep_dir_teardown(
>  	struct xrep_dir		*rd = sc->buf;
>
>  	xrep_findparent_scan_teardown(&rd->pscan);
> -	xfblob_destroy(rd->dir_names);
> -	xfarray_destroy(rd->dir_entries);
> +	if (rd->dir_names)
> +		xfblob_destroy(rd->dir_names);
> +	rd->dir_names = NULL;
> +	if (rd->dir_entries)
> +		xfarray_destroy(rd->dir_entries);
> +	rd->dir_names = NULL;
                 ^^^^^^^^^^

In xrep_dir_teardown, after destroying rd->dir_entries, the code sets
rd->dir_names = NULL instead of rd->dir_entries = NULL. This leaves
dir_entries as a dangling pointer after the xfarray is freed.

The commit message states the patch should "be sure to null out that
pointer afterwards", and the pattern in xrep_agi_buf_cleanup correctly
nulls both iunlink_prev and iunlink_next pointers. This change should
null both dir_names (line 177) and dir_entries (line 180), but line 180
incorrectly nulls dir_names again.

Shouldn't line 180 be rd->dir_entries = NULL?

[ ... ]

> Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")

The existing Fixes: tag points to commit ab97f4b1c03075, but this is not
the first commit that introduced the bug. The bug was first introduced by
commit f1184081ac97 ("xfs: teach scrub to check file nlinks") on
2024-02-22, which unconditionally called xfarray_destroy without checking
for NULL pointers. The commit ab97f4b1c03075 (2024-04-15) is one of
several later commits that perpetuated the same bug pattern.

Should the Fixes: tag reference f1184081ac97 instead?

