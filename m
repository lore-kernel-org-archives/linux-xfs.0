Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F96C43334
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jun 2022 08:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347745AbiFJIcr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 04:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348053AbiFJIcW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 04:32:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1972B3C732
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 01:30:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D515B832C4
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 08:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39CF2C341C6
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 08:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654849808;
        bh=kPTrugYuu3Hyc1GHOZOzm9kzpVRf3wuQV/aYA2aJqXM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LlkHnsj8vz1/F3lPIve15Vj2RiOwbhH0xk8I4RRHwOKcspOXAtiih+KX7thbdVOhY
         WuV+8YpamRm38922wNd+g8sP1e+sn0G1rDaaLMX9CYIsz7PshxJNgu7bWOx6F+6U1V
         B669ancDyVkHw/wrpHMOGf64zm9fzv1GZsoMPW/NgooBNCaEDcTOR2PZUWlCywj/ax
         xTYJC4dEyYAaBRDeXiXWUzSZ6mAkmwBl7W0RJ9RyGHcLAyAgE/BSFqwMzzypdu2SRn
         irZRqVz3TrOH7pQ8YJTwQc3KEDZ61y0wO8Clr/l/vDasqpZ3YLwPxwn4xNvRls1eqB
         VnILHdS8V22Ag==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 277AEC05FD5; Fri, 10 Jun 2022 08:30:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216110] rmdir sub directory cause i_nlink of parent directory
 down from 0 to 0xffffffff
Date:   Fri, 10 Jun 2022 08:30:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: hexiaole1994@126.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216110-201763-cIfbQ5nx8F@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216110-201763@https.bugzilla.kernel.org/>
References: <bug-216110-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216110

--- Comment #1 from hexiaole (hexiaole1994@126.com) ---
Created attachment 301146
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301146&action=3Dedit
screenshot of the corrupted i_nlink of the parent directory

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
