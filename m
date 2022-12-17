Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BE5C3DA6E
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Dec 2022 08:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiLQIMB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Dec 2022 03:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLQIL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 03:11:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90B8DF7C;
        Sat, 17 Dec 2022 00:11:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ECFBB81094;
        Sat, 17 Dec 2022 08:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2F5C433EF;
        Sat, 17 Dec 2022 08:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671264715;
        bh=rGm/I0GLZg7QQEw1nj0S35bs1bj4fv0X48q610EsTVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YJmqYGyD2Qy67yG85i0TtL3YhOG0Tx0eXmdA7620Pomy0bt+wPxh+kIk5l/p5tILj
         h7lBJaXRZeZr/YjRL4chAw3vsU6/Ysq7PoMSiDgP/9wtOGxPeCoWa9O9VKtRZEwnK5
         L6RevDWnw1PjemBenZlL3ERjxh6vId9z4daTNBrIf+h8ggHaTLSlizjbNGFxusyo5w
         qoFFR61AFL0NhISgrYD0sJrOXRTqfn3Z+IvbvP0/RcyWWu/U7fA1ow6T6eAgRobJXu
         UCwHz6JiiEJGI5jsQ4CjVmcvWZWXJqn92kiSn2WZyCSQbWN05YrFjomnlEHSzltfew
         OSgDjqEPVeY9Q==
Date:   Sat, 17 Dec 2022 00:11:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] common/populate: move decompression code to
 _{xfs,ext4}_mdrestore
Message-ID: <Y515ygVyWFXL9t+u@magnolia>
References: <167096070957.1750373.5715692265711468248.stgit@magnolia>
 <167096072838.1750373.11954125201906427521.stgit@magnolia>
 <20221217065015.y64kcmznbv677ba2@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221217065015.y64kcmznbv677ba2@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 17, 2022 at 02:50:15PM +0800, Zorro Lang wrote:
> On Tue, Dec 13, 2022 at 11:45:28AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Move the metadump decompression code to the per-filesystem mdrestore
> > commands so that everyone can take advantage of them.  This enables the
> > XFS and ext4 _mdrestore helpers to handle metadata dumps compressed with
> > their respective _metadump helpers.
> > 
> > In turn, this means that the xfs fuzz tests can now handle the
> > compressed metadumps created by the _scratch_populate_cached helper.
> > This is key to unbreaking fuzz testing for xfs.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/ext4     |   13 ++++++++++++-
> >  common/fuzzy    |    2 +-
> >  common/populate |   15 ++-------------
> >  common/xfs      |   15 +++++++++++++--
> >  4 files changed, 28 insertions(+), 17 deletions(-)
> > 
> > 
> > diff --git a/common/ext4 b/common/ext4
> > index dc2e4e59cc..cadf1a7974 100644
> > --- a/common/ext4
> > +++ b/common/ext4
> > @@ -129,9 +129,20 @@ _ext4_mdrestore()
> >  {
> >  	local metadump="$1"
> >  	local device="$2"
> > -	shift; shift
> > +	local compressopt="$3"
> 
> I didn't see this variable is used in this function, do I missed something?

Oops.  I missed that this variable isn't necessary at all. :(

--D

> > +	shift; shift; shift
> >  	local options="$@"
> >  
> > +	# If we're configured for compressed dumps and there isn't already an
> > +	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
> > +	# something.
> > +	if [ ! -e "$metadump" ] && [ -n "$DUMP_COMPRESSOR" ]; then
> > +		for compr in "$metadump".*; do
> > +			[ -e "$compr" ] && $DUMP_COMPRESSOR -d -f -k "$compr" && break
> > +		done
> > +	fi
> > +	test -r "$metadump" || return 1
> > +
> >  	$E2IMAGE_PROG $options -r "${metadump}" "${SCRATCH_DEV}"
> >  }
> >  
> > diff --git a/common/fuzzy b/common/fuzzy
> > index fad79124e5..e634815eec 100644
> > --- a/common/fuzzy
> > +++ b/common/fuzzy
> > @@ -159,7 +159,7 @@ __scratch_xfs_fuzz_mdrestore()
> >  	test -e "${POPULATE_METADUMP}" || _fail "Need to set POPULATE_METADUMP"
> >  
> >  	__scratch_xfs_fuzz_unmount
> > -	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}"
> > +	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" compress
> >  }
> >  
> >  __fuzz_notify() {
> > diff --git a/common/populate b/common/populate
> > index f382c40aca..96866ee4cf 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -848,20 +848,9 @@ _scratch_populate_cache_tag() {
> >  _scratch_populate_restore_cached() {
> >  	local metadump="$1"
> >  
> > -	# If we're configured for compressed dumps and there isn't already an
> > -	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
> > -	# something.
> > -	if [ -n "$DUMP_COMPRESSOR" ]; then
> > -		for compr in "$metadump".*; do
> > -			[ -e "$compr" ] && $DUMP_COMPRESSOR -d -f -k "$compr" && break
> > -		done
> > -	fi
> > -
> > -	test -r "$metadump" || return 1
> > -
> >  	case "${FSTYP}" in
> >  	"xfs")
> > -		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
> > +		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" compress
> >  		res=$?
> >  		test $res -ne 0 && return $res
> >  
> > @@ -876,7 +865,7 @@ _scratch_populate_restore_cached() {
> >  		return $res
> >  		;;
> >  	"ext2"|"ext3"|"ext4")
> > -		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"
> > +		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}" compress
> >  		ret=$?
> >  		test $ret -ne 0 && return $ret
> >  
> > diff --git a/common/xfs b/common/xfs
> > index 216dab3bcd..833c2f4368 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -641,9 +641,20 @@ _xfs_metadump() {
> >  _xfs_mdrestore() {
> >  	local metadump="$1"
> >  	local device="$2"
> > -	shift; shift
> > +	local compressopt="$3"
> 
> I didn't see this variable is used in this function either.
> 
> > +	shift; shift; shift
> >  	local options="$@"
> >  
> > +	# If we're configured for compressed dumps and there isn't already an
> > +	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
> > +	# something.
> > +	if [ ! -e "$metadump" ] && [ -n "$DUMP_COMPRESSOR" ]; then
> > +		for compr in "$metadump".*; do
> > +			[ -e "$compr" ] && $DUMP_COMPRESSOR -d -f -k "$compr" && break
> > +		done
> > +	fi
> > +	test -r "$metadump" || return 1
> > +
> >  	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
> >  }
> >  
> > @@ -666,7 +677,7 @@ _scratch_xfs_mdrestore()
> >  	local metadump=$1
> >  	shift
> >  
> > -	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$@"
> > +	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" nocompress "$@"
> >  }
> >  
> >  # run xfs_check and friends on a FS.
> > 
> 
