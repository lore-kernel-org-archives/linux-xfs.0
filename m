Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F89358D35
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725618; cv=none; b=Kjh4ZQS7gaa7Cs7mr/3YUEmIoRcD7e0SdY70AINrGjIOTZYRkuQhyFiLoeYXFfXK7jwcCTR8k+3yX5CoozODotSAE6maIyaWgyxinvrFYgumklWRc5ieuEjQF8sYVWNv8AOD8+6NeVl5cJ38QNkI6ExNG3+EsEzmohssmmgSKos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725618; c=relaxed/simple;
	bh=LnYNHeouMDv9t1cpPOCV4I3Zgks/PUwDn1hsp+U3Lhw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JIqI8cly0vrtMm3jpjqXFpQN2ki+YkdlLveFMommcWhjSrnhL86uZXvWaKbyt6SighC8Fl+oPk5vuM2sTx01XEo8ZcFMqFP+TZunoJMI+QI+UnlaGI41Yb1Okrj9q7b3zDuo88HX15GyDk0hk1yRVaH/s/FtKeTK1nEgL3bv3J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLK5pK8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLK5pK8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4024C116C6;
	Tue,  6 Jan 2026 18:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767725617;
	bh=LnYNHeouMDv9t1cpPOCV4I3Zgks/PUwDn1hsp+U3Lhw=;
	h=Date:From:To:Cc:Subject:From;
	b=cLK5pK8Zufw/9bJ7p1SjMLAQ1YxcYmTeNLRLU2FCj/jOyp9K2xYsqbenVzXxANvGH
	 WHWKXzPuT2YayhqEuYyy+plwJtfPXf9prf05d0PoHsRSFDW85q5j7M00PjTNjkKQQL
	 Mg+IqkOfHlO38mXnTmSvs2BfCFBEN7YfgVs9LSNK43rJqbgGfA/At6rx278PcBX+hS
	 n7lmEH4TVocvN9dfO17lcmXNXcuIksU/a3I7XJfSlss+Gc5OwErE61yAYhjjOR9vlC
	 cYOA1B7elKpE3eCK82BkavW+5rQv7VzOhTwrgsHmZIzrf9SfK8IO2VKh60nvbILPs6
	 VG0SuO9zBsf6A==
Date: Tue, 6 Jan 2026 10:53:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_logprint: print log data to the screen in host-endian
 order
Message-ID: <20260106185337.GK191501@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Don't make support have to byteswap u32 values when they're digging
through broken logs on x86 systems.  Also make it more obvious which
column is the offset and which are the byte(s).

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 logprint/log_print_all.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 0afad597bb6ce0..9c3cd5fb5cfb31 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -55,8 +55,8 @@ xlog_recover_print_data(
 
 		while (j < nums) {
 			if ((j % 8) == 0)
-				printf("%2x ", j);
-			printf("%8x ", *dp);
+				printf("%2x: ", j);
+			printf("%08x ", be32_to_cpu(*dp));
 			dp++;
 			j++;
 			if ((j % 8) == 0)
