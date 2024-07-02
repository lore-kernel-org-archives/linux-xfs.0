Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2140D2B9D8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898822; cv=none; b=sd1jpcm06nkfnGgwUB65hSd+E781LWWuhTeNGP91SBR7L6q8DmJMKfGi8TfqwpBVwRf+4PUqY5n34B7VLyDDS9LFYrc2vKmnHBR57gQu7/6xqrp9juM/A/iM66ErE2YXjc45MiWxYA3ell1MBjdjsToRifpP+l0gvnzlzlsuT+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898822; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oaIR5zUi+LcBaFdLJQqbEJJenee4BB90OtNHLgM2iFFyeI5MZpFRnCw3a8ITtP2vI6WfQ1+bXKUuIPyl5YVJxMOvUdOZuAwDzYXPMACg76W5A329icaV9FB4pX1llMzjom+yHJmI7kvuT3HAk8pyvwqob4Uy/hIwaruKlQgEvJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7D52868B05; Tue,  2 Jul 2024 07:40:18 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:40:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/5] xfs_scrub_all: encapsulate all the subprocess code
 in an object
Message-ID: <20240702054018.GA23338@lst.de>
References: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs> <171988119829.2008718.8789883453476961638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119829.2008718.8789883453476961638.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

