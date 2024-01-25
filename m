Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1F879C7;
	Thu, 25 Jan 2024 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706209486; cv=none; b=bv0d7mix7jmdiqPX3qZLICD390+y2d+ClGLtrU1pNhMJokLzO3NmBr90nX7hQAFwfHcvejycEvJKRAXvRnvzTs37ul9E/uXhICdYitmz8Xd+SsJe9jyhR7ChvMqsTKi05gbcWCPwQQX3LPmSmyEx3xcrxQBKMrCy0YnbzCQfA80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706209486; c=relaxed/simple;
	bh=hN6jaGKYHn0Ll9Q+qOYQuEkgXYuuEgKo9T6VXUeZgog=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fZ/QrPR61D53IgWYdJESMOyJ3xkhw9ZdKzbiGMQvPlwKwJxsoUBQ3paISG2b7KX+x8U5ONiXmffz5nkM1xKnWFLzv/iUuMVekqxc9UotjjQz0oCg5Dbo7Tyvyutdkvt2ebcZ5NzXJRPhGJP2bekHo0CHiqSrj8ccIuKgqgmY8So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cEhy6uiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cEhy6uiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4643C433F1;
	Thu, 25 Jan 2024 19:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706209485;
	bh=hN6jaGKYHn0Ll9Q+qOYQuEkgXYuuEgKo9T6VXUeZgog=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cEhy6uiPS7ZLSTs6X7OOD+s1U+6VD4jXMKCJcOeztdzwsquMeL0nK+QjAFNwFzNq5
	 wK2/paNl3u6DDO6PnRkF7G04XipL1g5bEh5itKVkBgqY3cqECxNWHke1OEjo+f9KRG
	 S3OAaQZJnXWLsB9uYCKSVx0xNdkJUP9sW8gtI9M19eFiVvJ6e5+lhq0PJo3QTadtVa
	 WMUi6BxHg4qIpU8G6y/4v5ApvjoN1TqOwOU3/v9opp8UKIAy35ihTdzIwcbNjvp+Yr
	 yvoYMVoueVD9EXCzRaBCh1CjEIbBjPFJ+4yEWxPgunJ3TPwQaIdp0PceHAhcjD8X4A
	 zV6y5hMAXTVfQ==
Date: Thu, 25 Jan 2024 11:04:45 -0800
Subject: [PATCH 03/10] common/populate: always metadump full metadata blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170620924408.3283496.10108828998772840672.stgit@frogsfrogsfrogs>
In-Reply-To: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Commit e443cadcea pushed the -a and -o options to the
_scratch_xfs_metadump callsites.  Unfortunately, it missed the
_xfs_metadump callsite in common/populate, so fix that now.

Fixes: e443cadcea ("common/xfs: Do not append -a and -o options to metadump")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index cfbfd88a7f..33f2db8d4a 100644
--- a/common/populate
+++ b/common/populate
@@ -1029,7 +1029,7 @@ _scratch_populate_cached() {
 			logdev=$SCRATCH_LOGDEV
 
 		_xfs_metadump "$POPULATE_METADUMP" "$SCRATCH_DEV" "$logdev" \
-			compress
+			compress -a -o
 		;;
 	"ext2"|"ext3"|"ext4")
 		_scratch_ext4_populate $@

