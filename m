Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 19B677F51
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 10:26:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB62A8F8049
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 08:26:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xUfsoPiZTIfed7o3 for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 08:26:10 -0700 (PDT)
Message-ID: <51DD7D13.1050200@sandeen.net>
Date: Wed, 10 Jul 2013 10:26:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2] mkfs: add missing noalign suboption information
References: <1373469280-12617-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1373469280-12617-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 7/10/13 10:14 AM, Carlos Maiolino wrote:
> Adds to the mkfs man page, information about noalign mkfs option which is
> missing until now.
> 
> Changelog:
> 
> 	V2:
> 	   -rephase noalign data-section option
> 	   -add noalign realtime device option
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  man/man8/mkfs.xfs.8 | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 04c19b4..61122f0 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -244,6 +244,11 @@ will automatically query the logical volume for appropriate
>  and
>  .B swidth
>  values.
> +.TP
> +.BI noalign
> +This option disables automatic geometry detection and creates the filesystem
> +without stripe geometry alignment even if the underlying storage device provides
> +this information.
>  .RE
>  .TP
>  .B \-f
> @@ -695,6 +700,10 @@ This is used to specify the size of the real-time section.
>  This suboption is only needed if the real-time section of the
>  filesystem should occupy less space than the size of the partition
>  or logical volume containing the section.
> +.TP
> +.BI noalign
> +This option disables stripe size detection, enforcing a realtime device with no
> +stripe geometry.

It's ok, but why change the wording vs. the data section?  i.e. I'd do:

> +This option disables automatic geometry detection and creates the realtime subvolume
> +without stripe geometry alignment even if the underlying storage device provides
> +this information.

But *shrug* it's not that big a deal.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>, or you can send V3 (or whatever) :)

-Eric

>  .RE
>  .TP
>  .BI \-s " sector_size"
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
