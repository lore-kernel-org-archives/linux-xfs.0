Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38300 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbfBDSMX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 13:12:23 -0500
Subject: Re: [PATCH 2/8] xfs_scrub_all.timer: activate after most of the
 system is up
References: <154524776457.28646.3004453037075812416.stgit@magnolia>
 <154524777696.28646.14668160393059175404.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9de27cb4-7027-023f-58d5-eca8456627ba@sandeen.net>
Date: Mon, 4 Feb 2019 12:12:21 -0600
MIME-Version: 1.0
In-Reply-To: <154524777696.28646.14668160393059175404.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 12/19/18 1:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We really don't want the xfs_scrub_all timer triggering while the system
> is booting up because not all the mounts will have finished, networking
> might not be up for reporting, and slowing down bootup annoys people.
> Therefore, delay the xfs_scrub_all service's activation until after the
> system has started all the big pieces it's going to start.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/xfs_scrub_all.service.in |    1 +
>  1 file changed, 1 insertion(+)

<lays hands on systemd-fu, attempts to sense aura of goodness>

<has no real basis for judgement but feels that waiting for more $STUFF can't hurt>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
