Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943D6C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 11:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240582AbiETL4k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 07:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346192AbiETL4j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 07:56:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480FE248D7
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 04:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1A5061DF6
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 11:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4694BC34118
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 11:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653047797;
        bh=S4KBLgSAZE6UntP2kPlECHzypxXEPW+XWpuEShDRWpM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=H9xTbcbBrkflsidQKvHTjUx92qcouqB/XS4kmOCOlyuBKF+qFOrXNPj6Xy7GWnvP2
         fXhYDidfDlyfCNRxV4UJXrri4CORqOjD790iy+8JLnTiVgfEXWH4uyljUHoRySrcx9
         wXvykgpboAgR50miuuaTTQfQIm5tNIQjsMWbGzKk97Jnv5CplD9c8uCcuQPQG8I77f
         q7yQFZ/KLjXU3gKDXLWBFStP/MfYi5aVD4CCw/AITlikVoKLtJTgIu5+QvV+eQKUfG
         Xs/RLc5um+9DHqFVVR2gAYXazO1O/JJqjhd7do6YMbT2xjuQ768jyZv3Saay9yHPrY
         7Fw3bPhPV8x9Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 37BB2C05FD2; Fri, 20 May 2022 11:56:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Fri, 20 May 2022 11:56:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugzkernelorg8392@araxon.sk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216007-201763-CIfj0dJPEm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

--- Comment #1 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
Created attachment 301009
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301009&action=3Dedit
kernel config file

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
