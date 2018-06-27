Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38727 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752348AbeF0XXf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Jun 2018 19:23:35 -0400
Date: Thu, 28 Jun 2018 01:23:33 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Mounting xfs filesystem takes long time
Message-ID: <20180627232333.GB21242@wotan.suse.de>
References: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
 <20180619161819.GD21698@magnolia>
 <e9a7c539-1dea-1050-19bc-b0eb7e788b33@sandeen.net>
 <20180621191535.GI7508@wotan.suse.de>
 <89d39e37-3944-f58d-018c-d36bdc9f870c@sandeen.net>
 <CAJCQCtSHT7fcHHxBaTESq5cdQQnYH95maNHby4MULCkar6mfeg@mail.gmail.com>
 <20180621221911.GT19934@dastard>
 <CAJCQCtSzsYSyCD2eEvdgpKJ8ZFShsJrV2FxKZ4bv=-S6gpx2fw@mail.gmail.com>
 <20180622040221.GY19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180622040221.GY19934@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>, Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "swadmin - levigo.de" <swadmin@levigo.de>, xfs list <linux-xfs@vger.kernel.org>

On Fri, Jun 22, 2018 at 02:02:21PM +1000, Dave Chinner wrote:
> On Thu, Jun 21, 2018 at 09:19:54PM -0600, Chris Murphy wrote:
> > On Thu, Jun 21, 2018 at 4:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > The mkfs ratios are about as optimal as we can get for the
> > > information we have about the storage - growing by
> > > 10x (i.e.  increaseing the number of AGs by 10x) puts us at the
> > > outside edge of the acceptible filesystem performance and longevity
> > > charcteristics. Growing by 100x puts us way outside the window,
> > > and examples like this where we are taking about growing by 10000x
> > > is just way beyond anything the static AG layout architecture was
> > > ever intended to support....

I don't  have time to test this but I can probably do so after my vacation
(now). Would it be best to just codify this eventually instead of having
this as tribal knowledge?

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 8ec445afb74b..14f4b6dce08f 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -75,6 +75,9 @@ main(int argc, char **argv)
 	fs_path_t		*fs;	/* mount point information */
 	libxfs_init_t		xi;	/* libxfs structure */
 	char			rpath[PATH_MAX];
+	int			fflag;	/* -f flag */
+	long long		dsize_max_suggested; /* max suggested size */
+	long long		dsize_max_arch; /* max design over flow */
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -93,6 +96,8 @@ main(int argc, char **argv)
 		case 'd':
 			dflag = 1;
 			break;
+		case 'f':
+			fflag = 1;
 		case 'e':
 			esize = atol(optarg);
 			rflag = 1;
@@ -249,6 +254,24 @@ main(int argc, char **argv)
 	if (dflag | mflag | aflag) {
 		xfs_growfs_data_t	in;
 
+		/*
+		 * Growing the filesyste by 10x increases the AG size by 10 as
+		 * well, and this puts us outside edge of the acceptible
+		 * filesystem performance and longevity charcteristics.
+		 *
+		 * Growing by 100x puts us way outside the window...
+		 *
+		 * Growing by 10000x is just way beyond anything the static AG
+		 * layout architecture was ever intended to support, so unless
+		 * you use -f, we won't allow in between 10x-1000x.
+		 */
+		dsize_max_suggested = ddsize * 10 / (geo.blocksize / BBSIZE);
+		if (dsize_max_suggested < ddsize)
+			dsize_max_suggested = ULLONG_MAX;
+		dsize_max_arch = ddsize * 1000 / (geo.blocksize / BBSIZE);
+		if (dsize_max_arch < ddsize)
+			dsize_max_arch = ULLONG_MAX;
+
 		if (!mflag)
 			maxpct = geo.imaxpct;
 		if (!dflag && !aflag)	/* Only mflag, no data size change */
@@ -261,6 +284,26 @@ main(int argc, char **argv)
 				(long long)dsize,
 				(long long)(ddsize/(geo.blocksize/BBSIZE)));
 			error = 1;
+		} else if (!fflag &&
+			   dsize > dsize_max_arch) {
+			fprintf(stderr, _(
+				"data size %lld beyond what XFS recomends for "
+				"this fs, max should be %lld but if used you "
+				"will suffer. Max suggested is %lld or use "
+				"-f to override.\n"),
+				(long long)dsize,
+				dsize_max_arch,
+				dsize_max_suggested);
+			error = 1;
+		} else if (!fflag &&
+			   dsize > dsize_max_suggested) {
+			fprintf(stderr, _(
+				"data size %lld beyond what XFS recomends for "
+				"this fs, max suggested is %lld or use "
+				"-f to override.\n"),
+				(long long)dsize,
+				dsize_max_suggested);
+			error = 1;
 		}
 
 		if (!error && dsize < geo.datablocks) {
