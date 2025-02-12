Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773091E766F;
	Wed, 12 Feb 2025 03:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331136; cv=none; b=YOi4c/WnPzbEQgn85YG2C0EZ5S+/JbUeG4ZQBoasaPWKZSqAXuppaXWmXq5FqgV3smBKGnDnJmq0d4jYafViyxSb3prCDWGSYNLYpFxQ63+xckC4HNLJMSOfO8sm7V+0GdrBoYXpJ9WhjSjH8xchLVbGT4N4iXmVVrcQmN9pi08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331136; c=relaxed/simple;
	bh=tsYskbEKM0ZpkngKnTqGzDf656K9u8CPVDIhgx1Jhmg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ckQDXAU/rZVdEXjtMp2DpIENDCTx7eQgxBg/gusLr1yYfrf8ZxsT6Az+5aIqdbKTHM2nWpCyCetciqwWF97yPCBbY/6Nb+xyNYATvx0fv2kL309R+khNIn1jcxYAXf2KQn+nv/b0/eFM9QEmgQVqsYVzyNeFO9wg2kh1eR6nr1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=upVHhlSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="upVHhlSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EAEC4CEDF;
	Wed, 12 Feb 2025 03:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331134;
	bh=tsYskbEKM0ZpkngKnTqGzDf656K9u8CPVDIhgx1Jhmg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=upVHhlSY0VIbqtbhBjbzLFyveJOAejRjY/zYr+yAo1bQmyf635j0Cj74JqTmeVNZ2
	 x6vE62OMs2vX3apILc54uKUOjipNCVTS5joUXtF/8tDiZHzNKHLfSYMFXIJhctd97q
	 WAtQqN9vy/wjw6x8IDI4CqY6VCrdwa+T9YsgMFhlSL/Lu96v0uUnJ+wMVlxBpb1gj8
	 HqxfHuwr6S3p1Rn1t5/4Z2x7XfR+Db9GfI5wfkjOr9C3Jwk6LaLqpgwBJf9gDaY35N
	 aqz/z1iKVwHbcH/abWEQgbY3ZcmrhoC19WvmW+Mte9YnRyvlNrd6iu9etXnYdci7bW
	 BAEGfBAg7O5jA==
Date: Tue, 11 Feb 2025 19:32:14 -0800
Subject: [PATCH 06/34] common/rc: revert recursive unmount in
 _clear_mount_stack
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094446.1758477.509311653788264022.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Zorro complained about the following regression in generic/589 that I
can't reproduce here on Debian 12:

>  --- /dev/fd/63  2025-01-08 19:53:49.621421512 -0500
>  +++ generic/589.out.bad 2025-01-08 19:53:49.244099127 -0500
>  @@ -30,6 +30,7 @@
>   mpC SCRATCH_DEV
>   mpC SCRATCH_DEV
>   ======
>  +umount: /mnt/xfstests/test/589-dst: not mounted
>
> It fails on generic/589 -> end_test -> _clear_mount_stack
>
>   ...
>   + end_test
>   + _clear_mount_stack
>   + '[' -n '/mnt/test/589-dst/201227_mpC /mnt/test/589-src/201227_mpA /mnt/test/589-dst /mnt/test/589-dst /mnt/test/589-src' ']'
>   + _unmount -R /mnt/test/589-dst/201227_mpC /mnt/test/589-src/201227_mpA /mnt/test/589-dst /mnt/test/589-dst /mnt/test/589-src
>   + local outlog=/tmp/201227.201227.umount
>   + local errlog=/tmp/201227.201227.umount.err
>   + rm -f /tmp/201227.201227.umount /tmp/201227.201227.umount.err
>   + /usr/bin/umount -R /mnt/test/589-dst/201227_mpC /mnt/test/589-src/201227_mpA /mnt/test/589-dst /mnt/test/589-dst /mnt/test/589-src
>   + local res=1
>   + '[' -s /tmp/201227.201227.umount ']'
>   + '[' -s /tmp/201227.201227.umount.err ']'
>   + cat /tmp/201227.201227.umount.err
>   + cat /tmp/201227.201227.umount.err
>   umount: /mnt/test/589-dst: not mounted
>
> The _get_mount already save all mount points into MOUNTED_POINT_STACK,
> MOUNTED_POINT_STACK="/mnt/test/589-dst/201227_mpC /mnt/test/589-src/201227_mpA /mnt/test/589-dst /mnt/test/589-dst /mnt/test/589-src"
>
> '-/mnt/test                                     /dev/sda5                                xfs        rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=64k,sunit=128,swidth=256,noquota
>   |-/mnt/test/589-src                           /dev/sda6                                xfs        rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=64k,sunit=128,swidth=256,noquota
>   | '-/mnt/test/589-src/223262_mpA              /dev/sda6                                xfs        rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=64k,sunit=128,swidth=256,noquota
>   '-/mnt/test/589-dst                           /dev/sda6                                xfs        rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=64k,sunit=128,swidth=256,noquota
>     |-/mnt/test/589-dst                         /dev/sda6                                xfs        rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=64k,sunit=128,swidth=256,noquota
>     | '-/mnt/test/589-dst/223262_mpC            /dev/sda6                                xfs        rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=64k,sunit=128,swidth=256,noquota
>     '-/mnt/test/589-dst/223262_mpC              /dev/sda6                                xfs        rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=64k,sunit=128,swidth=256,noquota
>
> Orignal _clear_mount_stack trys to umount all of them. But Dave gave -R option to
> umount command, so
>   `umount -R /mnt/test/589-dst/201227_mpC` and `umount -R /mnt/test/589-src/201227_mpA`
> already umount /mnt/test/589-dst and /mnt/test/589-src. recursively.
> Then `umount -R /mnt/test/589-dst` shows "not mounted".

I /think/ this is a result of commit 4c6bc4565105e6 performing this
"conversion" in _clear_mount_stack:

-		$UMOUNT_PROG $MOUNTED_POINT_STACK
+		_unmount -R $MOUNTED_POINT_STACK

This is not a 1:1 conversion here -- previously there was no
-R(ecursive) unmount option, and now there is.  It looks as though
umount parses /proc/self/mountinfo to figure out what to unmount, and
maybe on Zorro's system it balks if the argument passed is not present
in that file?  Debian 12's umount doesn't care.

Regardless, there was no justification for this change in behavior that
was buried in what is otherwise a hoist patch, so revert it.  The author
can resubmit the change with proper documentation.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 4c6bc4565105e6 ("fstests: clean up mount and unmount operations")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/rc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/rc b/common/rc
index 4658e3b8be747f..07646927bad523 100644
--- a/common/rc
+++ b/common/rc
@@ -334,7 +334,7 @@ _put_mount()
 _clear_mount_stack()
 {
 	if [ -n "$MOUNTED_POINT_STACK" ]; then
-		_unmount -R $MOUNTED_POINT_STACK
+		_unmount $MOUNTED_POINT_STACK
 	fi
 	MOUNTED_POINT_STACK=""
 }

