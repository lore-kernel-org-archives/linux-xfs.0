Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ACA1EEE0;
	Wed, 19 Feb 2025 01:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926908; cv=none; b=j7LeLnTC/ut2IFfEnYw+zY3jONv+w3Yd02j6AJUVyZYWcdfNHh8BnJ2WnOyQS2ufh7B/6FTbHfY9gE/aKgLjUAhXdCmJEd8JqSfuTWoTpprKN5rcQh/YG4U3cKOeBFKE5I9ygR+PE77d8s7FgLCrl54g/5aHAKQwUJZonHDiZCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926908; c=relaxed/simple;
	bh=VOxDPzJn9bmZez9LNjUkHbSaAvvrPtZQZAMPbcZfX7E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0/XS3/GatvogTykyy2eKMwoLoLY8JewrNXhE1a1MSyGXM5qDp4QXLK+5QUqBkO/z9+tIhOqFw0Rj2KBkFajOfA5Q2n/Ycs/a2Hm1ZJtTAGxkFeLNYKLzDvMQmfWxZe+mERhJ0dks9vq78PtlnT8unzT5zORvJHfQeuo2dJbFH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4UGNEPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4UGNEPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67232C4CEE2;
	Wed, 19 Feb 2025 01:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926908;
	bh=VOxDPzJn9bmZez9LNjUkHbSaAvvrPtZQZAMPbcZfX7E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m4UGNEPEa4Af6sc3eRVa2w5UBJWX6cPcefcdugVri36PvcPY24GjVxP59LYMT/S1e
	 40zqWDVQpwTWsYExZVXReNrirfgZG6lWgS/gG6Ms98UGqa9skpujyljVlWX4/wc8Z0
	 81C4R4bLqRBuHoiL7DPflaIa2q73QPNmCVmavyh9JO/3V+U5tF7pP2Uuw8NgfKIqOR
	 4SMqefjFxUUOJVjiFxaPC3V6VoMeqoArmGlL0f+r3+ZllZ1jp32grJIe+bzyP6xIvZ
	 ew2TMY0WWQLiydzSwfpGEGybJVs2adhYuAFtyMPP5ut63SjHizkNc/ZCMqDvDWMLkN
	 MmRQP1Vy0rk1w==
Date: Tue, 18 Feb 2025 17:01:48 -0800
Subject: [PATCH 1/4] xfs: update tests for quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589860.4080063.6004431845318847274.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
References: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update fstests to handle quota files in the metadir.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/common/xfs b/common/xfs
index 97bdf8575a4bd4..30d2f98c3795da 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1967,6 +1967,24 @@ _scratch_xfs_find_metafile()
 			return 0
 		fi
 		;;
+	"uquotino")
+		if _xfs_has_feature "$SCRATCH_DEV" metadir; then
+			echo "path -m /quota/user"
+			return 0
+		fi
+		;;
+	"gquotino")
+		if _xfs_has_feature "$SCRATCH_DEV" metadir; then
+			echo "path -m /quota/group"
+			return 0
+		fi
+		;;
+	"pquotino")
+		if _xfs_has_feature "$SCRATCH_DEV" metadir; then
+			echo "path -m /quota/project"
+			return 0
+		fi
+		;;
 	esac
 
 	sb_field="$(_scratch_xfs_get_sb_field "$metafile")"

