Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63CDC13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6nHlQkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D0AC433C8;
	Sun, 31 Dec 2023 22:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063156;
	bh=zQl7kPEcbI7gjJHNVl3r8oqkftrjhAY8yO3qo8elozo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S6nHlQknveRBLnheyf3LHOdsQcavWgBiUl1lNsUFHnaa1W+C+tBroSMUNiaFOh1rh
	 RR/cXyEtbV1JAPgTs1BTjm4G+UQkwddGb8vbwGZOF8Wk6fM8PGeElvoiu3bGO6sCIT
	 AfHpieOG7iw41CJYRlF5Bv1u3fPgUDs53XjlvM9o+j+7yZSEowUwBgSV20SOQv3vix
	 aj3K8dX3CDR8FMbQALyeYKyF3iqFzNQO5VRu++i3u3JJbS4TCUHfeMUzFrzGExKFtz
	 Y5p7LS8OdtzMJrtvE6jtfbO02d/PR2zIODeDh5ssPbRszgmNxQF0FL/lIpcX+WCB5D
	 BJcm08uaFa4Pg==
Date: Sun, 31 Dec 2023 14:52:36 -0800
Subject: [PATCH 1/9] debian: install scrub services with dh_installsystemd
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405001860.1800712.12681766556317697413.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use dh_installsystemd to handle the installation and activation of the
scrub systemd services.  This requires bumping the compat version to 11.
Note that the services are /not/ activated on installation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 debian/rules |    1 +
 1 file changed, 1 insertion(+)


diff --git a/debian/rules b/debian/rules
index 95df4835b25..57baad625c5 100755
--- a/debian/rules
+++ b/debian/rules
@@ -108,6 +108,7 @@ binary-arch: checkroot built
 	dh_compress
 	dh_fixperms
 	dh_makeshlibs
+	dh_installsystemd -p xfsprogs --no-enable --no-start --no-restart-after-upgrade --no-stop-on-upgrade
 	dh_installdeb
 	dh_shlibdeps
 	dh_gencontrol

