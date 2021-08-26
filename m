Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD05C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 22:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 710CE60FDC
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 22:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhHZWJh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 18:09:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47158 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230400AbhHZWJh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Aug 2021 18:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630015728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=isIs21Bh9mAqeU2JugVFUEmJqb3OLCcUMgUrEp/0p0Y=;
        b=XtJM+kEFJFWoCDGmGa/50Wkes9Fa/QaInXFa2qLTnx9syYcT/O8f55K0uECfop0eYa8MCj
        sCKzNlMVzgtE4w9o9qkf3/Cty3dfHYCZmjxF/vxeYIGDvvYvIcedAk0YY5JNUh1wLjXiRk
        S3FiUheSvgtX7GRUG4d5AZbrsPOZMA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-PIRjTjhrPSyotef1o-oK9w-1; Thu, 26 Aug 2021 18:08:45 -0400
X-MC-Unique: PIRjTjhrPSyotef1o-oK9w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E966760C0;
        Thu, 26 Aug 2021 22:08:44 +0000 (UTC)
Received: from redhat.com (unknown [10.22.10.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD81760C5F;
        Thu, 26 Aug 2021 22:08:43 +0000 (UTC)
Date:   Thu, 26 Aug 2021 17:08:41 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: dax: facilitate EXPERIMENTAL warning for dax=inode
 case
Message-ID: <20210826220841.jsdlbquqq55cetnu@redhat.com>
References: <20210826173012.273932-1-bodonnel@redhat.com>
 <20210826180947.GL12640@magnolia>
 <f6ddf52a-0b85-665a-115e-106242b1af95@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ddf52a-0b85-665a-115e-106242b1af95@sandeen.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 26, 2021 at 01:16:22PM -0500, Eric Sandeen wrote:
> 
> On 8/26/21 1:09 PM, Darrick J. Wong wrote:
> > On Thu, Aug 26, 2021 at 12:30:12PM -0500, Bill O'Donnell wrote:
> 
> > > @@ -1584,7 +1586,7 @@ xfs_fs_fill_super(
> > >   	if (xfs_has_crc(mp))
> > >   		sb->s_flags |= SB_I_VERSION;
> > > -	if (xfs_has_dax_always(mp)) {
> > > +	if (xfs_has_dax_always(mp) || xfs_has_dax_inode(mp)) {
> > 
> > Er... can't this be done without burning another feature bit by:
> > 
> > 	if (xfs_has_dax_always(mp) || (!xfs_has_dax_always(mp) &&
> > 				       !xfs_has_dax_never(mp))) {
> > 		...
> > 		xfs_warn(mp, "DAX IS EXPERIMENTAL");
> > 	}
> 
> changing this conditional in this way will also fail dax=inode mounts on
> reflink-capable (i.e. default) filesystems, no?

Correct. My original patch tests fine, and still handles the reflink and dax
incompatibility. The new suggested logic is problematic. 
-Bill

> 
> -	if (xfs_has_dax_always(mp)) {
> +	if (xfs_has_dax_always(mp) || $NEW_DAX_INODE_TEST) {
> 
> ...
>                 if (xfs_has_reflink(mp)) {
>                         xfs_alert(mp,
>                 "DAX and reflink cannot be used together!");
>                         error = -EINVAL;
>                         goto out_filestream_unmount;
>                 }
>         }
> 
> -Eric
> 

