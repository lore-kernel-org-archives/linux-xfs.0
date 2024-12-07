Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CCB182
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529911; cv=none; b=dxER0NTozZaRLkak7oLU3HYQIm/X5dmWgCtzKy9itk7d1IPDIPwmGnCmpcZOYiRMgqR4Dql/4n6j/CAigzLtNe7CyMokW7Gyvll1SQHZ/4px5MkSxumTbPcfGsFRFJ+kJF0BpzCSebJNNM3UffIWPJD/pQ0Xb5/uD2Wufd6lE3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529911; c=relaxed/simple;
	bh=Av/VOQdsA7QOQsWUD36EIwCE2gr5dwxG1IaXdqKJeqE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZPL2DzD6vil9rLZ3+9esKK+i+Pla34KqZysULd/1Ow9kCVtYWkWBRd7yNtGgIJ3ZGQeQAU1xK1iXJJlTNJs6s882MaNSFrRkBWq2IDLYPkWZdUIz0TZ0ZL5ZCH2cfkoCqYX5WgG2E5+yWUJ+T+rZszmZADq753IbquHAZk4m/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frcsHrXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frcsHrXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431BBC4CED1;
	Sat,  7 Dec 2024 00:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529911;
	bh=Av/VOQdsA7QOQsWUD36EIwCE2gr5dwxG1IaXdqKJeqE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=frcsHrXFZ8WNc+Uh4lziPRMcq6XBDgex/BODD7mncFgju/Gt3WU3RYT309KwifsWT
	 wcdUzpgpr6Pj7RehqeaFNJQY1HocDbCTCLMlES8LD7Gq1GUJTdnuVRVHB2WKTk3vOB
	 VgCfwEyFFZrux0PqTSFzX7AeM51eAdijFyPeT2OWoWaNYHeKS0NF5tF68Az9XRC4Js
	 +HgCAvQDACZ4+Fen5E38/EKSK14IBzD3y3JPrKsEY2zzZJtWAKJTVOoxlFZley5MhI
	 q1J9waDbUiA72rTgjhp9nMTfbG3EGVXbBqxJrfCCc+LAIH7aHS+5NvjhpJ4Hx7GJPQ
	 KGqBxy/9dPz4g==
Date: Fri, 06 Dec 2024 16:05:10 -0800
Subject: [PATCH 01/50] libxfs: remove XFS_ILOCK_RT*
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352751961.126362.26672776797656879.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've centralized the realtime metadata locking routines, get
rid of the ILOCK subclasses since we now use explicit lockdep classes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 1fc9c784b05054..dd24bdc2d169d9 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -180,8 +180,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define XFS_ERRLEVEL_LOW		1
 #define XFS_ILOCK_EXCL			0
 #define XFS_ILOCK_SHARED		0
-#define XFS_ILOCK_RTBITMAP		0
-#define XFS_ILOCK_RTSUM			0
 #define XFS_IOLOCK_EXCL			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)

