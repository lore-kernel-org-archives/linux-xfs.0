Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D6D25A62C;
	Tue,  4 Feb 2025 21:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704232; cv=none; b=UQn20urpUC0lADfSnC9uTBDaFTXcWKqTLel/XJQAjgnLRJhNQ/k+Hc89QYzJdNv3ntFjIfOLWKD+1HcF5vg2XA46rZQNnqpksLqMw00v85Ydfk8/pLw6AJzoLTREKQovwRzfakezGnqhmoZNeD4sWkz1FXjv9SrHeMPU71IgTLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704232; c=relaxed/simple;
	bh=jhLJqQjDNq917XY3AlaUSEKX8spg4BRMg40CXsk0z9A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J8Y4aiYrT2pdfbijtQh07XEwWJWV6ZMx7iZSnJEREjWqDK7FybatOOKb2VisFechr+CJrQvToTpAY38mabQxk02bRkDLMpNDGBI3FC248uozGLns89ywc4iHi8H8IKRmADwCjiUwgn+LPs+Caao4cPbrvTQWZqF+XLz2ktQPXvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZB2nQH83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZB2nQH83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FA4C4CEDF;
	Tue,  4 Feb 2025 21:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704232;
	bh=jhLJqQjDNq917XY3AlaUSEKX8spg4BRMg40CXsk0z9A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZB2nQH83gfBaQVQ2pWulksXxEJx9G6M2WSeCXjQS8lnKh4rEnMaSMSLwf8KQZBv8N
	 Nq43IF0/UxDiC4ISPZ1rlfv1oxMU7H1EiNYbLvGYcRO53xa4n8tdy0CLYbpvIlRL1G
	 u9PnEez4p64CwEfsS2jc5ODFdjia6W5ElOobkaNEIDbgfNBYctZp5ytjseM86jLSUu
	 7VvW6JA6l8glr1RX/76Fb0t5ar9XQkEn7l8SrHTT3s445ukxsx4ftTCw12QM2GQFw8
	 SeMYTheG//XKmU9PTT0ZFXWdelx0vwNuByAwxsxxZylskile++PFEoUjr8K/uFxA7R
	 ifTCgXHKEVmnA==
Date: Tue, 04 Feb 2025 13:23:51 -0800
Subject: [PATCH 06/34] common/rc: revert recursive unmount in
 _clear_mount_stack
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406199.546134.3521494633346683975.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
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

