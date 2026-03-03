Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9547915B0EC
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496760; cv=none; b=nqIWn5n1xhaP57r9wICGGvqjF2rpIZH+dEQ/ZLoQCcs1LxGxAxzLg0PjC1Sa8GVQwYPU0QwHtFPjKfzICjx17JmHOQgChTWS47jrqT44Vp4kKdyl9lCNalfjdHMjf5csFRiTMmJa0uKscxfezmfwNuHZaJCGooylKnCTxGXyUTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496760; c=relaxed/simple;
	bh=XBUaptrymzPUNKo9ezCoWdpImLfdIHyFejaB4HiTaUg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=asXKL8BgXVRnVcsjm7y6/ayoI+C+RZQK6cCaZE6XNG3JvbHBXkCQirNb2kL2ku2z1SxT7/P8eMQ5A1z/N/jDAkqcHnpf4YyzUvJui3jDzB+jA/K6KUmpkL/yq2QV+Ljs5JmFBIwMySd0drV4o5Loo5lVRPWEgYpcmZHmaA6iAPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tpID15De; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tpID15De"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FBBC19423;
	Tue,  3 Mar 2026 00:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496760;
	bh=XBUaptrymzPUNKo9ezCoWdpImLfdIHyFejaB4HiTaUg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tpID15DeBpAJF7t2+defqNEUVykivkAESpGEhDAVGXnBduFk7hYYnR7IeZGRcHcFk
	 vX2MXphGCaSiZDcGukgbqsRNb23vvb87YFoUlcBTeQcJqLzTpfRsue60LdkWe/8hQ9
	 ntQCjVdWycWK8E18EXqhamAm7XWmfpImA6f/nk9zTHCHbx03A6H9yYlakBWzke0DIW
	 WQCx+Qt4AXsSHZoTu756fpFl915h7SZh48Q8olsQBGPKJ5Gvdz27b29lorvycmShCB
	 i8dlSZbZ9iBLiheTrFme3XdzIqyzeNOiIb0ZUJfBgdNS+Qam2qWpQu7HJ6MKBxTV/u
	 X4QfD08wp+thw==
Date: Mon, 02 Mar 2026 16:12:40 -0800
Subject: [PATCH 02/36] libfrog: fix missing gettext call in current_fixed_time
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177249637813.457970.13704898468170992838.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This error message can be seen by regular users, so it should be looked
up in the internationalization catalogue with gettext.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libfrog/util.c b/libfrog/util.c
index d49cf72426f6c8..5bae5bab46f91d 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -83,8 +83,8 @@ current_fixed_time(
 			epoch = strtoll(source_date_epoch, &endp, 10);
 			if (errno != 0 || *endp != '\0') {
 				fprintf(stderr,
-			"%s: SOURCE_DATE_EPOCH '%s' invalid timestamp, ignoring.\n",
-				progname, source_date_epoch);
+ _("%s: SOURCE_DATE_EPOCH '%s' invalid timestamp, ignoring.\n"),
+						progname, source_date_epoch);
 
 				return false;
 			}

