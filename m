Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9BC2F2E;
	Thu, 13 Nov 2025 06:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763016948; cv=none; b=P9fkU2RFtug9jJahWUU8eJa+QC1wEuuXPBKwVnTNfW1rZlO/4Fjjgy+45myqtUHSofvx/9a5KE6KhvqgYGbdl1hgqWLdTgywQLkcSKi4W+xBchll4Ghb+atW5qiOT+HTP4Ol8r6tbBQi2JP7JQ3Ot46Cpoh8Xs9Gs1/nvO7iN8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763016948; c=relaxed/simple;
	bh=NdrChLn5Ca63Qt8rRXJjVn3C6tdxVnLlwSl0CfW6iMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QoBnvcttYvO7YpHz/ZojXfJGZKsyhhBzwcL0tlRiS/lllaY1C41rkNRWMGUewXImejKx1CThi2B4Td+vk9RjMJs3NCJ4c5BgLWisDh3MF20UETbxqMsGb0FHftIitn54TfAnTvTlA/HBtR3ce2J9Q6rlXdMEG2iYVigGh4/4vNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aVHJitlj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aVHJitlj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=El7SI5PteVGd8tbOlaue5rfugn9SVEem2nHz9oU0BvI=; b=aVHJitljtBgk4hh3Pkc2l0tkJM
	knBECJWSzmXxCpWyqOauwO3EyvW2DbZIG5wrGwZhfHI5+8bRy10/mCE13DHjENoLsfExmzkBJnsmT
	qA/f8qVFwM+Oe0dPXpdDVMn3rDHykjBlmpV3IX2jmCToxXyZvpwkmGbqfqcyz+KcTsuBLd29ngrgL
	xh/Xg7Wf8Ypwuh49cwF4fhhVCkiZUiGvFocJNXAjDkPNBCDGDUZqRMY+FVjH//yB4LsvCr+MOzIPX
	LQP/p6n24M42gSmQr4qCYkSG3IqAF6myu0f7PdovoF1eHMTcfG2kXXrDhNGogpIPydktGMUkxmN04
	qgU73Ysg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJRF8-00000009ySp-1VBd;
	Thu, 13 Nov 2025 06:55:42 +0000
Date: Wed, 12 Nov 2025 22:55:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>, cem@kernel.org,
	chandanbabu@kernel.org, bfoster@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: reject log records with v2 size but v1 header
 version to avoid OOB
Message-ID: <aRWA7v5Yng5i4X1U@infradead.org>
References: <aRSng1I6l1f7l7EB@infradead.org>
 <20251112181817.2027616-2-rpthibeault@gmail.com>
 <20251112184504.GA196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112184504.GA196370@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 12, 2025 at 10:45:04AM -0800, Darrick J. Wong wrote:
> > @@ -3064,8 +3064,12 @@ xlog_do_recovery_pass(
> >  		 * still allocate the buffer based on the incorrect on-disk
> >  		 * size.
> >  		 */
> > -		if (h_size > XLOG_HEADER_CYCLE_SIZE &&
> > -		    (rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
> 
> Just out of curiosity, why is this a bit flag test?  Did XFS ever emit a
> log record with both XLOG_VERSION_2 *and* XLOG_VERSION_1 set?  The code
> that writes new log records only sets h_version to 1 or 2, not 3.

Yeah.  This particular instance got added by me, but it is a copy and
paste from xlog_logrec_hblks, which again consolidate multiple chunks
of this style of code, which were moved around a few times.

I think originally this came from Nathan fixing this:

-               if ((h_version && XLOG_VERSION_2) &&
+
+               if ((h_version & XLOG_VERSION_2) &&

or in other words, this was a mess all the way back.

