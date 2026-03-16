Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51238382377
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 09:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773651783; cv=none; b=hwuRajqEsj4ITI+1qYnXvTIWI6q5tZwfmbNXufWK3fW1qXLG2MUHgB0rHhG/DBqDL4SiU7xakcL538tke9Ae9kw6PXxF/Xa2oKAs6QOOHLVuUBR0v9cIGelzvkgR8KoQA49VEQ258NRz1jJrOaqgRJkHSg4pA5cdem+J+q6De9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773651783; c=relaxed/simple;
	bh=QXKeRCb0AJ55cV5jacRphYGzWjr8BmNRm34YvQaG7lA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kiPw9D8K8He5ZNzpKk4tZB+ctXOhE35jpXie6buaMBvL5n/5YNHck9RLcLqxpRR1jzIFjejyMmyeieLInPOeowdpLn0v5oeMHAIkLfyvRy/fOt4OcGQSUJcNhxbH3LoBuzk35sTHWO0mKg+WyeR2IfKUJ8tuQIrdado1SrD9IN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA11268BEB; Mon, 16 Mar 2026 10:02:58 +0100 (CET)
Date: Mon, 16 Mar 2026 10:02:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: Re: [PATCH 2/3] xfs: improve xfs_zoned_show_stats()
Message-ID: <20260316090257.GB1952@lst.de>
References: <20260314235508.183984-1-dlemoal@kernel.org> <20260314235508.183984-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314235508.183984-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Mar 15, 2026 at 08:55:07AM +0900, Damien Le Moal wrote:
> Improve the information displayed by /proc/self/mountstats by adding the
> total number of zones (RT groups) together with the number of free
> zones, and by also showing the number of open zones and the maximum
> number of open zones before listing the open zones.

Same comment on the "improve" in the subject, I won't repeat it for the
third patch, promised :)

I am a little bit worried about changing the format of existing lines,
even if this interface is pretty new.  Maybe just add new lines for
the total values instead?
