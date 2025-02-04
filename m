Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F400825A62C;
	Tue,  4 Feb 2025 21:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704201; cv=none; b=UnhYGeei8wqow96YBjPzDP7MLlTMOrY0oWvJjUqSSi2wqIHibQHx7JCeAlMas9AnPEnJUeXhQKldnCc/DwwWGUSCTP+/KtI5y18Av6adC/D5+oy4WfxIxF5a6v4rM9h5nB9NYvtShxfidf18W4v6BCos5U31iJEqivwEr2s4KGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704201; c=relaxed/simple;
	bh=/2n+oEdRStjDZApaIexzeFtFcgjKHP56PTxV6YD1OXQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKydsFlrKPTXoBd93rHaZoN3s7mj9e9L1tIBwU5wTqBh5oUl0YJY4SNnxM4LUrC9HFHzsSV9oqgVzUQ/kocA/RIYDQY56RCBfnulaBi2qVmsorqdpxf3USZqza0T3+/BI9IkqKPulA0ecoJIthrzZH6F++/v8qP0ceGb4KWv5Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3LZFrKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3LZFrKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB05AC4CEDF;
	Tue,  4 Feb 2025 21:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704200;
	bh=/2n+oEdRStjDZApaIexzeFtFcgjKHP56PTxV6YD1OXQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I3LZFrKs+/2Sxqu4kf54fb0CmRpu00R/djBt6yobRKTl16GBCjevEIs1lTCCx+raS
	 FVnaBO4qdoofENU7rwO7tH3rxP+2GEJ9VC7bo5wMlUhwWUtlzBgF9Jyx/8CJyNxxXu
	 1hqpGpksLTyonwdICwJoIoMiZgzm/QXswIfCgIVrcuS/YqaPuFKmCB69ZUOAbUYfiK
	 YsW4WzJIGnusmhjIxPlhsCyk0McnTi1MMpZWacIW+Ozwwi0UAY4ph2LEfoX3G9hG06
	 kP+rOSQSvY++qr4yocDmRpuLZlFQdFM5y5FEphgueWeAkTTEb8S/WY3QKrK4VEu2SL
	 B/XWDTThUoB2w==
Date: Tue, 04 Feb 2025 13:23:20 -0800
Subject: [PATCH 04/34] generic/019: don't fail if fio crashes while shutting
 down
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406169.546134.1851003832859077051.stgit@frogsfrogsfrogs>
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

My system (Debian 12) has fio 3.33.  Once in a while, fio crashes while
shutting down after it receives a SIGBUS on account of the filesystem
going down.  This causes the test to fail with:

generic/019       - output mismatch (see /var/tmp/fstests/generic/019.out.bad)
    --- tests/generic/019.out   2024-02-28 16:20:24.130889521 -0800
    +++ /var/tmp/fstests/generic/019.out.bad    2025-01-03 15:00:35.903564431 -0800
    @@ -5,5 +5,6 @@

     Start fio..
     Force SCRATCH_DEV device failure
    +/tmp/fstests/tests/generic/019: line 112: 90841 Segmentation fault      $FIO_PROG $fio_config >> $seqres.full 2>&1
     Make SCRATCH_DEV device operable again
     Disallow global fail_make_request feature
    ...
    (Run 'diff -u /tmp/fstests/tests/generic/019.out /var/tmp/fstests/generic/019.out.bad'  to see the entire diff)

because the wait command will dutifully report fatal signals that kill
the fio process.  Unfortunately, a core dump shows that we blew up in
some library's exit handler somewhere:

(gdb) where
#0  unlink_chunk (p=p@entry=0x55b31cb9a430, av=0x7f8b4475ec60 <main_arena>) at ./malloc/malloc.c:1628
#1  0x00007f8b446222ff in _int_free (av=0x7f8b4475ec60 <main_arena>, p=0x55b31cb9a430, have_lock=<optimized out>, have_lock@entry=0) at ./malloc/malloc.c:4603
#2  0x00007f8b44624f1f in __GI___libc_free (mem=<optimized out>) at ./malloc/malloc.c:3385
#3  0x00007f8b3a71cf0e in ?? () from /lib/x86_64-linux-gnu/libtasn1.so.6
#4  0x00007f8b4426447c in ?? () from /lib/x86_64-linux-gnu/libgnutls.so.30
#5  0x00007f8b4542212a in _dl_call_fini (closure_map=closure_map@entry=0x7f8b44465620) at ./elf/dl-call_fini.c:43
#6  0x00007f8b4542581e in _dl_fini () at ./elf/dl-fini.c:114
#7  0x00007f8b445ca55d in __run_exit_handlers (status=0, listp=0x7f8b4475e820 <__exit_funcs>, run_list_atexit=run_list_atexit@entry=true, run_dtors=run_dtors@entry=true)
    at ./stdlib/exit.c:116
#8  0x00007f8b445ca69a in __GI_exit (status=<optimized out>) at ./stdlib/exit.c:146
#9  0x00007f8b445b3251 in __libc_start_call_main (main=main@entry=0x55b319278e10 <main>, argc=argc@entry=2, argv=argv@entry=0x7ffec6f8b468) at ../sysdeps/nptl/libc_start_call_main.h:74
#10 0x00007f8b445b3305 in __libc_start_main_impl (main=0x55b319278e10 <main>, argc=2, argv=0x7ffec6f8b468, init=<optimized out>, fini=<optimized out>, rtld_fini=<optimized out>,
    stack_end=0x7ffec6f8b458) at ../csu/libc-start.c:360
#11 0x000055b319278ed1 in _start ()

This isn't a filesystem failure, so mask this by shovelling the output
to seqres.full.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/019 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/019 b/tests/generic/019
index bed916b53f98e5..676ff27dab8062 100755
--- a/tests/generic/019
+++ b/tests/generic/019
@@ -109,7 +109,7 @@ _workout()
 	    _fail "failed: still able to perform integrity fsync on $SCRATCH_MNT"
 
 	_kill_fsstress
-	wait $fio_pid
+	wait $fio_pid &>> $seqres.full # old fio can crash on EIO, ignore segfault reporting
 	unset fio_pid
 
 	# We expect that broken FS still can be umounted

