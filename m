Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8707CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Dec 2022 15:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLJPtY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 10 Dec 2022 10:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLJPtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Dec 2022 10:49:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0C7FAE8
        for <linux-xfs@vger.kernel.org>; Sat, 10 Dec 2022 07:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670687307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iuJ9A/gY3J5YkbOFP3dDSzitByWWfHJ2BOP16ILAS38=;
        b=TzMobYFrzR4eY6D+FMrjTSPPfcw7SRwbFTGfILj5NiFuWE0PvsIa5cZIqE3IVTk97ceWDn
        PjNgoi0ZsQUffI1dGO6wEHkfobuGcJf1tl8WFe0R1Hknfw6be36gm/lG1YGZ7omz6cLynA
        WIUhoSgYrbSAOdOkUF33oKMDI7IOySQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-211-KROSVVPQNxuUU0meAfYQkw-1; Sat, 10 Dec 2022 10:48:26 -0500
X-MC-Unique: KROSVVPQNxuUU0meAfYQkw-1
Received: by mail-pl1-f197.google.com with SMTP id n5-20020a170902d2c500b00189e5b86fe2so6587376plc.16
        for <linux-xfs@vger.kernel.org>; Sat, 10 Dec 2022 07:48:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iuJ9A/gY3J5YkbOFP3dDSzitByWWfHJ2BOP16ILAS38=;
        b=D+casaX7z5wEdoqURuCccevJZE0YTA3dSigpXwG9skfG6iHR8PyIfcOoG0y7NBPua5
         rUOUxKPSY0IpioLDMB4v7FCIO/QMbfDzkrCzwklhzXMQhhqvcXf8SKtpbZSf8407L+PD
         AW1wiYAooAHtG9SKDrCyXpIz4eAVNzCRZ4I1AlJ11v+9wlI2OFm+2/63O4BSoIB4Pfme
         oKY6398UPKBsCVLmG5ozuHMwzu3MSzWCc2HRGtyvR5e1TNWg3wq8Am2Kw5Pm60TCeX7M
         Zzlc3hBDnY5rk+2zMFolyZVF6u6TbLMiH/KtGQuaQqi0UAvcC4dZ4nx9PALFfVhUCbWM
         0oVw==
X-Gm-Message-State: ANoB5pnoBNVBLpWLiy692VcfVx/grJlPTtSVDNmtv0Y8KBd0AlJV1o73
        yM0cy3jXl/LsGu+9ReqzHmkn9MbQhepRxqVTdlzaXIA3n2hXIrmkONhl++nxJWyAFv0CIqpI8Kl
        LwSgAKIOA0YJ6jkOJYeky
X-Received: by 2002:a05:622a:5987:b0:3a7:f7c1:5b65 with SMTP id gb7-20020a05622a598700b003a7f7c15b65mr15817210qtb.40.1670682478330;
        Sat, 10 Dec 2022 06:27:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6i/5AYSjVByw3CA0BzavanEHjmQiJcweNQXd2G1tRqPY3va/b+c2dkTISlprC+mqFvc6Grng==
X-Received: by 2002:a17:903:40cd:b0:18e:5710:eef3 with SMTP id t13-20020a17090340cd00b0018e5710eef3mr1144517pld.47.1670680649514;
        Sat, 10 Dec 2022 05:57:29 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ik28-20020a170902ab1c00b0017d97d13b18sm3051601plb.65.2022.12.10.05.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 05:57:28 -0800 (PST)
Date:   Sat, 10 Dec 2022 21:57:24 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        hsiangkao@linux.alibaba.com
Subject: Re: [PATCH V5 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Message-ID: <20221210135724.owsxdqiirtkqsv6e@zlang-mailbox>
References: <20221208072843.1866615-1-ZiyangZhang@linux.alibaba.com>
 <20221208072843.1866615-3-ZiyangZhang@linux.alibaba.com>
 <Y5NkVRNhQgZpWNMj@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5NkVRNhQgZpWNMj@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 09, 2022 at 08:37:41AM -0800, Darrick J. Wong wrote:
> On Thu, Dec 08, 2022 at 03:28:43PM +0800, Ziyang Zhang wrote:
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
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> > Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> > ---
> >  common/populate | 34 +++++++++++++++++++++++++++++++++-
> >  common/xfs      |  9 +++++++++
> >  2 files changed, 42 insertions(+), 1 deletion(-)
> > 
> > diff --git a/common/populate b/common/populate
> > index 6e004997..0d334a13 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -71,6 +71,37 @@ __populate_create_dir() {
> >  	done
> >  }
> >  
> > +# Create a large directory and ensure that it's a btree format
> > +__populate_xfs_create_btree_dir() {
> > +	local name="$1"
> > +	local isize="$2"
> > +	local missing="$3"
> > +	local icore_size="$(_xfs_inode_core_bytes)"
> 
> Doesn't this helper require a path argument now?

What kind of "path" argument? I think he copy it from __populate_create_dir(),
and keep using the "name" as the root path to create files/dir.

> 
> --D
> 
> > +	# We need enough extents to guarantee that the data fork is in
> > +	# btree format.  Cycling the mount to use xfs_db is too slow, so
> > +	# watch for when the extent count exceeds the space after the
> > +	# inode core.
> > +	local max_nextents="$(((isize - icore_size) / 16))"
> > +	local nr=0
> > +
> > +	mkdir -p "${name}"
> > +	while true; do
> > +		local creat=mkdir
> > +		test "$((nr % 20))" -eq 0 && creat=touch
> > +		$creat "${name}/$(printf "%.08d" "$nr")"
> > +		if [ "$((nr % 40))" -eq 0 ]; then
> > +			local nextents="$(_xfs_get_fsxattr nextents $name)"
> > +			[ $nextents -gt $max_nextents ] && break
> > +		fi
> > +		nr=$((nr+1))
> > +	done
> > +
> > +	test -z "${missing}" && return
> > +	seq 1 2 "${nr}" | while read d; do
> > +		rm -rf "${name}/$(printf "%.08d" "$d")"
> > +	done
> > +}
> > +
> >  # Add a bunch of attrs to a file
> >  __populate_create_attr() {
> >  	name="$1"
> > @@ -176,6 +207,7 @@ _scratch_xfs_populate() {
> >  
> >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> >  	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> > +	isize="$(_xfs_get_inode_size "$SCRATCH_MNT")"
> >  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
> >  	if [ $crc -eq 1 ]; then
> >  		leaf_hdr_size=64
> > @@ -226,7 +258,7 @@ _scratch_xfs_populate() {
> >  
> >  	# - BTREE
> >  	echo "+ btree dir"
> > -	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
> > +	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize" true
> >  
> >  	# Symlinks
> >  	# - FMT_LOCAL
> > diff --git a/common/xfs b/common/xfs
> > index 674384a9..7aaa63c7 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -1487,6 +1487,15 @@ _require_xfsrestore_xflag()
> >  			_notrun 'xfsrestore does not support -x flag.'
> >  }
> >  
> > +# Number of bytes reserved for a full inode record, which includes the
> > +# immediate fork areas.
> > +_xfs_get_inode_size()
> > +{
> > +	local mntpoint="$1"
> > +
> > +	$XFS_INFO_PROG "$mntpoint" | sed -n '/meta-data=.*isize/s/^.*isize=\([0-9]*\).*$/\1/p'
> > +}
> > +
> >  # Number of bytes reserved for only the inode record, excluding the
> >  # immediate fork areas.
> >  _xfs_get_inode_core_bytes()
> > -- 
> > 2.18.4
> > 
> 

