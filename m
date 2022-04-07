Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454C7C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 02:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiDGCfg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 22:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiDGCfg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 22:35:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854121FCD25
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 19:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3B306190E
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 02:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14DBFC385AD
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 02:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649298817;
        bh=il7LYTENj/ltiRNmtB/QOIIy3f7oH7a+YHr4v5dpiyo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Sa8JI2wc3+bgveABmwf06VHKk/XinWNDZuc5s6GNun7izMoWBN0yLGbgKR0id8fOu
         LqGWyVrDUnz7k6plSCaswAhipuaPw7IiY7xavnZAwBhNATZQhDvlxTogqTfb0iDW4o
         Jc0GgWEU/jQcVYXE6uofukrZdUBEGr5ayqPQeE6fIqyDgGVkpwBfbkZCAaM0Pm3YMK
         4eU6VhTaLQXbs7obTJdsYdhHDHp6wQs2T2ARyeD/MsUlrGecnhk2a7yE6Bi8OUskA/
         lF+xG8Hcg7c33xx60g4NJpB/1SyxigFN+xt+vNqc1oe5mzSftMKC/FqXkwz2pz4GbX
         TCkYefHrxlpiw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 050B9C05FE2; Thu,  7 Apr 2022 02:33:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Thu, 07 Apr 2022 02:33:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: matthew@wil.cx
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215804-201763-VD4z9rttpe@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215804-201763@https.bugzilla.kernel.org/>
References: <bug-215804-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215804

--- Comment #11 from Matthew Wilcox (matthew@wil.cx) ---
Ah, the migrate problem.  I have patches already:

https://lore.kernel.org/linux-mm/20220404193006.1429250-1-willy@infradead.o=
rg/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
