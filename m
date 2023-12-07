Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E694862D
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ADFq+V21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582CFC433C7;
	Thu,  7 Dec 2023 02:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916432;
	bh=TXfiFHn+Z2pUriO6Nr0OykP4RlM/R4fwiH0KBcUbCo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ADFq+V21zA1REwzZ8nZGlrNgnANeyWXOrg84gNJTakJUOVZaefaaqBIORiEyh0a79
	 x3jPYAlj2NOGjK9mGZlr0HTYtkpjsNT5KQ+oy3VaHxWVA4HooRZrIcZBlubqxa48Eh
	 HkWOfZSnIOhKJZe3HPa8hnu3XGTNYhS4sQd1G2mEl5351nl4NaySDHCuXMI2YavIAW
	 z/jjQ3lgfmAP5yDewFSmfAZTLEMk9XVEvd0UxvsUQ55gwWVFvmQbhNZ24KNJ385+ZQ
	 jz76CTN61fNEmZmvInGj6EsOzmLTEBfozzFs43SU6Grq8w4BfxkhQ/4zPTNSN15OPB
	 h8cd6a/u0Ht1g==
Date: Wed, 6 Dec 2023 18:33:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 4/5] xfs: elide defer work ->create_done if no intent
Message-ID: <20231207023351.GP361584@frogsfrogsfrogs>
References: <170191573238.1135812.13863112646073646742.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191573238.1135812.13863112646073646742.stg-ugh@frogsfrogsfrogs>

Heh.  I got the sick, so it might be a while before y'all hear from me
again.  Also, there is no "GIT PULL 5/5" I can't do math. :(

--D
