Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A15C4708D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Dec 2022 18:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiLGSDz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Dec 2022 13:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLGSDz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2022 13:03:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BD55D68D
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2022 10:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670436179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mAUw8mr5gob9KRJvX/lopDofECYekDPnPXYYvZOjiaw=;
        b=BxOcl5RvP3j51Mnc4BWa9S6QqzIDCbwDf9N8WhkjeyztC98fVo0QJvNO9/3mH2AzrEm7fr
        3H5CQk8xILvlhtsaQiaKPCBEGgOleoKklziI4mAsMePcOM2Izv8aiXZb6Z1YbRmFNDr65B
        JnPkFpgNYHwCUKBHRsmHiaIe9ygPQfI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-Qj-YhTAFNiSlvkiBKvuTrw-1; Wed, 07 Dec 2022 13:02:58 -0500
X-MC-Unique: Qj-YhTAFNiSlvkiBKvuTrw-1
Received: by mail-pj1-f71.google.com with SMTP id mg21-20020a17090b371500b00219767e0175so14137851pjb.1
        for <linux-xfs@vger.kernel.org>; Wed, 07 Dec 2022 10:02:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mAUw8mr5gob9KRJvX/lopDofECYekDPnPXYYvZOjiaw=;
        b=O0Ha3DVKH26F2pg1CZShIocARG1mWYlEMqqfUJ+GbKo7MN36ihXfKnxv1CgKYI+Yqu
         +Kgos+pk724G9X4xmwRpWr/03/2tOqih4rji63goZCKub04nn63cClQMu+yESRbW0K1R
         7r9CMdZYUyTW8viw8r3gLFDhsMPfGS6XszdrWZoXSvXE7It0+FFGwjI9B3VXQHzscXnZ
         RCXTZhF9jgvQt/oWmM73drSbJqlZGRzfWXR941EPFrQYArOd+ViVQ29B7k/bBn6F6eEp
         pF2yMaPF0QLgQlmNFaUNOUNq1jYeauL0tx37HcK1vAl21G6eFj6p9MVb7J5VpEXAl0vz
         c/7g==
X-Gm-Message-State: ANoB5plTzgrfI4NqOqMvmq36vrym2eIPnx085xsHLj4589mqKmYfyIN1
        96LwY6Av0Tr0UEJ6XNOJGLnOx0X5m4MdxmCyAQWi06u322FLs3MPZQdWWS9X52AURSrShurosQ1
        8QgrEGdV0kH+JmOkOoRMO
X-Received: by 2002:a17:90a:fb92:b0:219:7a1e:e643 with SMTP id cp18-20020a17090afb9200b002197a1ee643mr880150pjb.9.1670436177319;
        Wed, 07 Dec 2022 10:02:57 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5R/SV86CymtgER73xU79VBUD+kCPQmx8Bcw/mX+h94Zbk2r5SiIQNSGAep7+7jjnqrx6tjOA==
X-Received: by 2002:a17:90a:fb92:b0:219:7a1e:e643 with SMTP id cp18-20020a17090afb9200b002197a1ee643mr880145pjb.9.1670436176933;
        Wed, 07 Dec 2022 10:02:56 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n8-20020a17090a2bc800b002193f87fb4asm1486191pje.4.2022.12.07.10.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 10:02:56 -0800 (PST)
Date:   Thu, 8 Dec 2022 02:02:51 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, hsiangkao@linux.alibaba.com,
        allison.henderson@oracle.com
Subject: Re: [PATCH V3 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Message-ID: <20221207180251.fze2vdavljchgvbt@zlang-mailbox>
References: <20221206100517.1369625-1-ZiyangZhang@linux.alibaba.com>
 <20221206100517.1369625-3-ZiyangZhang@linux.alibaba.com>
 <Y498Ej35Bf9Oi6Wx@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y498Ej35Bf9Oi6Wx@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 06, 2022 at 09:29:54AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 06, 2022 at 06:05:17PM +0800, Ziyang Zhang wrote:
> > Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
> > S_IFDIR.FMT_BTREE could become btree format for its DATA fork.
> > 
> > Actually we just observed it can fail after apply our inode
> > extent-to-btree workaround. The root cause is that the kernel may be
> > too good at allocating consecutive blocks so that the data fork is
> > still in extents format.
> > 
> > Therefore instead of using a fixed number, let's make sure the number
> > of extents is large enough than (inode size - inode core size) /
> > sizeof(xfs_bmbt_rec_t).
> > 
> > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> > Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> > ---
> >  common/populate | 28 +++++++++++++++++++++++++++-
> >  common/xfs      |  9 +++++++++
> >  2 files changed, 36 insertions(+), 1 deletion(-)
> > 
> > diff --git a/common/populate b/common/populate
> > index 6e004997..1ca76459 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -71,6 +71,31 @@ __populate_create_dir() {
> >  	done
> >  }
> >  
> > +# Create a large directory and ensure that it's a btree format
> > +__populate_xfs_create_btree_dir() {
> > +	local name="$1"
> > +	local isize="$2"
> > +	local icore_size="$(_xfs_inode_core_bytes)"
> > +	# We need enough extents to guarantee that the data fork is in
> > +	# btree format.  Cycling the mount to use xfs_db is too slow, so
> > +	# watch for when the extent count exceeds the space after the
> > +	# inode core.
> > +	local max_nextents="$(((isize - icore_size) / 16))"
> > +
> > +	mkdir -p "${name}"
> > +	d=0
> > +	while true; do
> > +		creat=mkdir
> > +		test "$((d % 20))" -eq 0 && creat=touch
> > +		$creat "${name}/$(printf "%.08d" "$d")"
> > +		if [ "$((d % 40))" -eq 0 ]; then
> > +			nextents="$(_xfs_get_fsxattr nextents $name)"
> > +			[ $nextents -gt $max_nextents ] && break
> > +		fi
> > +		d=$((d+1))
> > +	done
> > +}
> > +
> >  # Add a bunch of attrs to a file
> >  __populate_create_attr() {
> >  	name="$1"
> > @@ -176,6 +201,7 @@ _scratch_xfs_populate() {
> >  
> >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> >  	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> > +	isize="$(_xfs_inode_size "$SCRATCH_MNT")"
> >  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
> >  	if [ $crc -eq 1 ]; then
> >  		leaf_hdr_size=64
> > @@ -226,7 +252,7 @@ _scratch_xfs_populate() {
> >  
> >  	# - BTREE
> >  	echo "+ btree dir"
> > -	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
> > +	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize"
> 
> The new helper function omits the "missing" parameter, which means that
> it no longer creates the directory entry blocks with a lot of free space
> in them, unlike current TOT.

Hi Ziyang,

Is there any reason we must drop this "missing" step. If no special reason, I'd
like to keep the original operation (the missing parameter is "true") to free
some space sparsely. I think that only removes some entries, won't remove the
dir-blocks (generally), so it won't affect the btree format you create.

Thanks,
Zorro

> 
> --D
> 
> >  
> >  	# Symlinks
> >  	# - FMT_LOCAL
> > diff --git a/common/xfs b/common/xfs
> > index 5180b9d3..744f0040 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -1487,6 +1487,15 @@ _require_xfsrestore_xflag()
> >  			_notrun 'xfsrestore does not support -x flag.'
> >  }
> >  
> > +# Number of bytes reserved for a full inode record, which includes the
> > +# immediate fork areas.
> > +_xfs_inode_size()
> > +{
> > +	local mntpoint="$1"
> > +
> > +	$XFS_INFO_PROG "$mntpoint" | grep 'meta-data=.*isize' | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g'
> > +}
> > +
> >  # Number of bytes reserved for only the inode record, excluding the
> >  # immediate fork areas.
> >  _xfs_inode_core_bytes()
> > -- 
> > 2.18.4
> > 
> 

