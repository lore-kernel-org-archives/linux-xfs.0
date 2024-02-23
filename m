Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B5A125A3
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 05:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708667298; cv=none; b=DY+OCOd+w2qjPqcuKXMiWDKTEnUE9sgikYEJPSI65kasBqaSDX376IcXY8e659k5D7t4kMNqzcvjiYTULqdXhEL4Ts/9wM20AupPWNfeTi01rdht548TCqII0j11vA74Cp2moVvNtEOA7Q5rTeYugv/p4nHUx9Tn7llfvlq7S8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708667298; c=relaxed/simple;
	bh=XDuki1EJTuF8MJ/UedULtphz4EOIHS20oHwF+VEIj6U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ad6K1bggaGv7wKL7wYWjfau3MF+Ya4ptO6hBn4ZZ4qCNxkM6JImU9SMFzLZixQcWn8UWQVNw7x5UBc96CC4xwKPt1Ce54pFgtdJunsWYOb7KBjP7Rd4IXkwaZAe3gNIqIhMEW6g6wLFkafd4i0k/GOdGGJydLopKlfpCFSxPMKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=joPDuOvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="joPDuOvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96F9C433F1;
	Fri, 23 Feb 2024 05:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708667297;
	bh=XDuki1EJTuF8MJ/UedULtphz4EOIHS20oHwF+VEIj6U=;
	h=Date:From:To:Cc:Subject:From;
	b=joPDuOvnuovPSQnwXbBtIi/N/DAqBLZmPH9mW54NcHFAbJLpgrEbfpVBobwRWyl27
	 7Wtx45TEelV82RA5WA0AJOaK2xgr7KzEds/uVZ3eHQHVLu86guA9JCT7MGfvNDEZqL
	 Bn+DC4sLTFKBQhx1PMMomzkdX6ttMX53sbtvpz66SOuIVkoA2pIkSKeMravn2ojKuG
	 JClVfixKhBR11OWxCfoszJv2qfxQ6Y9vyyWEOaRzQv7HPgRRlEzCy3HRXKRt/2bwof
	 S/3DZIumKDC0uN+FIhynvA8VnXzD7i3+Rbe17jpzVrqc64qxZrYO0Fvc8F7CU8fSxO
	 igCfYbda0UEIg==
Date: Thu, 22 Feb 2024 21:48:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>,
	Chandan Babu R <chandanrlinux@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] xfs: fix log recovery erroring out on refcount recovery
 failure
Message-ID: <20240223054817.GN6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Per the comment in the error case of xfs_reflink_recover_cow, zero out
any error (after shutting down the log) so that we actually kill any new
intent items that might have gotten logged by later recovery steps.
Discovered by xfs/434, which few people actually seem to run.

Fixes: 2c1e31ed5c88 ("xfs: place intent recovery under NOFS allocation context")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: actually send it to the list this time
---
 fs/xfs/xfs_log_recover.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cd134830a695..13f1d2e91540 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3532,6 +3532,7 @@ xlog_recover_finish(
 		 * and AIL.
 		 */
 		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+		error = 0;
 		goto out_error;
 	}
 
