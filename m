Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219B42C861
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897014; cv=none; b=ZjN40HnuNbp+Y95gKhI8OTcF9XfaNivyKVKDo0rb4uIU8lro3qSdGybPsJtOZ6kpe5hKOaRvq64jBhVEniC0SlipDWsPBl9LkRs0QkcCanJSKKMcPeTlWXetHo3Eg5TFPgwGUzCZCC9kxawpyDxsQi9AZv0xeXHJKebSLVWr3go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897014; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UzoupVb2/QiQBHKMTrkwP5LvQBHJQyZtIAc3+9+RMe6e+l7TY9lh/1cO2SIz0leixOJvHiqD9ZCWyWtyVl2dSzd0wr/ELICW5taAOGX55dCn8uaMFXyGapQ4SVh2zcN7vN+8arxW6r2STKvN/uLlCVsclBQGjtywH0xdAFpU8AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4FCB568BEB; Tue,  2 Jul 2024 07:10:10 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:10:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/12] xfs_db: advertise exchange-range in the version
 command
Message-ID: <20240702051009.GE22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116786.2006519.17065535694551373149.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116786.2006519.17065535694551373149.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
