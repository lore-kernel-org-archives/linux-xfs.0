Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8793285C84
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 15:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769182822; cv=none; b=s1UzfYfi8Lm0mLgN4/BZZiv0awXhYRH3AkW1i/8fj6x+Azhz1C9EehaQ7/aa9gX3Dngo7hSYMJ8K67aen7iK7sVGPwzl3NUiBeT1HTzxUChGrLnVLhPkXNODGB+no/3+wb5Zk81P2Zi9EkcElse4KVqLm/2/Jz/JqYI6ztYa/gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769182822; c=relaxed/simple;
	bh=ca5OUABJIUQw1awy0GFCz8SroFNXoro22G2gLfwRU4M=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=MLRWUEA7c/yb8TCcSJBsqPwcO/vzkZf1t4yxoQW2fTe0UR85X8X6Or1ZsybFGkHYw9GRyh6mNuC9jnIc90txKb33WScOo3d6tpVd/rnfJWD1NHeT+1gu1c9R+f03kE7raLlTqnbTKkwIn/ax0naHwHTmgyjmU0Jni8c7oBG35jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=miIdbsrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="miIdbsrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C132FC19423;
	Fri, 23 Jan 2026 15:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769182822;
	bh=ca5OUABJIUQw1awy0GFCz8SroFNXoro22G2gLfwRU4M=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=miIdbsrx/xWo97HXz/jQd5ViuIINwShbYv5Qx6eRXNyIG8yB3gaG3qsEC3ec3NRue
	 Durj4sBrnWWjXrQrr5xH6oIcmO56O5emUyNuGLQ8a1IWEydvOmOU7kqM01t5OPceT1
	 zG+0Ch1oWfduzSY0eJogyMLwv7U+uD29e7I3+kxKFCUuVj61KD4huJQI4bRL4FGdwB
	 Q0StbeWgJeXcRI2z9tt9kiNhB6Ahm8RhACQTzrDS2k1KVc0bsvE5bborNt5lu65RPV
	 j5N2SB7OE7hU/qBLJ7DVZz/2L5F8OHd/T1wd9v6yrKjTyhly4GgIB3PxfkGUIhbvit
	 OSujpWPpFXXCg==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 99424F40068;
	Fri, 23 Jan 2026 10:40:20 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Fri, 23 Jan 2026 10:40:20 -0500
X-ME-Sender: <xms:ZJZzaa9eivV6ZLC2S1VvjVQPBCkkSu4KwoG1yY5mRgNIWyYur9Ck5Q>
    <xme:ZJZzaVhe3sND8MoOXWzM6KbGKNU-wl2QbyrVMYOgilup7QoUs0_xsBDCg8xWETr0h
    3G1z6reNUTw9_CJt2iyf6fO5CBWZsC9dMjullwIvYdK7XZ5z1-MxMD6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeelgedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedfvehhuhgt
    khcunfgvvhgvrhdfuceotggvlheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhffekffeftdfgheeiveekudeuhfdvjedvfedvueduvdegleekgeetgfduhfefleen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegthhhutg
    hklhgvvhgvrhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeifeegleel
    leehledqfedvleekgeegvdefqdgtvghlpeepkhgvrhhnvghlrdhorhhgsehfrghsthhmrg
    hilhdrtghomhdpnhgspghrtghpthhtohepfedupdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopehsvghnohiihhgrthhskhihsegthhhrohhmihhumhdrohhrghdprhgtphhtth
    hopegrughilhhgvghrrdhkvghrnhgvlhesughilhhgvghrrdgtrgdprhgtphhtthhopehs
    lhgrvhgrseguuhgsvgihkhhordgtohhmpdhrtghpthhtoheprhhonhhnihgvshgrhhhlsg
    gvrhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghnnhgrsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    gtvghmsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegthhgroheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohephhgrnhhsgheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:ZJZzaUw-i5v04Oo4fuTDYQJ6fy5P88Zbs1MBvOy8w-xobwZu_7vEZg>
    <xmx:ZJZzaSq2wkh834Up5x5kLjRlIaDqOo5FWP-tWiZw1Fd0qfJBikQpKQ>
    <xmx:ZJZzaR7NIuH_l3ADDuDheAkeN4vFEAcw0T7KC-Ayt0CDPdHImRMmgQ>
    <xmx:ZJZzacgEYomzp6qZbIscHRcBPtxblNQkyJKtMbmaPLb7bORokH1X7w>
    <xmx:ZJZzaf1KoDZBtl7IdcWtFdAYuDM1ZCLx7M3GXs9B37KKxuKtytwrRpxO>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 68382780075; Fri, 23 Jan 2026 10:40:20 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AdRvsg_UpIrR
Date: Fri, 23 Jan 2026 10:39:55 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Yuezhang Mo" <yuezhang.mo@sony.com>,
 almaz.alexandrovich@paragon-software.com,
 "Viacheslav Dubeyko" <slava@dubeyko.com>, glaubitz@physik.fu-berlin.de,
 frank.li@vivo.com, "Theodore Tso" <tytso@mit.edu>,
 adilger.kernel@dilger.ca, "Carlos Maiolino" <cem@kernel.org>,
 "Steve French" <sfrench@samba.org>, "Paulo Alcantara" <pc@manguebit.org>,
 "Ronnie Sahlberg" <ronniesahlberg@gmail.com>,
 "Shyam Prasad N" <sprasad@microsoft.com>,
 "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>, "Jaegeuk Kim" <jaegeuk@kernel.org>,
 "Chao Yu" <chao@kernel.org>, "Hans de Goede" <hansg@kernel.org>,
 senozhatsky@chromium.org, "Chuck Lever" <chuck.lever@oracle.com>
Message-Id: <41b1274b-0720-451d-80db-210697cdb6ac@app.fastmail.com>
In-Reply-To: <20260123-zwirn-verfassen-c93175b7a1ee@brauner>
References: <20260120142439.1821554-1-cel@kernel.org>
 <20260123-zwirn-verfassen-c93175b7a1ee@brauner>
Subject: Re: [PATCH v6 00/16] Exposing case folding behavior
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, Jan 23, 2026, at 7:12 AM, Christian Brauner wrote:
>> Series based on v6.19-rc5.
>
> We're starting to cut it close even with the announced -rc8.
> So my current preference would be to wait for the 7.1 merge window.

Hi Christian -

Do you have a preference about continuing to post this series
during the merge window? I ask because netdev generally likes
a quiet period during the merge window.


-- 
Chuck Lever
