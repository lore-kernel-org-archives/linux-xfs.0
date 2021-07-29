Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E38C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 06:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7106260F5E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 06:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhG2GkY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 02:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhG2GkX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jul 2021 02:40:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348A1C061757
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 23:40:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so7967178pjd.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 23:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=mS96z76PVAObZfrD0ayEAOo84JDRuFrO6BPz1aBMPxU=;
        b=uqQwb2Nt1w7Sgukdr7VSIYGow1SY7eiC7hboQXJS8f9XA6asb9Xw/8nvtuUxCG5raQ
         J2TcqqfALTcO9H9hue/3XrMp25k5gcU79x49Ez7fX77CpEs7WTSRlNzSWfM1rj+ry3s9
         vKIKhx4bt0umPmWsslp7/+5X7YXozYyX9THheMilkprNNC4BnT23HEct1haxV0QGdtkX
         N3Gu87jz24jcuUbxg/OiyehVB0q2DdgwTr4gFFikfjejW1B+9sC9rqHzsX4pA+5Z2a/l
         ZsyjX4xrfxxdwEXzwhxgnpfp+IJm1KVu84jUVlhf7TnA4M53WP+alZJ3pNhS+fgblp3L
         gITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=mS96z76PVAObZfrD0ayEAOo84JDRuFrO6BPz1aBMPxU=;
        b=fw8CdQ8O4wQwfbpyHp/gHeevmTWm0YlaXMM15O18eINyItTNQTQ9FqX6pS8dKmtb2X
         FfP9WCG5ca5ToJBoi1EGi+U8TbfABgEilwLh9fNZUmBI6ZI+iys5XeQCTa2iCrUO5wj+
         8QhOVfeTDxfRNa/xz3D8+gLl+6KIVh7HVj50SayErzYEDvP32LKk5rLVu6ywpPnCGsuO
         3eiFvvpLZ6AsBXZ+UZorXpNwlj3TvBXfSi/jaumCJp9aygdqK+PsP0P8LTjxchgMmRtf
         Fkd9v8/9dWlETRFufncYlqwWvE029dQz58hlkT7Mv2jHWRlfmlPP8EctvI8yj6vC3Au7
         ZWHw==
X-Gm-Message-State: AOAM531bQnQSeMdwx3sTxcxyONoW0Ei6jlOwv6tGPRYxnisoTICD6GLy
        +6y61nXj/KStsPWMqVZylOvijxzE2mkWWA==
X-Google-Smtp-Source: ABdhPJweAXJZqwwmF+rpEnvdUjFKIOyO8QXkGqgT8swH9yUBeDGXPymi02KDJmf52uAllHYOLgeC+A==
X-Received: by 2002:a17:90b:3a89:: with SMTP id om9mr3709186pjb.91.1627540820571;
        Wed, 28 Jul 2021 23:40:20 -0700 (PDT)
Received: from garuda ([122.167.157.25])
        by smtp.gmail.com with ESMTPSA id y35sm2165253pfa.34.2021.07.28.23.40.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Jul 2021 23:40:20 -0700 (PDT)
References: <20210726114541.24898-1-chandanrlinux@gmail.com> <20210728212700.GJ3601443@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 00/12] xfs: Extend per-inode extent counters
In-reply-to: <20210728212700.GJ3601443@magnolia>
Date:   Thu, 29 Jul 2021 12:10:17 +0530
Message-ID: <878s1pfwry.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 29 Jul 2021 at 02:57, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 05:15:29PM +0530, Chandan Babu R wrote:
>> The commit xfs: fix inode fork extent count overflow
>> (3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
>> data fork extents should be possible to create. However the
>> corresponding on-disk field has a signed 32-bit type. Hence this
>> patchset extends the per-inode data extent counter to 64 bits out of
>> which 48 bits are used to store the extent count.
>
> A few other random notes that don't fit anywhere:
>
> If you decide to enable upgrades by adding an XFS_DIFLAG2 to indicate
> that a particular file has large extent counts, I think you can copy the
> same mechanisms that the DIFLAG2_BIGTIME flag uses as a template.  I
> think you'd need an extra bit of logic in xfs_trans_log_inode to turn on
> the feature bit and move the n*extents fields around if either extent
> count exceeds the old limits.
>

Ok. I will start implementing the upgrade feature unless objections are raised
by other developers.

> Please export the NREXT64 feature flag via an XFS_FSOP_GEOM flag so that
> userspace can detect support for having a lot of extents.  This will
> make it easy for libfrog to figure out that it should set the "send
> large extent counts" bulkstat flag.  It'll also make it easier to
> perform feature detection in fstests.

Sure. I will implement this as well.

Thanks for the suggestions.

>
> --D
>
>> Also, XFS has an attr fork extent counter which is 16 bits wide. A
>> workload which,
>> 1. Creates 1 million 255-byte sized xattrs,
>> 2. Deletes 50% of these xattrs in an alternating manner,
>> 3. Tries to insert 400,000 new 255-byte sized xattrs
>>    causes the xattr extent counter to overflow.
>>
>> Dave tells me that there are instances where a single file has more
>> than 100 million hardlinks. With parent pointers being stored in
>> xattrs, we will overflow the signed 16-bits wide xattr extent counter
>> when large number of hardlinks are created. Hence this patchset
>> extends the on-disk field to 32-bits.
>>
>> The following changes are made to accomplish this,
>> 1. A new incompat superblock flag to prevent older kernels from mounting
>>    the filesystem. This flag has to be set during mkfs time.
>> 2. A new 64-bit inode field is created to hold the data extent
>>    counter.
>> 3. The existing 32-bit inode data extent counter will be used to hold
>>    the attr fork extent counter.
>>
>> The patchset has been tested by executing xfstests with the following
>> mkfs.xfs options,
>> 1. -m crc=0 -b size=1k
>> 2. -m crc=0 -b size=4k
>> 3. -m crc=0 -b size=512
>> 4. -m rmapbt=1,reflink=1 -b size=1k
>> 5. -m rmapbt=1,reflink=1 -b size=4k
>>
>> Each of the above test scenarios were executed on the following
>> combinations (For V4 FS test scenario, the last combination
>> i.e. "Patched (enable extcnt64bit)", was omitted).
>> |-------------------------------+-----------|
>> | Xfsprogs                      | Kernel    |
>> |-------------------------------+-----------|
>> | Unpatched                     | Patched   |
>> | Patched (disable extcnt64bit) | Unpatched |
>> | Patched (disable extcnt64bit) | Patched   |
>> | Patched (enable extcnt64bit)  | Patched   |
>> |-------------------------------+-----------|
>>
>> I have also written a test (yet to be converted into xfstests format)
>> to check if the correct extent counter fields are updated with/without
>> the new incompat flag. I have also fixed some of the existing fstests
>> to work with the new extent counter fields.
>>
>> Increasing data extent counter width also causes the maximum height of
>> BMBT to increase. This requires that the macro XFS_BTREE_MAXLEVELS be
>> updated with a larger value. However such a change causes the value of
>> mp->m_rmap_maxlevels to increase which in turn causes log reservation
>> sizes to increase and hence a modified XFS driver will fail to mount
>> filesystems created by older versions of mkfs.xfs.
>>
>> Hence this patchset is built on top of Darrick's btree-dynamic-depth
>> branch which removes the macro XFS_BTREE_MAXLEVELS and computes
>> mp->m_rmap_maxlevels based on the size of an AG.
>>
>> These patches can also be obtained from
>> https://github.com/chandanr/linux.git at branch
>> xfs-incompat-extend-extcnt-v2.
>>
>> I will be posting the changes associated with xfsprogs separately.
>>
>> Changelog:
>> V1 -> V2:
>> 1. Rebase patches on top of Darrick's btree-dynamic-depth branch.
>> 2. Add new bulkstat ioctl version to support 64-bit data fork extent
>>    counter field.
>> 3. Introduce new error tag to verify if the old bulkstat ioctls skip
>>    reporting inodes with large data fork extent counters.
>>
>> Chandan Babu R (12):
>>   xfs: Move extent count limits to xfs_format.h
>>   xfs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32,
>>     XFS_IFORK_EXTCNT_MAXS16
>>   xfs: Introduce xfs_iext_max() helper
>>   xfs: Use xfs_extnum_t instead of basic data types
>>   xfs: Introduce xfs_dfork_nextents() helper
>>   xfs: xfs_dfork_nextents: Return extent count via an out argument
>>   xfs: Rename inode's extent counter fields based on their width
>>   xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
>>     respectively
>>   xfs: Rename XFS_IOC_BULKSTAT to XFS_IOC_BULKSTAT_V5
>>   xfs: Enable bulkstat ioctl to support 64-bit extent counters
>>   xfs: Extend per-inode extent counter widths
>>   xfs: Error tag to test if v5 bulkstat skips inodes with large extent
>>     count
>>
>>  fs/xfs/libxfs/xfs_bmap.c        | 21 +++----
>>  fs/xfs/libxfs/xfs_errortag.h    |  4 +-
>>  fs/xfs/libxfs/xfs_format.h      | 42 +++++++++++---
>>  fs/xfs/libxfs/xfs_fs.h          |  9 ++-
>>  fs/xfs/libxfs/xfs_inode_buf.c   | 82 ++++++++++++++++++++++++----
>>  fs/xfs/libxfs/xfs_inode_buf.h   |  2 +
>>  fs/xfs/libxfs/xfs_inode_fork.c  | 35 +++++++++---
>>  fs/xfs/libxfs/xfs_inode_fork.h  | 22 +++++++-
>>  fs/xfs/libxfs/xfs_log_format.h  |  7 ++-
>>  fs/xfs/libxfs/xfs_types.h       | 11 +---
>>  fs/xfs/scrub/attr_repair.c      |  2 +-
>>  fs/xfs/scrub/inode.c            | 97 ++++++++++++++++++++-------------
>>  fs/xfs/scrub/inode_repair.c     | 71 +++++++++++++++++-------
>>  fs/xfs/scrub/trace.h            | 16 +++---
>>  fs/xfs/xfs_error.c              |  3 +
>>  fs/xfs/xfs_inode.c              |  4 +-
>>  fs/xfs/xfs_inode_item.c         | 15 ++++-
>>  fs/xfs/xfs_inode_item_recover.c | 25 +++++++--
>>  fs/xfs/xfs_ioctl.c              | 33 +++++++++--
>>  fs/xfs/xfs_ioctl32.c            |  7 +++
>>  fs/xfs/xfs_itable.c             | 35 ++++++++++--
>>  fs/xfs/xfs_itable.h             |  1 +
>>  fs/xfs/xfs_trace.h              |  6 +-
>>  23 files changed, 402 insertions(+), 148 deletions(-)
>>
>> --
>> 2.30.2
>>

--
chandan
