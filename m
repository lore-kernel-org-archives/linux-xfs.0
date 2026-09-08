Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03EB50AC03;
	Tue,  8 Sep 2026 10:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863164; cv=none; b=Zu4NEw/SQhuUpVcn7KDQwAWwOEH31DrpuFbfWff0V/WtdTTt6RL5L3A8B3CZ7jR3FfS2tAgFeaRO4tBKg4JcYXNy9QE3SzkAdxxNZ8/XnzZa9VqDvYRyQXW6N4KG2Kck/o5dBG7+L/kX+K/XSO/59jJFw5Lmqf+W9DYGHOUDJiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863164; c=relaxed/simple;
	bh=kj8+rr3XsvevpmwaEHchFcZsnsbkCeg6AeWTZ7KEBiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LF47tgLNN02N0n3iCHGJv6DettRDyNGyQqQmXZAkpVEm7uEJL11DnYMpLaa5/v5nssCJ4+qWd2uTZWYalxiQAOLNj+J6gXQB3SMjYoiyzQUWc0fUot/h7IViK3+8WPi77JZP14CM2WoO84g50ftz7u849tzIXNpMGq7/mPFbsIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uJFDxLXA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OFfKr48x; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VTlBUETL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=82G4fWuP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uJFDxLXA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OFfKr48x";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VTlBUETL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="82G4fWuP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7CF5621A0A;
	Tue,  8 Sep 2026 10:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788863156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWD7Ln/F+2C9HZbAZUN+8f83ZRprJd/wvmSWmBxQkYI=;
	b=uJFDxLXA5DbAYlDoeSveMh87fjVzq1bmvjs1NDUJi1cc6w+wQ5F5YVxf6W/Epck6jT0g8U
	NNyyhz2EVt6h2WwNngOo5teCHvQ3O8yoPv3psWfpiJDgvcjx8DSyfuZZptvn66VBJkyFKh
	6UpLSZIH6XgfU6ZffqPeKwBPl9GN8Fs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788863156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWD7Ln/F+2C9HZbAZUN+8f83ZRprJd/wvmSWmBxQkYI=;
	b=OFfKr48xkS9b/ohjwQbtGXNntopkYLGqdnceoRD/9awnrcwmIO64v/gC7b/GYCzQrDSje5
	oUKHj3yOvVKmFQBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VTlBUETL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=82G4fWuP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788863152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWD7Ln/F+2C9HZbAZUN+8f83ZRprJd/wvmSWmBxQkYI=;
	b=VTlBUETL/4Ph5cXA8nR5ca9UeAn9s/kK2t5IsyEBqLrbNi4LGDx1do550Uf8p0gczyOF/t
	q9lNBZjtHPLlGCMuYmUGVk1ommhqF8cf+gBgDRT+ueZ3iHYSwjTNBWgzs3oywle3FBOwg+
	HhQdHuk5vPP6xW9EBb/O3FOM9Lf7zQY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788863152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWD7Ln/F+2C9HZbAZUN+8f83ZRprJd/wvmSWmBxQkYI=;
	b=82G4fWuPi9H5SXLFe71vbkiqeDMQQdZ0RWhnF2iyB3xzODAJPqbQOWOAc1LOU6JJDjf0wg
	h4yq1+j8J5iCFxAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5BFA01347F;
	Tue,  8 Sep 2026 10:25:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3ddwFrDin2rFFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 08 Sep 2026 10:25:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E385CA12E2; Tue, 08 Sep 2026 12:25:36 +0200 (CEST)
Date: Tue, 8 Sep 2026 12:25:36 +0200
From: Jan Kara <jack@suse.cz>
To: cem@kernel.org
Cc: zlang@kernel.org, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org, jack@suse.cz
Subject: Re: [RFC PATCH 2/2] generic: add test for quota enforcement via a
 nfs share
Message-ID: <c4fsyxsecb23xpvxcqrahn3s6rhy7vewhic36mcop7fdonav4q@ni6t7yv5fkhx>
References: <20260907164054.111393-1-cem@kernel.org>
 <20260907164054.111393-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907164054.111393-3-cem@kernel.org>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 7CF5621A0A
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,suse.com:email];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Mon 07-09-26 18:40:48, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This tests the quota enforcement when changing the group of a file via a
> NFS share, caused by mishandling of capabilities check.
> This initially has been found with a XFS filesystem backing the NFS
> share, but this still possible to occur on a different filesystem if it
> happens to also mishandle capabilities check.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  tests/generic/803     | 106 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/803.out |   2 +
>  2 files changed, 108 insertions(+)
>  create mode 100755 tests/generic/803
>  create mode 100644 tests/generic/803.out
> 
> diff --git a/tests/generic/803 b/tests/generic/803
> new file mode 100755
> index 000000000000..ab889466d80f
> --- /dev/null
> +++ b/tests/generic/803
> @@ -0,0 +1,106 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Red Hat.  All Rights Reserved.
> +#
> +# FS QA Test No. 803
> +#
> +# Regression test for group quota evasion via NFS.
> +#
> +# A user belonging to two groups with quotas enforced on both could bypass
> +# group quota by changing a file's group via an NFS client. The NFS server
> +# runs as root (real credentials) but impersonates the client user via
> +# override_creds() (effective credentials). The old code used
> +# has_capability_noaudit(), which checks real credentials, causing
> +# XFS_QMOPT_FORCE_RES to be set and bypassing quota checks.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick quota
> +
> +_cleanup()
> +{
> +	cd /
> +	[ -n "$mpoint" ] && $UMOUNT_PROG $mpoint 2>/dev/null
> +	sleep 2
> +	[ -n "$exportdir" ] && exportfs -u 127.0.0.1:$exportdir 2>/dev/null
> +	_stop_rpcbind
> +	$added_to_fsgqa2 && gpasswd -d fsgqa fsgqa2 >> $seqres.full 2>&1
> +	rm -rf $tmp.* $mpoint
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/quota
> +. ./common/nfs
> +
> +_require_scratch
> +_require_quota
> +_require_user
> +_require_group fsgqa2
> +_require_nfs_server
> +_require_nfs_client
> +
> +_fixed_by_kernel_commit e2f62a9744ebad3bcb6347a648e615026e9efeff \
> +	"xfs: fix capability check in xfs"
> +
> +added_to_fsgqa2=false
> +
> +_qmount_option "usrquota,grpquota"
> +_scratch_mkfs >> $seqres.full 2>&1
> +_qmount
> +
> +# Ensure fsgqa belongs to both fsgqa and fsgqa2 groups.
> +if ! id fsgqa | grep -qw fsgqa2; then
> +	gpasswd -a fsgqa fsgqa2 >> $seqres.full 2>&1 || \
> +		_notrun "Cannot add fsgqa to fsgqa2 group"
> +	added_to_fsgqa2=true
> +fi
> +
> +exportdir=$SCRATCH_MNT/exportdir
> +mpoint=$TEST_DIR/mpoint-$seq
> +nfs_userdir=$mpoint/userdir
> +
> +mkdir -p $exportdir/userdir $mpoint
> +chown fsgqa:fsgqa $exportdir/userdir
> +
> +setquota -g fsgqa  0 2048 0 0 $SCRATCH_MNT
> +setquota -g fsgqa2 0 4096 0 0 $SCRATCH_MNT
> +
> +# Use exportfs directly so we don't need to deal with /etc/exports file
> +exportfs -o rw,insecure,no_root_squash,sync 127.0.0.1:$exportdir \
> +	>> $seqres.full 2>&1 || _fail "NFS export of $exportdir failed"
> +mount -t nfs -o vers=4 127.0.0.1:$exportdir $mpoint \
> +	>> $seqres.full 2>&1 || _fail "NFS mount of $exportdir at $mpoint failed"
> +
> +# Write a 2MiB file via the NFS share as fsgqa, filling the fsgqa group quota.
> +_su fsgqa -c "dd if=/dev/zero of=$nfs_userdir/file1 bs=1M count=2 conv=fsync" \
> +	>> $seqres.full 2>&1
> +
> +# Confirm we hit fsgqa group quota limit, a second write must fail.
> +_su fsgqa -c "dd if=/dev/zero of=$nfs_userdir/verify bs=1M count=1 conv=fsync" \
> +	>> $seqres.full 2>&1 \
> +	&& _fail "fsgqa group quota not enforced after writing 2MiB"
> +rm -f $nfs_userdir/verify
> +
> +# Change file1 group to fsgqa2 using the NFS share.
> +_su fsgqa -c "chgrp fsgqa2 $nfs_userdir/file1" \
> +	|| _fail "chgrp of file1 to fsgqa2 failed unexpectedly"
> +
> +# Write a second 2MiB file via NFS as fsgqa.
> +_su fsgqa -c "dd if=/dev/zero of=$nfs_userdir/file2 bs=1M count=2 conv=fsync" \
> +	>> $seqres.full 2>&1
> +
> +# Change file2 to group fsgqa2 via using the NFS share.
> +_su fsgqa -c "chgrp fsgqa2 $nfs_userdir/file2" \
> +	|| _fail "chgrp of file2 to fsgqa2 failed unexpectedly"
> +
> +# Write a third 2MiB file via the NFS share as fsgqa.
> +_su fsgqa -c "dd if=/dev/zero of=$nfs_userdir/file3 bs=1M count=2 conv=fsync" \
> +	>> $seqres.full 2>&1
> +
> +# This chgrp must fail: fsgqa2 is at its 4MiB hardlimit.
> +_user_do "chgrp fsgqa2 $nfs_userdir/file3" | \
> +	sed "s|$nfs_userdir|MPOINT/userdir|g"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/803.out b/tests/generic/803.out
> new file mode 100644
> index 000000000000..3830b8595793
> --- /dev/null
> +++ b/tests/generic/803.out
> @@ -0,0 +1,2 @@
> +QA output created by 803
> +chgrp: changing group of 'MPOINT/userdir/file3': Disk quota exceeded
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
