Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16038C38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 15:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjARPLq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 10:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjARPKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 10:10:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C047366A0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 07:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674054597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a9gQrpEkg7DUjBrf/Jkqe5bWwtz9rN+oGDEtYr7z9D8=;
        b=M+9sZUtWP8irdOh/3Hl9i9FGWvwEvUL7xK2BQHtTuyLlRsgLkmu2geIpDoJfOpDSqKeQwD
        OnQWBDxfo4FogBE2I424axhP+MUmB3OkSUJkExkmmA0WcyjP5WSfm5KrqIt3NyMo7zb0xV
        e3c2DkndI5kOR+JN79jsv+bzHqohDZM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-_9etj-sEOAiBdt_dtOZvHA-1; Wed, 18 Jan 2023 10:09:56 -0500
X-MC-Unique: _9etj-sEOAiBdt_dtOZvHA-1
Received: by mail-pj1-f69.google.com with SMTP id lk5-20020a17090b33c500b00228cb369d7aso1598973pjb.5
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 07:09:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9gQrpEkg7DUjBrf/Jkqe5bWwtz9rN+oGDEtYr7z9D8=;
        b=llJ+O9WG4+rkYHBGL53KDp3QFrJVdrf30pq0v3VvCy6T0RvtpU9YKdyvycnwTrQYwz
         JPP3H58/9tfRCV4cnA8cz9g7OWCsnwiOukXfxLSKXUnLJA5zoUwXn5lGBttUZHm697m5
         vYa5r0ftr2XKrqtTx/CUcVLZpxb/hQ1DWp/IfjfMvz96jkXVc+S8OGSNTvdXkYhqTXKn
         Fr5iFAGvLeOP6+By2m3+24l7maFWyq3F0Du/PN/RxMbpjv9X0dm3N2yUfyBlIHkiP5DG
         nx4jLzud7XrNe+LQyS5lGxkZItFN7ZBWRYnKHSmcUTvRQFxyd7INScSu+G62gNB63TtS
         vAIA==
X-Gm-Message-State: AFqh2kryGWVFtH2vKDdx9wSYjXJ6DqafFtLjRXexcZquDIps2dkUZ7aw
        /4jITx8zhI9h43pua4WFCiOV5A1Ucni8C09B4HLEPNaFf29jLE0g9/2fvkO9mLtQOdiXXpL9Ktb
        hX9r4OilJ5+p8UJK2Jy3k
X-Received: by 2002:a17:902:bcc8:b0:194:c23d:59fd with SMTP id o8-20020a170902bcc800b00194c23d59fdmr826471pls.47.1674054594409;
        Wed, 18 Jan 2023 07:09:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv5DB4Q98LOQbavh/RHjL5cAOr8slroZ4GaDlJ9r6ToUZ6gVmTuVqfURvYW82n1PZbl8uF8wA==
X-Received: by 2002:a17:902:bcc8:b0:194:c23d:59fd with SMTP id o8-20020a170902bcc800b00194c23d59fdmr826441pls.47.1674054593912;
        Wed, 18 Jan 2023 07:09:53 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902a3c100b001899c2a0ae0sm23266373plb.40.2023.01.18.07.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:09:53 -0800 (PST)
Date:   Wed, 18 Jan 2023 23:09:49 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] populate: remove file creation loops that take
 forever
Message-ID: <20230118150949.pvcpq6nsskxkrtcs@zlang-mailbox>
References: <167400103044.1915094.5935980986164675922.stgit@magnolia>
 <167400103070.1915094.18012675472928079868.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167400103070.1915094.18012675472928079868.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 17, 2023 at 04:44:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace the file creation loops with a perl script that does everything
> we want from a single process.  This reduces the runtime of
> _scratch_xfs_populate substantially by avoiding thousands of execve
> overhead.  On my system, this reduces the runtime of xfs/349 (with scrub
> enabled) from ~140s to ~45s.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/populate |   61 ++++++++++++++++++-----------------------------
>  src/popdir.pl   |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 96 insertions(+), 37 deletions(-)
>  create mode 100755 src/popdir.pl
> 
> 
> diff --git a/common/populate b/common/populate
> index 84f4b8e374..180540aedd 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -11,6 +11,7 @@ _require_populate_commands() {
>  	_require_xfs_io_command "falloc"
>  	_require_xfs_io_command "fpunch"
>  	_require_test_program "punch-alternating"
> +	_require_test_program "popdir.pl"
>  	case "${FSTYP}" in
>  	"xfs")
>  		_require_command "$XFS_DB_PROG" "xfs_db"
> @@ -54,55 +55,50 @@ __populate_fragment_file() {
>  
>  # Create a large directory
>  __populate_create_dir() {
> -	name="$1"
> -	nr="$2"
> -	missing="$3"
> +	local name="$1"
> +	local nr="$2"
> +	local missing="$3"
> +	shift; shift; shift
>  
>  	mkdir -p "${name}"
> -	seq 0 "${nr}" | while read d; do
> -		creat=mkdir
> -		test "$((d % 20))" -eq 0 && creat=touch
> -		$creat "${name}/$(printf "%.08d" "$d")"
> -	done
> +	$here/src/popdir.pl --dir "${name}" --end "${nr}" "$@"
>  
>  	test -z "${missing}" && return
> -	seq 1 2 "${nr}" | while read d; do
> -		rm -rf "${name}/$(printf "%.08d" "$d")"
> -	done
> +	$here/src/popdir.pl --dir "${name}" --start 1 --incr 2 --end "${nr}" --remove "$@"
>  }
>  
>  # Create a large directory and ensure that it's a btree format
>  __populate_xfs_create_btree_dir() {
>  	local name="$1"
>  	local isize="$2"
> -	local missing="$3"
> +	local dblksz="$3"
> +	local missing="$4"
>  	local icore_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
>  	# We need enough extents to guarantee that the data fork is in
>  	# btree format.  Cycling the mount to use xfs_db is too slow, so
>  	# watch for when the extent count exceeds the space after the
>  	# inode core.
>  	local max_nextents="$(((isize - icore_size) / 16))"
> -	local nr=0
> +	local nr
> +	local incr
> +
> +	# Add about one block's worth of dirents before we check the data fork
> +	# format.
> +	incr=$(( (dblksz / 8) / 100 * 100 ))
>  
>  	mkdir -p "${name}"
> -	while true; do
> -		local creat=mkdir
> -		test "$((nr % 20))" -eq 0 && creat=touch
> -		$creat "${name}/$(printf "%.08d" "$nr")"
> +	for ((nr = 0; ; nr += incr)); do
> +		$here/src/popdir.pl --dir "${name}" --start "${nr}" --end "$((nr + incr - 1))"
> +
>  		# Extent count checks use data blocks only to avoid the removal
>  		# step from removing dabtree index blocks and reducing the
>  		# number of extents below the required threshold.
> -		if [ "$((nr % 40))" -eq 0 ]; then
> -			local nextents="$(xfs_bmap ${name} | grep -v hole | wc -l)"
> -			[ "$((nextents - 1))" -gt $max_nextents ] && break
> -		fi
> -		nr=$((nr+1))
> +		local nextents="$(xfs_bmap ${name} | grep -v hole | wc -l)"
> +		[ "$((nextents - 1))" -gt $max_nextents ] && break
>  	done
>  
>  	test -z "${missing}" && return
> -	seq 1 2 "${nr}" | while read d; do
> -		rm -rf "${name}/$(printf "%.08d" "$d")"
> -	done
> +	$here/src/popdir.pl --dir "${name}" --start 1 --incr 2 --end "${nr}" --remove
>  }
>  
>  # Add a bunch of attrs to a file
> @@ -224,9 +220,7 @@ _scratch_xfs_populate() {
>  
>  	# Fill up the root inode chunk
>  	echo "+ fill root ino chunk"
> -	seq 1 64 | while read f; do
> -		$XFS_IO_PROG -f -c "truncate 0" "${SCRATCH_MNT}/dummy${f}"
> -	done
> +	$here/src/popdir.pl --dir "${SCRATCH_MNT}" --start 1 --end 64 --format "dummy%u" --file-mult 1
>  
>  	# Regular files
>  	# - FMT_EXTENTS
> @@ -261,7 +255,7 @@ _scratch_xfs_populate() {
>  
>  	# - BTREE
>  	echo "+ btree dir"
> -	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize" true
> +	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize" "$dblksz" true
>  
>  	# Symlinks
>  	# - FMT_LOCAL
> @@ -340,14 +334,7 @@ _scratch_xfs_populate() {
>  	local rec_per_btblock=16
>  	local nr="$(( 2 * (blksz / rec_per_btblock) * ino_per_rec ))"
>  	local dir="${SCRATCH_MNT}/INOBT"
> -	mkdir -p "${dir}"
> -	seq 0 "${nr}" | while read f; do
> -		touch "${dir}/${f}"
> -	done
> -
> -	seq 0 2 "${nr}" | while read f; do
> -		rm -f "${dir}/${f}"
> -	done
> +	__populate_create_dir "${dir}" "${nr}" true --file-mult 1
>  
>  	# Reverse-mapping btree
>  	is_rmapbt="$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)"
> diff --git a/src/popdir.pl b/src/popdir.pl
> new file mode 100755
> index 0000000000..dc0c046b7d
> --- /dev/null
> +++ b/src/popdir.pl
> @@ -0,0 +1,72 @@
> +#!/usr/bin/perl -w
> +
> +# Copyright (c) 2023 Oracle.  All rights reserved.
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Create a bunch of files and subdirs in a directory.
> +
> +use Getopt::Long;
> +use File::Basename;
> +
> +$progname=$0;
> +GetOptions("start=i" => \$start,
> +	   "end=i" => \$end,
> +	   "file-mult=i" => \$file_mult,
> +	   "incr=i" => \$incr,
> +	   "format=s" => \$format,
> +	   "dir=s" => \$dir,
> +	   "remove!" => \$remove,
> +	   "help!" => \$help,
> +	   "verbose!" => \$verbose);
> +
> +
> +# check/remove output directory, get filesystem info
> +if (defined $help) {
> +  # newline at end of die message suppresses line number
> +  print STDERR <<"EOF";
> +Usage: $progname [options]
> +Options:
> +  --dir             chdir here before starting
> +  --start=num       create names starting with this number (0)
> +  --incr=num        increment file number by this much (1)
> +  --end=num         stop at this file number (100)
> +  --file-mult       create a regular file when file number is a multiple
> +                    of this quantity (20)
> +  --remove          remove instead of creating
> +  --format=str      printf formatting string for file name ("%08d")
> +  --verbose         verbose output
> +  --help            this help screen
> +EOF
> +  exit(1) unless defined $help;
> +  # otherwise...
> +  exit(0);
> +}
> +
> +if (defined $dir) {
> +	chdir($dir) or die("chdir $dir");
> +}
> +$start = 0 if (!defined $start);
> +$end = 100 if (!defined $end);
> +$file_mult = 20 if (!defined $file_mult);
> +$format = "%08d" if (!defined $format);
> +$incr = 1 if (!defined $incr);
> +
> +for ($i = $start; $i <= $end; $i += $incr) {
> +	$fname = sprintf($format, $i);
> +
> +	if ($remove) {
> +		$verbose && print "rm $fname\n";
> +		unlink($fname) or rmdir($fname) or die("unlink $fname");
> +	} elsif ($file_mult == 0 or ($i % $file_mult) == 0) {
> +		# create a file
> +		$verbose && print "touch $fname\n";
> +		open(DONTCARE, ">$fname") or die("touch $fname");
> +		close(DONTCARE);
> +	} else {
> +		# create a subdir
> +		$verbose && print "mkdir $fname\n";
> +		mkdir($fname, 0755) or die("mkdir $fname");
> +	}
> +}
> +
> +exit(0);
> 

