Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8F638F624;
	Mon, 28 Sep 2026 06:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576339; cv=none; b=asVDtMyYaQbHXq/9e5CNLLXTG6xlsqK+Tx3aRUKNvk7O9sBEpyLQonJjbCer7nhUk4hB+55rZxrha3mTuyxWnr0GFIVuzVT09H8glFIRG4x6AhveLjOQbHZ0bITDKtNElV2YP4Nc2AkhjHJS1H9C/5c2fFJhT8EeCbyc+PPS1QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576339; c=relaxed/simple;
	bh=kYJQq5lsJt1E/Z9aJaiyKbYNT7vRFz+H3hYR9qz9X3w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDKQ5sGUZbsWqVJU6sTwih5FoSwTa/4/dvS6LB8w1GFf6nIjwthrK0Ti7I8OZOrrtcREUq+hZfE+9plJEnc4IN8AIy1M3K4Dsde9/iBqt8wcnxbciiXMf/1P6kIfkNO2gFjHKo9rKIpQhDr4E09bXeBMIrobqNc4r2oGPW5E+JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wf/Bzwcu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wf/Bzwcu"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6A9E51F000FF;
	Mon, 28 Sep 2026 06:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576337;
	bh=2I/C8ApUfZnCoPcJHfcHmaHgo1/adhxvKHlXpdK+/es=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Wf/BzwcuFT3QvMDahWbszKrSXQOLc9Tpk5E9/Jrbb/nrf+rKyeAPhkYfLeuwRR+tC
	 d901EveoukWPpDXA8lfdKj5oljwy/rm8yOga5v9YhfP7Mr3IqceTeFt0jr713VMY/F
	 q0xf0FIQGZa/5JLbVMGyhv/uyQRabvA1aAalOxGUc+46328UDSDKxe0F4AU35MtPGM
	 n+VCKpqR7ZNZ5Hz5CRIGC1njPoQ6z5Fec4o4EtdEhxWUhpdXMha5XiBsyrAyRcywXe
	 EJcO3P/xPB6w0nAZfLzV80h9y4ztF6Yh9WFUMQ48xS87J6JN3AbdBEgrMVzkPeOSVN
	 emPxwgmrWPjJQ==
Date: Sun, 27 Sep 2026 23:18:57 -0700
Subject: [PATCH 12/12] xfs: don't fix the directory tree if live update fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612852.479634.517512730050227315.stgit@frogsfrogsfrogs>
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that we don't double-check dl->aborted one last time to
before committing repairs to the filesystem.  This is important because
the live update handler could have set ->aborted if it encountered a
runtime error.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dirtree_repair.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index b856abb6bbe9e8..717ebbe4f91916 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -440,6 +440,11 @@ xrep_dirtree_unlink(
 		error = -ESTALE;
 		goto out_trans_cancel;
 	}
+	if (dl->aborted) {
+		mutex_unlock(&dl->lock);
+		error = -EIO;
+		goto out_trans_cancel;
+	}
 	xrep_dirpath_set_outcome(dl, path, XREP_DIRPATH_DELETING);
 	mutex_unlock(&dl->lock);
 

