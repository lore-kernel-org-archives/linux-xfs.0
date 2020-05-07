Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3949AC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 13:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A83208D6
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 13:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XnW0s7oQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEGNkf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 09:40:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37561 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727816AbgEGNkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 09:40:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588858831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DstttZjpOhhf+Zrlea/gpkW8Mg/lU8sZo8BaFOkKj5E=;
        b=XnW0s7oQCf4ZRi6HJ8xaTJimBBPtNyHyx36o4W6BnhTqLVxcLM5Wp9dba8LSiiXcbJrs9v
        XK1u5n7wkFxMg3V2ObRf17gXb1PwLw9JgCTD/4/cenmyxhwhEHTNPKiaC9rs/6BerduDIv
        aal8mVs+pK7wiQid/lbBuoWMDLcDMoo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-YmJ4emXRMsOPfvd9k3dizQ-1; Thu, 07 May 2020 09:40:25 -0400
X-MC-Unique: YmJ4emXRMsOPfvd9k3dizQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34428473;
        Thu,  7 May 2020 13:40:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E00B7704A0;
        Thu,  7 May 2020 13:40:23 +0000 (UTC)
Date:   Thu, 7 May 2020 09:40:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: split xfs_iformat_fork
Message-ID: <20200507134022.GE9003@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-4-hch@lst.de>
 <20200501133431.GJ40250@bfoster>
 <20200507122718.GA17936@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507122718.GA17936@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 02:27:18PM +0200, Christoph Hellwig wrote:
> On Fri, May 01, 2020 at 09:34:31AM -0400, Brian Foster wrote:
> > > +	default:
> > > +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> > > +				sizeof(*dip), __this_address);
> > > +		return -EFSCORRUPTED;
> > > +	}
> > 
> > Can we fix this function up to use an error variable and return error at
> > the end like xfs_iformat_attr_work() does? Otherwise nice cleanup..
> 
> What would the benefit of a local variable be here?  It just adds a
> little extra code for no real gain.
> 

It looks like the variable is already defined, it's just not used
consistently. The only extra code are break statements in the switch and
a return statement at the end of the function, which currently looks odd
without it IMO.

Brian

