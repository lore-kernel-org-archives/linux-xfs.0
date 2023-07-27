Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3BCC001DC
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 15:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjG0Pfe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 11:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjG0Pfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 11:35:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3B526BA
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 08:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690472094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=83HeM6Yy5ZhHCBvAhGmYCcmmcdNeQw5Huo5S9s4zgYo=;
        b=N1NOogn/d3JteqbrIFRV+NymWMYH3yCGjHfnEbHA5iNRPK8QcSnvr0nuVkgNb8KLFh4IDX
        AEazswu2Qoxh/ytgOVZ2tqhA09OjwJrfvGmgY9FYEZ3n1FbzzFUAja7t1oecS+iy2929mB
        kwJgH6V7K+MVBWLRBwCRGTwzpymdQxQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-YcCq2ZZ5ObyWVAwxKH3VHg-1; Thu, 27 Jul 2023 11:34:52 -0400
X-MC-Unique: YcCq2ZZ5ObyWVAwxKH3VHg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1bbce3d48d9so10517625ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 08:34:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690472091; x=1691076891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=83HeM6Yy5ZhHCBvAhGmYCcmmcdNeQw5Huo5S9s4zgYo=;
        b=f15WXP/79atWysMiCT/njHHnYRcUltvTU4T8lI8euXiUBMmhX+PubV5tiGcs+XX1/A
         wWqNjoKbdUBu80d3y5YC3wzTANoDZ0lPKx9JGD6Yg6DHzl+fJWj5HqPHo6Hw6rELVx4Z
         7SFKUsM9X3HgqglB1JU+hkn+9SFWMTWmadjhKNUqUSWlznXFF27G0FGdraSuUMJkwTsr
         R4jq9h8cf8g8X3V2wc4bTxIL7sIVOboFnqnA4At60OlVXNidqw5yXEKOt0cmi4H/kHv8
         FDVMg6gP0SWNmsKVY6wRa8IjzLK9xqL5FoFwjZW5hTb80POW3iDtcRmWgH4a5q9u+q50
         lpDg==
X-Gm-Message-State: ABy/qLb6kfop1IQBIty7zOdc4ywVycNowmEjjSFdOvDgHhOcNLBmPSXj
        tKapr6dE+jXrvfU7+CtDx0P0/ZSlnQk5Vql88MZ1A2r/HrJ9lpmP0zyAz4E81YqXJh4cXKgr+ZK
        nyDdCfjYrqsfQtxVBXuD5Wfyz3ZIHqro=
X-Received: by 2002:a17:902:9884:b0:1bb:30c5:836b with SMTP id s4-20020a170902988400b001bb30c5836bmr5135169plp.58.1690472091627;
        Thu, 27 Jul 2023 08:34:51 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGgBJAFBiv4IqW94ImgEHmTMxJVk/8KA7PuqtoyruoXn14eMd4OHq6AFI4MR3FHaS8qw6WSdg==
X-Received: by 2002:a17:902:9884:b0:1bb:30c5:836b with SMTP id s4-20020a170902988400b001bb30c5836bmr5135154plp.58.1690472091333;
        Thu, 27 Jul 2023 08:34:51 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090282c500b001b66a71a4a0sm1802486plz.32.2023.07.27.08.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 08:34:50 -0700 (PDT)
Date:   Thu, 27 Jul 2023 23:34:47 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/122: adjust test for flexarray conversions in 6.5
Message-ID: <20230727153447.5zd7vuwhoqazyacb@zlang-mailbox>
References: <169033661482.3222297.18190312289773544342.stgit@frogsfrogsfrogs>
 <169033662042.3222297.14047592154027443561.stgit@frogsfrogsfrogs>
 <20230727135744.nhmwpv7dxt5nvshd@zlang-mailbox>
 <20230727152336.GJ11340@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727152336.GJ11340@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 08:23:36AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 27, 2023 at 09:57:44PM +0800, Zorro Lang wrote:
> > On Tue, Jul 25, 2023 at 06:57:00PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Adjust the output of this test to handle the conversion of flexarray
> > > declaration conversions in 6.5.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > Looks like it's about a49bbce58ea9 ("xfs: convert flex-array declarations
> > in xfs attr leaf blocks"). If you don't mind, I'd like to mention it in commit
> > log when I merge it :) This patch looks good to me,
> 
> Please do mention it.  I wasn't sure if I should do that or a _fixed_by
> tag, since technically there's no breakage in the xfs code itself...

Thanks, a _fixed_by tag looks not suitable, I also don't want to add _fixed_by
each time we change this case. So I don't have better idea, have to mention
the kernel commit in this commit log, to leave a record at least.

> 
> --D
> 
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > 
> > Thanks,
> > Zorro
> > 
> > >  tests/xfs/122 |    8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > 
> > > diff --git a/tests/xfs/122 b/tests/xfs/122
> > > index e616f1987d..ba927c77c4 100755
> > > --- a/tests/xfs/122
> > > +++ b/tests/xfs/122
> > > @@ -26,13 +26,21 @@ _wants_kernel_commit 03a7485cd701 \
> > >  _type_size_filter()
> > >  {
> > >  	# lazy SB adds __be32 agf_btreeblks - pv960372
> > > +	# flexarray conversion of the attr structures in Linux 6.5 changed
> > > +	# the sizeof output
> > >  	if [ "$($MKFS_XFS_PROG 2>&1 | grep -c lazy-count )" == "0" ]; then
> > >  		perl -ne '
> > >  s/sizeof\( xfs_agf_t \) = 60/sizeof( xfs_agf_t ) = <SIZE>/;
> > > +s/sizeof\(struct xfs_attr3_leafblock\) = 80/sizeof(struct xfs_attr3_leafblock) = 88/;
> > > +s/sizeof\(struct xfs_attr_shortform\) = 4/sizeof(struct xfs_attr_shortform) = 8/;
> > > +s/sizeof\(xfs_attr_leafblock_t\) = 32/sizeof(xfs_attr_leafblock_t) = 40/;
> > >  		print;'
> > >  	else
> > >  		perl -ne '
> > >  s/sizeof\( xfs_agf_t \) = 64/sizeof( xfs_agf_t ) = <SIZE>/;
> > > +s/sizeof\(struct xfs_attr3_leafblock\) = 80/sizeof(struct xfs_attr3_leafblock) = 88/;
> > > +s/sizeof\(struct xfs_attr_shortform\) = 4/sizeof(struct xfs_attr_shortform) = 8/;
> > > +s/sizeof\(xfs_attr_leafblock_t\) = 32/sizeof(xfs_attr_leafblock_t) = 40/;
> > >  		print;'
> > >  	fi
> > >  }
> > > 
> > 
> 

