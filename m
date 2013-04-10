Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F2CEB7FB1
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 13:56:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DC4F630405F
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 11:56:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id eApOa26lD1c0ePzh for <xfs@oss.sgi.com>;
	Wed, 10 Apr 2013 11:56:12 -0700 (PDT)
Message-ID: <5165B5CB.2070203@sandeen.net>
Date: Wed, 10 Apr 2013 13:56:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: reserve fields in inode for parent ptr and alloc
	policy
References: <20130410182438.268267840@sgi.com>
In-Reply-To: <20130410182438.268267840@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 4/10/13 1:24 PM, Mark Tinguely wrote:
> Reserve fields in new inode layout for parent pointer and
> allocation policy.
> 		----
> The inode will hold the parent information for the first
> link to a file. Information for the other links will be
> held in extended attribute entries.
> 
> The "di_parino" is the inode of the parent directory. The
> directory information for this entry is located the parent
> directory with "di_paroff" offset. 
> 
> The di_parino/di_paroff concept code is running.
> 		----
> The "di_allocpolicy" will be used to remember the allocation
> policy associated with this inode.

can you say more about this allocation policy?

-Eric

> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_dinode.h |    3 +++
>  fs/xfs/xfs_inode.c  |    6 ++++++
>  fs/xfs/xfs_inode.h  |    3 +++
>  3 files changed, 12 insertions(+)
> 
> Index: b/fs/xfs/xfs_dinode.h
> ===================================================================
> --- a/fs/xfs/xfs_dinode.h
> +++ b/fs/xfs/xfs_dinode.h
> @@ -76,6 +76,9 @@ typedef struct xfs_dinode {
>  	__be64		di_changecount;	/* number of attribute changes */
>  	__be64		di_lsn;		/* flush sequence */
>  	__be64		di_flags2;	/* more random flags */
> +	__be64		di_parino;	/* parent inode */
> +	__be32		di_paroff;	/* offset into parent directory */
> +	__be32		di_allocpolicy;	/* allocation policy number */
>  	__u8		di_pad2[16];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
> Index: b/fs/xfs/xfs_inode.c
> ===================================================================
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -875,6 +875,9 @@ xfs_dinode_from_disk(
>  		to->di_flags2 = be64_to_cpu(from->di_flags2);
>  		to->di_ino = be64_to_cpu(from->di_ino);
>  		to->di_lsn = be64_to_cpu(from->di_lsn);
> +		to->di_parino = be64_to_cpu(from->di_parino);
> +		to->di_paroff = be32_to_cpu(from->di_paroff);
> +		to->di_allocpolicy = be32_to_cpu(from->di_allocpolicy);
>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
>  		uuid_copy(&to->di_uuid, &from->di_uuid);
>  	}
> @@ -922,6 +925,9 @@ xfs_dinode_to_disk(
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_ino = cpu_to_be64(from->di_ino);
>  		to->di_lsn = cpu_to_be64(from->di_lsn);
> +		to->di_parino = cpu_to_be64(from->di_parino);
> +		to->di_paroff = cpu_to_be32(from->di_paroff);
> +		to->di_allocpolicy = cpu_to_be32(from->di_allocpolicy);
>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
>  		uuid_copy(&to->di_uuid, &from->di_uuid);
>  	}
> Index: b/fs/xfs/xfs_inode.h
> ===================================================================
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -159,6 +159,9 @@ typedef struct xfs_icdinode {
>  	__uint64_t	di_changecount;	/* number of attribute changes */
>  	xfs_lsn_t	di_lsn;		/* flush sequence */
>  	__uint64_t	di_flags2;	/* more random flags */
> +	xfs_ino_t	di_parino;	/* parent inode */
> +	__uint32_t	di_paroff;	/* offset into parent directory */
> +	__uint32_t	di_allocpolicy;	/* allocation policy number */
>  	__uint8_t	di_pad2[16];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
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
