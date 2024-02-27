Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B176654BFE;
	Tue, 27 Feb 2024 14:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045545; cv=none; b=dksveMl4rAkSJp+GZxiSmf5ZxENKFsY7ZSt+mIqvXkTwHnnFvcA2x13zOJVlHrJmIH/gMKei7Cqhk8UOXfbIC1adidS+aS6+buhnXCp0+CDP1glCPEc3yTI2n/BDN4GBRSNUGqMfaEbftyEyOu3fHS5O1peEWU+gL1c85sr9omc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045545; c=relaxed/simple;
	bh=eUdlhsgqfW9VFxbeUIAn9zC90xCNfQkX3KS7odTHw9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrgzBrnS289Xqlg7umjMd68xfWMqsCscViWYrWRbCsatrcHeAEXRWUU1iBnWGzk7r+Xs1oB9cNAjngzAKDhGSdDQn/fWGK6KlVUf9M0iizbEDsPsecOAamlcuHZAGiZA/Sm+fd5w164++yybhVM0RcOmRAk1fbd+i8YH6IK7TRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G3NpGbfl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G3NpGbfl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XiiRoniiKLqJRupLPFYYW/vIdCMSejsWY5p2ac3er60=; b=G3NpGbflJ4aLZlXIJrn9jmO13+
	1wl/qs6hJJVoj0Rps+ziIBQ6rxpvww8D8VEbWNsbpfCy/q5cNULjx5+hrNbGyJY2VeRxCGyDS/+w8
	Rzv4nroyU/bOPhww/G8jmHKNlbAROtG3ka21uCtJ1YuCAU49AYeqR1X8NAn9HsMCj56jtVD6rZTuP
	Q3f3OCQlGZNpBIlDyvLGfAPp+GGlRQYiCmtqjJfUyjiyY4xJjREaEFTTqSy/UcCBkCEFOEoXryJ1k
	Rv4mSi+rvMd+RlM8rj+JZZcSXkKjnwbl47m49u77sYsrFsbA5tVGjmIwhBxL4IBnvcGEDR0YbLXbD
	7O/FzQhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reyof-00000005eVx-3cx6;
	Tue, 27 Feb 2024 14:52:21 +0000
Date: Tue, 27 Feb 2024 06:52:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, guan@eryu.me,
	fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 1/8] generic/604: try to make race occur reliably
Message-ID: <Zd33JY8qn7urdMjB@infradead.org>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915233.896550.17140520436176386775.stgit@frogsfrogsfrogs>
 <20240227044021.GT616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227044021.GT616564@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 26, 2024 at 08:40:21PM -0800, Darrick J. Wong wrote:
> This test will occasionaly fail like so:
> 
>   --- /tmp/fstests/tests/generic/604.out	2024-02-03 12:08:52.349924277 -0800
>   +++ /var/tmp/fstests/generic/604.out.bad	2024-02-05 04:35:55.020000000 -0800
>   @@ -1,2 +1,5 @@
>    QA output created by 604
>   -Silence is golden
>   +mount: /opt: /dev/sda4 already mounted on /opt.
>   +       dmesg(1) may have more information after failed mount system call.
>   +mount -o usrquota,grpquota,prjquota, /dev/sda4 /opt failed
>   +(see /var/tmp/fstests/generic/604.full for details)
> 
> As far as I can tell, the cause of this seems to be _scratch_mount
> getting forked and exec'd before the backgrounded umount process has a
> chance to enter the kernel.  When this occurs, the mount() system call
> will return -EBUSY because this isn't an attempt to make a bind mount.
> Slow things down slightly by stalling the mount by 10ms.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v1.1: indent commit message, fix busted comment
> ---
>  tests/generic/604 |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/generic/604 b/tests/generic/604
> index cc6a4b214f..00da56dd70 100755
> --- a/tests/generic/604
> +++ b/tests/generic/604
> @@ -24,10 +24,12 @@ _scratch_mount
>  for i in $(seq 0 500); do
>  	$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/$i >/dev/null
>  done
> -# For overlayfs, avoid unmouting the base fs after _scratch_mount
> -# tries to mount the base fs
> +# For overlayfs, avoid unmouting the base fs after _scratch_mount tries to

s/unmouting/unmounting/ ?

