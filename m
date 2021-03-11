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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B3FC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 09:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B09F064FC4
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 09:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhCKJmp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 04:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbhCKJme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 04:42:34 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C82C061574;
        Thu, 11 Mar 2021 01:42:34 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id ba1so9950312plb.1;
        Thu, 11 Mar 2021 01:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=yj8SLugH/jXe4h1vrDEkg5x3bhjIsQQMv9xAwn13VO8=;
        b=rwqes1DdKxnHs2zbfNaY+9u4RzNx9xCtO/sM2wa3w0rUt6oaBfeIGQMx8AVxViamhJ
         MqWdlZlc9djTfoi+o5PbzB8mW6od/6U9q2SVlMAAK7irULbCHpMGBNmp68XiXTFmE8cM
         QiZXGNt36baUG1RVmGlvv3rkZQXU7TYxFjv2TmsWmnKYMkPH9ROPUHD6N6+fUEuUr/X1
         CU46DuJakzr1+sjsDJ/Ed2RRAmAdmgksjHBJhrVxGLKODYVAnNfe6q8+pIJaST7PEApY
         EAlCQfnohQmP6ZscgzBL3wgPeMPWXL3nj7s4LiEqjEr4YxsyWM2M7Vz5vFymjpov6ir/
         jQxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=yj8SLugH/jXe4h1vrDEkg5x3bhjIsQQMv9xAwn13VO8=;
        b=rXzM4K6XHbo8zJQKSJdLIC9+0wwxFlONDymTv5udBRgHwZhIpNQ7trO6nKEd18G59u
         hM1OwYD2WaA3OTm6nL9kZ8uZL3DDZJ5KCAZU/BVgMtxOW6UCilxPi087twPugGRrjqjG
         xzWzCgasOqQqk4fwowWezyMQ03q5bRYuBNwitvDmjMkiZTheqtDS7P3XzXuasxJ/YJMh
         0VdsG/uw3Ta3fJ9wmrc6V8wmlLr2thO9a2wh7d0vkxRkkr3Q+7zoK+XoSYbiGK02WCtj
         WX2Wc0/+l3Us70PbXJvdGGCy2bzVcI35bv/5pe/swo6GtnxkW6aQbvDViSyLPiVF3ymU
         cujQ==
X-Gm-Message-State: AOAM531QVe1ICfCsPHoEOpG9/N2H/nZxdxj0q82EmAPiEzqKEdSM5JIo
        QERNokR9con9BjHBPccN7aU=
X-Google-Smtp-Source: ABdhPJyiTRnrXnIDmSpASKtTCHr9O6VE4cuLa4F3ZWwmnDzpNSrhtQlVp+hq3LCovEVN/y3NL+IexQ==
X-Received: by 2002:a17:90b:1a86:: with SMTP id ng6mr7950983pjb.26.1615455753989;
        Thu, 11 Mar 2021 01:42:33 -0800 (PST)
Received: from garuda ([122.171.53.181])
        by smtp.gmail.com with ESMTPSA id 27sm1955053pgq.51.2021.03.11.01.42.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Mar 2021 01:42:33 -0800 (PST)
References: <161526480371.1214319.3263690953532787783.stgit@magnolia> <161526483109.1214319.14555094406560973318.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 05/10] common/filter: refactor quota report filtering
In-reply-to: <161526483109.1214319.14555094406560973318.stgit@magnolia>
Date:   Thu, 11 Mar 2021 15:12:30 +0530
Message-ID: <87k0qec9h5.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 09 Mar 2021 at 10:10, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> xfs/299 and xfs/050 share the same function to filter quota reporting
> into a format suitable for the golden output.  Refactor this so that we
> can use it in a new test.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/filter |   24 ++++++++++++++++++++++++
>  tests/xfs/050 |   30 ++++++------------------------
>  tests/xfs/299 |   30 ++++++------------------------
>  3 files changed, 36 insertions(+), 48 deletions(-)
>
>
> diff --git a/common/filter b/common/filter
> index 2f3277f7..2efbbd99 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -637,5 +637,29 @@ _filter_getcap()
>          sed -e "s/= //" -e "s/\+/=/g"
>  }
>  
> +# Filter user/group/project id numbers out of quota reports, and standardize
> +# the block counts to use filesystem block size.  Callers must set the id and
> +# bsize variables before calling this function.
> +_filter_quota_report()
> +{
> +	test -n "$id" || echo "id must be set"
> +	test -n "$bsize" || echo "block size must be set"
> +
> +	tr -s '[:space:]' | \
> +	perl -npe '
> +		s/^\#'$id' /[NAME] /g;
> +		s/^\#0 \d+ /[ROOT] 0 /g;
> +		s/6 days/7 days/g' |
> +	perl -npe '
> +		$val = 0;
> +		if ($ENV{'LARGE_SCRATCH_DEV'}) {
> +			$val = $ENV{'NUM_SPACE_FILES'};
> +		}
> +		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
> +	sed -e 's/ 65535 \[--------\]/ 00 \[--------\]/g' |
> +	perl -npe '
> +		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
> +}
> +
>  # make sure this script returns success
>  /bin/true
> diff --git a/tests/xfs/050 b/tests/xfs/050
> index 53412a13..1df97537 100755
> --- a/tests/xfs/050
> +++ b/tests/xfs/050
> @@ -47,24 +47,6 @@ bhard=$(( 1000 * $bsize ))
>  isoft=4
>  ihard=10
>  
> -_filter_report()
> -{
> -	tr -s '[:space:]' | \
> -	perl -npe '
> -		s/^\#'$id' /[NAME] /g;
> -		s/^\#0 \d+ /[ROOT] 0 /g;
> -		s/6 days/7 days/g' |
> -	perl -npe '
> -		$val = 0;
> -		if ($ENV{'LARGE_SCRATCH_DEV'}) {
> -			$val = $ENV{'NUM_SPACE_FILES'};
> -		}
> -		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
> -	sed -e 's/ 65535 \[--------\]/ 00 \[--------\]/g' |
> -	perl -npe '
> -		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
> -}
> -
>  # The actual point at which limit enforcement takes place for the
>  # hard block limit is variable depending on filesystem blocksize,
>  # and iosize.  What we want to test is that the limit is enforced
> @@ -84,7 +66,7 @@ _filter_and_check_blks()
>  			}
>  			s/^(\#'$id'\s+)(\d+)/\1 =OK=/g;
>  		}
> -	' | _filter_report
> +	' | _filter_quota_report
>  }
>  
>  _qsetup()
> @@ -134,7 +116,7 @@ _exercise()
>  	echo "*** report no quota settings" | tee -a $seqres.full
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
> -		_filter_report | LC_COLLATE=POSIX sort -ru
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
>  	echo "*** report initial settings" | tee -a $seqres.full
> @@ -147,7 +129,7 @@ _exercise()
>  		$SCRATCH_DEV
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
> -		_filter_report | LC_COLLATE=POSIX sort -ru
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
>  	echo "*** push past the soft inode limit" | tee -a $seqres.full
> @@ -159,7 +141,7 @@ _exercise()
>  	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" $SCRATCH_DEV
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
> -		_filter_report | LC_COLLATE=POSIX sort -ru
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
>  	echo "*** push past the soft block limit" | tee -a $seqres.full
> @@ -169,7 +151,7 @@ _exercise()
>  		-c "warn -b -$type 0 $id" $SCRATCH_DEV
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
> -		_filter_report | LC_COLLATE=POSIX sort -ru
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
>  	# Note: for quota accounting (not enforcement), EDQUOT is not expected
> @@ -183,7 +165,7 @@ _exercise()
>  		-c "warn -i -$type 0 $id" $SCRATCH_DEV
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
> -		_filter_report | LC_COLLATE=POSIX sort -ru
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
>  	# Note: for quota accounting (not enforcement), EDQUOT is not expected
> diff --git a/tests/xfs/299 b/tests/xfs/299
> index 15e0edf6..b862e67e 100755
> --- a/tests/xfs/299
> +++ b/tests/xfs/299
> @@ -40,24 +40,6 @@ _require_xfs_quota
>  _require_xfs_mkfs_crc
>  _require_xfs_crc
>  
> -_filter_report()
> -{
> -	tr -s '[:space:]' | \
> -	perl -npe '
> -		s/^\#'$id' /[NAME] /g;
> -		s/^\#0 \d+ /[ROOT] 0 /g;
> -		s/6 days/7 days/g' |
> -	perl -npe '
> -		$val = 0;
> -		if ($ENV{'LARGE_SCRATCH_DEV'}) {
> -			$val = $ENV{'NUM_SPACE_FILES'};
> -		}
> -		s/(^\[ROOT\] \S+ \S+ \S+ \S+ \[--------\] )(\S+)/$1@{[$2 - $val]}/g' |
> -	sed -e 's/ 65535 \[--------\]/ 00 \[--------\]/g' |
> -	perl -npe '
> -		s|^(.*?) (\d+) (\d+) (\d+)|$1 @{[$2 * 1024 /'$bsize']} @{[$3 * 1024 /'$bsize']} @{[$4 * 1024 /'$bsize']}|'
> -}
> -
>  # The actual point at which limit enforcement takes place for the
>  # hard block limit is variable depending on filesystem blocksize,
>  # and iosize.  What we want to test is that the limit is enforced
> @@ -77,7 +59,7 @@ _filter_and_check_blks()
>  			}
>  			s/^(\#'$id'\s+)(\d+)/\1 =OK=/g;
>  		}
> -	' | _filter_report
> +	' | _filter_quota_report
>  }
>  
>  _qsetup()
> @@ -120,7 +102,7 @@ _exercise()
>  	echo "*** report no quota settings" | tee -a $seqres.full
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
> -		_filter_report | LC_COLLATE=POSIX sort -ru
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
>  	echo "*** report initial settings" | tee -a $seqres.full
> @@ -133,7 +115,7 @@ _exercise()
>  		$SCRATCH_DEV
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
> -		_filter_report | LC_COLLATE=POSIX sort -ru
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
>  	echo "*** push past the soft inode limit" | tee -a $seqres.full
> @@ -145,7 +127,7 @@ _exercise()
>  	$XFS_QUOTA_PROG -x -c "warn -i -$type 0 $id" $SCRATCH_DEV
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
> -		_filter_report | LC_COLLATE=POSIX sort -ru
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
>  	echo "*** push past the soft block limit" | tee -a $seqres.full
> @@ -155,7 +137,7 @@ _exercise()
>  		-c "warn -b -$type 0 $id" $SCRATCH_DEV
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
> -		_filter_report | LC_COLLATE=POSIX sort -ru
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
>  	# Note: for quota accounting (not enforcement), EDQUOT is not expected
> @@ -169,7 +151,7 @@ _exercise()
>  		-c "warn -i -$type 0 $id" $SCRATCH_DEV
>  	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  		-c "repquota -birnN -$type" $SCRATCH_DEV |
> -		_filter_report | LC_COLLATE=POSIX sort -ru
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
>  
>  	echo
>  	# Note: for quota accounting (not enforcement), EDQUOT is not expected


-- 
chandan
