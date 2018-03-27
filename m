Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50266 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752001AbeC0Whd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 18:37:33 -0400
Date: Tue, 27 Mar 2018 15:37:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3 V2] libfrog: handle NULL dir && blkdev in
 __fs_table_lookup_mount
Message-ID: <20180327223725.GH4818@magnolia>
References: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
 <391d9faf-093f-24b7-9261-95feab18df51@redhat.com>
 <5b4e43a4-5090-0970-ef2c-20ad0df7a565@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b4e43a4-5090-0970-ef2c-20ad0df7a565@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 27, 2018 at 05:33:11PM -0500, Eric Sandeen wrote:
> If neither dir nor blkdev is set, dpath never gets set,
> and then gets used (uninitalized) later on.
> 
> If we are asked where "nothing" is mounted, just return
> "nowhere."
> 
> Fixes-coverity-id: 1433615
> Fixes-coverity-id: 1433616
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

 mmmmmm  mmmm  m    m   mmm         m    m   mm   mmmmm  mmmmm m     m
     #" m"  "m ##  ## m"   "        #    #   ##   #   "# #   "# "m m"
   m#   #    # # ## # #   mm        #mmmm#  #  #  #mmm#" #mmm#"  "#"
  m"    #    # # "" # #    #        #    #  #mm#  #      #        #
 ##mmmm  #mm#  #    #  "mmm"        #    # #    # #      #        #
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V2: wrappers prevent (sic) both being set, gracefully
> handle either of the sent-in paths being null.
> 
> diff --git a/libfrog/paths.c b/libfrog/paths.c
> index 318b48f..c7895e9 100644
> --- a/libfrog/paths.c
> +++ b/libfrog/paths.c
> @@ -98,6 +98,9 @@ __fs_table_lookup_mount(
>  	char		rpath[PATH_MAX];
>  	char		dpath[PATH_MAX];
>  
> +	if (!dir && !blkdev)
> +		return NULL;
> +
>  	if (dir && !realpath(dir, dpath))
>  		return NULL;
>  	if (blkdev && !realpath(blkdev, dpath))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
