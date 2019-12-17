Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8C9C2D0CD
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 12:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C44FF207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 12:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WC/BLmfQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLQMDQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 07:03:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40860 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726608AbfLQMDQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 07:03:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576584195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tD8dOME/4sWvD8hMnn32Hm7Actlpg4gWVP8R84BLjfA=;
        b=WC/BLmfQiAG3hS02f1uhlK6qvWHrJX2ADVnLzA4ig2mhzHgIjnWzVx4Z+wkVOqPK0q6rAY
        g4yibDNlCNobgzTUZcjViLAhkt1QvOnmktNGwD3Yqa9QsgYT5z6WqQa8Om2mvn4YoSKy+0
        7OeyGLSwilfw8Q57EjyZ6gqQK66dBIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-Gr_7FM5vNc-CB4HOR73Mdw-1; Tue, 17 Dec 2019 07:03:08 -0500
X-MC-Unique: Gr_7FM5vNc-CB4HOR73Mdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBB9F1800D42;
        Tue, 17 Dec 2019 12:03:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 626031000328;
        Tue, 17 Dec 2019 12:03:07 +0000 (UTC)
Date:   Tue, 17 Dec 2019 07:03:05 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 205833] fsfreeze blocks close(fd) on xfs sometimes
Message-ID: <20191217120305.GD48778@bfoster>
References: <bug-205833-201763@https.bugzilla.kernel.org/>
 <bug-205833-201763-eFyXjnn6uA@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-205833-201763-eFyXjnn6uA@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 09:34:34AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=205833
> 
> --- Comment #2 from Stefan @dns2utf8 Schindler (kernel.org@estada.ch) ---
> Hi Brian
> 
> Thank you! Here is the stack of a blocked `tail 0.txt` process:
> 
> cat /proc/276/stack
> [<0>] call_rwsem_down_read_failed+0x18/0x30
> [<0>] __percpu_down_read+0x58/0x80
> [<0>] __sb_start_write+0x65/0x70
> [<0>] xfs_trans_alloc+0xec/0x130 [xfs]
> [<0>] xfs_free_eofblocks+0x12a/0x1e0 [xfs]
> [<0>] xfs_release+0x144/0x170 [xfs]
> [<0>] xfs_file_release+0x15/0x20 [xfs]
> [<0>] __fput+0xea/0x220
> [<0>] ____fput+0xe/0x10
> [<0>] task_work_run+0x9d/0xc0
> [<0>] ptrace_notify+0x84/0x90
> [<0>] tracehook_report_syscall_exit+0x90/0xd0
> [<0>] syscall_slow_exit_work+0x50/0xd0
> [<0>] do_syscall_64+0x12b/0x130
> [<0>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [<0>] 0xffffffffffffffff
> 
> Your explanation matches the behaviour I see on the system.
> 
> If there was a patch, do you think it would get backported or just stay in
> mainline and ship with the regular releases?
> 

There was a patch, but it was RFC and hadn't been merged because IIRC
more investigation/testing was required to evaluate side effects. For
reference, the last post I see is the one below. In particular, patch 3
bypasses EOF block truncation from read-only file descriptors (I believe
the file writer task would still block).

https://marc.info/?l=linux-xfs&m=154951612101291&w=2

Based on the stack above, note that this is (at least for the time
being) expected behavior on XFS.

Brian

> Best,
> Stefan
> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
> 

