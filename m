Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36400 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfCRP2c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Mar 2019 11:28:32 -0400
Date: Mon, 18 Mar 2019 08:28:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: allow combination of sync_file_range() flags
Message-ID: <20190318152819.GL4929@magnolia>
References: <20190318131838.19019-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318131838.19019-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 18, 2019 at 09:18:38AM -0400, Brian Foster wrote:
> The sync_file_range() functionality supports a flags argument that
> allows the caller to specify any combination of initiating writeback
> or waiting for write completion before and/or after the write. The
> xfs_io handler supports the ability to specify combinations of flags
> on the command line, but fails to OR the flags together and thus
> only performs one action per invocation.
> 
> This is inconsistent with the syscall and command interpretation.
> Update the sync_file_range() handler to populate the flags mask as
> specified by the user.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Makes sens... oh wait, this is sync_file_range, what a trash fire! :(

The arg processing changes look ok though.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  io/sync_file_range.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/io/sync_file_range.c b/io/sync_file_range.c
> index 30bbc93d..8b5345c5 100644
> --- a/io/sync_file_range.c
> +++ b/io/sync_file_range.c
> @@ -37,13 +37,13 @@ sync_range_f(
>  	while ((c = getopt(argc, argv, "abw")) != EOF) {
>  		switch (c) {
>  		case 'a':
> -			sync_mode = SYNC_FILE_RANGE_WAIT_AFTER;
> +			sync_mode |= SYNC_FILE_RANGE_WAIT_AFTER;
>  			break;
>  		case 'b':
> -			sync_mode = SYNC_FILE_RANGE_WAIT_BEFORE;
> +			sync_mode |= SYNC_FILE_RANGE_WAIT_BEFORE;
>  			break;
>  		case 'w':
> -			sync_mode = SYNC_FILE_RANGE_WRITE;
> +			sync_mode |= SYNC_FILE_RANGE_WRITE;
>  			break;
>  		default:
>  			return command_usage(&sync_range_cmd);
> -- 
> 2.17.2
> 
