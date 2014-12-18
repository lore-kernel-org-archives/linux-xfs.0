Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C9FD7F51
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 09:12:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2E2CD8F804C
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 07:12:44 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id l8YErrGlvVM76zBS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 07:12:43 -0800 (PST)
Date: Thu, 18 Dec 2014 10:12:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_repair: do not check symlink component lengths
Message-ID: <20141218151237.GB13471@laptop.bfoster>
References: <548215D6.5020804@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <548215D6.5020804@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andy Grimm <agrimm@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Dec 05, 2014 at 02:30:14PM -0600, Eric Sandeen wrote:
> As reported by Andy Grimm,
> 
> # ln -s $( python -c 'print "a" * 260' ) /mnt/foo
> 
> will succeed on xfs, but then xfs_repair will complain:
> 
> component of symlink in inode 131 too long
> problem with symbolic link in inode 131
> would have cleared inode 131
> 
> The kernel checks the total length of the symlink on both read
> and write, but does not look at component paths.
> 
> Looking around the kernel, no other filesystem checks component
> lengths, nor does the vfs.  And as Andy points out, the target
> could even be on a different filesystem, with different limitations.
> 

Interesting, but we do enforce dentry name limits, yes? At least, I
can't create such a component on an XFS fs (haven't dug into where that
is enforced).

> And having a "too-long" component doesn't even seem like something
> likely to stem from disk corruption anyway, so I'm not sure why repair
> should care.
> 

My guess would be the intent is based on the above, where we can't
create such a long component name and thus a component that exceeds the
limits must be "invalid."

That said, a broken symlink is generally valid and not the same as
corruption, so I think I agree that this is somewhat misplaced
functionality...

> Therefore I propose removing the component length checks from xfs_repair.
> 
> Andy Grimm <agrimm@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 38a6562..73e4b9e 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1333,7 +1333,7 @@ process_symlink(
>  	xfs_dinode_t	*dino,
>  	blkmap_t 	*blkmap)
>  {
> -	char			*symlink, *cptr;
> +	char			*symlink;
>  	char			data[MAXPATHLEN];
>  
>  	/*
> @@ -1380,31 +1380,6 @@ _("found illegal null character in symlink inode %" PRIu64 "\n"),
>  		return(1);
>  	}
>  
> -	/*
> -	 * check for any component being too long
> -	 */
> -	if (be64_to_cpu(dino->di_size) >= MAXNAMELEN)  {
> -		cptr = strchr(symlink, '/');
> -
> -		while (cptr != NULL)  {
> -			if (cptr - symlink >= MAXNAMELEN)  {
> -				do_warn(
> -_("component of symlink in inode %" PRIu64 " too long\n"),
> -					lino);
> -				return(1);
> -			}
> -			symlink = cptr + 1;
> -			cptr = strchr(symlink, '/');
> -		}
> -
> -		if (strlen(symlink) >= MAXNAMELEN)  {
> -			do_warn(
> -_("component of symlink in inode %" PRIu64 " too long\n"),
> -				lino);
> -			return(1);
> -		}
> -	}
> -
>  	return(0);
>  }
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
