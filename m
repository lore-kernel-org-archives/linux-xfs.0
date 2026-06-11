Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D52F2C0F91
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781188439; cv=none; b=N1DJpMMACynaMKunUOhd60k3kxhX1Tb5klWIiEHPkOsNbGp+SmFkYo/mQ8PGGWR/osIRgVKY5JtjZPmipb7sbitEaFkqRVRS0wH4GOZCPv87rP1e+AKiuGmzmC9Yqebf2eo5sldXHacPkgeJrlcK8dhF1KBhBf5Ph70B48logXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781188439; c=relaxed/simple;
	bh=F04WZ/I3P6YRxSDm9cBbLUojNSRizYCioEnDQ002uLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXwAN5Rd4iYfvrpjHaZ8OFrRyLzQICl/ZSlC5ZYAgFiW2JDZvsR58w9o1h+oXPps7z7jseWSGJ5qYVvAu3CliiWRW599RZihfQ7xUNn+aUnGq1aGf2EBCW/13jmf3RREPPkkSDk4B19JVBofV+LNM44IgxkLz5G5/KzBSH7dHWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/exHQwq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/exHQwq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D04F71F00893;
	Thu, 11 Jun 2026 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781188437;
	bh=BFFsHzgeSdb8fXdG9zxwf9dxSM1FZ8bMtw/7MuWa00g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c/exHQwq67Krf/CHb9BWLDRF4xC04dQhByTk4uSXodmrLhnA8mG4JUgQfHTmOEYCF
	 eHql68Z277SD19bLJKv8RF/rrkb8ItXs4E8608shhDyaIe6xWK4V2H3P8Cmqm/AJuF
	 kvfnm6e05q8vz7SD6K9dMOqsaPMfZ5isGLeJOeCixoYGwKkCz7PECZDfyp4mBfoSFz
	 tr5XbGRUKJtYeIHzayj6r5+pLqorgx8+tNjoazCxMUBEPvIjfFCCf7XVqZfEHHCdCR
	 AN2Ivf2RJx7YnmR82uxqFFr6s6BLE/OnMTqsFcXwWmQVoHpMrgY0qZQm+vOCrxJFQH
	 vFP/LpCwXl9sA==
Date: Thu, 11 Jun 2026 07:33:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCH 7/6] xfs_healer: don't put the slice file in LDIRT
Message-ID: <20260611143357.GJ6078@frogsfrogsfrogs>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

The slice file isn't generated, it's merely copied as-is when installed.
Therefore it shouldn't be in LDIRT.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/healer/Makefile b/healer/Makefile
index a95ef9586d369b..e3c41e668da59e 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -37,17 +37,16 @@ INSTALL_HEALER += install-systemd
 SYSTEMD_SERVICES=\
 	system-xfs_healer.slice \
 	$(XFS_HEALER_SVCNAME)
+LDIRT += $(XFS_HEALER_SVCNAME)
 OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
 endif # HAVE_SYSTEMD
 
 ifeq ($(HAVE_HEALER_START_DEPS),yes)
 BUILD_TARGETS += xfs_healer_start
-LDIRT += xfs_healer_start xfs_healer_start.o
+LDIRT += xfs_healer_start xfs_healer_start.o xfs_healer_start.service
 SYSTEMD_SERVICES += xfs_healer_start.service
 endif # xfs_healer_start deps
 
-LDIRT += $(SYSTEMD_SERVICES)
-
 default: depend $(BUILD_TARGETS) $(SYSTEMD_SERVICES)
 
 ifeq ($(CHECKSRC),2)
