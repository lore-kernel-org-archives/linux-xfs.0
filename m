Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583E047FB01;
	Thu, 27 Aug 2026 16:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787848807; cv=none; b=BmS+5qSu3le0kFTCqTwqZHPxwTRX/LnhwKeRZYPnVZN2xyA/mV18XRpVuc400vL5+/OHxN6DnWfAXybiS/h2Eam/mfMkYLjSozx3BGxGnNfvWRcIXZCcszLIR8ERm4sSgN04kl1EjwwLjn1Vl88nb4xz+BgZv78mlsimDey01Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787848807; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cc189ULDw3dfmYa9uI99ImfH1HZbOFs2haphDrSM8uvM1z/qtTB92/VsSbAeCRPNOdskNqMn5pkVvQouWHa83isvr89qDJDSqXId4cKr5IRTNFFAOmBj9V8w4lgdK4zZIco8b/R7WJVzxN54H7E/hkLNNb3Os5SS44myxMBiQMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSnq7qQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSnq7qQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6F11F000E9;
	Thu, 27 Aug 2026 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787848802;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HSnq7qQL1zt3uiw78MlOknEwSqEAIcugPoNAoDVM9Bc0V2B6FvLPE6a2X3/pTM5CC
	 wBqcU2/Ti0czIQDRhcqU7Zgzc4wo4MkT0Hkl/KXPhVaI+m5pUkeKXY305apcx5XAR4
	 w9Ub2ERLW1O7bCjWmb5fLSHv6olLe7yffdXHgQe8RuvDzNOANma+PCC+zK5zCKlVEb
	 mhdU/CjN3qwrxAhc1lvWCEd18n+CdVq9YFekb/LKst2C496POoPuXyyqT03FJurdSM
	 mrwTXE0wYKa1cy6ieuy/X9/ESKFeEbCIBCFrKwh41V95P6BzlZ9HOaN/olj/WAevj5
	 Ot+AZueQj+0cQ==
Date: Fri, 28 Aug 2026 00:39:56 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, 
	Hans.Holmberg@wdc.com
Subject: Re: [PATCH] xfs/837: set rtinherit on the root directory
 programmatically
Message-ID: <apBn_91BwmsQjhsq@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, Hans.Holmberg@wdc.com
References: <20260826183001.GV839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826183001.GV839663@frogsfrogsfrogs>

