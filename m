Received: from dibed.net-space.pl (dibed.net-space.pl [84.10.22.86])
	by smtp.subspace.kernel.org (Postfix) with SMTP id EA2B28462
	for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 18:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.10.22.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916118; cv=none; b=BO9rYURN8H9iTY1lxYvNhufyR170b0HBFff+9m7k7LW9c1wXoFOyaRq2EwBMHdheuvpI17INKRHbjH4uNX7qRd3rtQBUESMBA8Z15PrPCn2tXoiSitY7YtzO2fRiGya0caS9mCR9K3MofNaG8/dytWzhxccZvWlJvv43bl314Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916118; c=relaxed/simple;
	bh=cGDsIZ8Khdn2R6tfkzZ5hWfPGtNg8i6ROPGDU6GIDbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J1qkcpHmKhL5YfcCnxG6c3PSWSRkPhkl7cqQR3DytytCU8rCmyGyqSzp/zAyQVolacXQft3WxU3in5nBUmMKRG+Nm8WFD+TQp98e14ne+4PkF9x54veW9GzFv4JFqJk/soDmcSLUKeSdJbGWD+sdaH/G86txuWGygkh/kAGNtUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl; spf=pass smtp.mailfrom=net-space.pl; arc=none smtp.client-ip=84.10.22.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=net-space.pl
Received: from router-fw.i.net-space.pl ([192.168.52.1]:41638 "EHLO
	tomti.i.net-space.pl") by router-fw-old.i.net-space.pl with ESMTP
	id S2261973AblDQSe4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
	Thu, 17 Apr 2025 20:34:56 +0200
X-Comment: RFC 2476 MSA function at dibed.net-space.pl logged sender identity as: dkiper
Date:	Thu, 17 Apr 2025 20:34:53 +0200
From:	Daniel Kiper <dkiper@net-space.pl>
To:	Eric Sandeen <sandeen@redhat.com>
Cc:	grub-devel@gnu.org, linux-xfs@vger.kernel.org,
	Anthony Iliopoulos <ailiop@suse.com>,
	Marta Lewandowska <mlewando@redhat.com>,
	Jon DeVree <nuxi@vault24.org>
Subject: Re: [PATCH GRUB] fs/xfs: fix large extent counters incompat feature
 support
Message-ID: <20250417183453.75qm4nt6otdktjij@tomti.i.net-space.pl>
References: <985816b8-35e6-4083-994f-ec9138bd35d2@redhat.com>
 <0e47cb04-542c-460a-a5b9-e9b0f3ef6c1f@redhat.com>
 <5c60155e-baa6-4a6c-a872-587397cf677a@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c60155e-baa6-4a6c-a872-587397cf677a@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Tue, Apr 15, 2025 at 08:08:12PM -0500, Eric Sandeen via Grub-devel wrote:
> Can I bribe someone to merge this fix, perhaps? ;)
>
> On 3/27/25 2:48 PM, Eric Sandeen wrote:
> > Grub folks, ping on this? It has 2 reviews and testing but I don't see it
> > merged yet.

Huh! This somehow fallen through the cracks. Sorry about that...

Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>

Daniel
