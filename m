Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B00209F4C
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 21:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736890839; cv=none; b=YClM4LlCmxtSkFbMlbrhsMHvI75b9w5wkY9oghEeTUsh2lzsbqtjmHMmjVMbmE15/oZT5t8vbmS7y9q0SCVKTzbqdSTt1s6ONirW9z3cWTRBCqGd6oRzHquTwsFszqfw31tbjMnTmhh3IFfWyVECEJAcAJ8WiHGwthC/R5TvZJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736890839; c=relaxed/simple;
	bh=1YkTVmxcrDWYflgE3xalJKcOXiRcQiDlna/L6L2vvQI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MbhtgQC2mW0fxCJYgACGTKMJOHCIi/il3JURfPAyuEgh8C9BVZ4mqKlYdl0kjnF6v5nDyHcTq7uk3xGvsHDLjiz3z8cIVPyaH+QhsDh/3OhBqOmCfDviuz9EVMPolWvhAY55iQqGuIyaA74pE8jHfJ0rVufeOWrrXySsD8i1Ek8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lETZSB1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lETZSB1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B0BC4CEDD;
	Tue, 14 Jan 2025 21:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736890838;
	bh=1YkTVmxcrDWYflgE3xalJKcOXiRcQiDlna/L6L2vvQI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lETZSB1m3ugXLd+nyXgJen3+Om+/8gySxN9sx6nXacOSDildcQkjQQIYfW/z6kClr
	 h00NoPqkrbHKyiF+40VmVb6/BoDYuhP4QS3bkm3TR6pjpSS1MsIYNcg3fQkcBPEJBW
	 G6k6eG09HBD6MX4Vvd7TISlms1wnNj+s6yHJsbbbTw/xjmQvxj3k/m1XZ6c7jDPSWI
	 OX7jiF7N/JmuJ3pD8m2VgGySHxPLuxrXcXbJTT/Ei54H1qCMEL3V2gvs5fd/j3f7G/
	 LzjpCFjFvbG30xoLCpEopsVu0U3LXAlbtGGmX036RVeBRWg4XPiyTEYK4nmPTEYR9E
	 3YWEuVpiHo53g==
Date: Tue, 14 Jan 2025 13:40:38 -0800
Subject: [PATCH 1/5] xfs_db: improve error message when unknown btree type
 given to btheight
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173689081897.3476119.13308060628733838470.stgit@frogsfrogsfrogs>
In-Reply-To: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
References: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

I found accidentally that if you do this (note 'rmap', not 'rmapbt'):

xfs_db /dev/sda -c 'btheight -n 100 rmap'

The program spits back "Numerical result out of range".  That's the
result of it failing to match "rmap" against a known btree type, and
falling back to parsing the string as if it were a btree geometry
description.

Improve this a little by checking that there's at least one semicolon in
the string so that the error message improves to:

"rmap: expected a btree geometry specification"

Fixes: cb1e69c564c1e0 ("xfs_db: add a function to compute btree geometry")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/btheight.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/db/btheight.c b/db/btheight.c
index 6643489c82c4c9..98165b522e4f6f 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -145,6 +145,12 @@ construct_records_per_block(
 		}
 	}
 
+	p = strchr(tag, ':');
+	if (!p) {
+		fprintf(stderr, _("%s: expected a btree geometry specification.\n"), tag);
+		return -1;
+	}
+
 	toktag = strdup(tag);
 	ret = -1;
 

