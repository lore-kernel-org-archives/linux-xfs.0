Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A05E34FF65
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 17:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768931513; cv=none; b=XYb2ZimztgTtIJh2JbXaXqfpP9PKRBLwItMpPTQD7lqvWfSQKadAK6QTp3G59yR+MeQrXwjhpnjQUEX82ykxqxTqRW2DTT6q6mOAQR7Nz89kYnJPUZ8Ok0mK/9s1ZXtBO20hKBljxa1iYLi0GoTyWhfJ+v7zHqKpKzIUxDsFy+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768931513; c=relaxed/simple;
	bh=UhADA2HyEWepsYT5DPNLpXHD9RXrnz8ED1vQem6UeQ8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brmaYReZto7cobA8siiwUihyDd0uYmaPHpgw6cL6ArM3XgSAQrYeVJyRr+JdoU6IHDBxXwjx3KLCeu0XH/6uc1XKyhxrQlspXpvOMgfu70oPxUnhC9z9BhFqM6Zkwb3xCqPy7kUNrBVqPV5+4e634OSt6geVDhfWY0+9pZxLKQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehoW1hxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehoW1hxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD14EC16AAE;
	Tue, 20 Jan 2026 17:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768931511;
	bh=UhADA2HyEWepsYT5DPNLpXHD9RXrnz8ED1vQem6UeQ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ehoW1hxgdXKzKZxrRSZhNNg0w31X+ey7mep0uy5cNaoj0UbVI+u6//4Nxx6/HOUqR
	 EIPwaGb7aYu077I6/zpBanDy4xywl74jRtyXo5iLRwDLJZEHejwLPNaxavfBlVVkgx
	 VHj0DCQ/FBNAgRudS6q+ASLja47HRzxWMvWEGQrTNmOCK3nI2l0pHOQMIKG/679CPI
	 /4Mt1GHndjCLpMEb5jxRGqCZ2jiobOf9klyaw2rNZAnAhG8X/+bbcKy76/okecxx9a
	 GirkLCsnnc/BnAsTK83jtd1SW3ydXl81+blP6IxoxGFPutBpVAASwE+fCht6LQ8md5
	 CTynzuoec5AYg==
Date: Tue, 20 Jan 2026 09:51:51 -0800
Subject: [PATCH 5/5] debian: don't explicitly reload systemd from postinst
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176893137162.1079372.6375654891810082088.stgit@frogsfrogsfrogs>
In-Reply-To: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
References: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we use dh_installsystemd, it's no longer necessary to run
systemctl daemon-reload explicitly from postinst because
dh_installsystemd will inject that into the DEBHELPER section on its
own.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 debian/postinst |    3 ---
 1 file changed, 3 deletions(-)


diff --git a/debian/postinst b/debian/postinst
index 2ad9174658ceb4..d11c8d94a3cbe4 100644
--- a/debian/postinst
+++ b/debian/postinst
@@ -8,9 +8,6 @@ case "${1}" in
 		then
 			update-initramfs -u
 		fi
-		if [ -x /bin/systemctl ]; then
-			/bin/systemctl daemon-reload 2>&1 || true
-		fi
 		;;
 
 	abort-upgrade|abort-remove|abort-deconfigure)

