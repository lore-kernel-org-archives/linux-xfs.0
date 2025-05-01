Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AC62EAE5;
	Thu,  1 May 2025 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106745; cv=none; b=Nly2KPAHvtUZBIl7KX8IEixbYrbG9PLSTOG4HJTpGAPNpgjt85OCGaa/q78+ukKjmzVbJSsOFWNYpaEMotHGmkCIQ9+/i4jVttxR+GiHyrmF6+uE11OZGsS+DhYlRkvDfLwn1VBnSHaPBBnziLddc3Q/7q+eEhMZQ6K8SzvySxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106745; c=relaxed/simple;
	bh=cszJgs9+WvNmrHRkOphnp4649kRRdQojL5QWzNSWSEI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tgpqVc1vNonMFFH1CioGJ8lpmtDxIBxpTEyywcxYgCKniTRDTrqQWYp+VjyzwYM3thigubT29XPl1+2BqBIDUR7xM6W0bM5pDgo8K09Xq39cSCDXBHhERdqMeCcA+PIx+waMA+UOyYMQwxs0c+G41+IN2SGj5Ij1aUibgxqOuSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xoQvF7qG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xoQvF7qG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ZSot+KHL7tR2PlbeerHOP6MU58bs41gMwZTH9VvpWB8=; b=xoQvF7qGL7GqtX1Hnn3M6dfDyZ
	ok5x9wG6B5spa34BKqlF9CNoCHaKF+ATMtwljZLSYLLCXT83uuCp2kr4Esougly5EOYBvqDVD6Co4
	298jKZMKGgk4CaS661qrhgjLSrSY7pLuLqj/f0Wvh0xK53pahpi3rRgkjG3fhswV7rbr11zva9qi9
	B8ptKjH1/qiBu1qr/Tj1MIj+4Ijr9vXYlG19Ig+8ThY9+PLhWMdGENKAgc2uhMLRmjzzgv55P/mH6
	nM1gu9s7r9mFMxnnr8uH+FDc/JzU0VEXtOBpNqI9c6bvZeFBc3rcdLvNVpy7ceNGhlzcxPT2plvIs
	BHMcM+KQ==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAU7x-0000000Fqeg-3szr;
	Thu, 01 May 2025 13:39:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: finishe xfstests support for zoned XFS
Date: Thu,  1 May 2025 08:38:54 -0500
Message-ID: <20250501133900.2880958-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series adds the remaining core bits to support zoned XFS file
systems, to go along with the kernel code in 6.15-rc and the xfsprogs
series on the list.  It does not include several newly developed
test cases which will be sent separately.
