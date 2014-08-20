Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 26E7F7F4E
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 13:54:55 -0500 (CDT)
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA74EAC003
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 11:54:51 -0700 (PDT)
Received: from [128.162.232.11] (porter.americas.sgi.com [128.162.232.11])
	by estes.americas.sgi.com (Postfix) with ESMTP id 886527002717
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 13:54:51 -0500 (CDT)
Message-ID: <53F4EEFB.9080905@sgi.com>
Date: Wed, 20 Aug 2014 13:54:51 -0500
From: Troy McCorkell <tdm@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH RESEND] xfsprogs: add supported file attributes to xfs.5
	manpage
References: <53F4E229.3010607@redhat.com>
In-Reply-To: <53F4E229.3010607@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 08/20/2014 01:00 PM, Eric Sandeen wrote:
> The chattr(1) manpage now refers users to filesystem-specific
> manpages for details on supported attributes, so add those to
> xfs.5.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> I thought I had sent this already, but I guess not...
>
> (and now resending to xfs@ not linux-xfs@ in hopes that this
> one gets through...)
>    
linux-xfs@ email address was converted to a spam trap several months back.
The only email traffic on it was from spammers.
-Troy

> diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> index 5e47c4c..3214455 100644
> --- a/man/man5/xfs.5
> +++ b/man/man5/xfs.5
> @@ -1,6 +1,6 @@
>   .TH xfs 5
>   .SH NAME
> -xfs \- layout and mount options for the XFS filesystem
> +xfs \- layout, mount options, and supported file attributes for the XFS filesystem
>   .SH DESCRIPTION
>   An XFS filesystem can reside on a regular disk partition or on a
>   logical volume.
> @@ -302,7 +302,27 @@ namespace is on stable storage. This is useful in HA setups
>   where failover must not result in clients seeing
>   inconsistent namespace presentation during or after a
>   failover event.
> +.SH FILE ATTRIBUTES
> +The XFS filesystem supports setting the following file
> +attributes on Linux systems using the
> +.BR chattr (1)
> +utility:
> +.sp
> +.BR a " - append only"
> +.sp
> +.BR A " - no atime updates"
> +.sp
> +.BR d " - no dump"
> +.sp
> +.BR i " - immutable"
> +.sp
> +.BR S " - synchronous updates"
> +.sp
> +For descriptions of these attribute flags, please refer to the
> +.BR chattr (1)
> +man page.
>   .SH SEE ALSO
> +.BR chattr (1),
>   .BR xfsctl (3),
>   .BR mount (8),
>   .BR mkfs.xfs (8),
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
