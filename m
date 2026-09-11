Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087493806CC;
	Fri, 11 Sep 2026 05:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106084; cv=none; b=dn6Hl+O/aN+rpHz1M++C8w/A9cMbgXXtIoSMG9bTvi/wEOWqQs45dSFOaXOC7G2H48dh71PJ6UDjdH39lIBoC8C5v4/zXFV4HjzWC7OW9dxdGiYdPmDz9k/k2R50Ph+GKsnwwaRuNszioVoEBCp10FKj+4UDGGfHalCs/1/oFNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106084; c=relaxed/simple;
	bh=BrOGas3ai17GV9ESG/lAVMI3V5l2ft6+o/t23y+hfEg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rpjdJSEuhtYlv8BeYVsb8GQLUaH3q/ozOf+b1cXstLCAptnRZeR+Fa50fqQOkuAEP+qUAGnp1Cv1575l9EO6EGYaVqHMkUdmUtePkMvn0YifLlRWJKDlPN36W1oJOoKw6mV/wIArZxYkMH8tixB49pvHgBzj6wmVN0S/+1OZqJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMSfP6CE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMSfP6CE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D29421F000FF;
	Fri, 11 Sep 2026 05:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106082;
	bh=KQHKi/S/t+82WXleDX7HEC4Rbeh6Yp3ip7NYyWgiCxk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=OMSfP6CE0+N2T3VaY5tiePlfKqci/eFkZSi+S6cbfInXfXrD+1LhBfqXa7fgsYWMH
	 Ps6PzJ2RccYqy8tC8U/C6q7J4qu3WFBOZGYN9EGDn6e9VBzDOtCx6F8BRI+hlxTqli
	 DskouXaXTBPJn7qjqDrGpwpIGoeYofM9V5TwM11t97sPU54hHMOeatqMvhOir9QPR4
	 zKXtWqLbIIhOEW7cWnloXDLWQo5mfzgtxaemAWnXhJmS1LNNwtkPGpl9JF05yoTgw6
	 +gEabFqs6mnM8IcQ3URJfgdsyHbiFGAk7FZVn4JIK/EwNMdvf1SIP55x/UOIlcWpoR
	 UZ0i+KLt4tE7g==
Date: Thu, 10 Sep 2026 22:54:42 -0700
Subject: [PATCH 5/6] xfs: only flag zero padding for dir3 data blocks,
 not dir3 block blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178910162126.174887.2134061998195559640.stgit@frogsfrogsfrogs>
In-Reply-To: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that xchk_directory_data_bestfree can be passed a
directory block that is either in "block" or "data" format, but the
check here unconditionally treats the dir3_block and dir3_data blocks as
if they have the same header format (they don't).  Consequently, we can
incorrectly set the preen state on dir3_block blocks, which of course
we can't preen away because dir3_block blocks do not have a padding
field.  Fix this.

Cc: <stable@vger.kernel.org> # v7.1-rc4
Fixes: 939919ccddfcc3 ("xfs: check directory data block header padding in scrub")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 2a037aae904d03..19d974c7e2b7a9 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -492,7 +492,7 @@ xchk_directory_data_bestfree(
 		goto out;
 	xchk_buffer_recheck(sc, bp);
 
-	if (xfs_has_crc(sc->mp)) {
+	if (!is_block && xfs_has_crc(sc->mp)) {
 		struct xfs_dir3_data_hdr    *hdr3 = bp->b_addr;
 
 		if (hdr3->pad)

