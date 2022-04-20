Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F60FC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 14:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354305AbiDTOuJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 10:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242167AbiDTOuI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 10:50:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2ED276277
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650466041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wUSuRePa/mdIrOt5XHxupWL6kKhWTt5Vn9W0bRTIUjk=;
        b=Q8H9L7E3eDDTcpbTnToQKHncTs2PoiWWVYuo7aqz2Wxs5fAjAngoif64O+rRX89mSymJlF
        6Vb6eTVPZgos90kYRTQsGjiMxnxdL8//qYUpos8c/zdmzW1qqtdTJ9I2t4nDq0hu9QYeML
        aUH+vV6axRjpYD2J8dEtw9ftJU4xscc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588--InIwK3dNai8cwePF4jOMQ-1; Wed, 20 Apr 2022 10:47:20 -0400
X-MC-Unique: -InIwK3dNai8cwePF4jOMQ-1
Received: by mail-qt1-f198.google.com with SMTP id a25-20020ac844b9000000b002f1f8988487so1098016qto.17
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:47:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=wUSuRePa/mdIrOt5XHxupWL6kKhWTt5Vn9W0bRTIUjk=;
        b=1PyaKtqOxFDWqEZBkMFGhUKvPXiGAaKlZI7gDQQW9QgQMQ4J176K3ObouR3awjb+XQ
         B1HaUO8RjyzSpQJ4HkvV50+H6j+GL31FIp8ll6UtR4wPFQbXjUA0JhnNz7HE2p40VqDL
         Mgj0RbCKjy5aN6Ao9q8Oucurp1x1pXt2TH7DPZ6cDowOwvsQNIzrv4015XIwbTneWZKn
         vvglTf9VXzyU8DsDx0pBD5lDP0i8MlGLDK/xDIW/jF555zwDp8S+vzlrQPb2b6cS8zzj
         uRlsGG/v3a1rcT/hr7nC4WY7T+sqEExZqxjqmPNgGkl6A4Z40rR6UMEvLunGunYmiEDq
         I6PA==
X-Gm-Message-State: AOAM532Jll6YIJjDycHy8jQunOXV5DpF1m5PL8+AyH2awyJ2Nj9gWDY6
        hbVe1ynwn0PQGzNKMo34WpShAleIyOoEgxLNR+/i0Q0uN8XxM/uFHeyAWEOW2kTm4cmvvikzGKE
        7/331AKhyMTFBSBD0j0Oz
X-Received: by 2002:a05:620a:6ce:b0:69c:c0b4:ed2b with SMTP id 14-20020a05620a06ce00b0069cc0b4ed2bmr12914784qky.718.1650466039612;
        Wed, 20 Apr 2022 07:47:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9dDCi4rfTyHLiEIhz/oLOP6wJX1YoJ/pMaWIMm/AeamVaVbL8CBWFwKIv7Eoymaw1gOYGjQ==
X-Received: by 2002:a05:620a:6ce:b0:69c:c0b4:ed2b with SMTP id 14-20020a05620a06ce00b0069cc0b4ed2bmr12914771qky.718.1650466039346;
        Wed, 20 Apr 2022 07:47:19 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k66-20020a37ba45000000b0069c5adb2f2fsm1619505qkf.6.2022.04.20.07.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 07:47:18 -0700 (PDT)
Date:   Wed, 20 Apr 2022 22:47:11 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs/019: fix golden output for files created in
 setgid dir
Message-ID: <20220420144711.bqw6c2joulngszdn@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <165038951495.1677615.10687913612774985228.stgit@magnolia>
 <165038952072.1677615.13209407698123810165.stgit@magnolia>
 <20220419183347.hruyn5zimz6tcxd4@zlang-mailbox>
 <20220419183855.GO17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419183855.GO17025@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 11:38:55AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 20, 2022 at 02:33:47AM +0800, Zorro Lang wrote:
> > On Tue, Apr 19, 2022 at 10:32:00AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > A recent change to xfs/019 exposed a long-standing bug in mkfs where
> > > it would always set the gid of a new child created in a setgid directory
> > > to match the gid parent directory instead of what's in the protofile.
> > > 
> > > Ignoring the user's directions is not the correct behavior, so update
> > > this test to reflect that.  Also don't erase the $seqres.full file,
> > > because that makes forensic analysis pointlessly difficult.
> > > 
> > > Cc: Catherine Hoang <catherine.hoang@oracle.com>
> > > Fixes: 7834a740 ("xfs/019: extend protofile test")
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > After merge this patch, xfs/019 fails on my system. So this test will cover
> > a new bug of xfsprogs which hasn't been fixed? If so, this change is good to me.
> > But we'd better to take a look at the patch you used to fix xfsprogs, and make
> > sure it's reviewed.
> 
> Yep.  Already reviewed, just waiting for xfsprogs 5.15.1:
> 
> https://lore.kernel.org/linux-xfs/B28D1D24-2E23-4F60-AA50-C199392BBE4F@oracle.com/T/#u

Thanks for this information, it makes sense to me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> --D
> 
> > 
> > Thanks,
> > Zorro
> > 
> > >  tests/xfs/019     |    3 +--
> > >  tests/xfs/019.out |    2 +-
> > >  2 files changed, 2 insertions(+), 3 deletions(-)
> > > 
> > > 
> > > diff --git a/tests/xfs/019 b/tests/xfs/019
> > > index 535b7af1..790a6821 100755
> > > --- a/tests/xfs/019
> > > +++ b/tests/xfs/019
> > > @@ -10,6 +10,7 @@
> > >  _begin_fstest mkfs auto quick
> > >  
> > >  seqfull="$seqres.full"
> > > +rm -f $seqfull
> > >  # Import common functions.
> > >  . ./common/filter
> > >  
> > > @@ -97,7 +98,6 @@ _verify_fs()
> > >  	echo "*** create FS version $1"
> > >  	VERSION="-n version=$1"
> > >  
> > > -	rm -f $seqfull
> > >  	_scratch_unmount >/dev/null 2>&1
> > >  
> > >  	_full "mkfs"
> > > @@ -131,6 +131,5 @@ _verify_fs()
> > >  _verify_fs 2
> > >  
> > >  echo "*** done"
> > > -rm $seqfull
> > >  status=0
> > >  exit
> > > diff --git a/tests/xfs/019.out b/tests/xfs/019.out
> > > index 8584f593..9db157f9 100644
> > > --- a/tests/xfs/019.out
> > > +++ b/tests/xfs/019.out
> > > @@ -61,7 +61,7 @@ Device: <DEVICE> Inode: <INODE> Links: 2
> > >  
> > >   File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
> > >   Size: 5 Filetype: Regular File
> > > - Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (2)
> > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > >  Device: <DEVICE> Inode: <INODE> Links: 1 
> > >  
> > >   File: "./pipe"
> > > 
> > 
> 

