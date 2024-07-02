Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289DF2AD17
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901734; cv=none; b=g15SlL/9GQEF9BJy0xl6hT7J8aIZz+y5OFlVgCtPhPzCCDGcwB0Di97hmwzqODcFwK+eNagdFNpY+1+9DTpbc1k29G9W1Nm/q/4G8mx5nDue+XUxFlIumIz6dVdqgFUx8hjCssnhHV6v6M7wLlToaq4AufvoN8ZkVWzLfbFIX9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901734; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R6mi9k2qquTBBUT1ZnWEYK/+viq2PbOHo/1AMAruNhmRzBfHvrFhuWEtRZzdY/4ZKMa/t+D/JT0ZbygMo8Ghvh8JZjKZQ84LaEhZo/gifMQ21Ii7EoJ/gf9RY/Jjcl9qf+KC7VQqE+fScfotOepCKuFvft9LQP9LTg2p/LDOpvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3F01B68B05; Tue,  2 Jul 2024 08:28:50 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:28:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 15/24] xfs_db: report parent pointers embedded in xattrs
Message-ID: <20240702062850.GO24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121294.2009260.6773463880437891539.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121294.2009260.6773463880437891539.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
