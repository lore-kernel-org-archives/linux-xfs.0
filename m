Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 04:39:52 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBICdjKw027398
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 04:39:48 -0800
Date: Tue, 18 Dec 2007 23:39:50 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs problem ?
Message-ID: <20071218123950.GM4396912@sgi.com>
References: <a727368a0712171751i3eb2633epaf31a6a48129c777@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a727368a0712171751i3eb2633epaf31a6a48129c777@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sudheer <ssudheer@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 18, 2007 at 07:21:21AM +0530, sudheer wrote:
> Sir ,
> 
> When i run  tail -f /var/log/messages
> --------------------------------------------------------------
> Dec 17 20:50:42 u15200848 kernel:  [<c014bb20>] pdflush+0x0/0x50
> Dec 17 20:50:42 u15200848 kernel:  [<c014ba2c>] __pdflush+0xbc/0x1b0
> Dec 17 20:50:42 u15200848 kernel:  [<c014bb5d>] pdflush+0x3d/0x50
> Dec 17 20:50:42 u15200848 kernel:  [<c014afb0>] wb_kupdate+0x0/0x140
> Dec 17 20:50:42 u15200848 kernel:  [<c0134fba>] kthread+0xba/0xc0
> Dec 17 20:50:42 u15200848 kernel:  [<c0134f00>] kthread+0x0/0xc0
> Dec 17 20:50:42 u15200848 kernel:  [<c0101255>]
> kernel_thread_helper+0x5/0x10
> Dec 17 20:50:42 u15200848 kernel: 0x0: 58 41 47 46 00 00 00 01 00 00 00 0a
> 00 18 c5 15
> Dec 17 20:50:42 u15200848 kernel: Filesystem "hda7": XFS internal error
> xfs_alloc_read_agf at line 2173 of file fs/xfs/xfs_alloc.c.  Caller

That indicates a corrupted AGF. The magic number looks good:

#define XFS_AGF_MAGIC 0x58414746

so that leaves:

        agf_ok =
                be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC &&
                XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
                be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
                be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
                be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
                be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);

Fromteh hex dump above I can see the version is also good, but nothing else.

You should run xfs_check on teh filesystem and report the output to us, then
run xfs_repair to correct the problem (also send us the output).

The output of the two programs might tell use what was wrong....

> Is this a problem with the xfs file system ? in the  hda7   partition ?

Could be either - is you disk reporting errors? What does smart tell you?

> .How
> can i correct this on live server ?

unmount the filesystem, check it, repair it, mount it back up.
You can't fix it online.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
