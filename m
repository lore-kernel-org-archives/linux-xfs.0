Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44758 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbfCODCm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Mar 2019 23:02:42 -0400
Subject: Re: [PATCH 11/36] xfs_scrub_all.timer: activate after most of the
 system is up
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259749738.31886.13894651790702916465.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5df12a9e-b231-f560-ccc7-079601750af8@sandeen.net>
Date: Thu, 14 Mar 2019 22:02:41 -0500
MIME-Version: 1.0
In-Reply-To: <155259749738.31886.13894651790702916465.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 3/14/19 4:04 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We really don't want the xfs_scrub_all timer triggering while the system
> is booting up because not all the mounts will have finished, networking
> might not be up for reporting, and slowing down bootup annoys people.
> Therefore, delay the xfs_scrub_all service's activation until after the
> system has started all the big pieces it's going to start.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/xfs_scrub_all.service.in |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
> index 66f82fc7..b1b80da4 100644
> --- a/scrub/xfs_scrub_all.service.in
> +++ b/scrub/xfs_scrub_all.service.in
> @@ -2,6 +2,7 @@
>  Description=Online XFS Metadata Check for All Filesystems
>  ConditionACPower=true
>  Documentation=man:xfs_scrub_all(8)
> +After=paths.target multi-user.target network.target network-online.target systemd-networkd.service NetworkManager.service connman.service
>  
>  [Service]
>  Type=oneshot
> 
