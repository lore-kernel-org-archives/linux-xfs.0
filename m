Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B3917C203;
	Tue, 13 Oct 2026 00:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850147; cv=none; b=dlhi+wVHcR+8KQBcaMkIOQsMquNEFSOdRxBPnatflVP4Z1YDzWgmVMQLuE5WEr5VC0RR+/5vmqRZhUB0Gcyshy+REEHkVfWDyDAE3yfrBeADz2C6Rj4oscJ+OrJ2amwjcWe/h/F5XZF1nqYYiV+Edeg7N3xAdmqWykkJ8AnbuoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850147; c=relaxed/simple;
	bh=1PpylEWuYpPnl53rgV0A1kfh529UuQEmoAiot644Byg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h6SjjNdpiMe80Oal+S4IRYwXRtEfnOM4bA5w7qdHgaN/4WOsScDfvw9fM3yFtYbcvdnjS8bj1kPveH4PBu273+bJQ/8OLz3HOSGCkMsH6mwoete0LAdRgNi+g0H3BvXzYG5OuV0tl3z8ieqVz6doSVuFRfNh8c7pcS+k2u0OcEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kaafyOob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kaafyOob"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 719D41F0089B;
	Tue, 13 Oct 2026 00:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791850146;
	bh=C0xPs1i4w0in7gyj5h0zIll2Q1W98T8oBH2zmrP5ZmQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kaafyOobWwKrcHodEZ27I5AFeCY9WwlMhEmDewy8JOKQ0Z+RTGdZ7c0VNIkcixe5c
	 8WLD5h+h7xMiDqA3FDHIZBvOw1Mkd5+Vulq3shfqNCVAdi4MfJJZBeD6J5Mr717HFR
	 E27sdkLcGBwjqXZMzNQYqtw/V8ZdCK7h5awIBtUq+8iVyZ7XRVKlidMchxf0HX2l3K
	 UqcaIPya4O1AC5ggtGA50QxzcPxKAiDOXSvrrfglXrVinGnvvnjchuI7qSuafrpjbt
	 PUKpwsVgUAF7KD2mcoojaRUXSlaYEU2b9yMpQdiqcbvC/gjs8Mp16JUoYJKqrVRB2f
	 NJxF+cGHL0+rQ==
Date: Mon, 12 Oct 2026 17:09:06 -0700
Subject: [PATCH 2/6] common/xfs: add zoned/rtstart info to mkfs filter output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179185007491.1732194.4285326188369726064.stgit@frogsfrogsfrogs>
In-Reply-To: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
References: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

A subsequent patch will want to be able to extract the start of an
internal rt volume from the xfs_info output, so add the necessary lines
to _xfs_filter_mkfs to transform the output into bash variables.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/common/xfs b/common/xfs
index 98981e624ddade..318b1a3b245ae6 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1787,6 +1787,9 @@ _xfs_filter_mkfs()
 	}
 	if (/^\s+=\s+rgcount=(\d+)\s+rgsize=(\d+) extents/) {
 		print STDERR "rgcount=$1\nrgextents=$2\n";
+	}
+	if (/^\s+=\s+zoned=(\d+)\s+start=(\d+) reserved=(\d+)/) {
+		print STDERR "zoned=$1\nrtstart=$2\nrtreserved=$3\n";
 	}'
 }
 

