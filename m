Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8B6C76188
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 11:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbjDELIu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 07:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbjDELIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 07:08:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC9735BE
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 04:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680692879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LzJaUmfW7LSdhmFGvI4GPq0lFJqiEtn70THgtiWFu7E=;
        b=RPfQ1HaKn4lVvr9dRPj/oGHc13B47VdQ30AiipV9qDPYZTRtpQokIo/cTxXaxHbgD/H9v2
        H+3ihRPeowyh4EdwQ0sMxKjhkRylTPkUMSImqkZJXHdM4p0cW62S8WoVZ4gbzWsL01v/xH
        IDVPe8Cs8Ib8yDJDT+wG/oeFcJavqtA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372--qrgvhUyNyGbj0bR6KKJlA-1; Wed, 05 Apr 2023 07:07:58 -0400
X-MC-Unique: -qrgvhUyNyGbj0bR6KKJlA-1
Received: by mail-qv1-f72.google.com with SMTP id y19-20020ad445b3000000b005a5123cb627so16006167qvu.20
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 04:07:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680692878;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LzJaUmfW7LSdhmFGvI4GPq0lFJqiEtn70THgtiWFu7E=;
        b=AohXpO0Hzg6egHnJgZasrT9dkaL87ljIEXj5owKs6CaOtc3yzxJRB9qX6Vz9jcQySD
         3/g3Exm/zMwQSahnrsRf4RuGQv4fLEWBnTGpKhld6rUqlK38KdSvuGZUp+k+Y2/b1UWe
         +wt6J+fJauFc6vInqMDLwlqzFGsJ4W3Xf3hNzh+XgFJVijcFVZqlCI1IR9zpAmQh9d9k
         yppovfLvKQ5UWnWmEC8DG8a2Zhvys8mLMFJuCS9ZyNOVRJRYr6hfLSidrlGLnYATuXRD
         gHgSvaaFGaWAZeM2WeF5ta40byHK7komQTagfViUfVjN9Fj28EDgtbxK6/fVfA7YNic4
         1LrQ==
X-Gm-Message-State: AAQBX9drXkE3OFUbAqBf+kMZO6kBv6JlOWjKPbAPF2rmpMf9CK8Ckorn
        kzhsmWr/pt31tsaxEeuXHtE5B6iexOc4ta5OyDYKTyCigbGCJ+p3Ds7AmG7ft8CnqMc943PTT4/
        7hpbiarMb+ui6aD4fjxM=
X-Received: by 2002:a05:622a:1a9a:b0:3d2:a927:21b8 with SMTP id s26-20020a05622a1a9a00b003d2a92721b8mr4385127qtc.11.1680692877537;
        Wed, 05 Apr 2023 04:07:57 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZeP9y1P8OSuMOyueFPI4oWaLkw1tcoh1zocY7G03xptTKH+In+mgb9Q5Zm39xqD2zbBaEQ0g==
X-Received: by 2002:a05:622a:1a9a:b0:3d2:a927:21b8 with SMTP id s26-20020a05622a1a9a00b003d2a92721b8mr4385083qtc.11.1680692877295;
        Wed, 05 Apr 2023 04:07:57 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id k19-20020ac84753000000b003dffd3d3df5sm3934121qtp.2.2023.04.05.04.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 04:07:57 -0700 (PDT)
Date:   Wed, 5 Apr 2023 13:07:52 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Dave Chinner <david@fromorbit.com>, ebiggers@kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, djwong@kernel.org,
        dchinner@redhat.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev, rpeterso@redhat.com, agruenba@redhat.com,
        xiang@kernel.org, chao@kernel.org,
        damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com
Subject: Re: [PATCH v2 16/23] xfs: add inode on-disk VERITY flag
Message-ID: <20230405110752.ih5qvu2cr6folkds@aalbersh.remote.csb>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
 <20230404145319.2057051-17-aalbersh@redhat.com>
 <20230404224123.GD1893@sol.localdomain>
 <20230404235633.GN3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404235633.GN3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric and Dave,

On Wed, Apr 05, 2023 at 09:56:33AM +1000, Dave Chinner wrote:
> On Tue, Apr 04, 2023 at 03:41:23PM -0700, Eric Biggers wrote:
> > Hi Andrey,
> > 
> > On Tue, Apr 04, 2023 at 04:53:12PM +0200, Andrey Albershteyn wrote:
> > > Add flag to mark inodes which have fs-verity enabled on them (i.e.
> > > descriptor exist and tree is built).
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > > ---
> > >  fs/ioctl.c                 | 4 ++++
> > >  fs/xfs/libxfs/xfs_format.h | 4 +++-
> > >  fs/xfs/xfs_inode.c         | 2 ++
> > >  fs/xfs/xfs_iops.c          | 2 ++
> > >  include/uapi/linux/fs.h    | 1 +
> > >  5 files changed, 12 insertions(+), 1 deletion(-)
> > [...]
> > > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > > index b7b56871029c..5172a2eb902c 100644
> > > --- a/include/uapi/linux/fs.h
> > > +++ b/include/uapi/linux/fs.h
> > > @@ -140,6 +140,7 @@ struct fsxattr {
> > >  #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
> > >  #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
> > >  #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
> > > +#define FS_XFLAG_VERITY		0x00020000	/* fs-verity sealed inode */
> > >  #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
> > >  
> > 
> > I don't think "xfs: add inode on-disk VERITY flag" is an accurate description of
> > a patch that involves adding something to the UAPI.
> 
> Well it does that, but it also adds the UAPI for querying the
> on-disk flag via the FS_IOC_FSGETXATTR interface as well.  It
> probably should be split up into two patches.

Sure.

> 
> > Should the other filesystems support this new flag too?
> 
> I think they should get it automatically now that it has been
> defined for FS_IOC_FSGETXATTR and added to the generic fileattr flag
> fill functions in fs/ioctl.c.
> 
> > I'd also like all ways of getting the verity flag to continue to be mentioned in
> > Documentation/filesystems/fsverity.rst.  The existing methods (FS_IOC_GETFLAGS
> > and statx) are already mentioned there.
> 
> *nod*
> 

Ok, sure, missed that. Will split this patch and add description.

-- 
- Andrey

