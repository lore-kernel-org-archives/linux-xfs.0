Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9JFJmYu001417 for <xfs@oss.sgi.com>; Fri, 19 Oct 2012 10:19:49 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mRFFNEDyqqC05kUJ for
	<xfs@oss.sgi.com>; Fri, 19 Oct 2012 08:21:28 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9JFLROV000913
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 19 Oct 2012 11:21:27 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-113.phx2.redhat.com
	[10.3.113.113])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q9JFLO4u029973
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 19 Oct 2012 11:21:27 -0400
Date: Fri, 19 Oct 2012 12:21:23 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfstests 250: remove unwanted new line in 250.out
Message-ID: <20121019152123.GB15588@andromeda.usersys.redhat.com>
References: <1350618284-11708-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1350618284-11708-1-git-send-email-eguan@redhat.com>
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
To: xfs@oss.sgi.com

On Fri, Oct 19, 2012 at 11:44:44AM +0800, Eryu Guan wrote:
> Additional new line at the end of 250.out will fail the test, remove it.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  250.out | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/250.out b/250.out
> index 2225d6e..acb042a 100644
> --- a/250.out
> +++ b/250.out
> @@ -12,4 +12,3 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>  *** unmount loop filesystem
>  *** check loop filesystem
>  *** done
> -
> -- 
> 1.7.11.7
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Looks Good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
