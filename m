Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40BFC001B0
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 17:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbjHHROg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbjHHRNx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 13:13:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2502819BF
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 09:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4900C62574
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 13:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2A3BC43391
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 13:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691501943;
        bh=zwlHMeKVRflsP8gpUEVYWDWQrOcNP4C8mhhvTPiJ7Zg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GbCcpsGu/+GSOWut7bLpCulXF2uz/6Mjnm4CNOqyqtrksbMvr7JknVNVwHSAdt5Ts
         9/p/4BkAUIkoxYsqty1yFGkyXdNHgnxpBmSBpfSdvKaPGPwJ7B3meB1K4+qOEwUGtB
         HTXtVCyLff+4mCz3HAfsFkg1bISAh6G0SqeM8pI/oRzxM1zvzxIfXwHIfn+sUBDWOD
         FcXnWLhw8vwl8D4b2Q7sddSlsfsCyT5KX5a0cKBMIQyi1+u1133vpkmRcMLsGsacwi
         siU7rwqM/QyIIBTBeEgyGSLZ4V7LOAJPp+fcPtGU+caspXsaqGIHgNpGaOzs8vtyST
         TYxRbh9HeHl1w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A2B14C53BD0; Tue,  8 Aug 2023 13:39:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Tue, 08 Aug 2023 13:39:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217769-201763-MUCyxTlmHt@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217769-201763@https.bugzilla.kernel.org/>
References: <bug-217769-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217769

--- Comment #7 from Eric Sandeen (sandeen@sandeen.net) ---
What might be most useful is to create an xfs_metadump image of the problem=
atic
filesystem (with -o if you are ok with showing filenames in the clear) and =
from
there we can examine things.

A metadump image is metadata only, no file data, and compresses well. This =
can
then be turned back into a filesystem image for analysis.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
