Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AAB2D060D;
	Thu, 26 Feb 2026 01:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772069661; cv=none; b=Sc88sOZ/tASe6LRjOJbWwRYOcyfUKGmLhozvf56lciKIvrp12SQNvc5QvoEYzrA8IFPP56dvjE1mOmryed1gKf0F8K2S72OsFmpTHhpIStei4yFBBZboIL5MhscaxJ9dlSNBqgWSqG8LYEcUAol2En+J8kyJBGH+Xs9ZLAEyFpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772069661; c=relaxed/simple;
	bh=s0GI5iI3wRZDhofWKjF/FkmAMYAMF4AS6inKjugXtHI=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=tsB1oEd6BCOKX9TPmUubX5rybg/RijfIlGeTBfiweZ0/80qHKoxtZeajQDixfJYsgtKMXM+yytbk8+p/yn5EsEK6GCur0lfqAjjWeHulEnw9yRrl/9vDeAlp7PflImfxqT/5qVSdRBq3Ay3eLsMbluJH+IJOOZGsQnHCHCTXrz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=TyFPTUuN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Ib+fb/df; arc=none smtp.client-ip=202.12.124.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="TyFPTUuN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ib+fb/df"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 770D01301436;
	Wed, 25 Feb 2026 20:34:18 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 25 Feb 2026 20:34:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm3; t=
	1772069658; x=1772076858; bh=xFBd+sgdAigxjeaFROdJjStbv2bZWH9W94w
	m4HgXADY=; b=TyFPTUuNpFO4HIfohypp+ntLH4SQw2KPz+k2oQocgPVXp9IMTnX
	YTwXn0B0NRR1FYYXcaTtalmso1CAnAtpqQXesgp6NXUx9quUYAHLB9YpC7bcAFIk
	TvZwg0C4FEHSiJIWxgFCFZeZtQNbnePdiIhVa5xxbKLS4C0AAupb2KhOapT87xq6
	/3dFNWglRa3+Asvjf363pYv350SKI+bTeFGj0Ke0oZ/HCmva0nyqttckU6ALPSJC
	tKc9PZzn6EA/vn9yNXu2DyW0UREtAZ/UTz1GA6V09Li6HeUdi6bLRfdCD5cAE4/8
	WK60qtisykmi10YVhcXga6K3ltYHqs7v/qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772069658; x=
	1772076858; bh=xFBd+sgdAigxjeaFROdJjStbv2bZWH9W94wm4HgXADY=; b=I
	b+fb/dfhFB2brFsDKPdocEWfgR6l5L1tGXqcmDEUm3dOayVudiX+HaadK36d/22y
	X+hujziwNR1hhTLDE2AI+F4JYwsusV2edxzfklPwQ2qZG64OmPoEcH5DheOy4vAg
	yZobw4gbMhMooYzr+mwhaa5gBqWaBtLl4E4sefLwDLQNuUzHEvbFUl+50coVVzRQ
	uUSfLvsYvt4ZHYuBH0TtNmKmiN2iTjqr/WfXIN4vsdjnHDbYjLnhZrQP2i/uHaKd
	hi1uQRctV8MB4SMWSP8frR1+kHQsrbBVM9bNFci7X5iHcoMOp5CM90AYY1GGHLla
	lsHXTe1M7Jgjucp7xuAqA==
X-ME-Sender: <xms:GaOfaZdxVZrAzznSHl1LN0ciatDBWLW_4Ro8DTat2U9_lQfv7c3xVg>
    <xme:GaOfaU3CQnGhH_qC9WVaUqiJ_NCnEVlJXvoCDEyQujfqIEFNjcJ-KobsK6_w0bXRA
    1o46wyvYNXYHRmuB2DKHe8Qk8RpFZRs_31jtFSaYRrHAyZ0>
X-ME-Received: <xmr:GaOfaZ56MuiAcHw3-TwPARtUbYmsMUpCo2Tgrqvdk_rKhN1qr8rZK8mNn6nhWrEZy_AkfhXlZTsDqCDkE90mmkyGUJoOWVM0jUxttdORdGVn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeegjeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtjeertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epudetfefhudevhedvfeeufedvffekveekgfdtfefggfekheejgefhteeihffggfelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohepfedupdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpd
    hrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdhunhhiohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqtghifhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohepvggtrhihphhtfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheptggvphhhqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:GaOfabL1dxc7_aM4UDs5Mnpgjmz6nRiprNnIb1cnNlkCnzS-DCI01w>
    <xmx:GaOfadZA0aqqd6hc81DmwuMDHkptr7xfpw9R6OlYEqEEXQp_JHd2Tg>
    <xmx:GaOfaQ1gMPhOOVjW9cB40OYojuSXNA5JDysMhyGtEuX2KAF1dKYb1w>
    <xmx:GaOfaXPevv-IvnTNjJUThP9sr3Z22JJ883VL2eHqz1vQzs-Pzf2nZA>
    <xmx:GqOfaQqK_qAYvtHo1ixO-4yAHtdC6htK7kcrEBnPb9SzuKAO8kARg5HQ>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Feb 2026 20:34:09 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Cc: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "David Howells" <dhowells@redhat.com>,
 "Marc Dionne" <marc.dionne@auristor.com>, "Xiubo Li" <xiubli@redhat.com>,
 "Ilya Dryomov" <idryomov@gmail.com>, "Tyler Hicks" <code@tyhicks.com>,
 "Miklos Szeredi" <miklos@szeredi.hu>,
 "Richard Weinberger" <richard@nod.at>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>,
 "Chuck Lever" <chuck.lever@oracle.com>,
 "Jeff Layton" <jlayton@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Steve French" <sfrench@samba.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Carlos Maiolino" <cem@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-afs@lists.infradead.org, netfs@lists.linux.dev,
 ceph-devel@vger.kernel.org, ecryptfs@vger.kernel.org,
 linux-um@lists.infradead.org, linux-nfs@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] VFS: allow d_splice_alias() and d_add() to work on
 hashed dentries.
In-reply-to: <177206761798.7472.8904569543245678825@noble.neil.brown.name>
References: <20250812235228.3072318-1-neil@brown.name>, <>,
 <20250812235228.3072318-9-neil@brown.name>, <>,
 <20250813050717.GD222315@ZenIV>,
 <177206761798.7472.8904569543245678825@noble.neil.brown.name>
Date: Thu, 26 Feb 2026 12:34:06 +1100
Message-id: <177206964635.7472.10143856965392266372@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Thu, 26 Feb 2026, NeilBrown wrote:
> 
> d_add_hashed() would be much the same as d_instantiate(), and that
> could be used for d_splice_alias() when the dentry is hashed.
> There aren't any cases where d_splice_alias() is called with a directory
> inode and a hashed dentry.

There are of course... mkdir() is given a hashed negative dentry and may
need to use d_splice_alias() if there is any chance the inode was
accessible (e.g. by fhandle) before the splice can happen.

Maybe we could always give mkdir a d_in_lookup() alias?

As it is, generic "create object" code inside a filesystem may need to
handle three cases:

 d_in_lookup() - use d_splice_alias()
 otherwise if non-dir: - use d_instantiate
 otherwise - use some new d_add_or_obtain (name taken from NFS) which 
     does the right thing with directories.

Currently most d_drop() and use d_splice_alias() but I need to avoid the
d_drop().

Thanks,
NeilBrown
