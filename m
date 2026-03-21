Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB71832E141;
	Sat, 21 Mar 2026 11:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094321; cv=none; b=glYcdb4Q/Or0nZNckIOKE2x2tkJWOiBSI7TD+AGdaa/jAi7OtecwpbEadLj3rAsD8F9E7hYmfNBystOyOyZqaJGkzSN+zOz8F1FuFJ8gWrajlpGxm80UJwPePsAsutw5O8IMyjke7FHCPW/53U05CPCTVw9KUULFjqlTbD3OJIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094321; c=relaxed/simple;
	bh=fJ4PCrGTSbxqHLzJ9rzqcuhFTW5952Eo95pKbjqW10o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLYqy+OV79jdfnA2jq3E95E5kCNznOJCGWu+JW7Y7/ZE1kY1A2UwbeXo/eWzskFbjIt2NupGSV4UcCPytJJ9H+zPzt//JOeFvQd3+hX6IVoO2HrLopxw+B+HH4v0Sq9hCV3uzgOvLfdhvxFYD4mITSa0iYZIlu9+dIhv7qUOT64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imT7JVu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imT7JVu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1883C2BCB6;
	Sat, 21 Mar 2026 11:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094321;
	bh=fJ4PCrGTSbxqHLzJ9rzqcuhFTW5952Eo95pKbjqW10o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imT7JVu2duEPG27jJNK7gdZBI0YgFmPj+NmUlbXvVOh1iaBG2IAWHU67VAtNYy0V8
	 Axl8ButFdLl9idyqQB5kJbW4Id5GmVQZIT21iPi6pUw4p72nJl1eoI6wxZJNjqOZN5
	 S/kqD3LPh5IealXPs0LAvVk8v10Y3kiCUhKeDPc7WD+2qasryRtWD01jZYz4MlaUic
	 30vt919ycgYsVp+qRfGWJzMYiw+D9dqno7u+g9hb9eb+6lbjdVSw8kz9abrFHP4mPH
	 rbgNCTfcK9UXiwynMy1hlQD8ma4V0XRuQrYyMg0u4li0gz2YW2rIsN3+5a39WyMd4I
	 ucAkynr9hQjnw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v2 1/9] fstests: add _require_nouuid_mountopt() helper
Date: Sat, 21 Mar 2026 19:58:22 +0800
Message-ID: <237cee13793732b06111dc4e6368698ca885ad72.1774090817.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1774090817.git.asj@kernel.org>
References: <cover.1774090817.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper function to check if the filesystem supports the -o nouuid
mount option. The helper attempts a scratch mount with -o nouuid and
skips the test if the option is not supported by the filesystem.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/common/rc b/common/rc
index fd4ca9641822..9e3041beee2f 100644
--- a/common/rc
+++ b/common/rc
@@ -6149,6 +6149,15 @@ _require_max_file_range_blocks()
 	esac
 }
 
+_require_nouuid_mountopt()
+{
+	_require_scratch
+	_scratch_mkfs > /dev/null 2>&1 || _notrun "mkfs failed"
+	_try_scratch_mount -o nouuid > /dev/null 2>&1 || \
+		_notrun "mount -o nouuid not supported by $FSTYP"
+	_scratch_unmount
+}
+
 ################################################################################
 # make sure this script returns success
 /bin/true
-- 
2.43.0

