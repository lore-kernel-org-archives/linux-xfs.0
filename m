Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE04219C540
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496964; cv=none; b=Tgq42urxO4LVNGPKnvBYSrEgWDTXTJi/5j2Lk+LNoia96uTt2D8aJ9JDhmQvAgoDfqYOGeisxD7/BFWbPDclGVjizGKR7ELk1gqVUdgL1furWJDcy03g+gaJM0dsfKKrP6ekyXMuo+2FVEaCpbgUbTlfZrE3fHq/KZMGLCvfSaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496964; c=relaxed/simple;
	bh=YFJemUPHfQmqPovfTYA80VU6llN+D+u/vaR/ByRCqsY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o+EeEWoIErmUK/Oey50T0bIaLbqlCz+4/5qfwKoUuFNPX3RE99GW249z9TtuBnGn/KmdqnXmIFeZkjadCvgbXZk57ZKSQj1D4/BUWBS50P360kIVrrrhAPUtbZPGLn1DXhQX6+LTEDZ/jXRzKRIW1xBwPFNCVDAYwZOm1w/0K+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dXUrh4bB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dXUrh4bB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60796C19423;
	Tue,  3 Mar 2026 00:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496964;
	bh=YFJemUPHfQmqPovfTYA80VU6llN+D+u/vaR/ByRCqsY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dXUrh4bBLYuB7WSudn9D9u3tZYcWZUFMXp/cpMWkv64C9mL3kyP5e4G1ettZ9wUx1
	 KWCZpkglgSFeHkX90nVfB+L8fCt8KFr+OT7dGw9AESQnaoSxdF8pP5pwi7GLBe+iZy
	 X9c75LhxsrkOgsZ0G6XyXAoEInpv9JDn1ni8eZId86s1k2cpdTlH1lbi/eGVP7nwqm
	 nHCyUxGMCH+eLsJpHnf8s0G078g8Gs8lYlty/9xXJTqPSAeFvL7UzDvxC00VKpslYk
	 F22MwpgzewuJS+43ttSQH9jr8XsAYmi4tfRpTAqdw7B/DuglmshmSlFA9fd1cC1dM8
	 V6zwqytpI3kUg==
Date: Mon, 02 Mar 2026 16:16:03 -0800
Subject: [PATCH 15/36] xfs: add missing forward declaration in xfs_zones.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, dlemoal@kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177249638055.457970.7793974322448117529.stgit@frogsfrogsfrogs>
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

From: Damien Le Moal <dlemoal@kernel.org>

Source kernel commit: 41263267ef26d315b1425eb9c8a8d7092f9db7c8

Add the missing forward declaration for struct blk_zone in xfs_zones.h.
This avoids headaches with the order of header file inclusion to avoid
compilation errors.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_zones.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/xfs_zones.h b/libxfs/xfs_zones.h
index 5fefd132e002ee..df10a34da71d64 100644
--- a/libxfs/xfs_zones.h
+++ b/libxfs/xfs_zones.h
@@ -3,6 +3,7 @@
 #define _LIBXFS_ZONES_H
 
 struct xfs_rtgroup;
+struct blk_zone;
 
 /*
  * In order to guarantee forward progress for GC we need to reserve at least

