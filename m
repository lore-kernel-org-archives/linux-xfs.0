Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF11319D8A7;
	Wed, 19 Feb 2025 00:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926454; cv=none; b=lpeNZaso6Yd1/slqAT7c3iV00jIq5CFV2inH62QU7sIZ99XyQHhGw5s63O8cmf47166pewTgm56KGjGiAIfjPsLNUxmH1OGdAT4eUnfsd4vyMINKUXEIcbPAjOHxw00bMRVXDvtqt089igAnOUInrLcFx6Pgs5qOIY+t2Sr48pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926454; c=relaxed/simple;
	bh=eGLYfSAS1jPiC8cDgTecQA3TB5seG3X1C2zFLDZPp44=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OKmAwC2rG/agD6gUVgHaQtiDbje3fRDWJ4qYkAL9SNeEx07ifglNLxQ7nkPWL4ciTC+miEgbiX3FDrqSXYHipwinvpBA54ba9y5KkeIAygb069eicBw1QNXeVr/GrpEBQbkMBC/ctgXFdQ2Ag3S1IvLM/f1mtUrFg9xqR3IN14Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hV8sRJsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hV8sRJsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6576C4CEE2;
	Wed, 19 Feb 2025 00:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926454;
	bh=eGLYfSAS1jPiC8cDgTecQA3TB5seG3X1C2zFLDZPp44=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hV8sRJsx7X1WNxoAibNDudp/0l9O7aKO/bN2kpoqisf/d+3ujF9+5txEp1yWbdokk
	 YaK7WpP09qtSSVIHEDpiR6XKgTMpI51hBJjpzTykzIC+Ej8nvESupwIY7ZcY2g4V7Y
	 mQcQIieo5MTsjdixeCxdqv8AOy++PyyMM/0CdVKq7D1pmCHdgrDMI4CukJGAL4SLVK
	 WpDiF+0MVugeBLHKcqKYbpOGocgzQjDWC67SCTK3+hqj1Smsp5rKCwrpFeXLwkBRkU
	 xmcDJeFHpd77UWBKdf3ZpBLrWF/uqEXB7frJh4SSlvz8907yJBlEYiXb/Ye8IEkE9Y
	 V71HbhMPHyhJg==
Date: Tue, 18 Feb 2025 16:54:14 -0800
Subject: [PATCH 03/12] common/repair: patch up repair sb inode value
 complaints
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588116.4078751.15663339276086108396.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've refactored xfs_repair to be more consistent in how it
reports unexpected superblock inode pointer values, we have to fix up
the fstests repair filters to emulate the old golden output.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/repair |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/repair b/common/repair
index 0dae830520f1e9..a79f9b2b3571ce 100644
--- a/common/repair
+++ b/common/repair
@@ -28,6 +28,10 @@ _filter_repair()
 	perl -ne '
 # for sb
 /- agno = / && next;	# remove each AG line (variable number)
+s/realtime bitmap inode pointer/realtime bitmap ino pointer/;
+s/sb realtime bitmap inode value/sb realtime bitmap inode/;
+s/realtime summary inode pointer/realtime summary ino pointer/;
+s/sb realtime summary inode value/sb realtime summary inode/;
 s/(pointer to) (\d+)/\1 INO/;
 # Changed inode output in 5.5.0
 s/sb root inode value /sb root inode /;

