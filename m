Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4A5E47F9E
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 14:15:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 257CA304039
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 12:15:10 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RcNma2McXPsYjK0U for <xfs@oss.sgi.com>;
	Tue, 28 Jan 2014 12:15:06 -0800 (PST)
Date: Wed, 29 Jan 2014 07:15:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs for-3.1.12 branch has been updated to 40c65a7
Message-ID: <20140128201503.GL2212@dastard>
References: <201401201822.48520.arekm@maven.pl> <52E6A9A2.1010905@sgi.com>
	<20140128044216.GI2212@dastard> <52E7CDBA.5000709@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E7CDBA.5000709@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 28, 2014 at 09:33:14AM -0600, Rich Johnston wrote:
> On 01/27/2014 10:42 PM, Dave Chinner wrote:
> >On Mon, Jan 27, 2014 at 12:46:58PM -0600, Rich Johnston wrote:
> >>Arkadiusz,
> >>
> >>Thanks for compiling the list.
> >>
> >>The for-3.1.12  Branch created from "a547280... 3.1.11 release"
> >>
> >>If there are others you want committed, please let me know.
> >>
> >>Thanks
> >>--Rich
> >>
> >>
> >>The following have been committed from the candidate list
> >>provided by Arkadiusz:
> >>
> >>
> >>40c65a7... xfs_metadump: Make -F (force) optional
> >>ec3a1f1... xfs_repair: suggest reboot after dangerous repair
> >>8660952... xfsprogs: suggest "-d" option for repair of RO mount
> >>5a8206c... xfs_repair: correct docs for "-t" units
> >>0d5c444... xfs_fsr: fix SWAPEXT failures under selinux
> >>f3d3dae... libxfs: fix root inode handling inconsistencies
> >
> >Introduces this compiler warning in db/init.c:
> >
> >init.c: In function =BFinit=BF:
> >init.c:152:3: warning: implicit declaration of function =BFxfs_initializ=
e_perag_data=BF [-Wimplicit-function-declaration]
> >
> >
> >>cf507b6... xfsprogs: remove xfs_check references from fsck.xfs
> >>script & manpage
> >>6e2f2d1... xfsprogs: fix resource leak in longform_dir2_rebuild()
> >>ecde3f9... xfs_repair: test for bad level in dir2 node
> >>d299df7... xfs_repair: avoid segfault if reporting progress early in re=
pair
> >>e660c2e... Sent: Friday, October 11, 2013 12:38:11 AM Subject:
> >>Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64
> >>5e1c7ac... xfsprogs: handle symlinks etc in fs_table_initialise_mounts()
> >>aba6204... xfsprogs: fix return value of verify_set_primary_sb()
> >>a2ea195... xfsprogs: fix potential memory leak in verify_set_primary_sb=
()
> >>3e53939... xfsprogs: fix potential memory leak in repare/sb.c
> >>820b8c2... xfsprogs: avoid array overflow in pf_batch_read()
> >>2a1dcdb... xfs_repair: zero out unused parts of superblocks
> >>982508b... xfsprogs: fix inode crash in xfs_repair
> >
> >Introduces this compiler warning in repair/phase6.c:
> >
> >phase6.c: In function =BFmk_orphanage=BF:
> >phase6.c:895:3: warning: implicit declaration of function =BFalloc_ex_da=
ta=BF [-Wimplicit-function-declaration]
> >
> >Running some smoke testing on the branch now. Rich, I expect that
> >you'll be doing some in-depth functionality, scalability and stress
> >testing of the branch over the next week or two?
> =

> I will do *some* testing yes. This is more for those who are
> interested in this branch. I do not plan on using it myself. I put
> it out there for those interested in a 3.1.12 release.

You're acting as the maintainer of this branch, so it's primarily
your responsibility to make sure it works.  That means you need to
ensure that it is fully tested and that when bugs and problems are
supported you respond to them, triage them and fix them. It doesn't
matter if you intend to use the branch or not - you signed up to do
this for the XFS users that were asking for it and that means you
need to ensure the quality of the release is acceptible. Being a
maintainer is more than being allowed to commit patches to a
repository.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
