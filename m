Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CA6C47094
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 08:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8030613F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 08:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhFJIqH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 04:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhFJIqG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 04:46:06 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899EFC061574;
        Thu, 10 Jun 2021 01:44:04 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 11so607995plk.12;
        Thu, 10 Jun 2021 01:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ALx+Si3czxv+LUCp/D+y31vtK5zKs6u6wL6Wo4SmWcM=;
        b=rj+RIC9VwqdUtWyhw9lOt1vKbM2bY3O3xqnA+zUMvjMiksC23jA9fkj+5MSdWLlwVC
         Iosva913tG/j5LTOASMI9dfoAtJ1fBO2EWb+wikWRtM2HE2orN4mfF+G38hzl0Ihxqfh
         dqBmLz1CkxTCL0IIuwpyVE7f1GzKWA5TniteYTvNkFLbv7XkPxVhXZn6CHO0rsSGGoe7
         ECEMl/5ytcLpSqXVcNscEJwarO9Ey2IXvXcABy/QgMkUmsC/yr4vBJ0aqJXclZw8xqmg
         ElrIXHw5jt7T6hQCax592DjDhXX4dBIGRoltHXwDIbeC4mqtkP6Y4b6YJwmoilzAcZ+Y
         TGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ALx+Si3czxv+LUCp/D+y31vtK5zKs6u6wL6Wo4SmWcM=;
        b=lgBvRZkFlPrDCcc3gfMcpjEbkmSXfB8fWWJRtZ6N+TbwcTukSG1VoAuZr+rLyBlkCv
         JuG0WN4YMZ66hXg5GLZwMQRuoytV6fldADk/CIUfAxZiYA+4KhlWKVy0rAS2pXlmrhpa
         LxhkNJ7TIKa9KiOZVBNNBOxl4SgBEdWRgzjvjojuKhH5dVS6Qk7G6VcusQImobs/Zygp
         7rSaMU/j2Q6c+3JVBsxN5zgNMsxUDsWhsqQ/oacaubvKG+uCQ5xQx+rVoFBhvghnUZtp
         yxFxwOlOsFn4wOIrbKR7bkf8UDONVdZ40Z6xjomrvicunUlbKUrIx6mITzHJq6R5brlu
         lHlw==
X-Gm-Message-State: AOAM531uBoDv833yRM7fowLQWdNYpgCoAVMR6/aBttmty22X5+TbJWM/
        lzhRvEX10dlfyba3AIB3kk0=
X-Google-Smtp-Source: ABdhPJzlQPdkI1QTBte1L7ePFdyE7TRSZjhiZlUHqvMWitcOFomQgcRpvWsCVH+0vmknPMzEO1ggVw==
X-Received: by 2002:a17:902:d4c8:b029:102:715b:e3a5 with SMTP id o8-20020a170902d4c8b0290102715be3a5mr3762919plg.83.1623314644151;
        Thu, 10 Jun 2021 01:44:04 -0700 (PDT)
Received: from garuda ([122.171.171.192])
        by smtp.gmail.com with ESMTPSA id d23sm7088636pjz.15.2021.06.10.01.44.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Jun 2021 01:44:03 -0700 (PDT)
References: <162317276202.653489.13006238543620278716.stgit@locust> <162317277866.653489.1612159248973350500.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 03/13] fstests: refactor test boilerplate code
In-reply-to: <162317277866.653489.1612159248973350500.stgit@locust>
Date:   Thu, 10 Jun 2021 14:14:00 +0530
Message-ID: <87wnr2p0rz.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Jun 2021 at 22:49, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Create two new helper functions to deal with boilerplate test code:
>
> A helper function to set the seq and seqnum variables.  We will expand
> on this in the next patch so that fstests can autogenerate group files
> from now on.
>
> A helper function to register cleanup code that will run if the test
> exits or trips over a standard range of signals.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/preamble |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  new             |   33 ++++++++++++---------------------
>  2 files changed, 61 insertions(+), 21 deletions(-)
>  create mode 100644 common/preamble
>
>
> diff --git a/common/preamble b/common/preamble
> new file mode 100644
> index 00000000..63f66957
> --- /dev/null
> +++ b/common/preamble
> @@ -0,0 +1,49 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +
> +# Boilerplate fstests functionality
> +
> +# Standard cleanup function.  Individual tests should override this.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# Install the supplied cleanup code as a signal handler for HUP, INT, QUIT,
> +# TERM, or when the test exits.  Extra signals can be specified as subsequent
> +# parameters.
> +_register_cleanup()
> +{
> +	local cleanup="$1"
> +	shift
> +
> +	test -n "$cleanup" && cleanup="${cleanup}; "
> +	trap "${cleanup}exit \$status" EXIT HUP INT QUIT TERM $*
> +}
> +# Initialize the global seq, seqres, here, tmp, and status variables to their
> +# defaults.  Group memberships are the only arguments to this helper.
> +_begin_fstest()
> +{
> +	if [ -n "$seq" ]; then
> +		echo "_begin_fstest can only be called once!"
> +		exit 1
> +	fi
> +
> +	seq=`basename $0`
> +	seqres=$RESULT_DIR/$seq
> +	echo "QA output created by $seq"
> +
> +	here=`pwd`
> +	tmp=/tmp/$$
> +	status=1	# failure is the default!
> +
> +	_register_cleanup _cleanup
> +
> +	. ./common/rc
> +
> +	# remove previous $seqres.full before test
> +	rm -f $seqres.full
> +
> +}
> diff --git a/new b/new
> index 357983d9..16e7c782 100755
> --- a/new
> +++ b/new
> @@ -153,27 +153,18 @@ cat <<End-of-File >$tdir/$id
>  #
>  # what am I here for?
>  #
> -seq=\`basename \$0\`
> -seqres=\$RESULT_DIR/\$seq
> -echo "QA output created by \$seq"
> -
> -here=\`pwd\`
> -tmp=/tmp/\$\$
> -status=1	# failure is the default!
> -trap "_cleanup; exit \\\$status" 0 1 2 3 15
> -
> -_cleanup()
> -{
> -	cd /
> -	rm -f \$tmp.*
> -}
> -
> -# get standard environment, filters and checks
> -. ./common/rc
> -. ./common/filter
> -
> -# remove previous \$seqres.full before test
> -rm -f \$seqres.full
> +. ./common/preamble
> +_begin_fstest group list here
> +
> +# Override the default cleanup function.
> +# _cleanup()
> +# {
> +# 	cd /
> +# 	rm -f \$tmp.*
> +# }
> +
> +# Import common functions.
> +# . ./common/filter
>  
>  # real QA test starts here
>  


-- 
chandan
