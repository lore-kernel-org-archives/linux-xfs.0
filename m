Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003C0C11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 14:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C81EF20656
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 14:06:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EiRYb96Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgBTOGa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 09:06:30 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60470 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727943AbgBTOGa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 09:06:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582207589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vSLEdgwNde4odo55hqzcb/QuU1LM+z7+XbyIDHHzC2M=;
        b=EiRYb96Q0kQ9yv9A1v74bGCEUeDQS8qB00Joc1hfGreqEjwuuPYA9d22elA3Sirs1/mhak
        d9sPze+2WWm9ak+bILBpajqHcjz+hIN4Xpg+gJWB3UuGUtqOTihEUXV/XkZcPtwgahyli3
        RZJNJwlufPBMfq7gfQkM6qYM+qF9nSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-3v5SehJVNl6eNEbTaGPQxg-1; Thu, 20 Feb 2020 09:06:27 -0500
X-MC-Unique: 3v5SehJVNl6eNEbTaGPQxg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D42E6100DFC8;
        Thu, 20 Feb 2020 14:06:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F9C619756;
        Thu, 20 Feb 2020 14:06:25 +0000 (UTC)
Date:   Thu, 20 Feb 2020 09:06:23 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_db: check that metadata updates have been
 committed
Message-ID: <20200220140623.GC48977@bfoster>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
 <158216293385.601264.3202158027072387776.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216293385.601264.3202158027072387776.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:42:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new function that will ensure that everything we scribbled on has
> landed on stable media, and report the results.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/init.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> 
> diff --git a/db/init.c b/db/init.c
> index 0ac37368..e92de232 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -184,6 +184,7 @@ main(
>  	char	*input;
>  	char	**v;
>  	int	start_iocur_sp;
> +	int	d, l, r;
>  
>  	init(argc, argv);
>  	start_iocur_sp = iocur_sp;
> @@ -216,6 +217,19 @@ main(
>  	 */
>  	while (iocur_sp > start_iocur_sp)
>  		pop_cur();
> +
> +	libxfs_flush_devices(mp, &d, &l, &r);
> +	if (d)
> +		fprintf(stderr, _("%s: cannot flush data device (%d).\n"),
> +				progname, d);
> +	if (l)
> +		fprintf(stderr, _("%s: cannot flush log device (%d).\n"),
> +				progname, l);
> +	if (r)
> +		fprintf(stderr, _("%s: cannot flush realtime device (%d).\n"),
> +				progname, r);
> +
> +

Seems like we could reduce some boilerplate by passing progname into
libxfs_flush_devices() and letting it dump out of the error messages,
unless there's some future code that cares about individual device error
state.

That said, it also seems the semantics of libxfs_flush_devices() are a
bit different from convention. Just below we invoke
libxfs_device_close() for each device (rather than for all three), and
device_close() also happens to call fsync() and platform_flush_device()
itself...

Brian

>  	libxfs_umount(mp);
>  	if (x.ddev)
>  		libxfs_device_close(x.ddev);
> 

