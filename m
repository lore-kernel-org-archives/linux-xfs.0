Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1587611718;
	Mon, 29 Jan 2024 04:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706500983; cv=none; b=I8eoRchlE4c9Zhu/bWPXg88F1e9+kzgaoNA0KAwLzhYSprHNQfyVepxFLeR7tfzQTw7kptbunxqOP56rNxyRxkh7mOzrkamqKjXDMJr0v8MduBhVFJjj4xoBA6s5yXKClSZFmwakI7hp/26qoVdfIk01a8ADI4zSFs20uHzHqq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706500983; c=relaxed/simple;
	bh=YT2RWbXxaBiXyuyzShGyHz64yql/pjo1Q3CoTYnSzN0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qa1ilo6Q4sHOORGna7YBHcVFhJNDTTnyHZfpvi62SPnRnBC3LnXkwew1Br9tBdMFpHM5P4KeBLzUUl88/NhWm6mrclBKREFTXRFyxJY0kZihdKVVAKsqYgxqTzQ0u1PJZMxRY1xokI38fB85zKViNxZ3nx5JrV9cNddjD4hYhV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a/ka+RqE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eWGAvAGd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a/ka+RqE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eWGAvAGd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a/ka+RqE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eWGAvAGd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a/ka+RqE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eWGAvAGd"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 15AF41F7CD;
	Mon, 29 Jan 2024 04:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706500980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1sx+GOHSFluGUk5NZr+VeRBJMNBf6sjx/2I/jGHwB4Y=;
	b=a/ka+RqEeP6D0sDWMBVWAMEoPQQauKvyQhPXemozt+kJWKZ3e/M68wuC+AgkSICyl7QM0g
	6Roqbz32cHrq+6H4gvK2zkSnAfL/CnBVny3czQ1zfst1hSWlS4hVTFq1TvS8+vsS0LBzkl
	EVr7KEc/wQ+ZNo2UWEkWx/Q4q95nOmE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706500980;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1sx+GOHSFluGUk5NZr+VeRBJMNBf6sjx/2I/jGHwB4Y=;
	b=eWGAvAGdhkRRhZMjKd25lgpiWo6EgQ052kJCVQBmq0IO6uIqkfwTPgAF1UsDuP0P3eOcJv
	Ur3nPVN8/5WZ+CBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706500980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1sx+GOHSFluGUk5NZr+VeRBJMNBf6sjx/2I/jGHwB4Y=;
	b=a/ka+RqEeP6D0sDWMBVWAMEoPQQauKvyQhPXemozt+kJWKZ3e/M68wuC+AgkSICyl7QM0g
	6Roqbz32cHrq+6H4gvK2zkSnAfL/CnBVny3czQ1zfst1hSWlS4hVTFq1TvS8+vsS0LBzkl
	EVr7KEc/wQ+ZNo2UWEkWx/Q4q95nOmE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706500980;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1sx+GOHSFluGUk5NZr+VeRBJMNBf6sjx/2I/jGHwB4Y=;
	b=eWGAvAGdhkRRhZMjKd25lgpiWo6EgQ052kJCVQBmq0IO6uIqkfwTPgAF1UsDuP0P3eOcJv
	Ur3nPVN8/5WZ+CBA==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A72B13428;
	Mon, 29 Jan 2024 04:02:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id XC4pC3Ijt2UGBQAAn2gu4w
	(envelope-from <ddiss@suse.de>); Mon, 29 Jan 2024 04:02:58 +0000
Date: Mon, 29 Jan 2024 15:02:47 +1100
From: David Disseldorp <ddiss@suse.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test xfs_growfs with too-small size expansion
Message-ID: <20240129150247.54c7a27a@echidna>
In-Reply-To: <20240128155653.1533493-1-zlang@kernel.org>
References: <20240128155653.1533493-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="a/ka+RqE";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eWGAvAGd
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 15AF41F7CD
X-Spam-Flag: NO

Looks fine.
Reviewed-by: David Disseldorp <ddiss@suse.de>

A couple of minor comments below...

On Sun, 28 Jan 2024 23:56:53 +0800, Zorro Lang wrote:

> This's a regression test of 84712492e6da ("xfs: short circuit
> xfs_growfs_data_private() if delta is zero").
> 
> If try to do growfs with "too-small" size expansion, might lead to a
> delta of "0" in xfs_growfs_data_private(), then end up in the shrink
> case and emit the EXPERIMENTAL warning even if we're not changing
> anything at all.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  tests/xfs/999     | 53 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |  2 ++
>  2 files changed, 55 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..09192ba3
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,53 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 999

I'll assume 999 is just a placeholder...

> +#
> +# Test xfs_growfs with "too-small" size expansion, which lead to a delta of "0"
> +# in xfs_growfs_data_private. This's a regression test of 84712492e6da ("xfs:
> +# short circuit xfs_growfs_data_private() if delta is zero").
> +#
> +. ./common/preamble
> +_begin_fstest auto quick growfs
> +
> +_cleanup()
> +{
> +	local dev
> +        $UMOUNT_PROG $LOOP_MNT 2>/dev/null
> +	dev=$(losetup -j testfile | cut -d: -f1)
> +	losetup -d $dev 2>/dev/null
> +        rm -rf $LOOP_IMG $LOOP_MNT
> +        cd /
> +        rm -f $tmp.*

nit: tabs and spaces mixed above

> +}
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_fixed_by_kernel_commit 84712492e6da \
> +	"xfs: short circuit xfs_growfs_data_private() if delta is zero"
> +_require_test
> +_require_loop
> +_require_xfs_io_command "truncate"

nit: it doesn't seem common for growfs, but you might want to add a:
  _require_command "$XFS_GROWFS_PROG" xfs_growfs
