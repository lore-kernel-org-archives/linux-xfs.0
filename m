Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111A6C55199
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 11:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6B8E2063A
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 11:12:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TcU7I06z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgD0LMP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 07:12:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55074 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726589AbgD0LMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 07:12:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587985934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9bkVjAqC9prJNVWMB4TLm+EKM94gqlRnosaWJwLWzLk=;
        b=TcU7I06zXlXHOZSJR6JyrBS/m1MIlUvfmLl43WQgGWEDdpOX8niJ3IkWSdQ4jPOZnRQ14I
        YeN8C5fRGR94Kts/KiO9kIHhPBX24yK3eUkoytmyrKafJo4vTQ2EJ7slAMn3tVnVcwhwgX
        r40Ku512tg/iVggvtEShDX4+fhtMxCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-sSKzTBSLPeWqP6E5u5IrPQ-1; Mon, 27 Apr 2020 07:12:12 -0400
X-MC-Unique: sSKzTBSLPeWqP6E5u5IrPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 860501899521;
        Mon, 27 Apr 2020 11:12:11 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AF9519C58;
        Mon, 27 Apr 2020 11:12:11 +0000 (UTC)
Date:   Mon, 27 Apr 2020 07:12:09 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 09/13] xfs: clean up AIL log item removal functions
Message-ID: <20200427111209.GC4577@bfoster>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-10-bfoster@redhat.com>
 <20200425173717.GG30534@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425173717.GG30534@infradead.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 10:37:17AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 22, 2020 at 01:54:25PM -0400, Brian Foster wrote:
> > Make the following changes to clean up both of these functions:
> > 
> > - Most callers of xfs_trans_ail_delete() acquire the AIL lock just
> >   before the call. Update _delete() to acquire the lock and open
> >   code the couple of callers that make additional checks under AIL
> >   lock.
> > - Drop the unnecessary ailp parameter from _delete().
> > - Drop the unused shutdown parameter from _remove() and open code
> >   the implementation.
> > 
> > In summary, this leaves a _delete() variant that expects an AIL
> > resident item and a _remove() helper that checks the AIL bit. Audit
> > the existing callsites for use of the appropriate function and
> > update as necessary.
> 
> Wouldn't it make sense to split this into separate patches for the
> items above?  I have a bit of a hard time verifying this patch, even
> if the goal sounds just right.
> 

This ended up as one patch pretty much because I couldn't figure out
what the factoring steps needed to be until I came to the end result.
I'll revisit splitting it up..

Brian

