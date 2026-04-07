Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13C03B8958
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 13:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569102; cv=none; b=sPE78AbDRDCBzlNeY0zAzChWa3h6ekNUEutMCdmWgWEz+KLzg07WMWNerpGIIk2w4ueGcYPlC3aZAAaTGmfpbhd77uBKEefhVXM+1h1HmMLJyXb7OzVpI8zpMaeevQxZo5eiRe71u6zD1rMU52HKB1Ij40lEf3SztYXOl05KIzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569102; c=relaxed/simple;
	bh=rXZk8/mPtdfPZU/uMOlv/oMkTynWZwgg/QPlPk518jw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rmP/GdgaUOpN/jlR6yS2uHloY7+IpocM6cYiMxI92NJPdIuaeZ1Q78VTwO6bN8+o+WG/xAWJ4cmY82mwsB+vkNBkw9mi9vTy9Nmkq+9orlkX+NZDFV2AzTol3t/vcC885z7TRYsvFeHSJTUS151pWCJLimXk9fXPStkbVfDa34s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PByEjYCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PByEjYCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC56C116C6;
	Tue,  7 Apr 2026 13:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775569102;
	bh=rXZk8/mPtdfPZU/uMOlv/oMkTynWZwgg/QPlPk518jw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=PByEjYCMy5Ur6IAqiC+j+VlyS0bCmWb3khz3eZtSVE988YCuSHsY+R23VKcTkKBv7
	 0L7rn+VD2/PT1HzhvmbksogzL0NEomgH44ljP8RKGDgJXzpv1d4IFeppTzg4zMXRXX
	 V5X8acaXWOn+spRlCqR/LpoB9xQz8HB9NwunHyeGs/1BHkni/wZ3+biOlZOQzA/xgi
	 /OPDY/PBxQPV8PV7uWqtCMyK9uoBFmntIBIz0mKPtFdUy+bmiNsfKRPUE/W5vJtxnW
	 vACkgfzRTsSxNM7pik5JmnxpY7oAyB5/j3PCPBLQmhPGwqiH/ug/+kTS2lJpdMJevs
	 pkv6L8IkqILGA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
 Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20260331152751.4048218-1-hch@lst.de>
References: <20260331152751.4048218-1-hch@lst.de>
Subject: Re: cleanup open GC zone handling v2
Message-Id: <177556910134.105112.9538363871406663981.b4-ty@kernel.org>
Date: Tue, 07 Apr 2026 15:38:21 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 31 Mar 2026 17:27:22 +0200, Christoph Hellwig wrote:
> this series cleans up the handling of open GC zones so that the
> reference counting works more similar to normal open GC zones.
> This cleans up the code in general, and also helps with experiments
> to support multiple open zones for GC I've started.
> 
> Changes since v1:
>  - improve various commit messages
>  - move over two patches to heree from a different series
>  - use READ_ONCE in nr_open_zones_show
>  - fix the nr_open_zones_show documentation
> 
> [...]

Applied to for-next, thanks!

[1/9] xfs: delay initial open of the GC zone
      commit: e771da0727c13ab2cb89ee47f2edcda8b87b2c73
[2/9] xfs: add a separate tracepoint for stealing an open zone for GC
      commit: c2257d9f63bbf7e1f39fb2b5585b21ea7445e18f
[3/9] xfs: put the open zone later xfs_open_zone_put
      commit: a99ed5dbae018627faf4ac275cb322e94606a6f9
[4/9] xfs: rename xfs_zone_gc_iter_next to xfs_zone_gc_iter_irec
      commit: ca0170a7fa41fa4ef5e31b0baf2225d84a385bfc
[5/9] xfs: refactor GC zone selection helpers
      commit: 53c1c822908d9804504596486b96d8b887b0bacd
[6/9] xfs: streamline GC zone selection
      commit: 4c1b6e03e31c5933355f25fe7fa564be3a0f931d
[7/9] xfs: reduce special casing for the open GC zone
      commit: 1d0d9e9459c053fc1700739e267271adccdcaadc
[8/9] xfs: expose the number of open zones in sysfs
      commit: 62c89988dc198efc17be0119a43ad21cf32334d6
[9/9] xfs: untangle the open zones reporting in mountinfo
      commit: 9de45faed34d11f1821c386ea306d9788e9a6448

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

