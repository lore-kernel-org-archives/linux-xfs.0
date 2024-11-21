Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A361CBA1B;
	Thu, 21 Nov 2024 10:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732184011; cv=none; b=MIsqmV71joelqgBwENcafOPHfPejS3dMoWsmmUStKtenR6ao1XgZd7c1fecnWMPhY625kfJQvpTinnDoHyYuYxpgFcWSliT+3z/OepQQJirvF9iRcC4k/X3UTSoPnSNcr/kS+FVZGYin5KW0uXAIfllitWDjKWjbVwmrXxlkK08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732184011; c=relaxed/simple;
	bh=7He/zr0ctEHos8KcaJPxBuzWIX6xq3Eg5RcF9BSQRos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZazNgrFCfbj/ZUTPqoz7zN8nbF1GwqFs+idwUP86OWDVGRjZAld5Mk3rFZFmXTP3DXWyAtU2ehzItAybPQKOxOQVZLdU0jS3KbaaxWj1X7gESyiFpSsTwKfBLdTLQBmPXcZlr0KUJaV/DzOi+hmeVsEoNJPww7/6ojTO5Imqh0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DAA8A68C4E; Thu, 21 Nov 2024 11:13:25 +0100 (CET)
Date: Thu, 21 Nov 2024 11:13:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, hch@lst.de,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241121101325.GA5608@lst.de>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs> <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs> <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20241121100555.GA4176@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121100555.GA4176@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 21, 2024 at 11:05:55AM +0100, Christoph Hellwig wrote:
> But the whole discard thing leaves me really confused, and the commit
> log in the patch references by the above link doesn't clear that up
> either.
> 
> Why does dmlogwrites require discard for XFS (and apprently XFS only)?
> Note that discard is not required and often does not zero data.  So
> if we need data to be zeroed we need to do that explicitly, and
> preferably in a way that is obvious.

Ok, I found the problem.  src/log-writes/log-writes.c does try to
discard to zero, which is broken.  This patch switches it to the
proper zeroout ioctl, which fixes my generic/757 issues, and should
also allow to revert commits to use dm-thin referenced in your link.

diff --git a/src/log-writes/log-writes.c b/src/log-writes/log-writes.c
index aa53473974d9..cb3ac962574c 100644
--- a/src/log-writes/log-writes.c
+++ b/src/log-writes/log-writes.c
@@ -31,7 +31,7 @@ static int discard_range(struct log *log, u64 start, u64 len)
 {
 	u64 range[2] = { start, len };
 
-	if (ioctl(log->replayfd, BLKDISCARD, &range) < 0) {
+	if (ioctl(log->replayfd, BLKZEROOUT, &range) < 0) {
 		if (log_writes_verbose)
 			printf("replay device doesn't support discard, "
 			       "switching to writing zeros\n");
