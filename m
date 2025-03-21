Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851C522B59D
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 16:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742573203; cv=none; b=vBvREGl9Su4rt3U5t+3Qq+Hkbtfe5IeKy3mghfY/u8p6PO9+e29QG+nEGIRtxCiQPgWlr33gx0oiUOyMVXvi4b9qkivYQC290+f0gb1euEeJtaYPp0BYwn2KtQAoDfFglnJ/CY4AxZwcE1mueRwPOmACi//IANNzp3qvG5nNugk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742573203; c=relaxed/simple;
	bh=ahY4abLue51VxkXlLtMob+uYZr8ai96AYh+dNPFB9uw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvSLJCvbJaQm4IDNJ13pruzrHxoREf/KHuy3mtGVEzxjicSZEqma2lw8UtjeL1NosaZUmVbQsXfVhgDv/RZEMvePAJtjpi7UW7un3rGHqj+ccNIm1Ox+aHRz+G+3wCjvx4qmUINAcntNwOdYf+pLy5P+7nFuCvSFLOPX8koxk1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XSp1rcSm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OvA/MwW/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XSp1rcSm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OvA/MwW/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XSp1rcSm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OvA/MwW/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XSp1rcSm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OvA/MwW/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 807EA1FFEE;
	Fri, 21 Mar 2025 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742573199;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3CTCY0h6d9AbypbdJg33nHngpxZ1CJkB8gNAGQR5ZRQ=;
	b=XSp1rcSmEfTL6fPSTuYkuf94lUcNgyaTsptbSZXODxeeT8uaO5hlOBmWWV61FhuKlx7ZEn
	I+earJ5IMq0j94Wc9txq+88ZHqgfApkuBx0VkKZBlJDzkDKR8+l6/cUoVwDbLOLt02GTk0
	zeCAU63AHR2pTL7xkOliUFxEyG7EtfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742573199;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3CTCY0h6d9AbypbdJg33nHngpxZ1CJkB8gNAGQR5ZRQ=;
	b=OvA/MwW/TvapM4+jMjPvEyxiT0jNd517QdxHUS49d08QOnkj3cWDO+hvyfi/nealJNyY/z
	kY666jXeWbWT0PCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XSp1rcSm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="OvA/MwW/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742573199;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3CTCY0h6d9AbypbdJg33nHngpxZ1CJkB8gNAGQR5ZRQ=;
	b=XSp1rcSmEfTL6fPSTuYkuf94lUcNgyaTsptbSZXODxeeT8uaO5hlOBmWWV61FhuKlx7ZEn
	I+earJ5IMq0j94Wc9txq+88ZHqgfApkuBx0VkKZBlJDzkDKR8+l6/cUoVwDbLOLt02GTk0
	zeCAU63AHR2pTL7xkOliUFxEyG7EtfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742573199;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3CTCY0h6d9AbypbdJg33nHngpxZ1CJkB8gNAGQR5ZRQ=;
	b=OvA/MwW/TvapM4+jMjPvEyxiT0jNd517QdxHUS49d08QOnkj3cWDO+hvyfi/nealJNyY/z
	kY666jXeWbWT0PCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 221E413A2C;
	Fri, 21 Mar 2025 16:06:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mgvFBo+O3WcAIQAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Fri, 21 Mar 2025 16:06:39 +0000
Date: Fri, 21 Mar 2025 17:06:33 +0100
From: Petr Vorel <pvorel@suse.cz>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ltp@lists.linux.it, Li Wang <liwang@redhat.com>,
	Cyril Hrubis <chrubis@suse.cz>,
	Andrea Cervesato <andrea.cervesato@suse.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Allison Collins <allison.henderson@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Gao Xiang <hsiangkao@redhat.com>,
	Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] ioctl_ficlone03: Require 5.10 for XFS
Message-ID: <20250321160633.GA177324@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20250321100320.162107-1-pvorel@suse.cz>
 <20250321152358.GK2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321152358.GK2803749@frogsfrogsfrogs>
X-Rspamd-Queue-Id: 807EA1FFEE
X-Spam-Level: 
X-Spamd-Result: default: False [-3.71 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	HAS_REPLYTO(0.30)[pvorel@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[lists.linux.it,redhat.com,suse.cz,suse.com,oracle.com,gmail.com,lst.de,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.71
X-Spam-Flag: NO

> On Fri, Mar 21, 2025 at 11:03:20AM +0100, Petr Vorel wrote:
> > Test fails on XFS on kernel older than 5.10:

> >     # ./ioctl_ficlone03
> > 	...
> >     tst_test.c:1183: TINFO: Mounting /dev/loop0 to /tmp/LTP_ioc6ARHZ7/mnt fstyp=xfs flags=0
> >     [   10.122070] XFS (loop0): Superblock has unknown incompatible features (0x8) enabled.

> 0x8 is XFS_SB_FEAT_INCOMPAT_BIGTIME, maybe you need to format with a set
> of filesystem features compatible with 5.10?

> # mkfs.xfs -c options=/usr/share/xfsprogs/mkfs/lts_5.10.conf /dev/sda1

Yes, XFS_SB_FEAT_INCOMPAT_BIGTIME is what is missing for the test. Device is
formatted with: -m reflink=1 (I'm sorry to not posting this before):

tst_test.c:1170: TINFO: Formatting /dev/loop0 with xfs opts='-m reflink=1' extra opts=''

I thought it would imply XFS_SB_FEAT_INCOMPAT_BIGTIME, but when I tried to remove it
it did not help:

tst_test.c:1909: TINFO: Tested kernel: 5.0.21-00005-gb6c47615d7bf #211 SMP Fri Mar 21 12:23:18 CET 2025 x86_64
...
tst_test.c:1833: TINFO: === Testing on xfs ===
tst_cmd.c:281: TINFO: Parsing mkfs.xfs version
tst_test.c:1170: TINFO: Formatting /dev/loop0 with xfs opts='' extra opts=''
tst_test.c:1183: TINFO: Mounting /dev[   75.418676] XFS (loop0): Superblock has unknown incompatible features (0x8) enabled.
/loop0 to /tmp/L[   75.419683] XFS (loop0): Filesystem cannot be safely mounted by this kernel.
TP_iocO8VAIk/mnt[   75.420629] XFS (loop0): SB validate failed with error -22.
 fstyp=xfs flags=0
tst_test.c:1183: TBROK: mount(/dev/loop0, mnt, xfs, 0, (nil)) failed: EINVAL (22)

Well, I tried with mkfs.xfs from openSUSE Leap 15.6 (tested via rapido-linux),
probably the defaults add it.

$ mkfs.xfs -V
mkfs.xfs version 6.7.0

Also I noted that test works on our 5.3.18 based SLES15-SP2 with xfsprogs
4.15.0. Maybe I'm just wasting your time with wrong patch.

Kind regards,
Petr

> --D

> >     [   10.123035] XFS (loop0): Filesystem cannot be safely mounted by this kernel.
> >     [   10.123916] XFS (loop0): SB validate failed with error -22.
> >     tst_test.c:1183: TBROK: mount(/dev/loop0, mnt, xfs, 0, (nil)) failed: EINVAL (22)

> > This also causes Btrfs testing to be skipped due TBROK on XFS. With increased version we get on 5.4 LTS:

> >     # ./ioctl_ficlone03
> >     tst_test.c:1904: TINFO: Tested kernel: 5.4.291 #194 SMP Fri Mar 21 10:18:02 CET 2025 x86_64
> >     ...
> >     tst_supported_fs_types.c:49: TINFO: mkfs is not needed for tmpfs
> >     tst_test.c:1833: TINFO: === Testing on xfs ===
> >     tst_cmd.c:281: TINFO: Parsing mkfs.xfs version
> >     tst_test.c:969: TCONF: The test requires kernel 5.10 or newer
> >     tst_test.c:1833: TINFO: === Testing on btrfs ===
> >     tst_test.c:1170: TINFO: Formatting /dev/loop0 with btrfs opts='' extra opts=''
> >     [   30.143670] BTRFS: device fsid 1a6d250c-0636-11f0-850f-c598bdcd84c4 devid 1 transid 6 /dev/loop0
> >     tst_test.c:1183: TINFO: Mounting /dev/loop0 to /tmp/LTP_iocjwzyal/mnt fstyp=btrfs flags=0
> >     [   30.156563] BTRFS info (device loop0): using crc32c (crc32c-generic) checksum algorithm
> >     [   30.157363] BTRFS info (device loop0): flagging fs with big metadata feature
> >     [   30.158061] BTRFS info (device loop0): using free space tree
> >     [   30.158620] BTRFS info (device loop0): has skinny extents
> >     [   30.159911] BTRFS info (device loop0): enabling ssd optimizations
> >     [   30.160652] BTRFS info (device loop0): checking UUID tree
> >     ioctl_ficlone03_fix.c:49: TPASS: invalid source : EBADF (9)
> >     ioctl_ficlone03_fix.c:55: TPASS: invalid source : EBADF (9)

> > Fixing commit is 29887a2271319 ("xfs: enable big timestamps").

> > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > ---
> > Hi all,

> > I suppose we aren't covering a test bug with this and test is really
> > wrong expecting 4.16 would work on XFS. FYI this affects 5.4.291
> > (latest 5.4 LTS which is still supported) and would not be fixed due a
> > lot of missing functionality from 5.10.

> > Kind regards,
> > Petr

> >  testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)

> > diff --git a/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c b/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
> > index 6a9d270d9f..e2ab10cba1 100644
> > --- a/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
> > +++ b/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
> > @@ -113,7 +113,7 @@ static struct tst_test test = {
> >  		{.type = "bcachefs"},
> >  		{
> >  			.type = "xfs",
> > -			.min_kver = "4.16",
> > +			.min_kver = "5.10",
> >  			.mkfs_ver = "mkfs.xfs >= 1.5.0",
> >  			.mkfs_opts = (const char *const []) {"-m", "reflink=1", NULL},
> >  		},
> > -- 
> > 2.47.2


