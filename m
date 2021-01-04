Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAE7C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 19:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 727C720784
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 19:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhADTfa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 14:35:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbhADTfa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 14:35:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609788844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OGR+6/+t+cAkiBULlmi72UwSH3wokl43j6RrQLVn/w4=;
        b=BfcrQBn8LzMYeQeCeJcV5+SK5QGU8Ct2MWFUwhs3ObPrXnf9fJyd7xg9e5s6y6aFX9Vqe1
        1txpZzysTKVrng61lcIaQBSVm94+Yvwun50iGIhTma1Iivm5dTu/zeRm6q0AB7EZxzLIYs
        pBii8gUWX8b61n6xfkDfZPbvdadu5ig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-c7eQXIi2Oce2kc9EGQC_NA-1; Mon, 04 Jan 2021 14:34:01 -0500
X-MC-Unique: c7eQXIi2Oce2kc9EGQC_NA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D297F803623;
        Mon,  4 Jan 2021 19:34:00 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79F066F95D;
        Mon,  4 Jan 2021 19:34:00 +0000 (UTC)
Date:   Mon, 4 Jan 2021 14:33:58 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 210723] [Bug report] overlayfs over xfs whiteout operation
 may cause deadlock
Message-ID: <20210104193358.GD254939@bfoster>
References: <bug-210723-201763@https.bugzilla.kernel.org/>
 <bug-210723-201763-DVHc1YENLi@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-210723-201763-DVHc1YENLi@https.bugzilla.kernel.org/>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 04, 2021 at 03:09:23PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=210723
> 
> --- Comment #1 from Dave (chiluk@ubuntu.com) ---
> Has there been any progress on this?  We've been regularly hitting what appears
> to be an xfs deadlock on 5.8, 5.9, and now 5.10 on our kubernetes nodes that
> also employ containers and overlayfs.  I haven't been able to do as much
> digging as wenli yet so I don't have any more detailed information.
> 

For whatever reason this bug report has not been synced between bugzilla
and the mailing list. I don't see the initial report on the list at all
and the subsequent replies to the initial thread appear on the list and
not in the bz.

In any event, I believe Darrick root caused and Wenli confirmed a fix
here:

https://lore.kernel.org/linux-xfs/20201217211117.GF38809@magnolia/

... which presumably just needs to be posted/reviewed as a proper patch.

Brian

> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
> 

