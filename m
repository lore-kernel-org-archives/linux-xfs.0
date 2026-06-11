Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB56D2DA76C
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186754; cv=none; b=INPA+btbNAbv/HHBoNtVSFEN+Yd2TVJO6Oaj2Jna4V26uJNcYlewjLf6FfxEUMIrw/Hcs/yzO4OIFPhnAD2x8DKiZPotgosJoPGqT51j4IrPKjebjpMz4IFia0ySOsUzn8VvvjkRpTdv+0oCPXeS5AgUSS1AA+R9FEFndEOT2+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186754; c=relaxed/simple;
	bh=j26GpgUZLcwKgvA3naSb5STDjT8J8YKYivfPDV5Hvgg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SMqcnUpLzbWcWlP8Bv/0QcPwN20j3rgJxIQAK7ADJPwyMDICVDHIjMeOB+k4smkrb0OUt7DKtni1YQPAdUvZoFPvpsfo4QzxNpcbf9i7SXnvqIziTNZtUA4ndofew0d77hN7WAuFScuV6JjNhLTxpGBYHm9tiqZgyMNgrEY0dY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4K0UROq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4K0UROq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3E1931F00893;
	Thu, 11 Jun 2026 14:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186753;
	bh=KYUzbb+G0t2EByx2N6P0ZR92BhFxYEUMRbaiQ2xonc4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=e4K0UROqqZXSpndyI1HXyCcbh6sBfaVP49VF1iswwYJ3FhRcILiAHuFQibCefHLKJ
	 GG0Lli7pweSHO0B7SrJqZiBym756DApMIv9GvniktGUUKuQwzWWrtWWjboNoe1CzOd
	 QeO7FHo+BOiNZNzYdeZuEC2xneU65y+ghiTSDdnavHwx9XqWAuo4gGLQ5En8i7vH2/
	 IIY9DTGoo/86YLQg6/YCQx7o2GdvGliinQcSnwNd7H0SnCmpl6rVw/oShKMxp1pscP
	 oWNJ6/I30Y/8ujEf+0JZPSXT/GNSMDQDwtU+SGB0oWSe9BGK1q5VovLvYi37hS4HFZ
	 LtDZBcwRu+lbA==
Date: Thu, 11 Jun 2026 07:05:52 -0700
Subject: [PATCH 4/6] xfs_healer_start: fix static checking
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178118661316.728615.15344702808600397376.stgit@frogsfrogsfrogs>
In-Reply-To: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix static checking for the startup program's source code.  Alternately,
we could move it to its own subdirectory.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/healer/Makefile b/healer/Makefile
index abdddf0eaa5ae1..d2d764d6142193 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -49,9 +49,14 @@ endif # xfs_healer_start deps
 
 default: depend $(BUILD_TARGETS) $(SYSTEMD_SERVICES)
 
+ifeq ($(CHECKSRC),2)
+xfs_healer_start: $(SUBDIRS) xfs_healer_start.o
+.PHONY: xfs_healer_start
+else
 xfs_healer_start: $(SUBDIRS) xfs_healer_start.o $(LTDEPENDENCIES)
 	@echo "    [LD]     $@"
 	$(Q)$(LTLINK) -o $@ $(LDFLAGS) xfs_healer_start.o $(LDLIBS)
+endif
 
 %.service: %.service.in $(builddefs)
 	@echo "    [SED]    $@"

