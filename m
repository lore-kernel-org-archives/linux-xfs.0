Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E002C47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDF342166E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:23:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Udp8briL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgEALXU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 07:23:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22041 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728485AbgEALXT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 07:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588332197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cwng3AdzEPQmQrKCIRxJzp2R1ov2HMPvhs9ASGdrSRg=;
        b=Udp8briLR1dRTs67SSvcT4dVRQ+93JdLZs8FAhh+InqTG7g+zlQgJNp+hyq68cKzc/Wg0d
        S0Z6tuBjW8ZRU+Paxc+jbj7iUxUwNNX3CGJsPoLPwobUobhbQRX9pFpmHM81WbRZmkl/H2
        mCODRP1PnlbJyrS+1taJLb+qRPvYGi0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-p-nOVtnQOmK5f9gZgeKUDA-1; Fri, 01 May 2020 07:22:58 -0400
X-MC-Unique: p-nOVtnQOmK5f9gZgeKUDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FCD5835B41;
        Fri,  1 May 2020 11:22:57 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A3AD605D7;
        Fri,  1 May 2020 11:22:56 +0000 (UTC)
Date:   Fri, 1 May 2020 07:22:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 03/17] xfs: simplify inode flush error handling
Message-ID: <20200501112254.GA40250@bfoster>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-4-bfoster@redhat.com>
 <20200430183703.GD6742@magnolia>
 <20200501091730.GA20187@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501091730.GA20187@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 02:17:30AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 30, 2020 at 11:37:03AM -0700, Darrick J. Wong wrote:
> > TBH I've long wondered why we flush one inode and only then check that
> > the icluster buffer is pinned and if so force the log?  Did we do that
> > for some sort of forward progress guarantee?
> > 
> > I looked at a3f74ffb6d144 (aka when the log force moved here from after
> > the iflush_cluster call) but that didn't help me figure out if there's
> > some subtlety here I'm missing, or if the ordering here was weird but
> > the weirdness didn't matter?
> > 
> > TLDR: I can't tell why it's ok to move the xfs_iflush_int call down past
> > the log force. :/
> 
> As far as I can tell the log force is to avoid waiting for the buffer
> to be unpinned.  This is mostly bad when using xfs_bwrite, which we
> still do for the xfs_reclaim_inode case, given that xfs_inode_item_push
> alredy checks for the pinned inode earlier, and lets the xfsaild handle
> the log pushing.
> 

Right, that was my impression of the force as well. Note that it's async
and we already own the buffer lock at this point, so I don't see why
ordering would matter that much functionally. My impression of the
earlier patch is this landed before the cluster flush because that's
heavier weight and simply provides the bulk of the optimization.

> Which means doing the log_force earlier is actually a (practially not
> relevant) micro-optimization as it gives the log code a few more
> instructions worth of time to push out and complete the log buffer.
> 
> Maybe this wants to be split out into a prep patch to better document
> the change.
> 
> 

The intent was more just to clean up the function than to provide any
sort of additional optimization. It seems cleaner to check pinned status
as soon as we grab the buffer vs. somewhere between inode flushes. I
don't think this warrants a separate patch unless we took it further to
somehow avoid the log force in the non-reclaim case. My understanding is
that Dave's upcoming work would eliminate the need for this force in the
reclaim case, so I'm not sure there's value in swizzling it around in
the meantime.

Brian

