Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E9934DCF3;
	Thu, 26 Mar 2026 06:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774505501; cv=none; b=MTyVXXPNaBCD0NsPdeL35E9Gc2j8zt//qIeftFBVlSnlZ5PTqcfYDegGBXY4qZuSTR92vPNylA9sZa17UFvsmP3xfgRlehm/dd6VcNumeUPGuaNnoOTbgWGbiDRebkbNlXi8wbYtNhkBK93lnCwlQ71OVKE6fNMZD/Zy/wzPano=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774505501; c=relaxed/simple;
	bh=q2Eg13gei556HLMQfAER96ysVcRNCnIfh25nzV3JjyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H47Dp2Pz8j1ugRT9d9ADVUnSsIa72UmrFjJnqSt+og9vGPgdxsGksIqZh6ByCuI0sLY1I7BpuQwDpFHjeRTSabrE8DbQgH7aAzRMW1xVtzZxDJGZq6jewTk5ZApdq3MNUQWCqc7E3d6CSt3H4ytp8BZBNVpsh4baJ54BAfM1uAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BD20868B05; Thu, 26 Mar 2026 07:11:37 +0100 (CET)
Date: Thu, 26 Mar 2026 07:11:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test that zone_gc_low_space writes start gc for
 rw fses
Message-ID: <20260326061137.GC23733@lst.de>
References: <20260325125013.26631-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325125013.26631-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 25, 2026 at 01:50:13PM +0100, Hans Holmberg wrote:
> Test that writes to the systfs attribute zone_gc_low_space triggers

s/systfs/sysfs/

> +get_scratch_mountstat() {
> +	awk -v mount="$SCRATCH_MNT" -v stat="$1" \
> +		'$0~"mounted on "mount" with fstype xfs"{f=1} f&&index($0,stat){print $NF;exit}' \
> +		/proc/self/mountstats
> +}
> +
> +get_user_available_rt_blocks() {
> +	get_scratch_mountstat "user available RT blocks:"
> +}
> +
> +gc_required() {
> +	get_scratch_mountstat "RT GC required:"
> +}

Should these go to common/xfs ?

> +
> +# figure out if the rt section is internal or not
> +if [ -z "$SCRATCH_RTDEV" ]; then
> +	zdev=$SCRATCH_DEV
> +else
> +	zdev=$SCRATCH_RTDEV
> +fi

Same for this asa new helper?

> +[ "$rt_available_post" -gt "$rt_available_pre" ] && _fail "gc should not run while read only"

Split up either using \ or a real if statement to avoid the overly long
line.

> +[ "$rt_available_pre" -ge "$rt_available_post" ] && _fail "gc did not free up space"

Same here.

Otherwise this looks good.

