Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE8687F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 11:04:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CADF4304032
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 09:04:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rkERuXpCX7Op55E6 for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 09:03:58 -0700 (PDT)
Message-ID: <542199F1.4040207@sandeen.net>
Date: Tue, 23 Sep 2014 11:04:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix xfsctl manual XFS_IOC_FSSETXATTR valid
	fields
References: <20140923154140.315778789@sgi.com>
In-Reply-To: <20140923154140.315778789@sgi.com>
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
To: Mark Tingueyl <tinguely@sgi.com>, xfs@oss.sgi.com

On 9/23/14 10:41 AM, Mark Tingueyl wrote:
> The xfsctl manual page fails to mention that fsx_projid is a
> setable field.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

p.s. You might want to fix your name in your email client, Mr. Tingueyl ;)

> ---
>  man/man3/xfsctl.3 |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: b/man/man3/xfsctl.3
> ===================================================================
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -245,9 +245,10 @@ Set additional attributes associated wit
>  The final argument points to a variable of type
>  .BR "struct fsxattr" ,
>  but only the following fields are used in this call:
> -.B fsx_xflags
> +.BR fsx_xflags ,
> +.B fsx_extsize
>  and
> -.BR fsx_extsize .
> +.BR fsx_projid .
>  The
>  .B fsx_xflags
>  realtime file bit and the file's extent size may be changed only
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
