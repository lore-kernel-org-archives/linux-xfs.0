Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA9F18E764
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 16:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723135576; cv=none; b=isi0vXW9s99Y78PpG1jTsTTtW4zSkcE9P13CnLcJq4+6T6PfBuH8zqQTxzQCxwTR95EG2Gv5jwQ7NJKZUQ/UY2ud+f4oiVPkTnL75GcID1wsRLLZcAUZoiLgxj3Xr0+dNgQB3NmLnX74oA+xbQZqdw9AoqKh3+cx8/Ym5l3TGV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723135576; c=relaxed/simple;
	bh=3/dJwRD03R77gpqbfj/RAmAkA6RPdwu2Nhli6PoDMjM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kFn8UoIeSyQkgXfCG7HgWrlnrk3UUFNB68wcTJyWi44YcJzFvvwPU086li3o/K0/NNKAzEohcQdI5+vTkmM3xZQl0bNDKh8SWUtDFT3VjKdISET0yyIjG8Vdk5k5wGWEKkdGTO5pmWH32ffPv4/f58M4plC8fSwK4wBpgUzP7xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Duq7NEtc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Duq7NEtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A42C32786;
	Thu,  8 Aug 2024 16:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723135575;
	bh=3/dJwRD03R77gpqbfj/RAmAkA6RPdwu2Nhli6PoDMjM=;
	h=Date:From:To:Cc:Subject:From;
	b=Duq7NEtcOUYck3u8qba5QG2h+a7xCtEdmi0F9cdXYS99qOATH+6m2534+HXqgeFHF
	 C9wGAcbt8UJVj//4Ju1eSpF42Z7hJj+qjZI8K7SdLgtF2mHJ4OhAmCPdx5OzsIlTlb
	 m7us3KxJAjUiDus4YdEF0fuJXgwEt+ml+WfLdZh4RGiNbVIwVTcJ0Yqg+0UW+WW4pt
	 HNZJGUC4SjbuJ9wKIApJA4eNC0oQQUTQkTYmAEJfgvg/lZBgLZ496mcxG6H/m2zjSN
	 /QSM4gqLGBGTV1T4N6odzW2A4xDirRi4sj4FtNqODTMM8njsL/seZZ01zClgVMhKps
	 doIV4PVUZvxgg==
Date: Thu, 8 Aug 2024 09:46:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [GIT PULLBOMB] xfsprogs: catch us up to 6.10, part 2
Message-ID: <20240808164615.GP6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

Please pull these last two patchsets for xfsprogs 6.10.  With this
merge, online repair will be done at last.  Time to move on to
performance tweaks and bug fixes!

--D
