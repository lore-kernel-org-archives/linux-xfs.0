Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCB217997
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 01:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724375703; cv=none; b=sVVL56sG3pyj7aEWh3iLfLT3MrrCwjfNWY67vA0Lt3cneDhoJbIhGPES8z8xDVQtLon5MAEp4he4Zr9cVikVtf31MQOyvOaLajXvDaF6p9nQLTEsfejI6fKVvQX9eHKLtFoxLjPyuDSK8pG+Bq6WtihUSPFRdqS+pGtkWwV19Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724375703; c=relaxed/simple;
	bh=W+MRhBQzOJpyd5+/RCiG2+pqZi1zXbnx0+rfgrUk1VU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cBlT8E19LC8AmDw5yKIApxu/4XuL4GRts8O6Vcq56M/xxGXGaVp56+KbftC6gNCHN8dA/0+fsjzvGqA/s1RzpVsZ14HOdN9kYAucvBhP97D0phrXf7VhKzNYrIEixnFX8YmU6WHnUjlgF/3GzFnSWPsGkN0sodFJtKfjoZ69+Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBkx8rgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBkx8rgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D322C32782;
	Fri, 23 Aug 2024 01:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724375703;
	bh=W+MRhBQzOJpyd5+/RCiG2+pqZi1zXbnx0+rfgrUk1VU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NBkx8rgnbvhIdF7zvotcuPUzbBywvTtc9kdfKWq9uUz3BJJWZffLHOJaFE+yy1P8P
	 V81HFcufWFbdJhQkCl+Hf0bqkmWCja1wd4BLyGaa9q9IsaAqs2SiSRnUgH6Z2jiFxx
	 RM5hs/UEprv2JNV/uL8hkhgaWZwyYBUl5jaS2x0d2XwAWOemYUEokPmdfGTXbXfGBS
	 G04hEDXonriRvrGHSjX89Va1u4S2Y12Ry9LSBfATy9lSZlwUSr3MLSxV+MiY1FQx4O
	 kiMPlssDuLM88pdzi9sWEH43SpYlYhsvCSYXOmTE0jCA3xE7E4gCK6FE07c698+3KM
	 tFo3MsPy7XmIA==
Date: Thu, 22 Aug 2024 18:15:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [RFD] xfsprogs/mkfs: prototype XFS image mode format for
 scalable AG growth
Message-ID: <20240823011502.GV6082@frogsfrogsfrogs>
References: <20240812135652.250798-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812135652.250798-1-bfoster@redhat.com>

On Mon, Aug 12, 2024 at 09:56:52AM -0400, Brian Foster wrote:
> Tweak a few checks to facilitate experimentation with an agcount=1
> filesystem format with a larger agsize than the filesystem data
> size. The purpose of this is to POC a filesystem image mode format
> for XFS that better supports the typical cloud filesystem image
> deployment use case where a very small fs image is created and then
> immediately grown orders of magnitude in size once deployed to
> container environments. The large grow size delta produces
> filesystems with excessive AG counts, which leads to various other
> functional problems that eventually derive from this sort of
> pathological geometry.
> 
> To experiment with this patch, format a small fs with something like
> the following:
> 
>   mkfs.xfs -f -lsize=64m -dsize=512m,agcount=1,agsize=8g <imgfile>
> 
> Increase the underlying image file size, mount and grow. The
> filesystem will grow according to the format time AG size as if the
> AG was a typical runt AG on a traditional multi-AG fs.
> 
> This means that the filesystem remains with an AG count of 1 until
> fs size grows beyond AG size. Since the typical deployment workflow
> is an immediate very small -> very large, one-time grow, the image
> fs can set a reasonable enough default or configurable AG size
> (based on user input) that ensures deployed filesystems end up in a
> generally supportable geometry (i.e. with multiple AGs for
> superblock redundancy) before seeing production workloads.
> 
> Further optional changes are possible on the kernel side to help
> provide some simple guardrails against misuse of this mechanism. For
> example, the kernel could do anything from warn/fail or restrict
> runtime functionality for an insufficient grow. The image mode
> itself could set a backwards incompat feature bit that requires a
> mount option to enable full functionality (with the exception of
> growfs). More discussion is required to determine whether this
> provides a usable solution for the common cloud workflows that
> exhibit this problem and what the right interface and/or limitations
> are to ensure it is used correctly.
> 
> Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This is a followup to the idea Darrick brought up in the expansion
> discussion here [1]. I poked through the code a bit and found it
> somewhat amusing how little was in the way of experimenting with this,
> so threw this against an fstests run over the weekend. I see maybe
> around ~10 or so test failures, most of which look like simple failures
> related to either not expecting agcount == 1 fs' or my generally
> hacky/experimental changes. There are a couple or so that require a bit
> more investigation to properly characterize before I would consider this
> fully sane.
> 
> I'm posting this separately from the expansion discussion to hopefully
> avoid further conflating the two. My current sense is that if this turns
> out to be a fundamentally workable approach, mkfs would more look
> something like 'mkfs --image-size 40g ...' and the kernel side may grow
> some optional guardrail logic mentioned above and in the previous
> discussion here [2], but others might have different ideas.
> 
> Darrick, you originally raised this idea and then Eric brought up some
> legitimate technical concerns in the expansion design thread. I'm
> curious if either of you have any further thoughts/ideas on this.

Well, it /does/ seem to work as intended -- you can create a filesystem
with a 100G agsize even on a 8G filesystem.  We've been over the
drawbacks of this approach vs. Dave's (i.e. explodefs is really only a
one-time event) so I won't rehash that here.

But it does solve the much more constrained problem of disk images
deployed from a gold master image undergoing a massive onetime expansion
during firstboot.  The lack of secondary superblocks and xfs_repair
warnings are concerning, but to that, I have these things to say:

a. If it's a gold master image from a trusted distributor, they should
be installing verity information on all the read-mostly files so that
one can validate the vendor's signatures.  The fs metadata being corrupt
is moot if fsverity fails.

b. We can turn off the xfs_repair hostility to single-AG filesystems
so that people who /do/ want to fsck their goldmaster images don't get
annoying warnings.  We /could/ add a new compat flag to say it's ok to
single-AG, or we could hang that on the fsverity sb flag.

c. Over on our end, we know the minimum cloud boot volume size -- it's
47GB.  My canned OL9 image seems to come with a 36GB root filesystem.
My guess is that most of our users will say yes to the instance creator
asking them if they want more space (a princely 67GB minimum if you're
stingy like I am!) so I think one could tweak the image creator to spit
out a 36GB AG XFS, knowing that only the Ferengi users *won't* end up
with a double-AG rootfs.

IOWs, this more or less works for the usecase that generates the most
internal complaints about xfs sucking.  As I said earlier, I've not
heard about people wanting to 10000x growfs after firstboot; usually
they only grow incrementally as they decide that extra $$$$$ is worth
another 10GB.

I think this is worth prototyping a bit more.  Do you?

--D

> Brian
> 
> [1] https://lore.kernel.org/linux-xfs/20240721230100.4159699-1-david@fromorbit.com/
> [2] https://lore.kernel.org/linux-xfs/ZqzMay58f0SvdWxV@bfoster/
> 
>  mkfs/xfs_mkfs.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 6d2469c3c..50a874a03 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -325,8 +325,7 @@ static struct opt_params dopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = D_AGCOUNT,
> -		  .conflicts = { { &dopts, D_AGSIZE },
> -				 { &dopts, D_CONCURRENCY },
> +		  .conflicts = { { &dopts, D_CONCURRENCY },
>  				 { NULL, LAST_CONFLICT } },
>  		  .minval = 1,
>  		  .maxval = XFS_MAX_AGNUMBER,
> @@ -368,8 +367,7 @@ static struct opt_params dopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_AGSIZE,
> -		  .conflicts = { { &dopts, D_AGCOUNT },
> -				 { &dopts, D_CONCURRENCY },
> +		  .conflicts = { { &dopts, D_CONCURRENCY },
>  				 { NULL, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .minval = XFS_AG_MIN_BYTES,
> @@ -1233,7 +1231,7 @@ validate_ag_geometry(
>  		usage();
>  	}
>  
> -	if (agsize > dblocks) {
> +	if (agsize > dblocks && agcount != 1) {
>  		fprintf(stderr,
>  	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
>  			(long long)agsize, (long long)dblocks);
> @@ -2703,7 +2701,8 @@ validate_supported(
>  	 * Filesystems should not have fewer than two AGs, because we need to
>  	 * have redundant superblocks.
>  	 */
> -	if (mp->m_sb.sb_agcount < 2) {
> +	if (mp->m_sb.sb_agcount < 2 &&
> +	    mp->m_sb.sb_agblocks <= mp->m_sb.sb_dblocks) {
>  		fprintf(stderr,
>   _("Filesystem must have at least 2 superblocks for redundancy!\n"));
>  		usage();
> -- 
> 2.45.0
> 
