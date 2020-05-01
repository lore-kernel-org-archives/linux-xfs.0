Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D19FC47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 769CD208C3
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:51:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CIgKEscS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbgEALvj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 07:51:39 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29616 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728480AbgEALvj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 07:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588333898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3GWTjdo06x01fWzVZRW44akHaLlrmBlUOWhnuacxRmA=;
        b=CIgKEscSgmepunZ3L9h0BrqBR8FB1OxlgjFb8/R7GlRVGu/IBSD4gqGdpol8ENdyc70ll4
        L+yBB/zYgkDY/tCsNDzUvyL+EUBI2ISDkLXo8Ftxro9higETzZ5cROgkKQrKPMSq3cfawn
        L/G6UVWby65PPAw4N1NPy76uWwNyC7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-e9W_yw7PNiOAFe0krUpVzQ-1; Fri, 01 May 2020 07:51:36 -0400
X-MC-Unique: e9W_yw7PNiOAFe0krUpVzQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47DD1107ACCA;
        Fri,  1 May 2020 11:51:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B06A660CC0;
        Fri,  1 May 2020 11:51:34 +0000 (UTC)
Date:   Fri, 1 May 2020 07:51:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: pass a commit_mode to xfs_trans_commit
Message-ID: <20200501115132.GG40250@bfoster>
References: <20200409073650.1590904-1-hch@lst.de>
 <20200501080703.GA17731@infradead.org>
 <20200501102403.GA37819@bfoster>
 <20200501104245.GA28237@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501104245.GA28237@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 12:42:45PM +0200, Christoph Hellwig wrote:
> On Fri, May 01, 2020 at 06:24:03AM -0400, Brian Foster wrote:
> > I recall looking at this when it was first posted and my first reaction
> > was that I didn't really like the interface. I decided to think about it
> > to see if it grew on me and then just lost track (sorry). It's not so
> > much passing a flag to commit as opposed to the flags not directly
> > controlling behavior (i.e., one flag means sync if <something> is true,
> > another flag means sync if <something else> is true, etc.) tends to
> > confuse me. I don't feel terribly strongly about it if others prefer
> > this pattern, but I still find the existing code more readable.
> > 
> > I vaguely recall thinking it might be nice if we could dump this into
> > transaction state to avoid the aforementioned logic warts, but IIRC that
> > might not have been possible for all users of this functionality..
> 
> Moving the flag out of the transaction structure was the main motivation
> for this series - the fact that we need different arguments to
> xfs_trans_commit is just a fallout from that.  The rationale is that
> I found it highly confusing to figure out how and where we set the sync
> flag vs having it obvious in the one place where we commit the
> transaction.
> 

Sorry, I was referring to moving your new [W|DIR]SYNC variants to
somewhere like xfs_trans_res->tr_logflags in the comment above, not the
existing XFS_TRANS_SYNC flag (which I would keep). Regardless, I didn't
think that would work across the board from looking at it before.
Perhaps it would work in some cases..

I agree that the current approach is confusing in that it's not always
clear when to set the sync flag. I disagree that this patch makes it
obvious and in one place because when I see this:

	error = xfs_trans_commit(args->trans, XFS_TRANS_COMMIT_WSYNC);

... it makes me think the flag has an immediate effect (like COMMIT_SYNC
does) and subsequently raises the same questions around the existing
code of when or when not to use which flag in the context of the
individual transaction. *shrug* Just my .02.

Brian

