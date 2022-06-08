Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E95C43334
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 05:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiFHFQ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 01:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbiFHFQf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 01:16:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D953C3040
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 19:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EA73B823D1
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 02:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24C89C341CB
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 02:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654654777;
        bh=8k/cCbLv/bjFnVGdbaVsd6SO3BhhLLjOxnVpg8HcW00=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=H6aBxWIrdE7Jco04XQe4Ps8NcAEae8iQ+bEpIACuW8HGJmCSWuAcS1iQIZRciJ3qv
         DKQF4DqDuNd4xgI3j6S7N653EJD3ixD1U75xEDUnPMwdCNVFVNR0XPwDiydrTfT5na
         VY7tbiAIunlf+WkvQTmdpuYIbSOtLNsMpAOiPYyjfmi56HV1/SKTUL2PM3AxfZwTcs
         wfPrz5aXQEZ3ek2xEWju1qRlTOHqdDgzlP3n7zjtEzhSq6A0R0M/n+L7MCk8bKHtW6
         HSRogpKu/qM6TfM/EpQbv8d+C9fBx25dDyCP3QhjekAmfHadndgOvd1wWCNFqFFt5p
         xXOzZnZ4ZeFgA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 08792C05FD2; Wed,  8 Jun 2022 02:19:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Wed, 08 Jun 2022 02:19:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-MAvXsBz9h3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216073-201763@https.bugzilla.kernel.org/>
References: <bug-216073-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216073

--- Comment #5 from Zorro Lang (zlang@redhat.com) ---
On Tue, Jun 07, 2022 at 05:05:01PM +0200, Alexander Gordeev wrote:
> On Mon, Jun 06, 2022 at 03:13:12PM -0700, Andrew Morton wrote:
> > (switched to email.  Please respond via emailed reply-to-all, not via t=
he
> > bugzilla web interface).
>=20
> Hi Zorro,
>=20
> Unfortunately, I am not able to reproduce the issue. Could you please
> clarify your test environment details and share your xfstests config?

One of the test environment details as [1]. The xfstests config as [2].
It's easier to reproduce on 64k directory size xfs by running xfstests
auto group.

Thanks,
Zorro

[1]
CPU
Vendor  IBM/S390
Model Name      8561
Family  0
Model   3126312
Stepping        0
Speed   0.0
Processors      2
Cores   0
Sockets 0
Hyper   True
Flags   edat dfp vxp vx vxe ldisp sie vxe2 highgprs etf3eh te vxd gs sort z=
arch
msa stfle dflt eimm esan3
Arch(s) s390x

Memory  4096 MB
NUMA Nodes      1

Disks
Model   Size    Logical sector size     Physical sector size
3390/0c 41.03 GB / 38.21 GiB    4096 bytes      4096 bytes

[2]
# cat local.config
FSTYP=3Dxfs
TEST_DEV=3D/dev/loop0
TEST_DIR=3D/mnt/fstests/TEST_DIR
SCRATCH_DEV=3D/dev/loop1
SCRATCH_MNT=3D/mnt/fstests/SCRATCH_DIR
LOGWRITES_DEV=3D/dev/loop2
MKFS_OPTIONS=3D"-n size=3D65536 -m
crc=3D1,finobt=3D1,reflink=3D1,rmapbt=3D0,bigtime=3D1,inobtcount=3D1"
TEST_FS_MOUNT_OPTS=3D""

>=20
> Thanks!
>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
