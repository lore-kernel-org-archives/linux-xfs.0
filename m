Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86F21FF1CF;
	Fri, 23 May 2025 05:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747977250; cv=none; b=iNmwqeRZXBgcHfukDV+EpUmZLfzbmL6+keoIGoEX64zj7DECz93d0a6mlVoWjTPUgcLjzKUodYcrM/E+tMSuJq6eixbKoRTX8qZH2FtHuXsZIuiY7JxC0xvRtWeH6zJPF/aISEctJiiSAQQhNoEZv1EO5HviBDQmdQesUgr38cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747977250; c=relaxed/simple;
	bh=DpMEC4OhGJ0CmEZmBQJoFOaHVpTZGHILlG3LXc2FpGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sdScr5Fkx9Q0MswBrXeJkgQVmtAr11pAVGixWwnAHcsuUauqwwJbjfC/pJCY3yChRSyrex+Wii3vggvR1g3IxFifHFi7IBSCHdQc/NthUJ4m4dh9jqzXBfg0bL/V8b3lYAOZc932/MHRdTrtoFNcSywKCjcByXWz4dnmKHm+e64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GcpBzauh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GcpBzauh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a9sizBR3KTEl9eByxYseLaZMbszYfPSPhg0QFwUxRUs=; b=GcpBzauhqOV4rSJ8oWghAaMf8O
	gpfyEX2zXdWJ9Ao/gWYBINfj9zlgyGIyvE9JaLCwdiIZOFwKd07+TstebTov5/cwwr8D9PHGyJSN+
	JrXHZJYr9+SMCh+/TC5Dxk3mR9hGiuvtKDuc0pWVrneqURkVc0YrY/MtFefOqRe2RlXp3TUkEgWIy
	4JiwaiSXMpaifJjocQjeAzgW0h5tdWxPBaOGgXVyiCkekX3gAGDxshsc3Zc/9gErcDtmhs/cpg5/Z
	XMRal18l8tS4QxfwnLw1gkbrxy5RkmModHlsl5H+Hvv3FqddEt24u5oKgm/b//kCF6BQRK9PY9K2V
	dfQxpUAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uIKjQ-00000002ylr-0O72;
	Fri, 23 May 2025 05:14:08 +0000
Date: Thu, 22 May 2025 22:14:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] check: check and fix the test filesystem after
 failed tests
Message-ID: <aDAEIE-UPT6P4xsE@infradead.org>
References: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
 <174786719769.1398933.12370766699740321314.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174786719769.1398933.12370766699740321314.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, May 21, 2025 at 03:42:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, ./check calls _check_filesystems after a test passes to make
> sure that the test and scratch filesystems are ok, and repairs the test
> filesystem if it's not ok.
> 
> However, we don't do this for failed tests.  If a test fails /and/
> corrupts the test filesystem, every subsequent passing test will be
> marked as a failure because of latent corruptions on the test
> filesystem.
> 
> This is a little silly, so let's call _check_filesystems on the test
> filesystem after a test fail so that the badness doesn't spread.
> 
> Cc: <fstests@vger.kernel.org> # v2023.05.01
> Fixes: 4a444bc19a836f ("check: _check_filesystems for errors even if test failed")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  check |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/check b/check
> index 826641268f8b52..818ce44da28f65 100755
> --- a/check
> +++ b/check
> @@ -986,8 +986,13 @@ function run_section()
>  			_dump_err_cont "[failed, exit status $sts]"
>  			_test_unmount 2> /dev/null
>  			_scratch_unmount 2> /dev/null
> -			rm -f ${RESULT_DIR}/require_test*
>  			rm -f ${RESULT_DIR}/require_scratch*
> +
> +			# Make sure the test filesystem is ready to go since
> +			# we don't call _check_filesystems for failed tests
> +			(_adjust_oom_score 250; _check_filesystems) || tc_status="fail"

Maybe break the line after the || to improve readability?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

