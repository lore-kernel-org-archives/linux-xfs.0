Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420E178F26;
	Tue, 21 Jul 2026 03:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604431; cv=none; b=cXcXttBk/Iifr673jzwwd5BliBwwSmrGBMnglUc0VWgo9Qgwdm96yLvrmRWPh4yWk6VAJefJVzHDA0Uq6uTWEvf4pSokAbTO8uDJjEAU9xc7e85g0TuqtcTXTvGPD0u92meuZ0wde09KDs9CLo1Cq6q22tbaTIbJVK8TcFQ7mBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604431; c=relaxed/simple;
	bh=m8WUQddTb4ZFWTO8Uod8Pb/NYY20TBWJkmcbjb9PmWc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TOHBLCHJG0eW8oLJMQ+qR99/EpGmLBgdSVx4wJviIzoETA3m8R/3AH8zWW/QrdDotGygpJGLr7cyfSdzMgG+k6C5V0OiaqkmN57kmfSAHNADl0o+sNZ5PF2u/OqGkdo1zHQRCRkWWNnzEplMdlVY+fs2kS+tkmibTDT/79OS1Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NMgmeXTs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMgmeXTs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BF8881F000E9;
	Tue, 21 Jul 2026 03:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604429;
	bh=Tj1A79AOFaOBGbxkvBJ82/QjNoIM5RmskWRZ8dai/V0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=NMgmeXTszbAVQ7AmjuO0LWhW3VJKz3Sd7CdTvGKA1puvx3AlaxuNML4r3f0nVpLtM
	 4zX3PJHTTmudW4ns2ixxc/LXf5XdqgR2kjG26WNj8mi8fETWd7JHYQnTvl3AsgJxtb
	 K6I5HnidAelQR5WQzJdSihTshM1Fn/UFai7e40rtwagfddG4FpMVngzCJJWjOBn9Fk
	 q5avHcHhxVQiB0r3Dz/OCTkLSbafloo+IYghO+z2h4sxk5NLK828Z1T4Co19XjzFOR
	 5YzjoCwIJahnjf1Hg1R3kxnJ7KRCYy6tzbRH8QkQZMOunZETLBBNn9DYuYuY08kPAF
	 VDuz9ST/UReEQ==
Date: Mon, 20 Jul 2026 20:27:09 -0700
Subject: [PATCH 9/9] xfs: set the prev pointer when reinserting an inode on
 the unlinked list
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419679.830862.7131488553992668965.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we find a rogue free inode and decide to reinsert it into the
unlinked list, we need to set the prev pointer to NULLAGINO so that the
incore list gets updated.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index da2265678d17f5..f75bb8f27b1215 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1489,6 +1489,10 @@ xrep_iunlink_add_to_bucket(
 	if (error)
 		return error;
 
+	error = xrep_iunlink_store_prev(ragi, agino, NULLAGINO);
+	if (error)
+		return error;
+
 	/* Remember the head inode's previous pointer. */
 	if (current_head != NULLAGINO) {
 		error = xrep_iunlink_store_prev(ragi, current_head, agino);

