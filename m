Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9IMe9Dv135355 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 17:40:09 -0500
Message-ID: <1318977605.2877.60.camel@doink>
Subject: Re: [RFC PATCH 1/3] Remove in core use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
From: Alex Elder <aelder@sgi.com>
Date: Tue, 18 Oct 2011 17:40:05 -0500
In-Reply-To: <20111018000938.14942.44199.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20111018000932.14942.11597.sendpatchset@chandra-lucid.austin.ibm.com>
	<20111018000938.14942.44199.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-10-17 at 19:09 -0500, Chandra Seetharaman wrote:
> Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
> start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts.
> 
> No changes is made to the on-disk version of the superblock yey. On-disk
> copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

OK, I have a few things you should change below.

Some are based on the assumption that where we're
headed is to support *both* group *and* project
quotas simultaneously.

I haven't looked at the other two yet, I'll start
that tomorrow.

					-Alex

. . .

> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index d06afbc..366bbb7 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -591,6 +591,14 @@ xfs_sb_from_disk(
>  	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
>  	to->sb_gquotino = be64_to_cpu(from->sb_gquotino);
>  	to->sb_qflags = be16_to_cpu(from->sb_qflags);

OK, based on the comment you have in "xfs_quota.h" below:
This stuff is coming off disk, so it will be done
unconditionally (i.e., not related to the superblock
version).  However, you could add an assertion that
if OQUOTA_ENFD or OQUOTA_CHKD are set, then neither
{P,G}QUOTA_{CHKD,ENFD} is set, and vice-versa.
Or perhaps not an assertion, maybe just issue a
warning and correct it.  (Or perhaps some other
handling is more appropriate, have to think it
through.)

> +	if (to->sb_qflags & XFS_OQUOTA_ENFD)
> +		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> +					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> +	if (to->sb_qflags & XFS_OQUOTA_CHKD)
> +		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> +					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> +	to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> +
>  	to->sb_flags = from->sb_flags;
>  	to->sb_shared_vn = from->sb_shared_vn;
>  	to->sb_inoalignmt = be32_to_cpu(from->sb_inoalignmt);
> @@ -625,6 +633,12 @@ xfs_sb_to_disk(
>  	if (!fields)
>  		return;
>  

Meanwhile, this will be going to disk, so will eventually
be done only if XFS_SB_VERSION_NO_OQUOTA is *not* set.
Otherwise the P and G flags will go as-is to disk.  (Not
suggesting a change here--just sort of finishing my
thought from above.)

> +	if (from->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> +		from->sb_qflags |= XFS_OQUOTA_ENFD;
> +	if (from->sb_qflags & (XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> +		from->sb_qflags |= XFS_OQUOTA_CHKD;
> +	from->sb_qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> +					XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
>  	while (fields) {
>  		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
>  		first = xfs_sb_info[f].offset;
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 5cff443..cb2ed78 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c

. . .

> @@ -1688,7 +1691,7 @@ xfs_qm_quotacheck(
>  	 * quotachecked status, since we won't be doing accounting for
>  	 * that type anymore.
>  	 */
> -	mp->m_qflags &= ~(XFS_OQUOTA_CHKD | XFS_UQUOTA_CHKD);
> +	mp->m_qflags &= ~(XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD | XFS_UQUOTA_CHKD);

	mp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;

>  	mp->m_qflags |= flags;
>  
>   error_return:
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 5cc3dde..3a67805 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -120,11 +120,11 @@ xfs_qm_scall_quotaoff(
>  	}
>  	if (flags & XFS_GQUOTA_ACCT) {
>  		dqtype |= XFS_QMOPT_GQUOTA;
> -		flags |= (XFS_OQUOTA_CHKD | XFS_OQUOTA_ENFD);
> +		flags |= (XFS_GQUOTA_CHKD | XFS_GQUOTA_ENFD);
>  		inactivate_flags |= XFS_GQUOTA_ACTIVE;
>  	} else if (flags & XFS_PQUOTA_ACCT) {

We don't want the "else" here, right?  Only one
or the other branch will be taken at this point
anyway, since we distinguished between group and
project quotas when we read the superblock from
disk?

>  		dqtype |= XFS_QMOPT_PQUOTA;
> -		flags |= (XFS_OQUOTA_CHKD | XFS_OQUOTA_ENFD);
> +		flags |= (XFS_PQUOTA_CHKD | XFS_PQUOTA_ENFD);
>  		inactivate_flags |= XFS_PQUOTA_ACTIVE;
>  	}
>  

. . .

> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index a595f29..41483d8 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -154,19 +154,35 @@ typedef struct xfs_qoff_logformat {
>  #define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
>  
>  /*
> + * If the superblock version is earlier than XFS_SB_VERSION_NO_OQUOTA,
> + * following flags will only be used in m_qflags and incore sb_qflags
> + * From XFS_SB_VERSION_NO_OQUOTA, these flags will be stored in
> + * on-disk sb_qflags too.
> + * Also from XFS_SB_VERSION_NO_OQUOTA, XFS_OQUOTA_.* will not be used 
> + * in on-disk sb_qflags.

I think this could benefit a little from rewording.
Maybe something that emphasizes things more in this
order:
- in-core, we (now) always distinguish between group and
  project quotas using distinct flags
- on-disk, they may either be separate or combined,
  depending on the whether XFS_SB_VERSION_NO_OQUOTA
  is set in the superblock version bits
- conversion to and from the combined OQUOTA flag (if
  necessary) is done only in xfs_sb_{to,from}_disk()

Also, I see in the later patch you use a macro like
xfs_sb_version_hasseparatepquota() (whose name I'm not
sure I like at this point), and it *might* read better
if you use that rather in describing things rather than
the XFS_SB_VERSION_NO_OQUOTA bit.

> + */
> +#define XFS_GQUOTA_ENFD	0x0080  /* group quota limits enforced */
> +#define XFS_GQUOTA_CHKD	0x0100  /* quotacheck run on group quotas */
> +#define XFS_PQUOTA_ENFD	0x0200  /* project quota limits enforced */
> +#define XFS_PQUOTA_CHKD	0x0400  /* quotacheck run on project quotas */
> +
> +/*

. . .

>  
>  #define XFS_MOUNT_QUOTA_SET1	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
>  				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
> -				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
> +				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD)
>  
>  #define XFS_MOUNT_QUOTA_SET2	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
>  				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
> -				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
> +				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD)

There is nothing preventing a SET3--only group and project
quotas enabled but not user quotas.

But the place these symbols are is xfs_qm_scall_quotaoff(),
and because you are no longer going to be combining the
group and project interpretation I think these two are
no longer needed and that logic can be simplified.  Take a
look at that code and see if you can just get rid of these
SET1 and SET2 symbols altogether.

>  
>  #define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
>  				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
> -				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD|\
> -				 XFS_GQUOTA_ACCT)
> +				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD|\
> +				 XFS_GQUOTA_ACCT|XFS_GQUOTA_ENFD|\
> +				 XFS_GQUOTA_CHKD)
>  
> 

. . .

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ba16248..b1c8d5b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -328,7 +328,8 @@ xfs_parseargs(
>  			mp->m_qflags &= ~(XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
>  					  XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
>  					  XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
> -					  XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD);
> +					  XFS_UQUOTA_ENFD | XFS_PQUOTA_ENFD |
> +					  XFS_GQUOTA_ENFD);

		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;			
		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;

That last one is actually not yet defined.

>  		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
>  			   !strcmp(this_char, MNTOPT_UQUOTA) ||
>  			   !strcmp(this_char, MNTOPT_USRQUOTA)) {

. . .

> @@ -552,12 +553,12 @@ xfs_showargs(
>  	/* Either project or group quotas can be active, not both */
>  
>  	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
> -		if (mp->m_qflags & XFS_OQUOTA_ENFD)
> +		if (mp->m_qflags & XFS_PQUOTA_ENFD)
>  			seq_puts(m, "," MNTOPT_PRJQUOTA);
>  		else
>  			seq_puts(m, "," MNTOPT_PQUOTANOENF);
>  	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {

I think you want to drop the "else" here also.

> -		if (mp->m_qflags & XFS_OQUOTA_ENFD)
> +		if (mp->m_qflags & XFS_GQUOTA_ENFD)
>  			seq_puts(m, "," MNTOPT_GRPQUOTA);
>  		else
>  			seq_puts(m, "," MNTOPT_GQUOTANOENF);

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
