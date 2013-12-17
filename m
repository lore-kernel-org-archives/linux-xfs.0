Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 230257F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 10:22:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1346D304059
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 08:22:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fJIy1J3EYC1nolcr for
	<xfs@oss.sgi.com>; Tue, 17 Dec 2013 08:22:45 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rBHGMinD029340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 11:22:44 -0500
Received: from orion.maiolino.org (ovpn-113-114.phx2.redhat.com [10.3.113.114])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id rBHGMbVo019494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 11:22:43 -0500
Date: Tue, 17 Dec 2013 14:22:36 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/3] common: Filter out lost+found directory from _ls_l()
	output
Message-ID: <20131217162234.GA28325@orion.maiolino.org>
References: <1387288947-12650-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1387288947-12650-1-git-send-email-lczerner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Lukas,

I guess this patchset lacks a cover letter you might have forgotten to add?
despite the first patch which is easier to understand the reason due the
comment you added to the own patch, the purpose of the remaining patches are
not clear.


On Tue, Dec 17, 2013 at 03:02:25PM +0100, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  common/rc | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index 5f61d57..7a168e9 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -74,10 +74,11 @@ _md5_checksum()
>  
>  # ls -l w/ selinux sometimes puts a dot at the end:
>  # -rwxrw-r--. id1 id2 file1
> +# Also filter out lost+found directory on extN file system if present
>  
>  _ls_l()
>  {
> -	ls -l $* | sed "s/\(^[-rwxdlbcpsStT]*\)\. /\1 /"
> +	ls -l $* | sed "s/\(^[-rwxdlbcpsStT]*\)\. /\1 /" | grep -v 'lost+found'
>  }
>  
>  _mount_opts()
> -- 
> 1.8.3.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
