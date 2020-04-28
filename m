Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6BDC83004
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 21:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215332072A
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 21:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FQKWCekw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgD1VCM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 17:02:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40852 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726274AbgD1VCM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 17:02:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588107731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4yb25hok8lTmn7lljDe5dcNu9a1PHK68a3FDn6mvv4s=;
        b=FQKWCekwuZmTLfazzU+GbVXFrXvwyeXTGr/QokH9WwFwkU17k4ajseeVdvWspGH1clD5wv
        XCMBZc+Ag9JseoVtLRJ5lOeGqLWwtJwXdLdaxWSi40k7tXiPL1mG9dcYIJ65zpH00MVxMk
        u8oM/GyJFEeAvxNE6H7SVQqPx00vPL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-1MNU_it-MimQrIdTbtUyoQ-1; Tue, 28 Apr 2020 17:01:58 -0400
X-MC-Unique: 1MNU_it-MimQrIdTbtUyoQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 308E5464;
        Tue, 28 Apr 2020 21:01:57 +0000 (UTC)
Received: from redhat.com (ovpn-115-0.rdu2.redhat.com [10.10.115.0])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF0B5605CB;
        Tue, 28 Apr 2020 21:01:56 +0000 (UTC)
Date:   Tue, 28 Apr 2020 16:01:54 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [XFS SUMMIT] xfs and gcc
Message-ID: <20200428210154.GA2060862@redhat.com>
References: <20200423150306.GA345064@redhat.com>
 <20200427172440.GS6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427172440.GS6742@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 10:24:40AM -0700, Darrick J. Wong wrote:
> On Thu, Apr 23, 2020 at 10:03:06AM -0500, Bill O'Donnell wrote:
> > Hello -
> > 
> > I'd be interested in having some discussion about the forward momentum
> > of gcc, and xfs staying in reasonable sync with it. I'm sure you've noticed
> > the warnings stacking up as xfs and xfsprogs is built.

To be fair, I'm only seeing a bunch of warnings on xfsprogs builds. ;)

> 
> Not really, because I'm still running gcc 8.4.  At least until I sort
> through the remaining grub brain damage and actually upgrade every
> system. :D
> 
> > With gcc-10 coming
> > about in distros, the inevitable warnings and errors will become more than
> > annoying.
> > 
> > How best to approach modifications to xfs to alleviate these build issues?
> 
> No idea. :(
> 
> Admittedly it would be nice to ask the kernel robot or something like it
> if it's willing to take on building some of the core userspace packages.
> They're a little spammy (we recently had a cppcheck episode) but more
> often than not, it does catch minor problems.
> 
> --D
> 
> > Thanks-
> > Bill
> > 
> 

