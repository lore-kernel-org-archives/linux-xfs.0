Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730A6CA90AF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 11:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4535220659
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 11:00:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M2ZTsHVx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbgEMLA1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 07:00:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48542 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726020AbgEMLA1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 07:00:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589367624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J8HCUAJl3YWUi1bvz+f8CN3lNrUHyhTdBlGFJffZykU=;
        b=M2ZTsHVxOLaOcHRysUsrWiPtguhozCpoAsvPzgPQqZXwjDp+dmCESEhsKQzfynGwkQYz4m
        fAAQOBjNBlARcDGvMS3qmni/xYlSjg00LcZCUalAkVl+K8d4ScTED0C5qhAM/HlMSAHflM
        xS3BZS26Ts30TRN1kLCqsdbLNO7xrW4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-XXF7Aj7RP8aCSLnJ1CqWmA-1; Wed, 13 May 2020 07:00:22 -0400
X-MC-Unique: XXF7Aj7RP8aCSLnJ1CqWmA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7EC8A0BDC;
        Wed, 13 May 2020 11:00:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC9C160C05;
        Wed, 13 May 2020 11:00:18 +0000 (UTC)
Date:   Wed, 13 May 2020 07:00:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: remove XFS_QMOPT_ENOSPC flag
Message-ID: <20200513110016.GA44225@bfoster>
References: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
 <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
 <20200508130154.GC27577@bfoster>
 <57c07fd1-9dd1-8a03-da29-2b1b99cfa2ed@sandeen.net>
 <20200508162129.GJ27577@bfoster>
 <20200512233443.GP6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512233443.GP6714@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 04:34:43PM -0700, Darrick J. Wong wrote:
> On Fri, May 08, 2020 at 12:21:29PM -0400, Brian Foster wrote:
> > On Fri, May 08, 2020 at 10:45:48AM -0500, Eric Sandeen wrote:
> > > On 5/8/20 8:01 AM, Brian Foster wrote:
> > > > On Thu, May 07, 2020 at 11:00:34PM -0500, Eric Sandeen wrote:
> > > >> The only place we return -EDQUOT, and therefore need to make a decision
> > > >> about returning -ENOSPC for project quota instead, is in xfs_trans_dqresv().
> > > >>
> > > >> So there's no reason to be setting and clearing XFS_QMOPT_ENOSPC at higher
> > > >> levels; if xfs_trans_dqresv has failed, test if the dqp we were were handed
> > > >> is a project quota and if so, return -ENOSPC instead of EDQUOT.  The
> > > >> complexity is just a leftover from when project & group quota were mutually
> > > >> exclusive and shared some codepaths.
> > > >>
> > > >> The prior patch was the trivial bugfix, this is the slightly more involved
> > > >> cleanup.
> > > >>
> > > >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > > >> ---
> > > > 
> > > > Hmm so what about callers that don't pass QMOPT_ENOSPC? For example, it
> > > > looks like various xfs_trans_reserve_quota() calls pass a pdqp but don't
> > > > set the flag.
> > > 
> > > Oh, interesting.  I bet that was an oversight, tbh, but let's see.
> > > 
> > > <rewinds 14 years>
> > > 
> > > commit 9a2a7de268f67fea0c450ed3e99a2d31f43d7166
> > > Author: Nathan Scott <nathans@sgi.com>
> > > Date:   Fri Mar 31 13:04:49 2006 +1000
> > > 
> > >     [XFS] Make project quota enforcement return an error code consistent with
> > >     its use.
> > > 
> > > so yeah, even back then, stuff like xfs_symlink returned EDQUOT not ENOSPC.
> > > 
> > > Today, these call the reservation w/o the special ENOSPC flag:
> > > 
> > > xfs_unmap_extent
> > > xfs_create
> > > xfs_create_tmpfile
> > > xfs_symlink
> > > 
> > > and so will return EDQUOT instead of ENOSPC even for project quota.
> > > 
> > > You're right that my patch changes these to ENOSPC.
> > > 
> > > > Is the intent to change behavior such that -ENOSPC is
> > > > unconditional for project quota reservation failures?
> > > 
> > > Now it's a conundrum.  I /think/ the current behavior is due to an oversight, but 
> > > 
> > > a) I'm not certain, and
> > > b) can we change it now?
> > > 
> > 
> > Heh, I can't really tell what the intended/expected behavior is. For
> > whatever it's worth, it seems reasonable enough to me to change it based
> > on the fact that project quotas have been expected to return -ENOSPC in
> > at least some common cases for many years. It seems unlikely that users
> > would know or care about the change in behavior in the subset noted
> > above, but who knows. It might be good to get some other opinions. :P
> 
> "I bet you a beer at the next conference (if they ever happen again)
> that nobody will notice"? :P
> 

Apocalypse aside, free beer is free beer. ;)

> TBH while I find it a little odd that project quota gets to return
> ENOSPC instead of EDQUOT, I find it more odd that sometimes it doesn't.
> This at least gets us to consistent behavior (EDQUOT for user/group,
> ENOSPC for project) so for the series:
> 

Works for me, but can we update the commit log to describe the behavior
change before this goes in? In fact, it might even make sense to retitle
the patch to something like "xfs: always return -ENOSPC on project quota
reservation failure" and let the flag removal be a side effect of that.

Brian

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> (Let's see what an fstests run spits out...)
> 
> --D
> 
> > Brian
> > 
> > > -Eric
> > > 
> > 
> 

