Return-Path: <SRS0=Ip4f=4C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2106EC2BA83
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E949B222C2
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:18:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C6Yspuzt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405185AbgBNSSm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 13:18:42 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51664 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405177AbgBNSSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Feb 2020 13:18:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581704320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xGatBSxTmbi3SCLMY3Iax0T1D3mK/QaiiHyVZvgWjiQ=;
        b=C6Yspuzt8QNK6m9sOWfRn4jW7chjiuLa0Yd/o+TubZq88otMb6DtYC4NUj8LCuZ5cBxRS2
        TRbfvzVeWbJyYQXc544pQXtCgzrsv1VrYeVD9nD1xVKwG+5vR5KGs50n5d1uFczyqmkVhq
        Fb+GpKK/SG1gYZIivk8GXapzqlmhEsQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-S4psMR2xM_-FJYOL0vCn7Q-1; Fri, 14 Feb 2020 13:18:33 -0500
X-MC-Unique: S4psMR2xM_-FJYOL0vCn7Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27CEF8017CC;
        Fri, 14 Feb 2020 18:18:32 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1ED390094;
        Fri, 14 Feb 2020 18:18:31 +0000 (UTC)
Date:   Fri, 14 Feb 2020 13:18:30 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 206397] [xfstests generic/475] XFS: Assertion failed:
 iclog->ic_state == XLOG_STATE_ACTIVE, file: fs/xfs/xfs_log.c, line: 572
Message-ID: <20200214181830.GA20865@bfoster>
References: <bug-206397-201763@https.bugzilla.kernel.org/>
 <bug-206397-201763-9tX2Bll3tL@https.bugzilla.kernel.org/>
 <20200212155510.GC17921@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212155510.GC17921@bfoster>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 12, 2020 at 10:55:10AM -0500, Brian Foster wrote:
> On Tue, Feb 04, 2020 at 05:10:05PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=206397
> > 
> > --- Comment #2 from Zorro Lang (zlang@redhat.com) ---
> > (In reply to Chandan Rajendra from comment #1)
> > > I was unable to recreate this issue on a ppc64le kvm guest. I used Linux
> > > v5.5 and xfsprogs' for-next branch.
> > > 
> > > Can you please share the kernel config file? Also, Can you please tell me
> > > how easy is it recreate this bug?
> > 
> > It's really hard to reproduce. The g/475 is a random test, it's helped us to
> > find many different issues. For this bug, this's the 1st time I hit it, and
> > can't reproduce it simply.
> > 
> 
> Have you still been unable to reproduce (assuming you've been attempting
> to)? How many iterations were required before you reproduced the first
> time?
> 
> I'm wondering if the XLOG_STATE_IOERROR check in xfs_log_release_iclog()
> is racy with respect to filesystem shutdown. There's an ASSERT_ALWAYS()
> earlier in this (xlog_cil_push()) codepath that checks for ACTIVE ||
> WANT_SYNC and it doesn't appear that has failed from your output
> snippet. The aforementioned IOERROR check occurs before we acquire
> ->l_icloglock, however, which I think means xfs_log_force_umount() could
> jump in if called from another task and reset all of the iclogs while
> the release path waits on the lock.
> 

FWIW, I wasn't able to reproduce after a day or so of iterating
generic/475, but I was able to confirm that the check referenced above
is racy. The problem looks like a minor oversight in commit df732b29c8
("xfs: call xlog_state_release_iclog with l_icloglock held"). I've
floated a patch here:

https://lore.kernel.org/linux-xfs/20200214181528.24046-1-bfoster@redhat.com/

Brian

> Brian
> 
> > -- 
> > You are receiving this mail because:
> > You are watching the assignee of the bug.
> > 
> 

