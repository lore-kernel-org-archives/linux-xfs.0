Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233CD2DBF75;
	Fri, 25 Sep 2026 04:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309573; cv=none; b=EPJWtuQEfEW9jt1cbzmhShppYEX8geluCxSiNVKM5fQQTaB8JpRp58RohDnkDmQPFqTctPKYZKfBe6zYF9Yt1JN18+bG/5rZAND1Syq1febmt2jYEMNqVqffsWWTyhulOkbUXipnVT6LgXiGsbV821u/9Y6y5JWFX/s1XQcw+Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309573; c=relaxed/simple;
	bh=tKVTyoxydjZtPVY84TWriy9jGcmv0bDwCWJOH4VQvCQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mNT8bOWESFVf52vt5akkpXrQnPJ0nZktZTiqxBBVcC+aSWZx3AibxoAmeJx6Uy6W9BuyunqCjHowbCkACRBNxifAdG95n2kIPVnUZ8sDrTAl4D5F+xhYX+HJ/hokG+KUJ5CMM/WPs8J93T7rp2fnW0946vu5KVtrAk+fGMsXQKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GxfuEvZk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GxfuEvZk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD2DC1F00893;
	Fri, 25 Sep 2026 04:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309571;
	bh=JmH7YODakEYTSw92WIGl37SzA87EbS0FJGWKFK1VH/M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=GxfuEvZkBic9KizPYkLn/5qMS7InWZlOf4M3qbeJbaOc51nS70gL1CvWR4yF3Ey6G
	 Frw7NQN6yX36Put+sfdsLhSrFmwjU22oCZP8pf0QX5HqmXS3w70eoK32eWfnokRBal
	 7kV49l7TpQeKy21CRpwCf7nVzLN4r05Nya/PnIq4wdsYIt78D+pEEQ7YYmGb6etFHW
	 /mdtSy3gMWjky2h7gVIYYDgfey9b2mPf0f/XeVq0Dj+jotqIoBqXYBZXdZ9Sblh718
	 pV1zFYnX08DQW6q59PE5DLl78jwr+kpBoFV668gOshjtX8kNEm4q6G0xuOdKDuRA5X
	 vHWsHO1/CnfIQ==
Date: Thu, 24 Sep 2026 21:12:51 -0700
Subject: [PATCH 09/12] xfs: break out of zoned reservation loop if signals are
 pending
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179030932240.3344850.15431918414180548991.stgit@frogsfrogsfrogs>
In-Reply-To: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

I noticed that if you run generic/476 for long enough on a zoned
filesystem that it runs out of space in the zoned section, fsstress gets
stuck in this loop trying to reserve space, failing, and kicking off the
gc.  The garbage collector in turn is continuously running (so we don't
break out of the loop) but the process is no longer responsive to
signals and can't be killed.

Fix this by backing out to userspace for any pending signal.  This
should be safe because space reservation is usually the first step in
any modification to a zoned file.

Cc: <hch@lst.de>
Cc: <stable@vger.kernel.org> # v6.15
Fixes: 0bb2193056b596 ("xfs: add support for zoned space reservations")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_zone_space_resv.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index 7aa3c74fb2e01a..8edc82025abbd5 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -157,6 +157,11 @@ xfs_zoned_reserve_available(
 		if (error != -ENOSPC)
 			break;
 
+		if (signal_pending(current)) {
+			error = -ERESTARTSYS;
+			break;
+		}
+
 		/*
 		 * Make sure to start GC if it is not running already. As we
 		 * check the rtavailable count when filling up zones, GC is

