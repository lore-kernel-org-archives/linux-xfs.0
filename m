Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE95EC7EE24
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jun 2023 03:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjFDDbY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Jun 2023 23:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjFDDbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2023 23:31:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92399D3
        for <linux-xfs@vger.kernel.org>; Sat,  3 Jun 2023 20:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12F5661B50
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 03:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FCA1C433A1
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 03:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685849481;
        bh=lmQ9PD10V5FK+YiSwpXbn3aXkrrIilCBpRBEWEnwErA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=U0UfiBsqjk8vLGeBy84GJlHkWpzg7rgnnJkGhNUXtHyY2uL9RCaa0MPYbFwr72Qy0
         +Hoagy0UYEqVFWACFOJ6GyLDfyFFvJh6DuRPw5rZwnZ0kCo9o+wlLUMfCEg24/SN6e
         RfMWkhIolu94alzKzeCfKZVCkgT2+WCF/9lZVHzTWaK9iPkRR9IhbUtxkY2taWABzY
         fSqGZs8TU69OsTqBwmuN1zQsQLStMEUbtRebsVb3JxaE5VKDnMW/C53gTI44L7Cv0f
         1wofevF0hGJu74uMhEHWhS0n8C0notxbf7cIMxJ8QVmtLMkcahqmWd7ZMf88byzJYH
         pfl9EjZyCb80Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 59E3CC43145; Sun,  4 Jun 2023 03:31:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217522] xfs_attr3_leaf_add_work produces a warning
Date:   Sun, 04 Jun 2023 03:31:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lomov.vl@bkoty.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217522-201763-NVge3HI5rt@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217522-201763@https.bugzilla.kernel.org/>
References: <bug-217522-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217522

--- Comment #2 from Vladimir Lomov (lomov.vl@bkoty.ru) ---
Hello
** bugzilla-daemon@kernel.org <bugzilla-daemon@kernel.org> [2023-06-03 14:5=
0:24
+0000]:

>https://bugzilla.kernel.org/show_bug.cgi?id=3D217522
>
>--- Comment #1 from Darrick J. Wong (djwong@kernel.org) ---
>On Sat, Jun 03, 2023 at 03:58:25AM +0000, bugzilla-daemon@kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D217522
>>
>>             Bug ID: 217522
>>            Summary: xfs_attr3_leaf_add_work produces a warning
>>            Product: File System
>>            Version: 2.5
>>           Hardware: All
>>                 OS: Linux
>>             Status: NEW
>>           Severity: normal
>>           Priority: P3
>>          Component: XFS
>>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>>           Reporter: lomov.vl@bkoty.ru
>>         Regression: No
>>
>> Hi.
>>
>> While running linux-next
>> (6.4.0-rc4-next-20230602-1-next-git-06849-gbc708bbd8260) on one of my ho=
sts,
>> I
>> see the following message in the kernel log (`dmesg`):
>> ```
>> Jun 02 20:01:19 smoon.bkoty.ru kernel: ------------[ cut here ]---------=
---
>> Jun 02 20:01:19 smoon.bkoty.ru kernel: memcpy: detected field-spanning w=
rite
>> (size 12) of single field "(char *)name_loc->nameval" at
>
> Yes, this bug is a collision between the bad old ways of doing flex
> arrays:
>
> typedef struct xfs_attr_leaf_name_local {
>         __be16  valuelen;               /* number of bytes in value */
>         __u8    namelen;                /* length of name bytes */
>         __u8    nameval[1];             /* name/value bytes */
> } xfs_attr_leaf_name_local_t;

> And the static checking that gcc/llvm purport to be able to do properly.

Something similar has caused problems with kernel compilation before:
https://lkml.org/lkml/2023/5/24/576 (I'm not 100% sure if the origin is the
same though).

> This is encoded into the ondisk structures, which means that someone
> needs to do perform a deep audit to change each array[1] into an
> array[] and then ensure that every sizeof() performed on those structure
> definitions has been adjusted.  Then they would need to run the full QA
> test suite to ensure that no regressions have been introduced.  Then
> someone will need to track down any code using
> /usr/include/xfs/xfs_da_format.h to let them know about the silent
> compiler bomb heading their way.

> I prefer we leave it as-is since this code has been running for years
> with no problems.

Should I assume that this problem is not significant and won't have any eff=
ect
to the FS and won't cause the FS to misbehave or become corrupted? If so, w=
hy
does the problem only show up on one host but not on the other? Or is this a
runtime check, and it somehow happens on the first system (even rebooted
twice), but not on the second one.

[...]

---
Vladimir Lomov

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
