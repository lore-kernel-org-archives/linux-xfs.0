Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B241E7C34;
	Mon, 21 Oct 2024 10:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506920; cv=none; b=beTalH5TOCeaA1Q4SvFlJ+AFFMHcoCUSjBk2EFuFq38Z5ude/gz+d/iACQR1U+K2aAkYPKCggRxwTrjGci+qCouhe/+McDlbZht3quOcNsHe0URNTgDKbG/dR7yU+kbGVYZppJg3ZDbi3HCdmx2z1Z6rdq5ug9TpPB/1FwEyTUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506920; c=relaxed/simple;
	bh=dusvwWHZeY9kdD0iR9KFatieNIJOGPeSJsGUxj0uZt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieKt16lhlxHhSE0el6bNAaLWLqWwTny+XXcXkkZOMB1ICkqnDLcHsVQmHCywd2nEdzS59MUia+QLXFmc1u/+qISev5m0El6pCEWVRg2KZNFwmZSKmlIXM3OlBzX23yyFlnFeRan7xNr2mk1VYFXoM/Cn+M9MQNEfV7/hsoOt5h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDvGpTfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDvGpTfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE86C4CEC7;
	Mon, 21 Oct 2024 10:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506920;
	bh=dusvwWHZeY9kdD0iR9KFatieNIJOGPeSJsGUxj0uZt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDvGpTfx9NjlBY++et4kG9zOMlfdkHiPWiD8zNrgJBTYrjXQSx1BQxW3HK9VyX00X
	 eACwNiivM2He9NIN+k09PY4wdFZ39BvVMj/vz53syvtvLT2aRoJydsM8/5YogiLKce
	 tqAqvyvOt9iB1Bk1ZVLFCqP5yhaCUoNufZa6xDD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 030/124] xfs: check shortform attr entry flags specifically
Date: Mon, 21 Oct 2024 12:23:54 +0200
Message-ID: <20241021102257.892283414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit 309dc9cbbb4379241bcc9b5a6a42c04279a0e5a7 upstream.

While reviewing flag checking in the attr scrub functions, we noticed
that the shortform attr scanner didn't catch entries that have the LOCAL
or INCOMPLETE bits set.  Neither of these flags can ever be set on a
shortform attr, so we need to check this narrower set of valid flags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -566,6 +566,15 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		/*
+		 * Shortform entries do not set LOCAL or INCOMPLETE, so the
+		 * only valid flag bits here are for namespaces.
+		 */
+		if (sfe->flags & ~XFS_ATTR_NSP_ONDISK_MASK) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)sfe - (char *)sf,
 				sizeof(struct xfs_attr_sf_entry))) {


