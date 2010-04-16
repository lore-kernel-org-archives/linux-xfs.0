Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GFl07K258146 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 10:47:01 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCAD71488156
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 08:48:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zMafkwRNprgxeu9u for
	<xfs@oss.sgi.com>; Fri, 16 Apr 2010 08:48:57 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3GFmuSg025150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 11:48:56 -0400
Message-ID: <4BC886E7.3030606@redhat.com>
Date: Fri, 16 Apr 2010 10:48:55 -0500
From: Eric Sandeen <esandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] 125 run ftrunc with relative path
References: <alpine.LFD.2.00.1004160924090.2710@localhost>
In-Reply-To: <alpine.LFD.2.00.1004160924090.2710@localhost>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On 04/16/2010 02:27 AM, Lukas Czerner wrote:
> From 16588d733e681954386f1b92dd6e47cfef92a207 Mon Sep 17 00:00:00 2001
> From: Lukas Czerner <lczerner@redhat.com>
> Date: Tue, 13 Apr 2010 19:34:07 +0200
> Subject: [PATCH] 125 run ftrunc with relative path
> 
> Since ftrunc is invoked with su $qa_user, it can fail when absolute path
> is not accessible to everyone.

Looks right to me.

After talking w/ you on IRC, I'll take the liberty of adding your
signed-off-by: to the patch, and check it in with my reviewed-by:

Thanks,
-Eric

> ---
>  125 |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/125 b/125
> index e84109a..9a29941 100755
> --- a/125
> +++ b/125
> @@ -61,7 +61,7 @@ touch $TESTFILE
>  chmod a+rw $TESTDIR
>  chmod a+rw $TESTFILE
>  
> -su $qa_user -c "$here/src/ftrunc -f $TESTFILE"
> +su $qa_user -c "./src/ftrunc -f $TESTFILE"
>  
>  if [ "$?" != "0" ];  then
>      echo src/ftrunc returned non 0 status!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
