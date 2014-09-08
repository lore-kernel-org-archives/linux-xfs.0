Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6FE847F57
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 08:45:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EB44304039
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 06:45:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Hsi9BQaukiW9Hf9P (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 06:45:27 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s88DjQJR012487
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 8 Sep 2014 09:45:26 -0400
Date: Mon, 8 Sep 2014 09:45:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] xfs_repair: fix dir refcount when '.' missing and
	dir is rebuilt
Message-ID: <20140908134524.GC52419@bfoster.bfoster>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
	<1410108065-18156-4-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1410108065-18156-4-git-send-email-sandeen@redhat.com>
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
Cc: xfs@oss.sgi.com

On Sun, Sep 07, 2014 at 11:41:03AM -0500, Eric Sandeen wrote:
> In phase 6's longform_dir2_entry_check, if we never
> find a '.' entry we never add a reference to that entry;
> if we subsequently rebuild it, '.' gets added, but
> no ref to it is ever made.  This leads to Phase 7 doing
> i.e.:
> 
>   Phase 7 - verify and correct link counts...
>   resetting inode 5184 nlinks from 2 to 1
> 
> and the next run will do:
> 
>   Phase 7 - verify and correct link counts...
>   resetting inode 5184 nlinks from 1 to 2
> 
> So if '.' was never found, but the directory got
> rebuilt, manually add the ref for it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  repair/phase6.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index f13069f..cc36a9c 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2288,6 +2288,12 @@ out_fix:
>  			if (bplist[i])
>  				libxfs_putbuf(bplist[i]);
>  		longform_dir2_rebuild(mp, ino, ip, irec, ino_offset, hashtab);
> +		/*
> +		 * If we didn't find a dot, we never added a ref for it;
> +		 * it's there now after the rebuild, so mark it as reached.
> +		 */
> +		if (*need_dot)
> +			add_inode_ref(irec, ino_offset);

So if I follow this correctly, we iterate through the dir, add each name
to the hashtable and handle the inode reference count in the first
longform_dir2_entry_check() loop. If something is wrong, we call
longform_dir2_rebuild() to rebuild the dir from the hashtable of
names/inodes. We may or may not have added a reference for dot at that
point, and need_dot is set appropriately.

This seems Ok, but where is the dot entry actually added? Hmm, I see
that we handle dot in the longform_dir2_rebuild() loop by just skipping
over it...

Brian


>  		*num_illegal = 0;
>  		*need_dot = 0;
>  	} else {
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
