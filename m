Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87506132484;
	Tue,  9 Apr 2024 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712676433; cv=none; b=fxVwP+XXGZRcvgNYMh6eSiwzc0tzWT68qvNuga6Mt0ffeZOx2LHrwWKn+Qn7HUCkbe01FQ/yU+ys4QfAhsXzL6G5PVvFRt/oKOwKSkqbpRnTkrWHGDi7SmQ+CCEV30nyRgczikeAYNIC33QP01LOC1EUbQA5ZIMS9EUCmLTxhzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712676433; c=relaxed/simple;
	bh=xbuY/2Nhdmd6Cb9+dqxv8QNKoLzR73eoTaRtNqU91ks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4KHyg7Nz7FdhQHuTvyj+wHiGZ+k23bD7uIdzy569c6dNXnDgpI/mIgYl+ulLrr+slgcx9ZnxUDTSdMnFEMZqg5Hup/LGvoRL4c2yUlsCuz7oiv7rjZ0LjWSn74i05oTXeG/91BqpJ2FPkmRLViOAJHMVXSOPUQ8C71sIg7oYhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+xeWeuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+xeWeuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A90C41679;
	Tue,  9 Apr 2024 15:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712676433;
	bh=xbuY/2Nhdmd6Cb9+dqxv8QNKoLzR73eoTaRtNqU91ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X+xeWeuOYdlyG7OhC5F9gnYn6gMCgnVorj4IILyhgE4UAkh093l98LjbbO2NuUMza
	 7QdgYleYlTs79InwhGgJlfl+hIUmv4ZkI1WVhot+5uIXg2GsnGyRszg6JYz52Od6ft
	 aFdridSOdJdKfJNLj0AqMYtQ1UY24lmAWHM16/31X/ym9MeyFpy3mh4a6Eqzwh6Xwy
	 pMj5omytkvTdP1y6q1VZtWEBV2Wc7QxZ/iyuOM1F2+Hn00u5qlanHVeuHSZN/BO0Fm
	 J9EZjro4LnBdHVx3ACtVcriWZM1ZoJHp7ex/jzDxl+ATIBDXZK9OmrNLzLPfCtpHGY
	 P2zamwpUcBHng==
Date: Tue, 9 Apr 2024 08:27:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 2/6] remove xfs/096
Message-ID: <20240409152712.GC634366@frogsfrogsfrogs>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408133243.694134-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408133243.694134-3-hch@lst.de>

On Mon, Apr 08, 2024 at 03:32:39PM +0200, Christoph Hellwig wrote:
> This test exercises mkfs error handling before strict validation was added
> and thus is useless for xfsprogs > 4.5.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yesssssssss decruftifying. :)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  .gitignore                 |   1 -
>  common/xfs                 |   9 ---
>  tests/xfs/096              | 130 -------------------------------------
>  tests/xfs/096.out.external |  50 --------------
>  tests/xfs/096.out.internal |  51 ---------------
>  5 files changed, 241 deletions(-)
>  delete mode 100755 tests/xfs/096
>  delete mode 100644 tests/xfs/096.out.external
>  delete mode 100644 tests/xfs/096.out.internal
> 
> diff --git a/.gitignore b/.gitignore
> index 3b160209a..51cda513d 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -211,7 +211,6 @@ tags
>  /tests/generic/050.out
>  /tests/xfs/033.out
>  /tests/xfs/071.out
> -/tests/xfs/096.out
>  /tests/xfs/216.out
>  
>  # cscope files
> diff --git a/common/xfs b/common/xfs
> index 57d21762c..49ca5a2d5 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1211,15 +1211,6 @@ _require_xfs_mkfs_validation()
>  	fi
>  }
>  
> -# The opposite of _require_xfs_mkfs_validation.
> -_require_xfs_mkfs_without_validation()
> -{
> -	_xfs_mkfs_validation_check
> -	if [ "$?" -ne 0 ]; then
> -		_notrun "Requires older mkfs without strict input checks: the last supported version of xfsprogs is 4.5."
> -	fi
> -}
> -
>  _require_scratch_xfs_shrink()
>  {
>  	_require_scratch
> diff --git a/tests/xfs/096 b/tests/xfs/096
> deleted file mode 100755
> index a7a5444f8..000000000
> --- a/tests/xfs/096
> +++ /dev/null
> @@ -1,130 +0,0 @@
> -#! /bin/bash
> -# SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
> -#
> -# FS QA Test No. 096
> -#
> -# test out mkfs_xfs output on IRIX/Linux and some of its error handling
> -# ensure pv#920679 is addressed
> -#
> -seqfull=$0
> -. ./common/preamble
> -_begin_fstest mkfs v2log auto quick
> -
> -# Import common functions.
> -. ./common/filter
> -. ./common/log
> -
> -#
> -# filter out counts which will vary
> -#   - extsz, blocks, agsize, agcount, device name, rtextents
> -#   - log version varies for crc enabled fs
> -#   - lsunit varies for 512/4k sector devices
> -# filter out differences between linux and irix:
> -#   - sectsz on Linux
> -#   - mmr, mixed-case on IRIX
> -#   - lazy-count on IRIX
> -#   - inode-paths on IRIX
> -#   - trailing spaces on Linux but not on IRIX
> -#
> -# Example output:
> -#  meta-data=DEV isize=256    agcount=N, agsize=N blks
> -#  data     =                       bsize=4096   blocks=N, imaxpct=25
> -#           =                       sunit=65     swidth=65 blks, unwritten=1
> -#  naming   =version 2              bsize=4096
> -#  log      =internal log           bsize=4096   blocks=N, version=1
> -#           =                       sunit=0 blks
> -#  realtime =none                   extsz=65536  blocks=N, rtextents=N
> -#
> -mkfs_filter()
> -{
> -   tee -a $seqres.full | \
> -   sed \
> -	-e 's/extsz=[0-9][0-9]*[ ]*/extsz=N, /' \
> -	-e 's/blocks=[0-9][0-9]*/blocks=N/' \
> -	-e 's/imaxpct=[0-9][0-9]*/imaxpct=N/' \
> -	-e 's/agsize=[0-9][0-9]*/agsize=N/' \
> -	-e 's/agcount=[0-9][0-9]*/agcount=N/' \
> -        -e 's/swidth=[0-9][0-9]* blks$/&, unwritten=1/' \
> -	-e 's/rtextents=[0-9][0-9]*/rtextents=N/' \
> -	-e 's/meta-data=[^ ]*/meta-data=DEV/' \
> -        -e 's/ *isize=[0-9]* / isize=N /' \
> -	-e '/ *= *sectsz=[0-9][0-9]* *attr=[0-9][0-9]*.*$/d' \
> -	-e '/ *= *mmr=[0-9][0-9]* *$/d' \
> -	-e 's/ *mixed-case=[YN]//' \
> -	-e 's/ *ascii-ci=[01]//' \
> -	-e 's/\(version=\)\([12]\)/\1N/' \
> -	-e 's/\(sunit=\)\([018] blks\)/\1N blks/' \
> -	-e 's/sectsz=[0-9][0-9]* *//' \
> -	-e 's/, lazy-count.*//' \
> -	-e '/inode-paths/d' \
> -	-e 's/\(log[ 	]*=\).*bsize/\1LOG                    bsize/' \
> -	-e 's/\(realtime[ 	]*=\).*extsz/\1REALTIME               extsz/' \
> -	-e '/.*crc=/d' \
> -	-e 's/ *$//' \
> -	-e 's/ ftype=[01]//' \
> -	-e '/^log stripe unit.*too large/d' \
> -	-e '/^log stripe unit adjusted/d' \
> -	-e '/Discarding/d' \
> -   | grep -v parent
> -}
> -
> -# real QA test starts here
> -
> -# Modify as appropriate.
> -_supported_fs xfs
> -_require_scratch
> -_require_v2log
> -_require_xfs_mkfs_without_validation
> -
> -# choose .out file based on internal/external log
> -rm -f $seqfull.out
> -if [ "$USE_EXTERNAL" = yes ]; then
> -	ln -s $seq.out.external $seqfull.out
> -else
> -	ln -s $seq.out.internal $seqfull.out
> -fi
> -
> -# maximum log record size
> -max_lr_size=`expr 256 \* 1024`
> -
> -big_su=`expr $max_lr_size + 4096`
> -
> -#
> -# Test out various mkfs param combinations
> -#
> -cat >$tmp.seq.params <<EOF
> -# su too big but must be a multiple of fs block size too
> -  -l version=2,su=`expr $max_lr_size + 512`
> -# test log stripe greater than LR size
> -  -l version=2,su=$big_su
> -# same test but get log stripe from data stripe
> -  -l version=2 -d su=$big_su,sw=1
> -# test out data stripe
> -  -m crc=0 -l version=1 -d su=$big_su,sw=1
> -# test out data stripe the same but using sunit & swidth
> -  -m crc=0 -l version=1 -d sunit=`expr $big_su / 512`,swidth=`expr $big_su / 512`
> -EOF
> -
> -#
> -# call mkfs in a loop for various params
> -#
> -echo ""
> -cat $tmp.seq.params \
> -| while read mkfs
> -do
> -    if echo $mkfs | grep -q '^#'; then
> -        # print out header & ignore comment
> -	echo $mkfs
> -	continue
> -    fi
> -    echo "--- mkfs=$mkfs ---"
> -    export MKFS_OPTIONS="$mkfs"
> -    _scratch_mkfs_xfs 2>&1 | mkfs_filter
> -    echo ""
> -    echo ""
> -done
> -
> -# success, all done
> -status=0
> -exit
> diff --git a/tests/xfs/096.out.external b/tests/xfs/096.out.external
> deleted file mode 100644
> index 3122330ac..000000000
> --- a/tests/xfs/096.out.external
> +++ /dev/null
> @@ -1,50 +0,0 @@
> -QA output created by 096
> -
> -# su too big but must be a multiple of fs block size too
> ---- mkfs=-l version=2,su=262656 ---
> -log stripe unit (262656) must be a multiple of the block size (4096)
> -
> -
> -# test log stripe greater than LR size
> ---- mkfs=-l version=2,su=266240 ---
> -meta-data=DEV isize=N      agcount=N, agsize=N blks
> -data     =                       bsize=4096   blocks=N, imaxpct=N
> -         =                       sunit=0      swidth=0 blks, unwritten=1
> -naming   =version 2              bsize=4096
> -log      =LOG                    bsize=4096   blocks=N, version=N
> -realtime =REALTIME               extsz=N, blocks=N, rtextents=N
> -
> -
> -# same test but get log stripe from data stripe
> ---- mkfs=-l version=2 -d su=266240,sw=1 ---
> -meta-data=DEV isize=N      agcount=N, agsize=N blks
> -data     =                       bsize=4096   blocks=N, imaxpct=N
> -         =                       sunit=65     swidth=65 blks, unwritten=1
> -naming   =version 2              bsize=4096
> -log      =LOG                    bsize=4096   blocks=N, version=N
> -         =                       sunit=N blks
> -realtime =REALTIME               extsz=N, blocks=N, rtextents=N
> -
> -
> -# test out data stripe
> ---- mkfs=-m crc=0 -l version=1 -d su=266240,sw=1 ---
> -meta-data=DEV isize=N      agcount=N, agsize=N blks
> -data     =                       bsize=4096   blocks=N, imaxpct=N
> -         =                       sunit=65     swidth=65 blks, unwritten=1
> -naming   =version 2              bsize=4096
> -log      =LOG                    bsize=4096   blocks=N, version=N
> -         =                       sunit=N blks
> -realtime =REALTIME               extsz=N, blocks=N, rtextents=N
> -
> -
> -# test out data stripe the same but using sunit & swidth
> ---- mkfs=-m crc=0 -l version=1 -d sunit=520,swidth=520 ---
> -meta-data=DEV isize=N      agcount=N, agsize=N blks
> -data     =                       bsize=4096   blocks=N, imaxpct=N
> -         =                       sunit=65     swidth=65 blks, unwritten=1
> -naming   =version 2              bsize=4096
> -log      =LOG                    bsize=4096   blocks=N, version=N
> -         =                       sunit=N blks
> -realtime =REALTIME               extsz=N, blocks=N, rtextents=N
> -
> -
> diff --git a/tests/xfs/096.out.internal b/tests/xfs/096.out.internal
> deleted file mode 100644
> index 80201d25b..000000000
> --- a/tests/xfs/096.out.internal
> +++ /dev/null
> @@ -1,51 +0,0 @@
> -QA output created by 096
> -
> -# su too big but must be a multiple of fs block size too
> ---- mkfs=-l version=2,su=262656 ---
> -log stripe unit (262656) must be a multiple of the block size (4096)
> -
> -
> -# test log stripe greater than LR size
> ---- mkfs=-l version=2,su=266240 ---
> -meta-data=DEV isize=N    agcount=N, agsize=N blks
> -data     =                       bsize=4096   blocks=N, imaxpct=N
> -         =                       sunit=0      swidth=0 blks, unwritten=1
> -naming   =version 2              bsize=4096
> -log      =LOG                    bsize=4096   blocks=N, version=N
> -         =                       sunit=N blks
> -realtime =REALTIME               extsz=N, blocks=N, rtextents=N
> -
> -
> -# same test but get log stripe from data stripe
> ---- mkfs=-l version=2 -d su=266240,sw=1 ---
> -meta-data=DEV isize=N    agcount=N, agsize=N blks
> -data     =                       bsize=4096   blocks=N, imaxpct=N
> -         =                       sunit=65     swidth=65 blks, unwritten=1
> -naming   =version 2              bsize=4096
> -log      =LOG                    bsize=4096   blocks=N, version=N
> -         =                       sunit=N blks
> -realtime =REALTIME               extsz=N, blocks=N, rtextents=N
> -
> -
> -# test out data stripe
> ---- mkfs=-m crc=0 -l version=1 -d su=266240,sw=1 ---
> -meta-data=DEV isize=N    agcount=N, agsize=N blks
> -data     =                       bsize=4096   blocks=N, imaxpct=N
> -         =                       sunit=65     swidth=65 blks, unwritten=1
> -naming   =version 2              bsize=4096
> -log      =LOG                    bsize=4096   blocks=N, version=N
> -         =                       sunit=N blks
> -realtime =REALTIME               extsz=N, blocks=N, rtextents=N
> -
> -
> -# test out data stripe the same but using sunit & swidth
> ---- mkfs=-m crc=0 -l version=1 -d sunit=520,swidth=520 ---
> -meta-data=DEV isize=N    agcount=N, agsize=N blks
> -data     =                       bsize=4096   blocks=N, imaxpct=N
> -         =                       sunit=65     swidth=65 blks, unwritten=1
> -naming   =version 2              bsize=4096
> -log      =LOG                    bsize=4096   blocks=N, version=N
> -         =                       sunit=N blks
> -realtime =REALTIME               extsz=N, blocks=N, rtextents=N
> -
> -
> -- 
> 2.39.2
> 
> 
