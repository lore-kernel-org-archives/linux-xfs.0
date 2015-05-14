Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3E9CB7F5E
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 09:22:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AE2DEAC001
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 07:22:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AHew8x8pU4dVM6B9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 May 2015 07:21:58 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t4EELvVP003208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 14 May 2015 10:21:57 -0400
Date: Thu, 14 May 2015 10:21:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't cast string literals
Message-ID: <20150514142155.GB23683@bfoster.bfoster>
References: <5553DB60.6060907@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5553DB60.6060907@redhat.com>
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

On Wed, May 13, 2015 at 06:16:48PM -0500, Eric Sandeen wrote:
> The commit:
> 
> a9273ca5 xfs: convert attr to use unsigned names
> 
> added these (unsigned char *) casts, but then the _SIZE macros
> return "7" - size of a pointer minus one - not the length of
> the string.  This is harmless in the kernel, because the _SIZE
> macros are not used, but as we sync up with userspace, this will
> matter.
> 
> I don't think the cast is necessary; i.e. assigning the string
> literal to an unsigned char *, or passing it to a function
> expecting an unsigned char *, should be ok, right?
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I can send the xfsprogs version if you like, if this passes
> muster ;)
> 
> (the other option is to cast it back to a (char *) in the sizeof
> but then things are just getting weird IMHO...)
> 

Heh, the cast inside the directive looks weird enough to me in the first
place. In this case it seems spurious, so I'm fine with it:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 4daaa66..ff22a4d 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1453,8 +1453,8 @@ struct xfs_acl {
>  		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
>  
>  /* On-disk XFS extended attribute names */
> -#define SGI_ACL_FILE		(unsigned char *)"SGI_ACL_FILE"
> -#define SGI_ACL_DEFAULT		(unsigned char *)"SGI_ACL_DEFAULT"
> +#define SGI_ACL_FILE		"SGI_ACL_FILE"
> +#define SGI_ACL_DEFAULT		"SGI_ACL_DEFAULT"
>  #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
>  #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
