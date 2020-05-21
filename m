Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5151EC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 17:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1849320759
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 17:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SzM5DXne"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgEURKD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 13:10:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24133 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728581AbgEURKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 13:10:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590081002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lthb6SbxtcMxgAK/SZf5iu4yHeaRb3WqO7lobx7HclI=;
        b=SzM5DXnedm3WY1hzs8NlCrjIHQeTgBx6FJjW7Ebm9C3ooH//DTvllVoT4u2XhQ7S25j26J
        Ptn+KLh0UcEq7YfBq54DMWaxrwj2oe3xm+U3xrtNg1OZeowBzUNn/4Lspy9UtcL0yhH0lZ
        HfUqZgVtYYwNMTmcFntFhphBRGQLCq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-GKdU-MQnO76V9ht_qIJDyg-1; Thu, 21 May 2020 13:09:57 -0400
X-MC-Unique: GKdU-MQnO76V9ht_qIJDyg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D715C835B40;
        Thu, 21 May 2020 17:09:56 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 86E90707C0;
        Thu, 21 May 2020 17:09:56 +0000 (UTC)
Date:   Thu, 21 May 2020 13:09:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 207817] kworker using a lots of cpu
Message-ID: <20200521170954.GB45732@bfoster>
References: <bug-207817-201763@https.bugzilla.kernel.org/>
 <bug-207817-201763-k4jOyZfee6@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-207817-201763-k4jOyZfee6@https.bugzilla.kernel.org/>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 04:45:34PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=207817
> 
> --- Comment #1 from Alexander Petrovsky (askjuise@gmail.com) ---
> After 1 day, it seems like some internal activity calm down kworker at 00:00
> UTC, it could be logrotate or smth else. But now, I'm observe the follow (seems
> like it has the same root cause):
> 

Note that you're reporting problems with a distro kernel and proprietary
hypervisor to an upstream mailing list (via an upstream bug tracker).
The feedback will likely be limited unless you can reproduce on an
upstream kernel.

In general, it's not really clear to me what you're reporting beyond the
writeback task using more CPU than anticipated. What is that based on?
What problematic functional or performance related behavior is observed?
If performance related, what exactly is the workload?

> #df -h
> Filesystem                     Size  Used Avail Use% Mounted on
> ...
> /dev/mapper/vg_logs-lv_varlog   38G  -30G   68G    - /var/log
> ...

I think we've had some upstream patches to fix underflows and such in
space reporting paths fairly recently, but I'm not sure off hand if
those are associated with any functional issues beyond indication of
potential corruption. This suggests you should probably run 'xfs_repair
-n' on this filesystem if you haven't already.

Brian

> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
> 

