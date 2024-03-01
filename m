Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF72D38DC3;
	Fri,  1 Mar 2024 15:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709306949; cv=none; b=bwDgC+kBAhc/yOb6NN0octf9zp00fO6V7o8OHHTnGQ80q9Mo6hfT5j/fY7ecDDjO+oKrHJkTta1EZjQopT/i1XpKl7JLg7v/8kun8wLDqlN0OHxHUt7p2nVn9LMEk+dEg5xKgrk0kwc/HUbNvoXWj3vrTAWxri/5tNfnblWzoSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709306949; c=relaxed/simple;
	bh=LYlptxBO4Vd+P5/3+/J09lsZDdds7WZzOHBzrUmbm5o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XRRWaEopkFVzM4lXdeFi9jRWuXppa7vgc3B9UfH4hhZaHVxb0j0dfVutYsN1kw67FAcbTtNjEWvp5gDuGUulc8EbuLQXtAosKJaU7oJykJM1QeNfaTxV0V29zwZsh+IHax8Y4P263dj3nhuBri5wS8MfI6MZ8Wg/YSyiF0q8FSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NsMBI7dP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NsMBI7dP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=RQNzufGH4y+iWEiOdnipdlGIHxmIIS+h1rKtZYecMTM=; b=NsMBI7dPdk4u+hNbvIpTWCvPVI
	6quqTpaB44KBYhtUuUEAoI/JQAxIOgC8AjrQa9ghildfnjpACitBdDjkPvAgHfpaas/FxG1wXeMc3
	Ba7kD71VUlh0hS9Fh3ls3o9IOIlS3SC+YGDTM0OzJX8gqw+uOqYzDntYdJyUBkLFNAt2qlB8F5yGj
	E8UCxXjAphRD+MW6I1t5Gp9gr2MHFmRyfEuhQsh+RhTJ9QteoZc5EvB9Ku/504vMV7yqlqZ8CpeXP
	/ON2GN6KNWiixwAOSf5LdnamWK/heC1amErNVJlUB8EpUTKvVnkamTyS1QkpJB+dmgkKdKnFDpOEv
	IvV4c0aA==;
Received: from [206.0.71.40] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rg4oP-00000000tDe-2CF2;
	Fri, 01 Mar 2024 15:29:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] shared/298: run xfs_db against the loop device instead of the image file
Date: Fri,  1 Mar 2024 08:28:20 -0700
Message-Id: <20240301152820.1149483-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_db fails to properly detect the device sector size and thus segfaults
when run again an image file with 4k sector size.  While that's something
we should fix in xfs_db it will require a fair amount of refactoring of
the libxfs init code.  For now just change shared/298 to run xfs_db
against the loop device created on the image file that is used for I/O,
which feels like the right thing to do anyway to avoid cache coherency
issues.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/shared/298 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shared/298 b/tests/shared/298
index 071c03dee..f657578c7 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -69,7 +69,7 @@ get_free_sectors()
 	agsize=`$XFS_INFO_PROG $loop_mnt | $SED_PROG -n 's/.*agsize=\(.*\) blks.*/\1/p'`
 	# Convert free space (agno, block, length) to (start sector, end sector)
 	_umount $loop_mnt
-	$XFS_DB_PROG -r -c "freesp -d" $img_file | $SED_PROG '/^.*from/,$d'| \
+	$XFS_DB_PROG -r -c "freesp -d" $loop_dev | $SED_PROG '/^.*from/,$d'| \
 		 $AWK_PROG -v spb=$sectors_per_block -v agsize=$agsize \
 		'{ print spb * ($1 * agsize + $2), spb * ($1 * agsize + $2 + $3) - 1 }'
 	;;
-- 
2.39.2

