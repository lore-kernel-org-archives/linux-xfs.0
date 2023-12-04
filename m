Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB37BB
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 21:24:06 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id A3D76227A8E; Mon,  4 Dec 2023 06:24:03 +0100 (CET)
Date: Mon, 4 Dec 2023 06:24:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: collapse the ->create_done functions
Message-ID: <20231204052403.GD26448@lst.de>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs> <170162990294.3037772.8654512217801085122.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162990294.3037772.8654512217801085122.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +static struct xfs_log_item *
> +xfs_attr_create_done(
> +	struct xfs_trans		*tp,
> +	struct xfs_log_item		*intent,
> +	unsigned int			count)
>  {
> -	struct xfs_attrd_log_item		*attrdp;
> +	struct xfs_attri_log_item	*attrip;
> +	struct xfs_attrd_log_item	*attrdp;
>  
> -	ASSERT(tp != NULL);
> +	if (!intent)
> +		return NULL;
> +
> +	attrip = ATTRI_ITEM(intent);

How can we end up with a NULL intent here? The intent passed in is
always ->dfp_intent and I don't think that can be NULL.  No other
implementation of ->create_done checks for it either.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
