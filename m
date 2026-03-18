Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C22364024;
	Wed, 18 Mar 2026 06:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773813669; cv=none; b=EMsRfwn11xj81zy9UG4l/qcO/8M11DkXX4/7dgmtHhDoTtd6kuxZvQAvVbtxB60o9QFM74JvCSZrbPgtKTYEBjsCq1CpE0kzf8kY6KycPAwHLtJV3Yvrlu+8bKISLLAQ1r78J0QNYXkuJkb+xAOqbyort7pLI/Klt4I3qYX3aEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773813669; c=relaxed/simple;
	bh=eoeXMShuwIc7VXnwzGr31dFw+vdhSKf6eWr85iPbANE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ct5dnmp+07p7Lvs5es3JQDrk6ZUCCbucRc24LbX+h4u9xI/G16iFSud4+7SZjYX5Cm/3TwvAXXsQXIKqb6BZCkuoC0XBttAMWYj3zK1Dn78jyeNJ6WmnKgQ+RfItsDu5tKMXkcn6Na47m8HckI4LBEP0K1yXK0wTJUbEQ/ETlzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pAZhx6IT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pAZhx6IT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DSQm5WEtMIg8wcrUtvewKlfdnXGbTE3FZ0iWcpqlitk=; b=pAZhx6ITrA+6T6PBi5jqoxS1ml
	4l1HUkgD6qoOFZFxf/VrKb7j2I8W8SzEpd2OEdtlN17lhqOFKDaQRBEJCinK562T68E8I17GwXC5I
	2VhA+zjvTRSjjhRQUNsA0qnroRVjJkKunkEwC2fFSyfZYLqoenWaZwddlFeNJ+UMKexv72w366bXZ
	F7OsodX8R1zHC2yaFywmJHNoUUOdqt8J2rMaZ31bGUUkmGZuJYhe5sW+RgndZOGuDcuTB78Nh4A81
	NJdBdHxNPhXTpJ+dB0zuVtUuDj7lBS+emm5BNZi0f1byH02AZKIt0xXPu5rb6oIpjt8U3OttacRfZ
	8Y+Ro1kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2jxr-00000007p1o-0aco;
	Wed, 18 Mar 2026 06:01:07 +0000
Date: Tue, 17 Mar 2026 23:01:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] common: ignore stderr for the two new svcname helpers
Message-ID: <abo_o-YemfJiCQ_h@infradead.org>
References: <177370372656.2108664.15986990094116651469.stgit@frogsfrogsfrogs>
 <177370372686.2108664.121048853724965231.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177370372686.2108664.121048853724965231.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 16, 2026 at 04:29:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If either utility doesn't support the --svcname switch, ignore the
> error output and just return an empty string.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

