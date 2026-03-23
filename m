Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4203030F540
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291498; cv=none; b=AJOx0uncA9U+1GHwV6tO521mqxi8so1/zEoCvRi/kLEjc3icTxp1yVhi8Ipe4QsvIOeMZQD+TODa6QyHcvENtsHUudSQEa0T6kOXQVSEcLB0WCEFgUWote0mAidrVv4ggnH8QHRN1I3gwN8XBiCvV0AY1Bs1CoXyOhZig+xqBkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291498; c=relaxed/simple;
	bh=xu521yLcL/6VJ/yF9H6V0WYahl81xMy2i5mtWUacU1Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HOGA59qYs6N90xBj/CPP7uQw13SqNDZ0BZxaF4RxBuAClzN8INEwX/YzBxHT0EWEBOXP3Zl+6YT7/E855Y6cqLpaFCkRX/LCZB3hjE86k+BAFaxci89Ku6XdnSrALQu+O8zEd709+3z1bBetlmK4bMdOVYHcAzW0P5GWfjx9ncc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xc3eu11E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xc3eu11E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2200C4CEF7;
	Mon, 23 Mar 2026 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291497;
	bh=xu521yLcL/6VJ/yF9H6V0WYahl81xMy2i5mtWUacU1Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xc3eu11EO4smILcfYjKvPpyRxZVafbPZIzdY8QwVwjkdrAGq9AbYaAWClFLPL8nvp
	 0K8oCS1Er0d/rREwZZ6CdLwnFfBYyrEWWdwwxyk1wwUcGEwzXclVi8imLxvC53ZSFg
	 zo5vzYBWs+SRRPOyPfgW7/F9Rq1xnHrTGbn36W5ulZMBeVQ4W2WBxlhfurDdNYiQuz
	 o6wMMFe1egcGkW1BUQ9CYSm2KU660qmbLNV0OUTZFFSF/K/ukSvP/t+9ZWrfTOBLeA
	 bb9tWLx33JUgjnyy3/fdg3mzFVdmKgeaa4i7FapizEzltW2z5Jhjs8hGk7F1mWirb9
	 PjMQJn53kkBZA==
Date: Mon, 23 Mar 2026 11:44:57 -0700
Subject: [PATCH 14/40] xfs: move struct xfs_log_iovec to xfs_log_priv.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120995.2266274.7632583477440336004.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 027410591418bded6ba6051151d88fc6fb8a7614

This structure is now only used by the core logging and CIL code.

Also remove the unused typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_log_format.h   |    7 -------
 libxlog/xfs_log_recover.c |    4 ++--
 2 files changed, 2 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 908e7060428ccb..3f5a24dda90701 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -184,13 +184,6 @@ struct xlog_rec_header {
 #define XLOG_REC_SIZE_OTHER	offsetofend(struct xlog_rec_header, h_size)
 #endif /* __i386__ */
 
-/* not an on-disk structure, but needed by log recovery in userspace */
-struct xfs_log_iovec {
-	void		*i_addr;	/* beginning address of region */
-	int		i_len;		/* length in bytes of region */
-	uint		i_type;		/* type of region */
-};
-
 /*
  * Transaction Header definitions.
  *
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 65e3c782d59674..af72b97d150b75 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1112,8 +1112,8 @@ xlog_recover_add_to_trans(
 		}
 
 		item->ri_total = in_f->ilf_size;
-		item->ri_buf = kzalloc(
-			item->ri_total * sizeof(struct xfs_log_iovec), 0);
+		item->ri_buf = kcalloc(item->ri_total, sizeof(*item->ri_buf),
+				0);
 	}
 	ASSERT(item->ri_total > item->ri_cnt);
 	/* Description region is ri_buf[0] */

