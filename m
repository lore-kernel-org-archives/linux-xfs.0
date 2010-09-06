Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o861BaDu143325 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 20:11:36 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 719AF14E6AC9
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 18:23:16 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	gXy1j0rIpGHeN87O for <xfs@oss.sgi.com>;
	Sun, 05 Sep 2010 18:23:16 -0700 (PDT)
Date: Mon, 6 Sep 2010 11:12:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: separate project quota from group quota (questions, design issues)
Message-ID: <20100906011213.GY7362@dastard>
References: <201009041000.55878.arekm@maven.pl>
	<20100904233053.GA26586@infradead.org>
	<201009051924.36443.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009051924.36443.arekm@maven.pl>
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, Sep 05, 2010 at 07:24:35PM +0200, Arkadiusz Miskiewicz wrote:
> On Sunday 05 of September 2010, Christoph Hellwig wrote:
> > Thanks for doing this work Arek, I think it will be useful for some
> > users and defintively is cleaners than what we have now.
> > 
> > > I started doing that by splitting every group+project handling code into
> > > separate group and project one. Added superblock field for project quota.
> > > New feature flag (SEPARATEPQUOTA).
> > 
> > Ok.
> > 
> > > If old filesystem (for SEPARATEQUOTA) is mounted then I'll simply load
> > > sb_gquotino into mp->m_sb.sb_pquotino which I think is enough to handle
> > > old fs (since new kernel operates on separate structures for project
> > > quota).
> > 
> > Do you mean an old filesystem without the SEPARATEQUOTA bit set here?
> 
> Yes. When trying to load existing project quota inode in 
> xfs_qm_init_quotainos() I'm doing:
> 
> +                       if (!xfs_sb_version_hasseparatepquota(&mp->m_sb)) {
> +                               ASSERT(!XFS_IS_GQUOTA_ON(mp));
> +                               mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
> +                               mp->m_sb.sb_gquotino = 0;
> +                       }
> 
> While xfs_mod_sb() now does:
> 
>         /*
>          * Filesystem has no separatepquota turned on,
>          * so we need to store project quota in group
>          * quota inode on disk.
>          */
>         if (!xfs_sb_version_hasseparatepquota(&mp->m_sb)) {
>                 mp->m_sb.sb_gquotino = mp->m_sb.sb_pquotino;
>                 mp->m_sb.sb_pquotino = 0;
>         }
>
>        xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
>
>  [...]
>         /*
>          * Restore original in-memory project quota inode state.
>          */
>         if (!xfs_sb_version_hasseparatepquota(&mp->m_sb)) {
>                 mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
>                 mp->m_sb.sb_gquotino = 0;
>         }

I don't think that is safe - we can have concurrent access to the
in-core superblock (mp->m_sb) without locking the superblock, so
something that races with xfs_mod_sb() looking up project quota
could die a horrible death here.

The only time that you should need to do this juggling is when the
quota inode changes. That is, when the XFS_SB_GQUOTINO field is
set. Otherwise the field won't be modified and so we don't need to
convert the values. That only occurs when quotas are being
initialised (xfs_qm_qino_alloc()) during mount, so in that case
there can't be any concurrent operations occurring. Hence swizzling
the inode fields only when the XFS_SB_GQUOTINO filed is set should
be safe.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
