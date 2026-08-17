Received: from mta1.migadu.com (out-151.mta1.migadu.com [95.215.58.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF1A3F7A9B
	for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2026 13:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973594; cv=none; b=dmM4lu3nv98LUe31a5zit2SibGmx6Epx8QsdFypIuq4Ds4SSmoYGBt06X+bZhWvAq5ElYYYBdAZAVotkdmtI4OekiKeKXBXbIve7MM+PhQUfhpepjeUgJSPlA/feIkQ9tNuegU2fo8Bc1TJYwCbw1BsDenuHJncyjEY7CIR/t/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973594; c=relaxed/simple;
	bh=qDGaSGd8u93TvDMngq9Ccz8H6NOTNAvsQwpmKdm0k/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QueVrGr7MZKiN+zMVYzJf5RVJ+47nRv96CY0I6+b/dvwg3NTKTzLX+t7rJZ+1JQKLh+guiMBj2WcUpYGoSspgDFgveYpncn7WAsOLGmJEX67H46+brUnj4EEC2j5N6Ols2xw+qwODiooS1MAy6L6KSKpUxt5penbLjMlc/GJIkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GeGFjpj5; arc=none smtp.client-ip=95.215.58.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GeGFjpj5"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qDGaSGd8u93TvDMngq9Ccz8H6NOTNAvsQwpmKdm0k/A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786973590; v=1; x=1787578390;
 b=GeGFjpj5MDSsuTWe7+LerZ64ouJxtM7Yks9OqjS79136RFU6OUFoTPPNZzXzZ0UGA3vUP3eT
 8ToysIyKmBTYvxFNNhFHZZTA2CFlZjbeDq0d7cYaqqPlfSHxE3Fg4ukr1m86AKGUuP1o7YqLO/D
 Q2TI0PNV3MPSEVmY5fUxK4n8=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: from localhost (195.100.225.50)
	by smtp.migadu.com with ESMTPS id b5cc297c925db0cd;
	Mon, 17 Aug 2026 13:33:10 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 15:33:06 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <dchinner@redhat.com>, Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 09/11] xfs: Implement RWF_NOSERIAL to parallelize
 RWF_WRITETHROUGH writes
Message-ID: <aoMMIfyEuuaDFpMh@quentin>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <945bb8c88a121580cb07d0311c6742a2584ea6b2.1785908600.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <945bb8c88a121580cb07d0311c6742a2584ea6b2.1785908600.git.ojaswin@linux.ibm.com>

>  	}
>  
> +	/*
> +	 * Writethrough implies non-serial writes ie writes can go
> +	 * parallelly.
> +	 */
> +	if (flags & RWF_WRITETHROUGH)
> +		kiocb_flags |= IOCB_NOSERIAL;
> +

From a user perspective, shouldn't this be an explicit user flag instead
of implicitly enabling for all RWF_WRITETHROUGH?

Power users who would want performance over POSIX compliance can enable
this but it should not be the other way around IMO.

--
Pankaj
