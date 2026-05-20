Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9210F3BED1E;
	Wed, 20 May 2026 16:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296325; cv=none; b=m/iSfnybSReiinMtTuOUz5V+5MFp8JBwq1zv0HtRP1WnH23j5mp0QpJujgD6kw2zUgeNt31CH0W4pbZ6peQlnpCdB6Tf/1Es7GYHYzDNTerEDoB/fGNaaBgi9e3k1b/FHsC86/WFOXHpgklRVP82n+2WV+RK40x1YY3G2yOz95w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296325; c=relaxed/simple;
	bh=HuRpGc2PUG4TKGlMk6ECKCEenG1oz34paklJhSdTDJs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Y5jFSPY5CTAWkfIJAV8F/0JMkSGvj+sdEYUHYAnQvQOUjvOdar20CKWl5gR8rx3HT3kCO8gvk6eAvdGDIb+dJcC6ga21H4mv70ywMkoQJ+BrFMFrFO+jrhFSTgDgW1WFKf7ex5auZahiSCTxrE069lHUID3OD4WnUARQ/QV9m9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UwbdSUFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UwbdSUFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0611F00893;
	Wed, 20 May 2026 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779296324;
	bh=3HYCTjUKnMgOBwx9QLeP6Mvnf90VdQqX6Kq1eV2MzLM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=UwbdSUFfiPD5nEs75u3836d9xkPyk26dXYEF4j6ngljmJB9byL9nvxBvogPMZEwS4
	 HlmwR0Rq34lWaUCSaxX+qP0G3jQY+n5dNstgtVC1XjtFLnN6eag316xOeo21Oo3l8g
	 nI/CHm5zH75HQblS72L7CFw3OiTnVKVi2i56AqGT074yhwFoulv9ggS7h9og71NL8s
	 CUImdcg29FH5HSElh25NizNdrsqsSlyqKLhIH/aZ9mRzSL8VNxnMhU9kQHBMXoWC96
	 wXpf0wB09Xs4FpEjOOUxXPlqI+hwRYphh5mtId442ujsKT5lIzZRLejcS2h5i3exxx
	 +yDZS5cE5w3vg==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 653BFF4007D;
	Wed, 20 May 2026 12:58:42 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Wed, 20 May 2026 12:58:42 -0400
X-ME-Sender: <xms:QugNavyinx7bKrqL4HPeQunpcXbIaluZN7wF9StWTZXgR2qve6JZ-g>
    <xme:QugNaiGhRRos_yOLWfm-5tiI1PIm-uXq5yDDMT3oiNGBSfN1wx_UeyhKOJHGIa_bo
    cQ9rqE22bExtjIDyUHyrxhoLANTG9qDp37GvGe2tAPk0XVFu3TxC64>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeehudejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedfvehhuhgt
    khcunfgvvhgvrhdfuceotggvlheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhffekffeftdfgheeiveekudeuhfdvjedvfedvueduvdegleekgeetgfduhfefleen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegthhhutg
    hklhgvvhgvrhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeifeegleel
    leehledqfedvleekgeegvdefqdgtvghlpeepkhgvrhhnvghlrdhorhhgsehfrghsthhmrg
    hilhdrtghomhdpnhgspghrtghpthhtohepfeegpdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopehsvghnohiihhgrthhskhihsegthhhrohhmihhumhdrohhrghdprhgtphhtth
    hopegrughilhhgvghrrdhkvghrnhgvlhesughilhhgvghrrdgtrgdprhgtphhtthhopehs
    lhgrvhgrseguuhgsvgihkhhordgtohhmpdhrtghpthhtoheprhhonhhnihgvshgrhhhlsg
    gvrhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghnnhgrsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    gsrhhoohhnihgvsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegtvghmsehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopegthhgroheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:QugNamfaq2UpdXiWnPnay5nQ_rQckvm_41kR8NgaI4_lDDqQ4Yiy8A>
    <xmx:QugNamv95ErjE6pb8okHjc44uM5BHK6ky05NPxz2-vrTiBeWgMpiJw>
    <xmx:QugNaqupzmbSbdKQTrJcjN0dK0NknGvcRa4HhfzOtsthEH7eWtONFQ>
    <xmx:QugNat90cmRSntFhphxoUhXn78eiEA_yq5VNO1np6BiZmUQI6kUYVw>
    <xmx:QugNar9VQVV9Crz_mdTjuEL665Y3HC3jfH6afIH-rv2ZfQMjW6d6XLfr>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 33FD9780076; Wed, 20 May 2026 12:58:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AuvJ25pICu_N
Date: Wed, 20 May 2026 12:58:22 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Mark Brown" <broonie@kernel.org>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-api@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net,
 "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Yuezhang Mo" <yuezhang.mo@sony.com>,
 almaz.alexandrovich@paragon-software.com,
 "Viacheslav Dubeyko" <slava@dubeyko.com>,
 "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>,
 frank.li@vivo.com, "Theodore Tso" <tytso@mit.edu>,
 adilger.kernel@dilger.ca, "Carlos Maiolino" <cem@kernel.org>,
 "Steve French" <sfrench@samba.org>, "Paulo Alcantara" <pc@manguebit.org>,
 "Ronnie Sahlberg" <ronniesahlberg@gmail.com>,
 "Shyam Prasad N" <sprasad@microsoft.com>,
 "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>, "Jaegeuk Kim" <jaegeuk@kernel.org>,
 "Chao Yu" <chao@kernel.org>, "Hans de Goede" <hansg@kernel.org>,
 senozhatsky@chromium.org, "Chuck Lever" <chuck.lever@oracle.com>,
 "Roland Mainz" <roland.mainz@nrubsig.org>
Message-Id: <858d7233-1d9c-48f4-aa4f-c5a9f6e1f5dc@app.fastmail.com>
In-Reply-To: <3a347b64-f91b-450f-b27d-26ea6810b960@sirena.org.uk>
References: <20260507-case-sensitivity-v14-0-e62cc8200435@oracle.com>
 <20260507-case-sensitivity-v14-3-e62cc8200435@oracle.com>
 <dc69224d-9926-4414-8c6e-4c15ae98705b@sirena.org.uk>
 <04302551-3628-4036-9a3f-596cb782f5b7@app.fastmail.com>
 <a366645c-364d-4588-8a15-4cd446f64366@sirena.org.uk>
 <8b750b3f-4d73-41f3-84fb-6e387fd24168@app.fastmail.com>
 <3a347b64-f91b-450f-b27d-26ea6810b960@sirena.org.uk>
Subject: Re: [PATCH v14 03/15] fat: Implement fileattr_get for case sensitivity
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, May 20, 2026, at 11:19 AM, Mark Brown wrote:
> On Wed, May 20, 2026 at 11:12:51AM -0400, Chuck Lever wrote:
>> On Wed, May 20, 2026, at 10:54 AM, Mark Brown wrote:
>
>> > It's not testing tmpfs (well, it does but that passed), as the log above
>> > shows it is making a vfat filesystem on a loop device backed by a file
>> > that happens to be in a tmpfs and then testing that.  There's a bunch of
>> > filesystems covered in this manner:
>
>> OK. Is vfat the only failure in LTP statx04 ?
>
> Yes, it's the only one showing as failing - there are four failures
> correspoding to the four tests done for vfat.

03/15 adds .fileattr_get = fat_fileattr_get for both
fat_file_inode_operations and vfat_dir_inode_operations. LTP
opens a directory (SAFE_OPEN(TESTDIR, O_RDONLY|O_DIRECTORY)),
so FS_IOC_GETFLAGS on the dir now succeeds, and statx04
proceeds where it was previously skipped.

AFAICS, 03/15 did not change pre-existing kernel behavior of
stx_attributes_mask on vfat. It merely converted a "skipped"
LTP outcome into an "executed but failed" outcome.

Fix options:

* fat_getattr() could call generic_fill_statx_attr(inode, stat),
  which advertises KSTAT_ATTR_VFS_FLAGS (IMMUTABLE + APPEND).
  That clears 2 of 4 TFAILs but not COMPRESSED/NODUMP, which
  FAT genuinely does not back.

* Set stat->attributes_mask |= KSTAT_ATTR_FS_IOC_FLAGS in
  fat_getattr(). Honest only to the extent that FAT now exposes
  some FS_*_FL bits via fileattr. This would silence the test
  failures, but advertises capabilities (COMPRESSED, NODUMP)
  FAT doesn't track.

* Admit the LTP statx04 test needs to be updated.
  FS_IOC_GETFLAGS succeeding does not logically imply all four
  FS_IOC_FLAGS-mapped STATX_ATTR_* bits are supported. The
  test's gate is too coarse for filesystems that gained a
  narrowly-scoped fileattr_get (just casefold/immutable). The
  test's tag list pins it to filesystems that do support the
  full set, but vfat was tacitly excluded by the prior ENOTTY.

The first option is the narrowest kernel-side change, and
matches what other minimal-fileattr filesystems do.


-- 
Chuck Lever
