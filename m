Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34197C8E0
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712727915; cv=none; b=OML5XG3cb7HLYn6eZf/0Uaw0AVFpQ270KcVuXAk1JMPyxUqXzgBDt3ThMo5e/wWeCBivn4Lzk6T4An6Kz1ZQEemMwyDdNjEtIKmn/AgW+TCQtB+AbWoNf8hNrl4V0DQE67SqGXZYsSvQya61ZR+f0V/urklwCwEgbESBGQCTghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712727915; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGeJGnIjvVGuaIG+XhXcKFv73pb4l+qiOlNp7JRG9JbVCayM/gw80I4qjzYDfFKPbvc2csIBpU7z7kUpxeZIJ+sHlodOExT+Jq/vBp1eTCqCKzYNlRzNHP6oZAH15WCGTfrzrXIDJ0m8S+Pazp7b58s1qrezpG82Em44o0mig+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h78OsHmW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h78OsHmW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=h78OsHmWqNAvWf1X1wLglDV3++
	P/YtskBNDQkUfHo4+1I7EQqN8XPVuDFHCS2rKNsAE1aNMGfqB0jmBSXUZnQLVEexIB/uz8gFavWY1
	IbKBvFsNuGzS6yMKiNwwVY08XVg+ayadT9w1RCd5ctEJi1N8XH+9S2Rv1QlLE/yRglfzctOC6VXjZ
	aosBNjNxoU12Hi8rP+98DHbAgpv6PoyMVsn1mE5wC7ywZykDriprbL8CI6l+Yz0jjOWr9p2YU6AQ6
	YC/FQ0QcWUXcEnKsdg85Ki+oyqTgh25fmuH+h5GEOMbxfNQRphalp5tSpLhNQslsSGCFt4LK1+wMP
	Q9CNnwDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQlk-00000005F7J-2il0;
	Wed, 10 Apr 2024 05:45:12 +0000
Date: Tue, 9 Apr 2024 22:45:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/32] xfs: add parent attributes to link
Message-ID: <ZhYnaJT3SHckQZoB@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969857.3631889.10116561090490715564.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969857.3631889.10116561090490715564.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
