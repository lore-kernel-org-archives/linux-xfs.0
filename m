Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8B4C32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 15:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjARPVc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 10:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjARPUn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 10:20:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AEF222E4
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 07:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674054928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T4JBdUdMBoHs7hvAeeMHU3iDURrNTWwVZS8+jlT8fo0=;
        b=HHvsQ4SnyGsqArORQUyIGYhUPfydFIOaH0rK5jsOsT/DNB3dS0BmgIlzMhyEzWOCqoliPh
        wR6O5pqZjQDEpdO6bHYB7541wMsUGwQWMpi135Rxjkd0C1XBhITji/wZ16ODqDIJzFijFQ
        q/pNEhBMfSUBsdx8SRE1cm7uoE2PkYM=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-642-TrccXUMNMM6PzFvNQpWXZg-1; Wed, 18 Jan 2023 10:15:27 -0500
X-MC-Unique: TrccXUMNMM6PzFvNQpWXZg-1
Received: by mail-pf1-f199.google.com with SMTP id f22-20020a056a00239600b0058d956679f5so4280996pfc.5
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 07:15:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4JBdUdMBoHs7hvAeeMHU3iDURrNTWwVZS8+jlT8fo0=;
        b=zjcB01PiDckalNRlMICc3M3vvhgHEt6ipLDKrhdt+jgRPjRLxpsp/e/xB2rTYrQah8
         reYiWfS30yfZA1gW4LbQ5OeD6Nz+j/ajIX/NW0A7HiWM7kKR2c0mDgA+2D21bEWNhtNN
         ZxRgwBmBnkDFg9etW7RTX2U78eja6O+McUhwFcBP4ZF8DAZX7weAE5Nl9xoaffxjz1F/
         TIYOEZKb8Bp3BqDauaXajnjQ3ixgFlHumZFN7AMOG5XTOwENjURIQ8epwZ+d/TD28AN5
         WdSBBzBwC50hqUgmsXV8OanBPgboSVIBdjWxSNmBLTjz/6VFCmSNfmoziUOJYPVmNeap
         HeGg==
X-Gm-Message-State: AFqh2koTWtd5otpqDMkjETGtreBC2y4V6LXmtqJZlj4fPwEgmBJDreWY
        BgoT7K9fXml5Hv6KylWa1mA8KeNR3S040hAq2ngg2rCRlKr7SiBsE/TcSIH08zNnvsBU9tty5pM
        YJCA44btCJdzV700ISe4r
X-Received: by 2002:a05:6a00:1887:b0:589:d831:ad2a with SMTP id x7-20020a056a00188700b00589d831ad2amr11217172pfh.6.1674054925212;
        Wed, 18 Jan 2023 07:15:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsCSa5cUFVxx+1wz4SmlTTqWXDFHInZAWsMmTGiNXAKq2bUS7e3giYtVkhSjO5SpEbjtl1wBg==
X-Received: by 2002:a05:6a00:1887:b0:589:d831:ad2a with SMTP id x7-20020a056a00188700b00589d831ad2amr11217142pfh.6.1674054924862;
        Wed, 18 Jan 2023 07:15:24 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d124-20020a621d82000000b0056bbeaa82b9sm22172066pfd.113.2023.01.18.07.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:15:24 -0800 (PST)
Date:   Wed, 18 Jan 2023 23:15:20 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] populate: improve attr creation runtime
Message-ID: <20230118151520.6xutv5uwc4cv5nlr@zlang-mailbox>
References: <167400103044.1915094.5935980986164675922.stgit@magnolia>
 <167400103083.1915094.17122126052905864562.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167400103083.1915094.17122126052905864562.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 17, 2023 at 04:44:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace the file creation loops with a python script that does
> everything we want from a single process.  This reduces the runtime of
> _scratch_xfs_populate substantially by avoiding thousands of execve
> overhead.  This patch builds on the previous one by reducing the runtime
> of xfs/349 from ~45s to ~15s.
> 
> For people who don't have python3, use setfattr's "restore" mode to bulk
> create xattrs.  This reduces runtime to about ~25s.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Thanks for making a fallback if there's not python3. The python logic and
that fallback logic all look good to me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

>  common/populate |   22 +++++++++++++++++---
>  src/popattr.py  |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 81 insertions(+), 3 deletions(-)
>  create mode 100755 src/popattr.py
> 
> 
> diff --git a/common/populate b/common/populate
> index 180540aedd..f34551d272 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -12,6 +12,10 @@ _require_populate_commands() {
>  	_require_xfs_io_command "fpunch"
>  	_require_test_program "punch-alternating"
>  	_require_test_program "popdir.pl"
> +	if [ -n "${PYTHON3_PROG}" ]; then
> +		_require_command $PYTHON3_PROG python3
> +		_require_test_program "popattr.py"
> +	fi
>  	case "${FSTYP}" in
>  	"xfs")
>  		_require_command "$XFS_DB_PROG" "xfs_db"
> @@ -108,9 +112,21 @@ __populate_create_attr() {
>  	missing="$3"
>  
>  	touch "${name}"
> -	seq 0 "${nr}" | while read d; do
> -		setfattr -n "user.$(printf "%.08d" "$d")" -v "$(printf "%.08d" "$d")" "${name}"
> -	done
> +
> +	if [ -n "${PYTHON3_PROG}" ]; then
> +		${PYTHON3_PROG} $here/src/popattr.py --file "${name}" --end "${nr}"
> +
> +		test -z "${missing}" && return
> +		${PYTHON3_PROG} $here/src/popattr.py --file "${name}" --start 1 --incr 2 --end "${nr}" --remove
> +		return
> +	fi
> +
> +	# Simulate a getfattr dump file so we can bulk-add attrs.
> +	(
> +		echo "# file: ${name}";
> +		seq --format "user.%08g=\"abcdefgh\"" 0 "${nr}"
> +		echo
> +	) | setfattr --restore -
>  
>  	test -z "${missing}" && return
>  	seq 1 2 "${nr}" | while read d; do
> diff --git a/src/popattr.py b/src/popattr.py
> new file mode 100755
> index 0000000000..397ced9d33
> --- /dev/null
> +++ b/src/popattr.py
> @@ -0,0 +1,62 @@
> +#!/usr/bin/python3
> +
> +# Copyright (c) 2023 Oracle.  All rights reserved.
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Create a bunch of xattrs in a file.
> +
> +import argparse
> +import sys
> +import os
> +
> +parser = argparse.ArgumentParser(description = 'Mass create xattrs in a file')
> +parser.add_argument(
> +	'--file', required = True, type = str, help = 'manipulate this file')
> +parser.add_argument(
> +	'--start', type = int, default = 0,
> +	help = 'create xattrs starting with this number')
> +parser.add_argument(
> +	'--incr', type = int, default = 1,
> +	help = 'increment attr number by this much')
> +parser.add_argument(
> +	'--end', type = int, default = 1000,
> +	help = 'stop at this attr number')
> +parser.add_argument(
> +	'--remove', dest = 'remove', action = 'store_true',
> +	help = 'remove instead of creating')
> +parser.add_argument(
> +	'--format', type = str, default = '%08d',
> +	help = 'printf formatting string for attr name')
> +parser.add_argument(
> +	'--verbose', dest = 'verbose', action = 'store_true',
> +	help = 'verbose output')
> +
> +args = parser.parse_args()
> +
> +fmtstring = "user.%s" % args.format
> +
> +# If we are passed a regular file, open it as a proper file descriptor and
> +# pass that around for speed.  Otherwise, we pass the path.
> +fp = None
> +try:
> +	fp = open(args.file, 'r')
> +	fd = fp.fileno()
> +	os.listxattr(fd)
> +	if args.verbose:
> +		print("using fd calls")
> +except:
> +	if args.verbose:
> +		print("using path calls")
> +	fd = args.file
> +
> +for i in range(args.start, args.end + 1, args.incr):
> +	fname = fmtstring % i
> +
> +	if args.remove:
> +		if args.verbose:
> +			print("removexattr %s" % fname)
> +		os.removexattr(fd, fname)
> +	else:
> +		if args.verbose:
> +			print("setxattr %s" % fname)
> +		os.setxattr(fd, fname, b'abcdefgh')
> 

