Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ECA2AE84;
	Wed, 30 Jul 2025 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753885158; cv=none; b=qW1G32QB84RmbWA50Vml2C1rDyOaJ2dwLYiYbzhy1Ud2lLwEm72zePL9g89EWc9OvobOQVPVbUN8kvUpJXNpAvT+c4TmCWCogj/Dc3KTj0QxHunjRFajNwKoEPu8Gz4AJtBdqoDxfNjFN/7yOU61Dl8Iu8nxUez6lyrEts7gkWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753885158; c=relaxed/simple;
	bh=l8L3lymksBlk3rcl6ZOMnK0s42qYm9hcrhp2HtNdeAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+3srcbJde4eUTLXPKQymGPsQ7vvgZy5qARXpnw/8RJNzWAU5ixOyEFMOzjGesVlOMf3ggpPholrWQ1TaxRS1IOB/46KWHBL/eO1sZW34hKX/KiHeVm9ys0OS62Wk33vNgq+L4KsGGJI90uIPPJYBJl1NoNvWKDV4lvYZsL4WD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LUHgJlnd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LUHgJlnd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pQSqeTZ7/wH2OpAnaS1NShrsX+MJAqtGb5UPG65SWWo=; b=LUHgJlndjs04W+Z9VuFGMAa2mi
	bJfecWdxJ2GgOfVFjNHtCDdlpwtopZnm9DCp63vu2h+ceMQFWL3xzZxzDsATpX2ztisP+8Jtb8an9
	OUC+fQDzw+/BXm1VResmYVoGE+Scvm3wq8RgoI5lM6Zp0oceGz4jg5lS3MaigmSG9gWZqumnkVH8i
	x6vknqHT5eqSmf4QDsk9TyoUiaBNKzwnioEoONMk9Etixh87mPwGsXlRePsgyP/vAT+5B44FuEV2+
	QvPohFi8+w2N2weY1CmgzfqMZbWOSXVg+NfhsZ+0Dz1GvPOPjLEDxrI7V3uDJK2h+na7bsvBfFz6D
	YzSBwFZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uh7eG-00000001ifj-2ewt;
	Wed, 30 Jul 2025 14:19:16 +0000
Date: Wed, 30 Jul 2025 07:19:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] generic/767: require fallocate support
Message-ID: <aIop5EoM8IZbdApZ@infradead.org>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957955.3020742.3992038586505582880.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381957955.3020742.3992038586505582880.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 29, 2025 at 01:09:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test fails on filesystems that don't support fallocate, so screen
> them out.

Looks good, I was just going to send this as well..

Reviewed-by: Christoph Hellwig <hch@lst.de>

