Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6F56A8A9
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 15:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708444489; cv=none; b=syCQ0IXXy94Tat89xBtRZnWN6eE8Bs5aRXGTgnvk5CmV89ot02B6XJ82560xaaq3/DVketXAShvy7FIl9HN9MOxsatgzvkKUewarnTkqj3sB2AcMp1IBaLYwuPmPqU6SJfsd6eex8cfo+xxrd3liLvznBlWo2ofgCrwy1pCTkic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708444489; c=relaxed/simple;
	bh=nO7gSNnEUgQn4GDRoMJGEtd2rjSMUFYG2l8NSMQzOHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMnoW3t+fiHUX5B2VqKogGnNg+eTufQpoXIE2Aqd2s9/yfzjkhWsE5uU7LVso+YFDkXx+LC1Be7sHzYsDgXU/ANVudrTWv6iH6jXhg1MgOibsioBDdM/AtS0jg9nJbk5d8Mg1hVyBRywUVbc7SqY2dJ/4IKdIBUTA9gYC2zk98k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 947C568D07; Tue, 20 Feb 2024 16:54:44 +0100 (CET)
Date: Tue, 20 Feb 2024 16:54:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: put the xfs xfile abstraction on a diet v4
Message-ID: <20240220155444.GC17393@lst.de>
References: <20240219062730.3031391-1-hch@lst.de> <87ttm3hix0.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttm3hix0.fsf@debian-BULLSEYE-live-builder-AMD64>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 20, 2024 at 09:42:23AM +0530, Chandan Babu R wrote:
> Can XFS developers please review the following patches,
> 
> xfs: use shmem_kernel_file_setup in xfile_create
> xfs: remove xfile_{get,put}_page

I reviewed these, but if you are resending patches you aren't
supposed to add your own reviewed-by in addition to the signoff
if you're looking for that.

