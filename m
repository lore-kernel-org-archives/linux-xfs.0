Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162FE1A28B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719899099; cv=none; b=YOKcakYIltkO2fkQoGvyjyPlFRiXR7PxsEGQ/0kVt8KQiQlfszTikYfJCszvWydEx1qYK8uuOPxKfnKfZg5M6FZ0wg0ggMFHwLdu7Hhhs8OHpVZ+L9Jjs12eKnYDt2YinzgljehhGuU4NdlC5mFdMlruLf4nT9Be8X0nOQVkSss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719899099; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5cXm9rmQJpS9vS17XadU68ZsvaH4G+ToUlYLOn78Ss+6KtG1VLuGHx/JJFtJ+XLPbHXYXzxPAZMP508Nqa58NhyvpzpOl5uwsFm57RmUy+mDSWLkNbRfwzyGqtEf8OFi+FEEH1tWqYSMM5v2bgV/rgRx9Gp00EXWHs3zfZFUL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70E9E68B05; Tue,  2 Jul 2024 07:44:55 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:44:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/3] xfs_repair: enforce one namespace bit per extended
 attribute
Message-ID: <20240702054455.GB23465@lst.de>
References: <171988120597.2009101.16960117804604964893.stgit@frogsfrogsfrogs> <171988120632.2009101.8080215211983761365.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988120632.2009101.8080215211983761365.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
