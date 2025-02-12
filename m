Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16DC1D86E6;
	Wed, 12 Feb 2025 03:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331103; cv=none; b=TIWKsPqkUUjgRwnKy0Ncc8Vh7DVGFHRl6oOyRN3fTCASOqPqUNPUjCi6gddyQ2j/+qBC/BI3BkW146HNS9BUHlFQJyrGG+VccOMR1pfX5xaob0ARYKJ8Hw7YXR9PYKMq+DcowGRf0OpKchgT80XPN6Y8Y2lRRnIUd3ldv7YR5dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331103; c=relaxed/simple;
	bh=/2n+oEdRStjDZApaIexzeFtFcgjKHP56PTxV6YD1OXQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kimkf+K3ORB/0DyC3bztQRmAMY9mBLKTp9jxVhmCIs8lxnmlvnY+YKUIL4ghCtjszezpLyBnWXBV4sfRZDGA1hK8mNOu4dXnjyHHgPrvlaOLkiv4WspRHF+EYHDhMz3R2u+lhzxVICSokUJf9BviEL+JPkri67JJUdg4MFeEdUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mEI/4p2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mEI/4p2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C219C4CEE4;
	Wed, 12 Feb 2025 03:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331103;
	bh=/2n+oEdRStjDZApaIexzeFtFcgjKHP56PTxV6YD1OXQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mEI/4p2jqhW5voLFL2G5AI7FT9epVF9XPhcIBIBCo02k+j2UKLaYeZ7OOtjKC7AJT
	 b7CbFahsQrdcC2ecGwO0ScJ/2fg5dh1Xe5Z03SEmWnObP9hNRuEkUEPNESyPnSB+If
	 Qy48S7V8Sqy+i20Nv7eIA9FNaF54v1Z+1T8JrEiHlZR4Y4iFArLqdJ5eeck1GhwluI
	 NVaIl18FJFg5HFY8UWFRcU2PJr17zdHbqjN1W3/5NlMUQbsk2m13AAhpj+vv/nmrsr
	 yK5xy+IY4gn/Qtatk5rZvCKG7v65utocPf+FzfWkmo4Z/CiUMaa2k+5nj3W2k5qfkm
	 3bPB6xXG13JaQ==
Date: Tue, 11 Feb 2025 19:31:43 -0800
Subject: [PATCH 04/34] generic/019: don't fail if fio crashes while shutting
 down
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094415.1758477.15609327294422681469.stgit@frogsfrogsfrogs>
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

