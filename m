Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Oct 2006 19:13:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9N2DIaG016895
	for <xfs@oss.sgi.com>; Sun, 22 Oct 2006 19:13:20 -0700
Date: Mon, 23 Oct 2006 12:12:03 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] diskquota: 32bit quota tools on 64bit architectures
Message-ID: <20061023021203.GH8394166@melbourne.sgi.com>
References: <200610191232.k9JCW7CF015486@vass.7ka.mipt.ru> <20061019172948.GA30975@infradead.org> <200610200610.k9K6AXgP031789@vass.7ka.mipt.ru> <200610211828.33230.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200610211828.33230.arnd@arndb.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vasily Tarasov <vtaras@openvz.org>, Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Jan Kara <jack@suse.cz>, Dmitry Mishin <dim@openvz.org>, Vasily Averin <vvs@sw.ru>, Kirill Korotaev <dev@openvz.org>, OpenVZ Developers List <devel@openvz.org>, xfs@oss.sgi.com

On Sat, Oct 21, 2006 at 06:28:32PM +0200, Arnd Bergmann wrote:
> On a related topic, I just noticed 
> 
> typedef struct fs_qfilestat {
> 	__u64		qfs_ino;	/* inode number */
> 	__u64		qfs_nblks;	/* number of BBs 512-byte-blks */
> 	__u32		qfs_nextents;	/* number of extents */
> } fs_qfilestat_t;
> 
> typedef struct fs_quota_stat {
> 	__s8		qs_version;	/* version number for future changes */
> 	__u16		qs_flags;	/* XFS_QUOTA_{U,P,G}DQ_{ACCT,ENFD} */
> 	__s8		qs_pad;		/* unused */
> 	fs_qfilestat_t	qs_uquota;	/* user quota storage information */
> 	fs_qfilestat_t	qs_gquota;	/* group quota storage information */
> 	__u32		qs_incoredqs;	/* number of dquots incore */
> 	__s32		qs_btimelimit;  /* limit for blks timer */	
> 	__s32		qs_itimelimit;  /* limit for inodes timer */	
> 	__s32		qs_rtbtimelimit;/* limit for rt blks timer */	
> 	__u16		qs_bwarnlimit;	/* limit for num warnings */
> 	__u16		qs_iwarnlimit;	/* limit for num warnings */
> } fs_quota_stat_t;

Ah, the XFS quota structures.....

> This one seems to have a more severe problem in x86_64 compat
> mode. I haven't tried it, but isn't everything down from
> gs_gquota aligned differently on i386?

Yes - this is just one of several interfaces into XFS that need compat
handling that don't have them right now.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
