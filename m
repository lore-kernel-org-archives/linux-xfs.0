Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE84C63697
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 01:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72BEC20757
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 01:56:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ajpTdOn1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgKXBzq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:55:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726731AbgKXBzq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Nov 2020 20:55:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606182944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VGcoD9cJyIoraWzK6hKk5qDVwHUv+H8uXT6RPGfb/Jg=;
        b=ajpTdOn1ijqa/y/mDvyBoVf6/7aVUjO2fVS6nola1+9GnVXFG2/UCIFf9Vi/VOrmsUTT1p
        WNCTWp/PoVwSTcqRWJUPIp+ZzmAgPCqpa+5JpBWs1yQjCiBMp5NlSqJnae1mjvBm6LG26a
        Oi9HXNRTeXQTeW4IpxeKfvY8hKliHlg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-qdN-6fvpPk6FvkwD8wKJBg-1; Mon, 23 Nov 2020 20:55:42 -0500
X-MC-Unique: qdN-6fvpPk6FvkwD8wKJBg-1
Received: by mail-pl1-f199.google.com with SMTP id f3so12443148plb.11
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2020 17:55:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VGcoD9cJyIoraWzK6hKk5qDVwHUv+H8uXT6RPGfb/Jg=;
        b=CvZoOZqB3ql3U4rZFw/d69aVi43x5nzOZcdQBYRQ51WyzvThXGa/6ETK2YuAwgp1Sq
         oGYifAl6ek7o1hhesOR9aL7fwOPYesTaM7FGV+uKNtDxRVzsIW0dYPMbbWLzDxFBq0go
         Y0kKxhc2UUSCLGYnOdKAlsCXutmNZR9nUAo1TZRggyotPL72fBkgtoF8SQUu2Ga1rAFz
         rYOORT79qUaWXFpHfjx46V0to9eOFQK7/7afTaaTzO0X5d2MOx3KwM9QNM1/0xvt1/Ap
         b/Op4LvX+scEPxfV7c3CcrkBsouC47kyEUJXdx04dKS4Q25jXl0b3Sedk9hoRj3uHGrL
         0cww==
X-Gm-Message-State: AOAM532Q/4SEv0av8WxH6ej1NeVFOQSMNyKcrD+ZIsnBi6BvoWqBEATM
        6SPEQHYvqOSoXN4jaDmJ2ghUJnKLXe8hn8P4uWaIjc0KdwIVmfXvXB1Q09gNxs/LgWFq8nZHdcb
        mkDDvLb+Q1e0Bc6CMRgmO
X-Received: by 2002:a17:90a:f314:: with SMTP id ca20mr2124851pjb.191.1606182941014;
        Mon, 23 Nov 2020 17:55:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwOERy6YQDTd4yvMOmWdY1TucX213z+RoPyE86xDRv8QQM4Q6XXSAOPEPqX8h9a9FwiW8mHlQ==
X-Received: by 2002:a17:90a:f314:: with SMTP id ca20mr2124837pjb.191.1606182940792;
        Mon, 23 Nov 2020 17:55:40 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e14sm11300058pgv.64.2020.11.23.17.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 17:55:40 -0800 (PST)
Date:   Tue, 24 Nov 2020 09:55:30 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] generic: add test for XFS forkoff miscalcution on
 32-bit platform
Message-ID: <20201124015530.GA3096505@xiangao.remote.csb>
References: <20201118060258.1939824-1-hsiangkao@redhat.com>
 <20201123082047.2991878-1-hsiangkao@redhat.com>
 <20201123182400.GD7880@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201123182400.GD7880@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Mon, Nov 23, 2020 at 10:24:00AM -0800, Darrick J. Wong wrote:
> On Mon, Nov 23, 2020 at 04:20:47PM +0800, Gao Xiang wrote:

...

> > +_supported_fs generic
> > +_require_scratch
> > +_require_attrs user
> 
> Does this require
> 
> _require_no_xfs_bug_on_assert ?
> 

For the sake of harmless testcase, I think that is fine and I will
add it in the next version as
[ $FSTYP = "xfs" ] && _require_no_xfs_bug_on_assert


To clarify the synotom:
if bug_on_assert is on, it will bug_on on the second setfattr,
_scratch_cycle_mount will fail due to
umount: can't unmount /tmp/mnt: Device or resource busy

if _scratch_cycle_mount is removed, _getfattr will hung due to
(I think) unbalanced xfs_ilock(dp, XFS_ILOCK_EXCL) in xfs_attr_set()
and xfs_attr_get() will take the lock again.


if bug_on_assert is off, it will fail on _scratch_cycle_mount due to
log recovery replay fail when mounting as below

[  856.786226] XFS (sda): Mounting V5 Filesystem                       
[  856.802704] XFS (sda): Starting recovery (logdev: internal)                                                                                                                                                    
[  856.806362] XFS: Assertion failed: len <= XFS_DFORK_ASIZE(dip, mp), file: fs/xfs/xfs_inode_item_recover.c, line: 426

but if the line of _scratch_cycle_mount is removed, _getfattr will
success due to
	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
				      GFP_NOFS | __GFP_NOFAIL);
	ifp->if_bytes = new_size;
in xfs_idata_realloc(), and xfs_attr_shortform_getvalue() will
temporary ok. yet this testcase have _scratch_cycle_mount anyway.

In any case, it's fine with _getfattr after _scratch_cycle_mount
for this testcase.

And "bug_on_assert is off" does no harm to the system stablity itself
so I think that's better.

> > +
> > +# Use fixed inode size 512, so both v4 and v5 can be tested,
> > +# and also make sure the issue can be triggered if the default
> > +# inode size is changed later.
> > +[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -i size=512"
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_scratch_mount
> > +
> > +localfile="${SCRATCH_MNT}/testfile"
> > +touch $localfile
> > +
> > +# value cannot exceed XFS_ATTR_SF_ENTSIZE_MAX (256) or it will turn into
> > +# leaf form directly; the following combination can trigger the issue for
> > +# both v4 (XFS_LITINO = 412) & v5 (XFS_LITINO = 336) fses.
> > +"${SETFATTR_PROG}" -n user.0 -v "`seq 0 80`" "${localfile}"
> > +"${SETFATTR_PROG}" -n user.1 -v "`seq 0 80`" "${localfile}"
> 
> It's probably worth mentioning that the second setattr causes an integer
> underflow that is incorrectly typecast, leading to the assert
> triggering.  Otherwise this seems reasonable to me.

Ok, will try to add in the next version as well.

Thanks,
Gao Xiang

> 
> --D
> 
> > +
> > +# Make sure that changes are written to disk
> > +_scratch_cycle_mount
> > +
> > +# getfattr won't succeed with the expected result if fails
> > +_getfattr --absolute-names -ebase64 -d $localfile | tail -n +2 | sort
> > +
> > +_scratch_unmount
> > +status=0
> > +exit
> > diff --git a/tests/generic/618.out b/tests/generic/618.out
> > new file mode 100644
> > index 00000000..848fdc58
> > --- /dev/null
> > +++ b/tests/generic/618.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 618
> > +
> > +user.0=0sMAoxCjIKMwo0CjUKNgo3CjgKOQoxMAoxMQoxMgoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAoyMQoyMgoyMwoyNAoyNQoyNgoyNwoyOAoyOQozMAozMQozMgozMwozNAozNQozNgozNwozOAozOQo0MAo0MQo0Mgo0Mwo0NAo0NQo0Ngo0Nwo0OAo0OQo1MAo1MQo1Mgo1Mwo1NAo1NQo1Ngo1Nwo1OAo1OQo2MAo2MQo2Mgo2Mwo2NAo2NQo2Ngo2Nwo2OAo2OQo3MAo3MQo3Mgo3Mwo3NAo3NQo3Ngo3Nwo3OAo3OQo4MA==
> > +user.1=0sMAoxCjIKMwo0CjUKNgo3CjgKOQoxMAoxMQoxMgoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAoyMQoyMgoyMwoyNAoyNQoyNgoyNwoyOAoyOQozMAozMQozMgozMwozNAozNQozNgozNwozOAozOQo0MAo0MQo0Mgo0Mwo0NAo0NQo0Ngo0Nwo0OAo0OQo1MAo1MQo1Mgo1Mwo1NAo1NQo1Ngo1Nwo1OAo1OQo2MAo2MQo2Mgo2Mwo2NAo2NQo2Ngo2Nwo2OAo2OQo3MAo3MQo3Mgo3Mwo3NAo3NQo3Ngo3Nwo3OAo3OQo4MA==
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 94e860b8..eca9d619 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -620,3 +620,4 @@
> >  615 auto rw
> >  616 auto rw io_uring stress
> >  617 auto rw io_uring stress
> > +618 auto quick attr
> > -- 
> > 2.18.4
> > 
> 

