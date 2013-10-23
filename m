Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E3087F37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 08:09:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7DCB43040C0
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 06:09:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S4Nu7YOtloMIAxTH for
	<xfs@oss.sgi.com>; Wed, 23 Oct 2013 06:09:34 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9ND9YM0016854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 09:09:34 -0400
Received: from orion.maiolino.org (ovpn-113-152.phx2.redhat.com [10.3.113.152])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r9ND9U2x007462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 09:09:33 -0400
Date: Wed, 23 Oct 2013 11:09:30 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfstests: generic/273: do not use /proc/cpuinfo
Message-ID: <20131023130929.GC31449@orion.maiolino.org>
References: <1382529524-2184-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<1382529524-2184-3-git-send-email-stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1382529524-2184-3-git-send-email-stanislav.kholmanskikh@oracle.com>
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

Looks good indeed.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
On Wed, Oct 23, 2013 at 03:58:44PM +0400, Stanislav Kholmanskikh wrote:
> The content of /proc/cpuinfo file is platform-dependent.
> So we can not use it reliably to check a number of available cpus.
> It would be better to use sysfs interface, as _no_of_online_cpus() does.
> 
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> ---
>  tests/generic/273 |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tests/generic/273 b/tests/generic/273
> index d149808..c028438 100755
> --- a/tests/generic/273
> +++ b/tests/generic/273
> @@ -47,7 +47,7 @@ count=2
>  
>  _threads_set()
>  {
> -	_cpu_num=`cat /proc/cpuinfo | grep "processor" | wc -l`
> +	_cpu_num=`_no_of_online_cpus`
>  	threads=$(($_cpu_num * 50))
>  	if [ $threads -gt 200 ]
>  	then
> -- 
> 1.7.1
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
