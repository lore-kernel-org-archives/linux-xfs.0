Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203865;
	b=3lGIjQdUoUxySrD9ETKyhjasU2MHSUK2Y4JlNfPN6xflQ7A5N7fIfYZayqDGtBQX2NyH
	 w8X6JriB9sHD8zdyewHneGmLJtr8Ln02L391WzuhYpb3RlwUoHCg0F1BKgltfMHuEZz05
	 tmKwf+r2YMCHbVDFAjcrVl7bpmErXtxcaHW2Cr2b9FTJh4SuKiRIEIC2AvxC5C8Y/+h55
	 t6VoDuOugyOvwsQPpSLniOkIr6ifnBUeBrNxauqTaJ7+33fkVIORx9TJFCS6UcsVJMZzT
	 UmsInYyyuhw4VddkUla4AeKyO/yLUj7YRF7us5I3V5iKEmXoAvLWxCbdokbPqg7ckzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203865;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=VCWpTLAPPXJfxR7B3MJWFPG56Z5xLpadAYbL7gIAQz8=;
	b=DxuJ8Cfv3RuY/RV8KWBPi84swvI3kb5IN0oWLQS4zos3UyIeGoQMLqsB3eHzuZmH9KBT
	 wK6M+fL3lpJ0K0sdLclvxOzaDmKkeQQuK3U/ENS07f+SaxKpj6z+Y4j69YWs2A5W+WzgV
	 J4mnG6lbX0Es1hIrCLORKfW+yDm4u/FENyyOgq/UHfWZYv9xnVgus6ryu9JNFK6v6p2VG
	 zdH+bgZlxYnKQwHVC95oJG7eRBR8sr7odR18z7e4SJ+7Nli3ylvH3hE+N4EGuX9HR7TnL
	 eUyswdWCzhPF8AYN3+nCCvhyhQvXB7LDMuloJK4qwvS1WhglC/w9KZM1mZH2mD7h+LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA861606A31D;
	Wed, 28 Oct 2026 16:11:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA861606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5476268AFE; Wed, 28 Oct 2026 17:11:00 +0100 (CET)
Date: Wed, 28 Oct 2026 17:10:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 6/9] xfs: clamp the pNFS layout range to the maximum
 file size
Message-ID: <20261028161059.GA20998@lst.de>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com> <20261020-xfs-pnfs-batch-v4-6-9230fa2ca4a4@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020-xfs-pnfs-batch-v4-6-9230fa2ca4a4@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 20, 2026 at 12:08:49PM +0900, Daejun Park via B4 Relay wrote:
> -	if (offset > limit)
> +	if (offset < 0 || offset >= limit)
>  		goto out_unlock;
> -	if (offset > limit - length)
> +	if (length > limit - offset)
>  		length = limit - offset;

This could use min(), but either way the change looks gind:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(a slightly shorted and to the point commit log wouldn't hurt either..)
