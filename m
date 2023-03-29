Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3630C761A6
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Mar 2023 10:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjC2KiJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Mar 2023 06:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjC2Khn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2023 06:37:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B22B3;
        Wed, 29 Mar 2023 03:37:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AF186211E2;
        Wed, 29 Mar 2023 10:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680086260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fVZw6l+s3xo8LoDMVkg77+pEHxDFng3uIhUWOeoLLJs=;
        b=UVm06+mJ3D6Lv4RfQPYcINzGVTcXR3gTIlOVOuryMUe7xdByneR9RzutVnqHFei69RTciz
        MJOJOQlwTsBlnuq89tSuc9sRTLfXuGhKP0xdt0VM0tPMvXU6KKAIfaEVQw+EkU/nhTgCHn
        QBlwNL8/lodbxODP7J6m9mysQ3TsB+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680086260;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fVZw6l+s3xo8LoDMVkg77+pEHxDFng3uIhUWOeoLLJs=;
        b=FftWU/3sVrghvmxF+LbwPxVI9u2yqtfTy1g62yjqEIpyLxiQhFKRFUtKnj9OpYmT9zrb/c
        vkJbxA7aDa/wkNDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 72D82139D3;
        Wed, 29 Mar 2023 10:37:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RX+FGvQUJGRELgAAMHmgww
        (envelope-from <ddiss@suse.de>); Wed, 29 Mar 2023 10:37:40 +0000
Date:   Wed, 29 Mar 2023 12:39:17 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] generic/{251,260}: compute maximum fitrim offset
Message-ID: <20230329123917.7f436940@echidna.fritz.box>
In-Reply-To: <168005149047.4147931.2729971759269213680.stgit@frogsfrogsfrogs>
References: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
        <168005149047.4147931.2729971759269213680.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 28 Mar 2023 17:58:10 -0700, Darrick J. Wong wrote:

> From: Darrick J. Wong <djwong@kernel.org>
> 
> FITRIM is a bizarre ioctl.  Callers are allowed to pass in "start" and
> "length" parameters, which are clearly some kind of range argument.  No
> means is provided to discover the minimum or maximum range.  Although
> regular userspace programs default to (start=0, length=-1ULL), this test
> tries to exercise different parameters.
> 
> However, the test assumes that the "size" column returned by the df
> command is the maximum value supported by the FITRIM command, and is
> surprised if the number of bytes trimmed by (start=0, length=-1ULL) is
> larger than this size quantity.
> 
> This is completely wrong on XFS with realtime volumes, because the
> statfs output (which is what df reports) will reflect the realtime
> volume if the directory argument is a realtime file or a directory
> flagged with rtinherit.  This is trivially reproducible by configuring a
> rt volume that is much larger than the data volume, setting rtinherit on
> the root dir at mkfs time, and running either of these tests.
> 
> Refactor the open-coded df logic so that we can determine the value
> programmatically for XFS.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/rc         |   15 +++++++++++++++
>  common/xfs        |   11 +++++++++++
>  tests/generic/251 |    2 +-
>  tests/generic/260 |    2 +-
>  4 files changed, 28 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 90749343f3..228982fa4d 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3927,6 +3927,21 @@ _require_batched_discard()
>  	fi
>  }
>  
> +# Given a mountpoint and the device associated with that mountpoint, return the
> +# maximum start offset that the FITRIM command will accept, in units of 1024
> +# byte blocks.
> +_discard_max_offset_kb()
> +{
> +	case "$FSTYP" in
> +	xfs)
> +		_xfs_discard_max_offset_kb "$1"
> +		;;
> +	*)
> +		$DF_PROG -k | grep "$1" | grep "$2" | awk '{print $3}'
> +		;;

Might as well fix it to properly match full paths, e.g.
  $DF_PROG -k|awk '$1 == "'$dev'" && $7 == "'$mnt'" { print $3 }'

With this:
   Reviewed-by: David Disseldorp <ddiss@suse.de>

One other minor suggestion below...

> +	esac
> +}
> +
>  _require_dumpe2fs()
>  {
>  	if [ -z "$DUMPE2FS_PROG" ]; then
> diff --git a/common/xfs b/common/xfs
> index e8e4832cea..a6c82fc6c7 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1783,3 +1783,14 @@ _require_xfs_scratch_atomicswap()
>  		_notrun "atomicswap dependencies not supported by scratch filesystem type: $FSTYP"
>  	_scratch_unmount
>  }
> +
> +# Return the maximum start offset that the FITRIM command will accept, in units
> +# of 1024 byte blocks.
> +_xfs_discard_max_offset_kb()
> +{
> +	local path="$1"
> +	local blksz="$($XFS_IO_PROG -c 'statfs' "$path" | grep "geom.bsize" | cut -d ' ' -f 3)"
> +	local dblks="$($XFS_IO_PROG -c 'statfs' "$path" | grep "geom.datablocks" | cut -d ' ' -f 3)"
> +
> +	echo "$((dblks * blksz / 1024))"

This could be simplified a little:
 $XFS_IO_PROG -c 'statfs' "$path" \
   | awk '{g[$1] = $3} END {print (g["geom.bsize"] * g["geom.datablocks"] / 1024)}'

> +}
