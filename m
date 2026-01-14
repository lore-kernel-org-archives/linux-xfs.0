Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB8B37F735
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768384610; cv=none; b=jh64tCiW9yxE/9J/8FsdeXvNAUKQzsIvgeagWV7zrsbGO9O/oG7c8FUbqclOjlOGxWJJ4yJiUgEf3FK4gamOlQxAQQT3FThUX+2s2RllwC9R+ZrHLKmZYIz621irwua+vsjFHGPDZ429VdvSdabUxGzhUe3gWLv6Dk4zvL7H55c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768384610; c=relaxed/simple;
	bh=7fcH9SKDgRB4Pm/yzPWC0XbWasJh5djzuJC08FiBL8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rW2AhjOhldC8d028whwmbYarCHcQhDUAizAlUMcdZvwUu4WHRiNZzjKJSlGvJC/2uo5nByjo4V2loKMED6COxk4poeVj1c7cCT3oyKf0si7m+NMJNtQ+9EPiwS0I6WPYoJ1n3NuXa7EyzZ6JnHaXEjivHztIubrUiWaOpjJIf1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlD/nVtn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlD/nVtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D425C4CEF7;
	Wed, 14 Jan 2026 09:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768384609;
	bh=7fcH9SKDgRB4Pm/yzPWC0XbWasJh5djzuJC08FiBL8Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WlD/nVtnyd2mlkmd24joB56zNEaWPy5hlZan/ByQS8+DmpOswO8tqYpeij2W/FnLk
	 ghXql5dbhxGcWnrADtm7B0yp9BKYRh4lsxRdYMEEJypGy8GDVKrmOKAQ3W+8ERpAOq
	 gP9gBnCa5+uHzEYKcSZqnUEzdnaDwAN0IF6bzFR6JrBDBl4Ryhmt+2zV1cYS6WWyvX
	 kF90hA8e3ryioVCjR6v/dqIyhyqncJ444rosnQMOBnep6BFbR7DSMbntX5SlESw6YJ
	 1GKTcvDJH8kqZ4V2XmAV+t0dSqO2p8S9O75IOGzfbPKSROROJU2w2fLdvhoxGuqHqj
	 3kYj+o/avrfgA==
Message-ID: <22a1cb53-25d0-4a57-9c8e-14c65eb1f995@kernel.org>
Date: Wed, 14 Jan 2026 10:56:46 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] xfs: add a xfs_rtgroup_raw_size helper
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20260114065339.3392929-1-hch@lst.de>
 <20260114065339.3392929-3-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260114065339.3392929-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/26 07:53, Christoph Hellwig wrote:
> Add a helper to figure the on-disk size of a group, accounting for the
> XFS_SB_FEAT_INCOMPAT_ZONE_GAPS feature if needed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
