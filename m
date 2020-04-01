Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9AEC2D0F1
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 02:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35FBC20842
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 02:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="nSPPWhK2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbgDACNr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Mar 2020 22:13:47 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:37196 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731531AbgDACNq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Mar 2020 22:13:46 -0400
Received: by mail-qv1-f67.google.com with SMTP id n1so12083144qvz.4
        for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2020 19:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KniChMqTea044eYeZlDJiANOdPR1prRqmVeYeeXnee4=;
        b=nSPPWhK2h5eO9qi6oaV3ytvnbTJjBjGLxyceKsKSqUTR6Y0zCKxs1YGiGWuJRUtlk4
         9iK54/peAqPuSj3usv53qGY11IoJ34tGTo1qqcjFOjwmdV6Ja5i9NXVn32daM+XYBojC
         Eov2NIpwaNNSTxiP3MQyqNLM4OcfRCx2NwDEfBaXID3gqzhvyfTE9+n2iTWpq06qzFuB
         8lKgDLxyz1rpnbnFpO+hH1+meQR6+MvWUpiiiDJVypNtIbqdTASqN5tZ6L2SM4YUj9Op
         jgSUpSFo9zZ6+y0tm+nrj1TynIh42MNydXVKyM17TDJMrRThIekDombdZKAQL35gtQIF
         NBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KniChMqTea044eYeZlDJiANOdPR1prRqmVeYeeXnee4=;
        b=lL4c7SznSfL1ceu0Ab8qH+vMU8mBguKhAxyDCwq4c0FRmyBQ3z3eatV6TiKl6aj4SO
         UDfx+OwuU6E8KwcZUT4yUXZ2Yqn8bfDgvfg5Q9MukG+UP81QDj9kMKI8ogo6/eAx9EMU
         v8OlBCQVgO13MQ06YRuVInLtkjDqLhTQz96uqCZ2H+GNzkXwVF56ABQYKJbv98HCXTlA
         kRwGZbyukrbRJKRlVehuu7AiGRNGjUD7DL8NfmljR98oYJUx+g1+CbMHLMabi5Gz9ecR
         WE4ejTX5s/inhG6DE9qWnqLAf7lLsO3NSep54O9A8oBnbHDLcQlETZ8bVee8DqPJWg/a
         rjaQ==
X-Gm-Message-State: ANhLgQ2bURY/3bJjPeA418jU73xtHW8iJf63JAqWum9zZYvpbMZQh6vS
        4efXGFBbhZPKd2YAqJ38KkiJ1w==
X-Google-Smtp-Source: ADFU+vvpf5sKaJFSIDxd31IiapKpD3wEy+jAt8PR7HOkG4mGjD4LWVP43Mk2Ci0zAg5giXEKIjqScA==
X-Received: by 2002:ad4:4e2f:: with SMTP id dm15mr6474007qvb.10.1585707224571;
        Tue, 31 Mar 2020 19:13:44 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id v75sm594528qkb.22.2020.03.31.19.13.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2020 19:13:44 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: linux-next: xfs metadata corruption since 30 March
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <20200331221324.GZ10776@dread.disaster.area>
Date:   Tue, 31 Mar 2020 22:13:42 -0400
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <05FB019A-F4DC-414C-B8D9-D2735AF22034@lca.pw>
References: <990EDC4E-1A4E-4AC3-84D9-078ACF5EB9CC@lca.pw>
 <20200331221324.GZ10776@dread.disaster.area>
To:     Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On Mar 31, 2020, at 6:13 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Tue, Mar 31, 2020 at 05:57:24PM -0400, Qian Cai wrote:
>> Ever since two days ago, linux-next starts to trigger xfs metadata =
corruption
>> during compilation workloads on both powerpc and arm64,
>=20
> Is this on an existing filesystem, or a new filesystem?

New.

>=20
>> I suspect it could be one of those commits,
>>=20
>> https://lore.kernel.org/linux-xfs/20200328182533.GM29339@magnolia/
>>=20
>> Especially, those commits that would mark corruption more =
aggressively?
>>=20
>>      [8d57c21600a5] xfs: add a function to deal with corrupt buffers =
post-verifiers
>>      [e83cf875d67a] xfs: xfs_buf_corruption_error should take =
__this_address
>>      [ce99494c9699] xfs: fix buffer corruption reporting when =
xfs_dir3_free_header_check fails
>>      [1cb5deb5bc09] xfs: don't ever return a stale pointer from =
__xfs_dir3_free_read
>>      [6fb5aac73310] xfs: check owner of dir3 free blocks
>>      [a10c21ed5d52] xfs: check owner of dir3 data blocks
>>      [1b2c1a63b678] xfs: check owner of dir3 blocks
>>      [2e107cf869ee] xfs: mark dir corrupt when lookup-by-hash fails
>>      [806d3909a57e] xfs: mark extended attr corrupt when =
lookup-by-hash fails
>=20
> Doubt it - they only add extra detection code and these:
>=20
>> [29331.182313][  T665] XFS (dm-2): Metadata corruption detected at =
xfs_inode_buf_verify+0x2b8/0x350 [xfs], xfs_inode block 0xa9b97900 =
xfs_inode_buf_verify
>> xfs_inode_buf_verify at fs/xfs/libxfs/xfs_inode_buf.c:101
>> [29331.182373][  T665] XFS (dm-2): Unmount and run xfs_repair
>> [29331.182386][  T665] XFS (dm-2): First 128 bytes of corrupted =
metadata buffer:
>> [29331.182402][  T665] 00000000: 2f 2a 20 53 50 44 58 2d 4c 69 63 65 =
6e 73 65 2d  /* SPDX-License-
>> [29331.182426][  T665] 00000010: 49 64 65 6e 74 69 66 69 65 72 3a 20 =
47 50 4c 2d  Identifier: GPL-
>=20
> Would get caught by the existing  verifiers as they aren't valid
> metadata at all.
>=20
> Basically, you are getting file data where there should be inode
> metadata. First thing to do is fix the existing corruptions with
> xfs_repair - please post the entire output so we can see what was
> corruption and what it fixed.


# xfs_repair -v /dev/mapper/rhel_hpe--apollo--cn99xx--11-home=20
Phase 1 - find and verify superblock...
        - block cache size set to 4355512 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 793608 tail block 786824
ERROR: The filesystem has valuable metadata changes in a log which needs =
to
be replayed.  Mount the filesystem to replay the log, and unmount it =
before
re-running xfs_repair.  If you are unable to mount the filesystem, then =
use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a =
mount
of the filesystem before doing this.

# mount /dev/mapper/rhel_hpe--apollo--cn99xx--11-home /home/
# umount /home/
# xfs_repair -v /dev/mapper/rhel_hpe--apollo--cn99xx--11-home=20
Phase 1 - find and verify superblock...
        - block cache size set to 4355512 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 793624 tail block 793624
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 2
        - agno =3D 1
        - agno =3D 3
Phase 5 - rebuild AG headers and trees...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...

        XFS_REPAIR Summary    Tue Mar 31 22:10:54 2020

Phase		Start		End		Duration
Phase 1:	03/31 22:10:45	03/31 22:10:45=09
Phase 2:	03/31 22:10:45	03/31 22:10:45=09
Phase 3:	03/31 22:10:45	03/31 22:10:46	1 second
Phase 4:	03/31 22:10:46	03/31 22:10:53	7 seconds
Phase 5:	03/31 22:10:53	03/31 22:10:53=09
Phase 6:	03/31 22:10:53	03/31 22:10:53=09
Phase 7:	03/31 22:10:53	03/31 22:10:53=09

Total run time: 8 seconds
done
>=20
> Then if the problem is still reproducable, I suspect you are going
> to have to bisect it. i.e. run test, get corruption, mark bisect
> bad, run xfs_repair or mkfs to fix mess, install new kernel, run
> test again....
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

