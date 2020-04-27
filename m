Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135AEC55199
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 11:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDCEB206B6
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 11:38:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XAJHrvS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgD0LiC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 07:38:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45184 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726260AbgD0LiB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 07:38:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587987480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rzuZ2aOv6e//6GoQ6kKEL9Ab6wLfSvLmhfEBQS/Wlk8=;
        b=XAJHrvS8HxtVxXF2bouAejQTMwRguIKvcA7SxhUYEWMMVl5kQo2msPOiyrJ9/cfMIgj6Dq
        UhvFKgtyGj7QFP2OJsjz2rXKmHk1TCIdeGjgtJyLG8/8IPJwaG9xB8XyjXdhGG0vIgX2Co
        tSQsfODQ8bKw5zQPrvGedo2sM5e2LLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-AVJDoYi6PlSFAUteoGh2RA-1; Mon, 27 Apr 2020 07:37:56 -0400
X-MC-Unique: AVJDoYi6PlSFAUteoGh2RA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C69E464;
        Mon, 27 Apr 2020 11:37:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA15E5D715;
        Mon, 27 Apr 2020 11:37:54 +0000 (UTC)
Date:   Mon, 27 Apr 2020 07:37:52 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: teach deferred op freezer to freeze and thaw
 inodes
Message-ID: <20200427113752.GE4577@bfoster>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752130655.2142108.9338576917893374360.stgit@magnolia>
 <20200425190137.GA16009@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425190137.GA16009@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 12:01:37PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 21, 2020 at 07:08:26PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make it so that the deferred operations freezer can save inode numbers
> > when we freeze the dfops chain, and turn them into pointers to incore
> > inodes when we thaw the dfops chain to finish them.  Next, add dfops
> > item freeze and thaw functions to the BUI/BUD items so that they can
> > take advantage of this new feature.  This fixes a UAF bug in the
> > deferred bunmapi code because xfs_bui_recover can schedule another BUI
> > to continue unmapping but drops the inode pointer immediately
> > afterwards.
> 
> I'm only looking over this the first time, but why can't we just keep
> inode reference around during reocvery instead of this fairly
> complicated scheme to save the ino and then look it up again?
> 

I'm also a little confused about the use after free in the first place.
Doesn't xfs_bui_recover() look up the inode itself, or is the issue that
xfs_bui_recover() is fine but we might get into
xfs_bmap_update_finish_item() sometime later on the same inode without
any reference? If the latter, similarly to Christoph I wonder if we
really could/should grab a reference on the inode for the intent itself,
even though that might not be necessary outside of recovery.

Either way, more details about the problem being fixed in the commit log
would be helpful.

Brian

