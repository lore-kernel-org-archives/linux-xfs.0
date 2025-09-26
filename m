Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD901E573F
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758901074; cv=none; b=PUqQ3/h4MQmHXMrkmb8CFugh1FK0lMnDVuzloIwoKasfk/fjWlMO4tqmP8zCBTmTPnj0SJ4R6dN0Ktivovs3JKS2vVRI2/haXK0iWsVbJQkS72JQSlgHMUJKVZk/VyILQSZPNH7ALhJcHnW+fCxMn2r9klbRWOwcWvB76pCsssg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758901074; c=relaxed/simple;
	bh=gqjjy4x7yRiMu8csQk8W7Fqdx8e8N4qT2tX/onlE3sQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abMr/FNlvcfot9d9KVm7K0soAVN7TkOHgkLHv8dznwgT8ycjGtntK30ihQ+9z9wUY84oJdqCCzYTq+AaWr+DCLLbgunUpWPkQ4Q1cqZb9DSx1/2kyfGKRO+Bcr7a5b+aD+PcnEa96CTe9LOmaqHfzZPZNt8Uu/uiaeEQWRQ1bmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3zB87k9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3zB87k9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758901072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NuJ1drhH6HCmU449hwtzxZyfclqHMgQnD+QVorNe8qc=;
	b=e3zB87k9zYJFq2f4tUWKBGam1mGYhbg+crtlNlz6Y/cYBZ+CzOO0blSMiBSKQbb1oLTz22
	Oe0Mlq+Q3laZVa56LJbjiX6AgNLCNBAmBa67SlOXwynEs7385te2PbTw24D4Fbb5ncFEVN
	dbvti1BmyGvyH61ybSYKbT2oRBWGeks=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-uA39LYf0Pmi-hWlHh584fQ-1; Fri, 26 Sep 2025 11:37:50 -0400
X-MC-Unique: uA39LYf0Pmi-hWlHh584fQ-1
X-Mimecast-MFC-AGG-ID: uA39LYf0Pmi-hWlHh584fQ_1758901069
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b55118e2d01so1652580a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 08:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758901069; x=1759505869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NuJ1drhH6HCmU449hwtzxZyfclqHMgQnD+QVorNe8qc=;
        b=VqziC0v82h1qeARYrC74EGu3h5JzB6+i1t+JPjcdS7vNvnvtTSxsjsaCzSR4b+4zF+
         Xoyjp25UiqHx8R2e9Edja41uT1/T8iSYxd3OWlxSyMss7QtBuNVB2QxCt7km3W9iW+o5
         1Qwu68FtsX6X6w4Ivnkzsq3qDEkFUY8OKxPP6RiyGTcWNsQE9KqMqMRidlRI1hVuSMis
         OaOjilJcKqWpI8Z473baCBvtmYc0/rHAC4+iLgOjYboCtQiIxEf6cbRnF19Lpak1VKBQ
         79whMDgtt74ApeW4WoP7FuWxRw0I8bPRTikl+aeUCogI0XCXjK4KrJ5crEO4J9Zrqq5d
         iPng==
X-Forwarded-Encrypted: i=1; AJvYcCXv06Udg2UbSRCM5e6uJWKPheoY1d4s1QnT2ABLJfA5hP4Bi2ZYjcrGnJFSCNOd53DFoc4aMDm4frY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI5u2tQtP/xmssVZ3tWsdZVtaln9C8CXNvaDnOlAUsdKJ1UfS2
	MXD2YWOalRxMS+ykPdXkA6v6Tnb3PecDqAr0zOuncAMty0hH93PLyO5zEkGvXH/Oa8sxdhx6yyt
	N5nKEn8QLiqhK8Os4ehOBbGuvN7THuT2jXBjsS3QBbt2SJG1+RHFLjfItP4Z+Wy1Z6YIu6g==
X-Gm-Gg: ASbGncscuJh5gIn1k13RtbOi93QU0rhRnfPiyUrnUUpzNdls1aUK9kjdPfJ0gUiwmyS
	cWc9pafVHwHs7iq/Iv9rWji91Mb2qEAdiC5cdi2Ld/f79yIzTRKzHVW3rF7+iQA5zV3Tr4WUZzj
	AhNQZnyeBcBK8wDW8Q1VjN8MiUkzmhHkmQDMMpTT0MC2moSiY0RgsmHamyKcNWz/pjB9zD6OfkH
	vPBkhtx5io4uDXTH0v8xTv/YCmoWF80Mu6+Y6EK90DfOwUZwfNCby+7z5ueU/Y4VW3jYFOe00Bs
	M7qLlkmk3llG9o4fnpmDqUhol/UgGVQYtmu3XVw6FNqFq0nkk8vvPVC861b59hAZyCuvIgf8mM9
	kcrZf
X-Received: by 2002:a05:6a21:7e87:b0:2ec:4146:6a0f with SMTP id adf61e73a8af0-2ec41467f18mr7154925637.35.1758901068955;
        Fri, 26 Sep 2025 08:37:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHc3Vr2SXRxWUrIPgMAtLDAtpeaOM03yRua4xmiTKc454FHwbWPteTYX79NE9EyV4pPkA1Usg==
X-Received: by 2002:a05:6a21:7e87:b0:2ec:4146:6a0f with SMTP id adf61e73a8af0-2ec41467f18mr7154900637.35.1758901068433;
        Fri, 26 Sep 2025 08:37:48 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c557493asm4972919a12.25.2025.09.26.08.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 08:37:48 -0700 (PDT)
Date: Fri, 26 Sep 2025 23:37:43 +0800
From: Zorro Lang <zlang@redhat.com>
To: cem@kernel.org
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/539: Remove test for good
Message-ID: <20250926153743.qzuafbnnarjynajo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250925093005.198090-1-cem@kernel.org>
 <20250925093005.198090-4-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925093005.198090-4-cem@kernel.org>

On Thu, Sep 25, 2025 at 11:29:26AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This check deprecation warnings are not being printed during remount for
> both attr2 and ikeep mount options.
> 
> Both options are now gone in 6.17, so this test not only is pointless
> from 6.17 and above, but will always fail due the lack of these options.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  tests/xfs/539     | 72 -----------------------------------------------
>  tests/xfs/539.out |  2 --
>  2 files changed, 74 deletions(-)
>  delete mode 100755 tests/xfs/539
>  delete mode 100644 tests/xfs/539.out
> 
> diff --git a/tests/xfs/539 b/tests/xfs/539
> deleted file mode 100755
> index 5098be4a9351..000000000000
> --- a/tests/xfs/539
> +++ /dev/null
> @@ -1,72 +0,0 @@
> -#! /bin/bash
> -# SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) 2020 Red Hat, Inc.. All Rights Reserved.
> -#
> -# FS QA Test 539
> -#
> -# https://bugzilla.kernel.org/show_bug.cgi?id=211605

As the "attr2" and "ikeep" have been removed, so we don't need this bug
coverage either. I'm good to remove this.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> -# Verify that the warnings are not printed on remount if the mount option has
> -# the same value as during the mount
> -#
> -# Regression test for commit:
> -# 92cf7d36384b xfs: Skip repetitive warnings about mount options
> -
> -. ./common/preamble
> -_begin_fstest auto quick mount
> -
> -# Import common functions.
> -
> -_fixed_by_kernel_commit 92cf7d36384b \
> -	"xfs: Skip repetitive warnings about mount options"
> -
> -_require_check_dmesg
> -_require_scratch
> -
> -log_tag()
> -{
> -	echo "fstests $seqnum [tag]" > /dev/kmsg
> -}
> -
> -dmesg_since_test_tag()
> -{
> -	dmesg | tac | sed -ne "0,\#fstests $seqnum \[tag\]#p" | \
> -		tac
> -}
> -
> -check_dmesg_for_since_tag()
> -{
> -	dmesg_since_test_tag | grep -E -q "$1"
> -}
> -
> -echo "Silence is golden."
> -
> -# Skip old kernels that did not print the warning yet
> -log_tag
> -_scratch_mkfs > $seqres.full 2>&1
> -_scratch_mount -o attr2
> -_scratch_unmount
> -check_dmesg_for_since_tag "XFS: attr2 mount option is deprecated" || \
> -	_notrun "Deprecation warning are not printed at all."
> -
> -# Test mount with default options (attr2 and noikeep) and remount with
> -# 2 groups of options
> -# 1) the defaults (attr2, noikeep)
> -# 2) non defaults (noattr2, ikeep)
> -_scratch_mount
> -for VAR in {attr2,noikeep}; do
> -	log_tag
> -	_scratch_remount $VAR
> -	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated." && \
> -		echo "Should not be able to find deprecation warning for $VAR"
> -done
> -for VAR in {noattr2,ikeep}; do
> -	log_tag
> -	_scratch_remount $VAR >> $seqres.full 2>&1
> -	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated" || \
> -		echo "Could not find deprecation warning for $VAR"
> -done
> -_scratch_unmount
> -
> -# success, all done
> -status=0
> -exit
> diff --git a/tests/xfs/539.out b/tests/xfs/539.out
> deleted file mode 100644
> index 038993426333..000000000000
> --- a/tests/xfs/539.out
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -QA output created by 539
> -Silence is golden.
> -- 
> 2.51.0
> 

