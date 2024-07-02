Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40FB60BBE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901594; cv=none; b=JuWYiSXog+hrj2Z6/qL/OA0mblHsXjDekjNEVMOnmPHgzErXM6xLs6QppdIbfUravuKfvlZKX95MrqV+lmGzUUv+QZTuG5odu+zTVn8kNSBsfVZk9xKx0a5j41iPo4VFXr9jRP2dUMi5EokBbxrvZsr1EU8Db82KmH9J1JfYMCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901594; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CrIEEyf6FvJTBkZ2vi7I0As6NKaIWxdzGBXaA+vL5LHhJK/MRiPNCPLeKXgX4ztbKve0IHROOK/hHTot1G8CkjUuFz9y4XSJkZNR2yMaCgnB5zAy6Wo3f6YzDwJo/N5cNNjliN7KL4cUZbqBDetfTdETC1x7+03FZW6sBtMORck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2740268B05; Tue,  2 Jul 2024 08:26:30 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:26:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/24] xfs_io: adapt parent command to new parent
 pointer ioctls
Message-ID: <20240702062629.GG24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121170.2009260.13120086561599609138.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121170.2009260.13120086561599609138.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
