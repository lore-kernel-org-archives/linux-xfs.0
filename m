Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EEF057F54
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 09:22:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D11C1304043
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 07:22:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KZkyv9rCADiVqsR3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 May 2015 07:22:14 -0700 (PDT)
Date: Thu, 14 May 2015 10:22:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_repair: properly detect reserved attribute names
Message-ID: <20150514142210.GC23683@bfoster.bfoster>
References: <555416A6.4020401@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <555416A6.4020401@redhat.com>
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
Cc: Zach Brown <zab@zabbo.net>, xfs-oss <xfs@oss.sgi.com>

On Wed, May 13, 2015 at 10:29:42PM -0500, Eric Sandeen wrote:
> This function in xfs_repair tries to make sure that if an attr
> name reserved for acls exists in the root namespace, then its
> value is a valid acl.
> 
> However, because it only compares up to the length of the
> reserved name, superstrings may match and cause false positive
> xfs_repair errors.
> 
> Ensure that both the length and the content match before
> flagging it as an error.
> 
> Spotted-by: Zach Brown <zab@zabbo.net>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

So it looks like master doesn't have the sizeof(unsigned char *)
problem and the 4.1 update branch does, so we want to make sure that
kernel fix makes it into the latter...

> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 27442c4..89a5bbf 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -747,9 +747,10 @@ valuecheck(
>  	void *valuep;
>  	int clearit = 0;
>  
> -	if ((strncmp(namevalue, SGI_ACL_FILE, SGI_ACL_FILE_SIZE) == 0) ||
> -			(strncmp(namevalue, SGI_ACL_DEFAULT,
> -				SGI_ACL_DEFAULT_SIZE) == 0)) {
> +	if ((namelen == SGI_ACL_FILE_SIZE &&
> +	     strncmp(namevalue, SGI_ACL_FILE, SGI_ACL_FILE_SIZE) == 0) ||
> +	    (namelen == SGI_ACL_DEFAULT_SIZE &&
> +	     strncmp(namevalue, SGI_ACL_DEFAULT, SGI_ACL_DEFAULT_SIZE) == 0)) {
>  		if (value == NULL) {
>  			valuep = malloc(valuelen);
>  			if (!valuep)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
