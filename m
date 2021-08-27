Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8303AC432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 15:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6005860E52
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 15:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbhH0PrX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 11:47:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234231AbhH0PrX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Aug 2021 11:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630079193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G7/+ccLkQozhWemN8zIf0lGn9lA4KRHKkYOoHaIXMtM=;
        b=ZukQ5++D4bboNmSn4KMuooD80PR4KdNctr/hsIfFy/2ZQnnM/aV/fdHCtu5RcKQWGzgD0w
        ufHZEMnZLdeqgEuDCNbKbe2bd2huMBGkh4JDUFF44orQ8cIZ6gpvD6OtpmO0hqrgiJN06v
        LFP5qfZTvd5kV+1G/j3kUOo8Oylb3Cg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489--OyOdWXtO92CONjaT8tTgQ-1; Fri, 27 Aug 2021 11:46:31 -0400
X-MC-Unique: -OyOdWXtO92CONjaT8tTgQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7D748799F5
        for <linux-xfs@vger.kernel.org>; Fri, 27 Aug 2021 15:46:30 +0000 (UTC)
Received: from redhat.com (unknown [10.22.10.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B1D2F69280;
        Fri, 27 Aug 2021 15:46:29 +0000 (UTC)
Date:   Fri, 27 Aug 2021 10:46:27 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Eric Sandeen <esandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Bill O'Donnell <bodonnel@redhat.com>
Subject: Re: [PATCH] mkfs.xfs.8: clarify DAX-vs-reflink restrictions in the
 mkfs.xfs man page
Message-ID: <20210827154627.ygbs6igbzavrwvyo@redhat.com>
References: <59ebcf23-9e32-e219-ef8b-9aa7ab2444c2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59ebcf23-9e32-e219-ef8b-9aa7ab2444c2@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 27, 2021 at 10:39:18AM -0500, Eric Sandeen wrote:
> Now that we have the tristate dax mount options, it is possible
> to enable DAX mode for non-reflinked files on a reflink-capable
> filesystem.  Clarify this in the mkfs.xfs manpage.
> 
> Reported-by: Bill O'Donnell <bodonnel@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index a7f70285..84ac50e8 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -316,12 +316,20 @@ option set. When the option
>  is used, the reference count btree feature is not supported and reflink is
>  disabled.
>  .IP
> -Note: the filesystem DAX mount option (
> +Note: the filesystem-wide DAX mount options (
>  .B \-o dax
> -) is incompatible with
> -reflink-enabled XFS filesystems.  To use filesystem DAX with XFS, specify the
> +and
> +.B \-o dax=always
> +) are incompatible with
> +reflink-enabled XFS filesystems.  To use filesystem-wide DAX with XFS, specify the
>  .B \-m reflink=0
>  option to mkfs.xfs to disable the reflink feature.
> +Alternatey, use the
s /Alternatey/Alternately

> +.B \-o dax=inode
> +mount option to selectively enable DAX mode on non-reflinked files.
> +See
> +.BR xfs (5)
> +for more information.
>  .RE
>  .PP
>  .PD 0
> 

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

