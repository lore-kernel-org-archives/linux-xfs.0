Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EE0A7F66
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 03:29:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F3E58F8037
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 01:29:52 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2VWdfgGwgY75EgBr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 01:29:51 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1I9To1k006707
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 04:29:50 -0500
Date: Wed, 18 Feb 2015 07:29:46 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: remove deprecated mount options
Message-ID: <20150218092946.GA29058@hades.maiolino.org>
References: <54E37F24.10300@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54E37F24.10300@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Looks good to me, also tested it, and there is no need anymore to keep warnings
about these deprecated functions IMHO

Consider it

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Tested-by: Carlos Maiolino <cmaiolino@redhat.com>

On Tue, Feb 17, 2015 at 11:49:24AM -0600, Eric Sandeen wrote:
> We recently removed deprecated sysctls; may as well
> remove deprecated mount options as well, we've stated
> that they'd be gone by now in the docs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 7077103..03a3d03 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -228,30 +228,19 @@ default behaviour.
>  Deprecated Mount Options
>  ========================
>  

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
