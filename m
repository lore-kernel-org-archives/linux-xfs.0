Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f180.google.com ([209.85.219.180]:44922 "EHLO
        mail-yb1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfF0QNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 12:13:00 -0400
MIME-Version: 1.0
References: <155009104740.32028.193157199378698979.stgit@magnolia> <20190213205804.GE32253@magnolia>
In-Reply-To: <20190213205804.GE32253@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 27 Jun 2019 19:12:48 +0300
Message-ID: <CAOQ4uximAfJjNdunY2xK_1DwC2G7v31XWbv64AdO9nYdExUsVw@mail.gmail.com>
Subject: [STABLE 4.19] fixes for xfs memory and fs corruption
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, stable <stable@vger.kernel.org>

Darrick,

Can I have your blessing on the choice of these upstream commits
as stable candidates?
I did not observe any xfstests regressions when testing v4.19.55
with these patches applied.

Sasha,

Can you run these patches though your xfstests setup?
They fix nasty bugs.

Make sure to update xfsprogs to very latest, because
generic/530 used to blow up (OOM) my test machine...

>
> The first patch fixes a memory corruption that syzkaller found in the
> attr listent code;

3b50086f0c0d xfs: don't overflow xattr listent buffer

> see "generic: posix acl extended attribute memory
> corruption test" for the relevant regression test.

Fixed generic/529

>
> Patches 2 fixes problems found in XFS's unlinked inode recovery code
> that were unearthed by some new testcases.  We're logging nlink==1 temp
> files on the iunlinked list (and then the vfs sets nlink to 0 without
> telling us) which means that we leak them in recovery if we crash
> immediately after the committing the creation of the temp file.
>
> Patch 3 fixes the problem that ifree during recovery can expand the
> finobt but we need to force the ifree code to reserve blocks for the
> transaction because perag reservations aren't set up yet.

e1f6ca113815 xfs: rename m_inotbt_nores to m_finobt_nores
15a268d9f263 xfs: reserve blocks for ifree transaction during log recovery
c4a6bf7f6cc7 xfs: don't ever put nlink > 0 inodes on the unlinked list

>
> See "[PATCH v2 2/2] generic: check the behavior of programs opening a
> lot of O_TMPFILE files" for the regression test.
>

Fixes generic/530

Thanks,
Amir.
