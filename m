Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CD8FBF6
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jul 2024 07:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720077739; cv=none; b=bgFngxC0RLdBnDS9zQezEAJCcvCF758Zf1zpsTa4jzDB9GrEs0EjYgGFlGQh2h9H3ZoHdJkoJckI/3LmyqhlfLdiA845E8q4NDHg6rtw2obzToWR1krSPEMDMNDIcNZzOyi6zmI1z+sDWpUkfE3d+oThPjD6J+nbtwJ6gLypl5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720077739; c=relaxed/simple;
	bh=ophFABTyBD9qXq+vQpVU1ReSufbfF6clJAJGH7SubNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=An50c52EqZ2ae8j5npmZ3p9dZN2t33ccNQtVo0q9tqXoDdqpn1fAskwjmgkiHaZwuXYreHrLfqneGuy1sTNjEKPCaRmvZjwieOPQNj/fehjU/fVfteg+qxq1TMrj1xD6lz0jjRD56cNxO1I4Qn07EJPmq9xsmUdMudZ8EBAPpbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6FBA168AA6; Thu,  4 Jul 2024 09:22:13 +0200 (CEST)
Date: Thu, 4 Jul 2024 09:22:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs_scrub: add a couple of omitted invisible
 code points
Message-ID: <20240704072213.GA25728@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117657.2007123.5376979485947307326.stgit@frogsfrogsfrogs> <20240702052225.GF22536@lst.de> <20240703015956.GS612460@frogsfrogsfrogs> <20240703042732.GA24160@lst.de> <20240703050219.GC612460@frogsfrogsfrogs> <20240703183510.GH612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240703183510.GH612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 03, 2024 at 11:35:10AM -0700, Darrick J. Wong wrote:
> I'm not sure how exactly to write a classifier here -- the 'invisible'
> and 'zero width' ones are obvious, but the 'joiner' code points don't
> seem to have any obvious trend to them.
> 
> For now I think I'll take the "conservative" approach and only flag
> things that sound like they're supposed to be general metacharacters,
> and leave out the modifier codepoints that are ok if they're surrounded
> by certain codepoints.  But this is a rather manual process.

Oh, right.  There is no clear identification and you are just doing
a manual search based on viѕual output.  Yes, there's unfortunately
no really good way to automate that.

