Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1925C6FBE
	for <linux-xfs@vger.kernel.org>; Sat,  1 Jun 2024 05:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717218027; cv=none; b=AtLKL01fCd/R4M8VLpbvPYBX220oLzWNpbbKwzZAEZDtL4fGbEUQZBohAQ8WR/qYep1aySNoe4dBAlYVQbWvsPXrE3DFocNUh5hkUQzn8GL3j+pPkzV7r9HL4YcaNW5LnKkvVbYKtWMZwC435oMJHchAq//kkTbTcHqX0iJ66X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717218027; c=relaxed/simple;
	bh=p4GcVWNEhMkZS+fvXPakm0lm2zCI+rkqeuJ+RQuC4Lc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wkm0DJNJdogbYjEu6olieXx7wBscurxWIFCp1FWz1V5zEprWvsc+YMr0yx7wECxHp1amcgrKkeYJgJEdzTFZTVTfR4sO0Ka3g0o3lUXLyX/mXqGSXuRKz5kMICtYQCRpXtFlcwpkAPq0CSgBpFj6fO9jAZ41pYkjraltBDi8WmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GA9BzngI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GA9BzngI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4iG8qyaJ096UkhRlQaKW7/00qJwmkgNGXViIN6hZ5Zg=; b=GA9BzngISQwcqtIIIYY8SStJLw
	HPl9d2NpNSeaYxPjGTKSo8MQ0AETC1I4Z0ta//V7Q7dbliT6fynBcsTz8nXeh0CHtvMRWLHyj3b7P
	ViYYzKfLqXS1Y5aOw0maobcmflZ9adFSsz13FBEkVMqqqU8rQ+Cjd/6DltffS4r7NBE3O7R7nd+EO
	+FuOaZhpojYqHlXQNDwVLowP67n7bQ40YhlxAxb2BOBWD+OVlFQXq6IbhmNS1c8AzQ2LIQS6pridW
	VdwZmC7Gd0j9dg+qrZpuq0lnjnbV96407hz2BzQuhZ02TAm4Gjqha8Vlwo+ASLybMPH/NYs2UaPla
	9x/KTw3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sDGqv-0000000Bz4y-1Izg;
	Sat, 01 Jun 2024 05:00:25 +0000
Date: Fri, 31 May 2024 22:00:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: detect null buf passed to duration
Message-ID: <Zlqq6Xmy_cw6uYFP@infradead.org>
References: <20240531201039.GR52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531201039.GR52987@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 31, 2024 at 01:10:39PM -0700, Darrick J. Wong wrote:
> I think this is a false negative since all callers are careful not to
> pass in a null pointer.

Yes.

> Unfortunately the compiler cannot detect that
> since this isn't a static function and complains.  Fix this by adding an
> explicit null check.

Can you try adding a __attribute__((nonnull(2))) to the declaration like
this?

diff --git a/repair/progress.h b/repair/progress.h
index 0b06b2c4f..c09aa6941 100644
--- a/repair/progress.h
+++ b/repair/progress.h
@@ -38,7 +38,7 @@ extern void summary_report(void);
 extern int  set_progress_msg(int report, uint64_t total);
 extern uint64_t print_final_rpt(void);
 extern char *timestamp(struct xfs_mount *mp, int end, int phase, char *buf);
-extern char *duration(time_t val, char *buf);
+char *duration(time_t val, char *buf) __attribute__((nonnull(2)));
 extern int do_parallel;
 
 #define	PROG_RPT_INC(a,b) if (ag_stride && prog_rpt_done) (a) += (b)
