Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7823659EB;
	Mon, 10 Aug 2026 20:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786392729; cv=none; b=p2u7If0eX1lVLN958gfJc3DBEf72bhNLquRwDfbVIv0p9RBgpZny4kOlOaWX+S55fdif+r6Rx76QjAkFvmzk5MKQyNF7ni/FT5iIy5NB/lZZzQJNjQPpDygiuLLK4T7PbTT7ongOKJ10L3kHNUCq8M1bVLLo3u1uINoXCHo4bK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786392729; c=relaxed/simple;
	bh=4LAkLc9ZgHDMEI4OizJc4UHXywm8wyD+wiUM/jLlGHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=na12S7ByjvVFNFFfSEYA6P5PUTnIo3Esq6cK3iFwyYrdRI7lnjcJrIEUPDvoc/33xDGVfsQvHIkKNJXb3XyX5UVyImsne4X0vXLFz6FnDONOk+oZpF03Fp+T5tYNpiHfWL/Zp1y+sUSQ3iFqD6E+x5zZqStkpbZ4xFhV406jObU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JqfbZ6GV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JqfbZ6GV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780E11F000E9;
	Mon, 10 Aug 2026 20:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786392728;
	bh=fy3TrqSfIvWqB5vFQmDDllShC626W5BG9v08bplGW6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JqfbZ6GVjaIwRXRoyJ4LJG2EB9Ekg+koZc4KN/ldFaoPThTYypPkVKFkeATmCKiNg
	 4cfMdS9DywHMKQorb+8b62duW7DHburYYbtxMMKc0//uxPTCTskr70RVcoqkiyOaPS
	 nB6BEflZG/z3vTNn4ImuQiaQphNWWBZccMnxBEKI4iCTaoSFI/c5io5xm/DcNblPp8
	 r8K6uHGxxB8LOpWqditTlQkg1s6Ex5ljV12AsjiWkqD8n+/0d9nsqAObvG4SWRFg0h
	 inTSZ0gzdIJ3cnpVuV3vzNshSh9SSTV6K9UpbKl5CNVz0JPAOkQfr7uaf10Yzv7ztC
	 85EIpKs/q81Eg==
Date: Tue, 11 Aug 2026 04:12:03 +0800
From: Zorro Lang <zlang@kernel.org>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test xfsdump subtree restores
Message-ID: <anot8-MiesDW5iqo@zlang-mailbox>
Mail-Followup-To: Donald Douwsma <ddouwsma@redhat.com>, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20260723062617.424905-1-ddouwsma@redhat.com>
 <amiGzsz0KuUrV29o@zlang-mailbox>
 <304f1600-70ef-411e-b56c-5b91102ba343@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <304f1600-70ef-411e-b56c-5b91102ba343@redhat.com>

On Fri, Aug 07, 2026 at 05:48:57PM +1000, Donald Douwsma wrote:
> On 28/7/26 20:39, Zorro Lang wrote:
> > On Thu, Jul 23, 2026 at 04:26:17PM +1000, Donald Douwsma wrote:
> >> Regression test for cumulative restores where a directory has been
> >> renamed outside of the subtree being restored triggering the assert:
> >>
> >>   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
> >>
> >> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> >> ---
> >> Changes since v1
> >> - Fix use of _do, including label quoting
> >> - Update test output
> >> - Add tests for additional edge cases
> >> ---
> >>  tests/xfs/995     | 58 +++++++++++++++++++++++++++++++++++++++++++++++
> >>  tests/xfs/995.out |  8 +++++++
> >>  2 files changed, 66 insertions(+)
> >>  create mode 100755 tests/xfs/995
> >>  create mode 100644 tests/xfs/995.out
> >>
> >> diff --git a/tests/xfs/995 b/tests/xfs/995
> >> new file mode 100755
> >> index 000000000..bba0bcd52
> >> --- /dev/null
> >> +++ b/tests/xfs/995
> >> @@ -0,0 +1,58 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2026 Red Hat.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 995
> >> +#
> >> +# Regression test for cumulative restores where a directory has been
> >> +# renamed outside of the subtree being restored resulting in
> >> +#
> >> +#   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
> >> +#
> >> +. ./common/preamble
> >> +_begin_fstest auto dump
> >> +_do_die_on_error="always"
> > 
> > I think this line is useless now, right? I'll remove it.
> > 
> 
> Yes, thanks.
> 
> I did have a general question about how _do_die_on_error is used
> 
> $ git grep _do_die_on_error
> common/rc:# second argument. If the command fails and the variable _do_die_on_error
> common/rc:# is set to "always" or the two argument form is used and _do_die_on_error
> common/rc:      && [ "$_do_die_on_error" = "always" \
> common/rc:          -o \( $# -eq 2 -a "$_do_die_on_error" = "message_only" \) ]

Oh, my bad. I confused this parameter with the "enable_error" parameter you
tried to introduce in your previous patch.

Since this variable is used by the current _do helper, setting it to "always" or
"message_only" here is good. I will keep this line.

> tests/generic/017:_do_die_on_error=y
> tests/generic/053:_do_die_on_error=y
> tests/xfs/041:_do_die_on_error=message_only
> tests/xfs/042:_do_die_on_error=message_only
> tests/xfs/596:_do_die_on_error=message_only
> tests/xfs/635:_do_die_on_error=message_only
> 
> _do_die_on_error=y doesn't seem valid.

I think you're right, "y" isn't valid. The _do() helper is quite old and rarely used.
If you have any optimization suggestions, feel free to send a patch to improve it.
For this patch, I'll merge your current version directly.

Thanks,
Zorro

> 
> generic/017 doesn't use _do, and I think generic/053 wants _do_die_on_error=always

> 
> Thoughts?
> 
> Don
> 
> 
> 
> 
