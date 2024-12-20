Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF05A5674D
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 15:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734709666; cv=none; b=MqnxuzNs3fbwUfmLKvzcqjwd+fj1KA8ZSDhWCzbROCdjM6MX3shm5ldbouqgCU4TONZqHwfjnzW+DMziqgKz8O5/HPjV4LfAqEPe8EuiYNjB2McmM2ACxondg3p3D3ZwCMAtXavqixDHnT/kInimPlhTKlsVWAqNtDoZftujPw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734709666; c=relaxed/simple;
	bh=M+Wk5TxNC5j77inYlZZ9N0eVdWDEPfW9A1+eYEG0UNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bt8yF6YpB3x6dZDnLdzFyeLr79jqYljig5SDWe17z2Y3NJsaYrfU8QRdOBGIMpYmCe9e959m11ssGrpmOAMz07AGH3OU+SlfPxeRWRYvH9wm0T6CC3rgOHDcbO/Cekj8PJcixDwkBYx1pRdSgCOZfAZzHLN+QF9Qb8RMwrZDad4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=jIEKQT3f; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kUM9OSYD; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="jIEKQT3f";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kUM9OSYD"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D0E371140145;
	Fri, 20 Dec 2024 10:47:43 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 20 Dec 2024 10:47:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1734709663;
	 x=1734796063; bh=jckxXYiCuVN7va9AVSe2az6HraYV2vpNjAwslQQmuOc=; b=
	jIEKQT3f6a64obCxUX7zOCwQnt9tDMKIeYJbQhWVN5XemppUk9Jjb3FJCvzjMm54
	TGyopM/+038bgqQP+iN8B/HqXJCvddlKmq+ZMLxk4lNqBYTWYmtO33oGaPzffSCW
	ualoVPRzxm78X9/7f5EmPAnibicPkmL/1Y4GK9fzviK86L4gC4o0CNKQFz4qJPsi
	6ukZXWhGCFIKr/SHmQ1bPzvLwjQeKtvNZHhFqRlL0J/qfz3mVk5F7e6XvC9pjyJa
	iw5QhTTDWjTP7kojDM4CYnC0517vBF5x1PICoJ0EX3Uw7MemlkbonYASb52bNapZ
	m3JvTXCv9Xp98JmfmIIl6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1734709663; x=
	1734796063; bh=jckxXYiCuVN7va9AVSe2az6HraYV2vpNjAwslQQmuOc=; b=k
	UM9OSYDHsQ7p3iEPFITtX7dEUYi04ZfDMk9Hb+7YCa064gF347etNzJprtSzM2TV
	/RFxTd5Y8qXZ3q0YTFTxtUTWYZZFRThI0EjyOKSzUnC/QceCPQi8TbtXOv1ECEoh
	iM+XLvqslh9DNrY/8/Y2AVDjS5zPRlyp5m4Lx+pAU+RFHPy07T+mWmPl8JvQRoMS
	R/6wUsERRpM5VsWcIR4nbRXAjZDpf3DcuJ+owhrUX2we6TDlshyS3LyemaIOy9vu
	5A5cNr0pImWCYNr3vIF0m3RSlbGt99cMo/LLMwYwM8qN1bUFMGA8O3muNuhlvvxF
	ieAVqOZjTAFvbU9IWzzZw==
X-ME-Sender: <xms:n5FlZ_1Ili6S5yy76zm0ecUuqXkfDAnHkjnW143RJ8OY4RShnF-yAA>
    <xme:n5FlZ-F9wtKB-vx2RCuwoM9STb0l37DE8acc4OWVrdphZl0HzsF2-JgfLVVkJieSo
    uoUfkdNam9NDc_jF_4>
X-ME-Received: <xmr:n5FlZ_4WtJq9AR0R1K0VenSFfnnrT-bUSf_SU3MwW2mFwgxDTzGPgmBVXsl2uqxI7I7P7sd5oF5Ny-bjg81RaO_Nq64>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddruddtvddgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpefgrhhitgcuufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvg
    hnrdhnvghtqeenucggtffrrghtthgvrhhnpeevieekueetfeeujedtheeffedvgeffiedv
    jeejleffhfeggeejuedtjeeulefhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggp
    rhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegujhifohhngh
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtohephhgvlhhpuggvshhksehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehthihtshhosehmihhtrdgvughupdhrtghpthhtoheplhhinh
    hugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegtrghthhgv
    rhhinhgvrdhhohgrnhhgsehorhgrtghlvgdrtghomhdprhgtphhtthhopehlrhhumhgrnh
    gtihhksehgohhoghhlvgdrtghomhdprhgtphhtthhopegthhgrnhgurghnsggrsghusehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopegtvghmsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:n5FlZ01qYWbmDKL0V6o6IBCiZBwrZ_EeRJIlhMHWcEQk1bGm_KkokQ>
    <xmx:n5FlZyE1Ox531BVyePRgc-XAlhcZQyIUD3KEeBqm5R53PdUDDiXNtQ>
    <xmx:n5FlZ1_hQyozUY1YqBd23WATM8ioNHKhwF-dOm1Rn1LSYHcqyxurXg>
    <xmx:n5FlZ_ngk5N6aBIAJEUl13ymmoQ_QFQtdxEqaU4eP2uuRnJ2NuehQw>
    <xmx:n5FlZ1C4ienkY420W5JAEtZpo6Wipsa5LTHvZ2tVElm4v8qr7Tb6iZ6N>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Dec 2024 10:47:42 -0500 (EST)
Message-ID: <c6451d7b-c0b6-4cdf-b0ff-90a23c52cc37@sandeen.net>
Date: Fri, 20 Dec 2024 09:47:42 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Create xfs-stable@lists.linux.dev
To: "Darrick J. Wong" <djwong@kernel.org>, helpdesk@kernel.org,
 Theodore Ts'o <tytso@mit.edu>
Cc: xfs <linux-xfs@vger.kernel.org>,
 Catherine Hoang <catherine.hoang@oracle.com>,
 Leah Rumancik <lrumancik@google.com>, Chandan Babu R
 <chandanbabu@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>
References: <20241219183237.GF6197@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20241219183237.GF6197@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/24 12:32 PM, Darrick J. Wong wrote:
> Hi there,
> 
> Could we create a separate mailing list to coordinate XFS LTS
> stable backporting work?  There's enough traffic on the main XFS list
> that the LTS backports get lost in the noise, and in the future we'd
> like to have a place for our LTS testing robots to send automated email.
> 
> A large portion of the upstream xfs community do not participate in LTS
> work so there's no reason to blast them with all that traffic.  What do
> the rest of you think about this?
> 
> Address    : xfs-stable@lists.linux.dev
> Description: XFS stable LTS mailing list
> Owners     : djwong@kernel.org, tytso@mit.edu
> Allow HTML : N
> Archives   : Y

I have no issue with this, and I think it's wise for the reasons you've
stated. Even those who don't actively participate in maintaining LTS
kernels may still wish to keep an eye on how things are evolving, and a
dedicated list would make that easier too.

If it comes to exist, are there any other -stable people, processes, or
bots that should start using it too?

Thanks,
-Eric
