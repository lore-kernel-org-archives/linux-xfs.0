Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F773C35E08
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06D172176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:08:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YUiQkDRs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgBYPIY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 10:08:24 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24892 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730624AbgBYPIY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 10:08:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582643303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n+BcUenGPzIF233daGDmBI0WiRoirINfsetMubIWECU=;
        b=YUiQkDRsSwikyvlguO4ULUhM2Ek6Lgr7TLbRmlF2464gQvytRc6er3sX+Dt88zSbSItmhi
        yAjCp6I3kZU3EUv/dxHbpVk6idaDLywechAXJR01UzvEXlhzBgtJ29zWGZUK6ejQ+9uY+v
        CE09OSsErYqKkhDVkjUGEf6FNuSfa/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-pjhkvlBkN8e4AQuYKN9ktA-1; Tue, 25 Feb 2020 10:08:21 -0500
X-MC-Unique: pjhkvlBkN8e4AQuYKN9ktA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5762D1857362;
        Tue, 25 Feb 2020 15:08:20 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE4F063764;
        Tue, 25 Feb 2020 15:08:19 +0000 (UTC)
Date:   Tue, 25 Feb 2020 10:08:17 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs_repair: check that metadata updates have been
 committed
Message-ID: <20200225150817.GC26938@bfoster>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
 <158258946575.451075.126426300036283442.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258946575.451075.126426300036283442.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:11:05PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that any metadata that we repaired or regenerated has been
> written to disk.  If that fails, exit with 1 to signal that there are
> still errors in the filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/xfs_repair.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index eb1ce546..ccb13f4a 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -703,6 +703,7 @@ main(int argc, char **argv)
>  	struct xfs_sb	psb;
>  	int		rval;
>  	struct xfs_ino_geometry	*igeo;
> +	int		error;
>  
>  	progname = basename(argv[0]);
>  	setlocale(LC_ALL, "");
> @@ -1104,7 +1105,11 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
>  	 */
>  	libxfs_bcache_flush();
>  	format_log_max_lsn(mp);
> -	libxfs_umount(mp);
> +
> +	/* Report failure if anything failed to get written to our fs. */
> +	error = -libxfs_umount(mp);
> +	if (error)
> +		exit(1);

I wonder a bit whether repair should really exit like this vs. report
the error as it does for most others, but I could go either way. I'll
defer to Eric:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  
>  	if (x.rtdev)
>  		libxfs_device_close(x.rtdev);
> 

