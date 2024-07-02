Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE03660BBE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902574; cv=none; b=jWHvXSBjMvUmFFS9z5/UYUnOfWVjwLqOJu34BO2+Mura0Tk9bfzoP2qdwZ0MoSkfKoISVCi0G0bT01graLefCqmXVM8wOcn2be32VMr60H9ZbqD1V7Ux/FqgROHPhgxB/mi9jTeuoJRyaQGoXfpv+eDZ+HLrHRSYRY1kbRjZMeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902574; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nVJmi531DPp5KT8c/bg7u5DNwSmu0gv8Aqp2eoxBO0ueWMpM8lN3VggyETTeb4a8z3Mal2KuTyRDz3/czAYVb00Sz8gYePlMUE6zRYCogL9Yi6766J0h66Tbt8nXlRXi3DCX7xhdSyxwlIp93M16JQRh2KqG/e5Vw9JzAvYlDSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E6BE068B05; Tue,  2 Jul 2024 08:42:49 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:42:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 04/12] xfs_repair: add parent pointers when messing
 with /lost+found
Message-ID: <20240702064249.GD25104@lst.de>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs> <171988122227.2010218.6936061653638637272.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122227.2010218.6936061653638637272.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
