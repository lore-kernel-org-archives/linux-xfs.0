Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5727C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 18:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 733E321D93
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 18:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbhADSnS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:43:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbhADSnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 13:43:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609785712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xnUFVPjyd5FDbZ2bJQABDl3KLZk7AdP09C8L9pyeYN4=;
        b=ayZLQ51OazsVGF2y7fSgr3Pw09VR306MM6y2SOwtVYcZ40ql1g5yzdTqJE+g0w/vYvZd5X
        KeHufHjYaNIbDkgngULbwU3wjrDWdEdxXWZddvgyCopz1G+VaJoKh43lQ4Kq/cRhJoYEbc
        0+KQBvuoEj1EuyUBR2H0f5UZHTS2YDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-B_dDdIGUMAyFEP1QTR-JjA-1; Mon, 04 Jan 2021 13:41:50 -0500
X-MC-Unique: B_dDdIGUMAyFEP1QTR-JjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 733E0107ACE4;
        Mon,  4 Jan 2021 18:41:49 +0000 (UTC)
Received: from localhost (unknown [10.66.61.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8FAF100AE2E;
        Mon,  4 Jan 2021 18:41:48 +0000 (UTC)
Date:   Tue, 5 Jan 2021 02:57:54 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: make inobtcount visible
Message-ID: <20210104185754.GI14354@localhost.localdomain>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs@vger.kernel.org
References: <20210104113006.328274-1-zlang@redhat.com>
 <3c682608-3ba8-83bb-8d16-49c798e7258c@sandeen.net>
 <3194df4e-267f-8fb1-c183-ead1d4080c85@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3194df4e-267f-8fb1-c183-ead1d4080c85@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 04, 2021 at 10:29:21AM -0600, Eric Sandeen wrote:
> 
> 
> On 1/4/21 9:28 AM, Eric Sandeen wrote:
> > On 1/4/21 5:30 AM, Zorro Lang wrote:
> >> When set inobtcount=1/0, we can't see it from xfs geometry report.
> >> So make it visible.
> >>
> >> Signed-off-by: Zorro Lang <zlang@redhat.com>
> > Hi Zorro - thanks for spotting this.
> > 
> > I think the libxfs changes need to hit the kernel first, then we can
> > pull it in and fix up the report_geom function.  Nothing calls
> > xfs_fs_geometry directly in userspace, FWIW.
> 
> Hah, of course I forgot about libxfs_fs_geometry. o_O
> 
> In any case, I think this should hit the kernel first, want to send
> that patch if it's not already on the list?

I can give it a try, if Darrick haven't had one in his developing list :)

Thanks,
Zorro

> 
> -Eric
> 
> > Thanks,
> > -Eric
> > 
> 

