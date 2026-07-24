Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78853419315
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 13:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900031; cv=none; b=gHcYCW+HVCsV4X/7JxYKlkMZn/Xf6plZSDxuHn4KlPwnfzPIRXGXOk0wAb/bvJyyiDZfaqDtXiau+UQ46FDJlZUyaN2MaIQhafBygmeOPBW7WAmCQsyE2QVbvYoP9OgK9uN+LI6IHVq4kiDKuc61VGdFzQ9Wq8fi2ynux9RbYq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900031; c=relaxed/simple;
	bh=H0HD6N410POA/WviH+K+f5NDAyh0/xlpYxSqbdwz8rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaR8VdoQcxQC/+vkkxWg74UNp1Rsxm3J+nobGWxj1RQEhTrlqzb0juKP4/rwge+L010NagH7VAYHJVzwjzMS67bD477fv3ALiItmd44Pa4eY0YNg53bogBUR8SxFbPWUrJpHrQVmgztqydyKn75pRcn0+1ggiQSC8N7FuLH2Q0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uXzeyrTj; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uXzeyrTj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uXzeyrTj";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uXzeyrTj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6D2993F12;
	Fri, 24 Jul 2026 13:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900024; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qs56XEJTOBFinoEPJP49pT6hCa6z1eMuZX0MvtQ+DGg=;
	b=uXzeyrTjXjqOPX5SgXZ5LSAxY+DPs1cjMss1YG+DwfKQNPtQSsx6P3z6I5UbflAiswMUTV
	vVmfIbcsVYKG32bCViSG0Roo0AirTk7FWBSICVk7W/hiB5CYlpP1qsmPZxUCrc3fTX5gbd
	QtGEFHzMIWL1VHAW2ZNUhjlebF+2weo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=uXzeyrTj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784900024; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qs56XEJTOBFinoEPJP49pT6hCa6z1eMuZX0MvtQ+DGg=;
	b=uXzeyrTjXjqOPX5SgXZ5LSAxY+DPs1cjMss1YG+DwfKQNPtQSsx6P3z6I5UbflAiswMUTV
	vVmfIbcsVYKG32bCViSG0Roo0AirTk7FWBSICVk7W/hiB5CYlpP1qsmPZxUCrc3fTX5gbd
	QtGEFHzMIWL1VHAW2ZNUhjlebF+2weo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DF38779BA;
	Fri, 24 Jul 2026 13:33:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uCDyILdpY2pIJgAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 24 Jul 2026 13:33:43 +0000
From: Daniel Vacek <neelx@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org,
	David Sterba <dsterba@suse.com>,
	Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 03/12] common/encrypt: add btrfs to get_ciphertext_filename
Date: Fri, 24 Jul 2026 15:33:19 +0200
Message-ID: <20260724133328.1837318-4-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724133328.1837318-1-neelx@suse.com>
References: <20260724133328.1837318-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 6D2993F12
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Add the relevant call to get an encrypted filename from btrfs.

v1:
 * fix reading of the encrypted name
   - use simple sed substitutions and consume escapes using printf

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---
 common/encrypt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index 29293ea4..8a0aaf1a 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -713,6 +713,20 @@ _get_ciphertext_filename()
 				print STDERR "Invalid base64-encoded string!\n";
 			}'
 		;;
+	btrfs)
+		# Extract the filename from the inode_ref object, similar to:
+		#
+		#	item 20 key (258 INODE_REF 257) itemoff 15121 itemsize 26
+		#		index 2 namelen 16 name: v\354\301\231\214\341+\335A\002\216\3405eFz
+		#
+		$BTRFS_UTIL_PROG inspect-internal dump-tree $device | \
+			sed -n "/ key ($inode INODE_REF $dir_inode) / { n
+				s/.*name: //
+				s/%/%%/g
+				s/\\\\ / /g
+				p; q }" | tr -d \\n | \
+			xargs -0 printf
+		;;
 	*)
 		_fail "_get_ciphertext_filename() isn't implemented on $FSTYP"
 		;;
@@ -767,6 +781,9 @@ _require_get_ciphertext_filename_support()
 			_notrun "dump.f2fs (f2fs-tools) is too old; doesn't support showing unambiguous on-disk filenames"
 		fi
 		;;
+	btrfs)
+		_require_command "$BTRFS_UTIL_PROG" btrfs
+		;;
 	*)
 		_notrun "_get_ciphertext_filename() isn't implemented on $FSTYP"
 		;;
-- 
2.53.0

