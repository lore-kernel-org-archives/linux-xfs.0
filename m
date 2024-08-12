Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEA7192B8A
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 22:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502368; cv=none; b=KWBKni/JoO7ckuArxQex+yGthABH7Jr15Unr04uH0B0pQj9hdbq2qnuC14iStDVKAYSy8MvcrqkffaFkcqa8SbMDSihm7W/XFXcBZokkJNMRZEqVOSzhGjfXvORHNkcLmRcVaCWkoHyq+w4gFq1WsGA969RjAGLsN3QR5RlCuKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502368; c=relaxed/simple;
	bh=+NA4HfCot/+PaUZvEBIVoyM4oT+OR0xsE+UV1xAS2uU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=K0GZQGiP2k+tZUuBdgX+r9+0WQBjsKL6AsmSGHE4wI4797yDuIzkAHm5pv+deMZ4FDUkVCxmk/xlX6TeM24H9qo1HHqPWtSELSRdfMKctIfyUSsl1ulkiiGI6jFENXJ3ykbad+1iND5bOOFeLciJe0YVfTqJgKHbIEQaapQJUEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLdiG4+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLdiG4+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DCCC4AF0D;
	Mon, 12 Aug 2024 22:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723502367;
	bh=+NA4HfCot/+PaUZvEBIVoyM4oT+OR0xsE+UV1xAS2uU=;
	h=Date:From:To:Cc:Subject:From;
	b=lLdiG4+Dm4GtqAYO+xiELtYA1PCTP6DbegzX9JAhycFrg9vJ2HOkjoV6ZlmkNeW5t
	 Ch5bbt7NK5L6YGNOrwKNR1/64N9NuXQzk7bs4ooJ7wZHkSZqZjAkvgiYbjFszma4z2
	 TEFGRpmhCO+VQN+IfCEJyhY4I+QvpNBxdMs/eIrCFsubd6x4uptUFeQYfCCmkCc2XE
	 ebIiOr0NfPWESO302PCDkc58VG1BA7BosfscfM+w8QOpbpI88HifYPxgNoBePLzHAz
	 YgkLOZ4ZkRJmrq9bLWkQq6mhYz4SlHyGZNK6Gkbb721zDzsNAzNWTkPjFzA7DaXz6U
	 yJVozUr1flauQ==
Date: Mon, 12 Aug 2024 15:39:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] xfs: fix folio dirtying for XFILE_ALLOC callers
Message-ID: <20240812223927.GC6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

willy pointed out that folio_mark_dirty is the correct function to use
to mark an xfile folio dirty because it calls out to the mapping's aops
to mark it dirty.  For tmpfs this likely doesn't matter much since it
currently uses nop_dirty_folio, but let's use the abstractions properly
and not leave logic bombs.

Reported-by: willy@infradead.org
Fixes: 6907e3c00a40 ("xfs: add file_{get,put}_folio")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index d848222f802b..9b5d98fe1f8a 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -293,7 +293,7 @@ xfile_get_folio(
 	 * (potentially last) reference in xfile_put_folio.
 	 */
 	if (flags & XFILE_ALLOC)
-		folio_set_dirty(folio);
+		folio_mark_dirty(folio);
 	return folio;
 }
 
