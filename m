Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A19C38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 16:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C17721473
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 16:21:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cWckn87k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgEHQVj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 12:21:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37802 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHQVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 12:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588954897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5DOf2fFO1D3xyn6y6CB/p9f55wKxDw14r6tBySMM5j0=;
        b=cWckn87kxeWdpLv3vrspcMJ6C1esHttaXDX7Rdkd4/3zcfNXVnkitxLks08m+TCHIPSFA2
        kGMoZ0nIrDAAqQJal15XAu8f+4tLMV1E/YcEJ65co7x1AGAPtIXuFvMb9VkN4ppL+nw9MQ
        JO1IIeCMdP6C0WQlD3NSL949NCs9Duk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-d4iDrbb2OBWgOpb9hmvnXQ-1; Fri, 08 May 2020 12:21:34 -0400
X-MC-Unique: d4iDrbb2OBWgOpb9hmvnXQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E70E4107ACCA;
        Fri,  8 May 2020 16:21:33 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 053001001DC2;
        Fri,  8 May 2020 16:21:30 +0000 (UTC)
Date:   Fri, 8 May 2020 12:21:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: remove XFS_QMOPT_ENOSPC flag
Message-ID: <20200508162129.GJ27577@bfoster>
References: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
 <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
 <20200508130154.GC27577@bfoster>
 <57c07fd1-9dd1-8a03-da29-2b1b99cfa2ed@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57c07fd1-9dd1-8a03-da29-2b1b99cfa2ed@sandeen.net>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 10:45:48AM -0500, Eric Sandeen wrote:
> On 5/8/20 8:01 AM, Brian Foster wrote:
> > On Thu, May 07, 2020 at 11:00:34PM -0500, Eric Sandeen wrote:
> >> The only place we return -EDQUOT, and therefore need to make a decision
> >> about returning -ENOSPC for project quota instead, is in xfs_trans_dqresv().
> >>
> >> So there's no reason to be setting and clearing XFS_QMOPT_ENOSPC at higher
> >> levels; if xfs_trans_dqresv has failed, test if the dqp we were were handed
> >> is a project quota and if so, return -ENOSPC instead of EDQUOT.  The
> >> complexity is just a leftover from when project & group quota were mutually
> >> exclusive and shared some codepaths.
> >>
> >> The prior patch was the trivial bugfix, this is the slightly more involved
> >> cleanup.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> > 
> > Hmm so what about callers that don't pass QMOPT_ENOSPC? For example, it
> > looks like various xfs_trans_reserve_quota() calls pass a pdqp but don't
> > set the flag.
> 
> Oh, interesting.  I bet that was an oversight, tbh, but let's see.
> 
> <rewinds 14 years>
> 
> commit 9a2a7de268f67fea0c450ed3e99a2d31f43d7166
> Author: Nathan Scott <nathans@sgi.com>
> Date:   Fri Mar 31 13:04:49 2006 +1000
> 
>     [XFS] Make project quota enforcement return an error code consistent with
>     its use.
> 
> so yeah, even back then, stuff like xfs_symlink returned EDQUOT not ENOSPC.
> 
> Today, these call the reservation w/o the special ENOSPC flag:
> 
> xfs_unmap_extent
> xfs_create
> xfs_create_tmpfile
> xfs_symlink
> 
> and so will return EDQUOT instead of ENOSPC even for project quota.
> 
> You're right that my patch changes these to ENOSPC.
> 
> > Is the intent to change behavior such that -ENOSPC is
> > unconditional for project quota reservation failures?
> 
> Now it's a conundrum.  I /think/ the current behavior is due to an oversight, but 
> 
> a) I'm not certain, and
> b) can we change it now?
> 

Heh, I can't really tell what the intended/expected behavior is. For
whatever it's worth, it seems reasonable enough to me to change it based
on the fact that project quotas have been expected to return -ENOSPC in
at least some common cases for many years. It seems unlikely that users
would know or care about the change in behavior in the subset noted
above, but who knows. It might be good to get some other opinions. :P

Brian

> -Eric
> 

