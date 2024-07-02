Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0ED2A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897879; cv=none; b=o87U6aeNqUNWEP/gp+iRjwqDTFPBqRRb1/amwF+01nXIJuk5XcG39QADGMQjKjbDVR3fbnwG9rdh3THmSQXWPrXKhN9ET3Abm95E96UPCG7Eg4bYKJ3hh6G4aLzbMYMPKK4ran5N9xU8qOXaRFUp9luB4YHJqcPnAv0szHxVTSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897879; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RC1pEUl+xGfRNNF64f25Wz1kgNJ7ji4s2kh2byCtY80pr/zt7XFJvA+Of93UaUnYNrbTHQjxPcREM4EpgACpdFrGuC+ePsIZvgHiDsWQhZ/rEYgNzSuuF9wz9nkieYNAvo09T6MTrYParkeU6SG9ISNcWl9C2liZdB2OUmeIvQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7631C68B05; Tue,  2 Jul 2024 07:24:35 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:24:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/13] xfs_scrub: reduce size of struct name_entry
Message-ID: <20240702052435.GM22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117763.2007123.5929393677337209049.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117763.2007123.5929393677337209049.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
