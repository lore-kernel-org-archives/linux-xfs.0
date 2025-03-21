Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7A24207A;
	Fri, 21 Mar 2025 16:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742573928; cv=none; b=D3FQf5XRMuzTvBWMaRDjkfiFBZh3MlNwSUv3/YxXrks2J81qASehLZdvoIov0097Xi9o7y8lYhVbRl2+7ScV7I4FcZ3Io8TOyQWra4p+xclBg6JJ0/lCN2kHN2r8OveJTeDHoJUoreiOjchItyZ7MyppFJJwLviWy3WOtrrx0aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742573928; c=relaxed/simple;
	bh=DwRKLtbDRxPFh80TV0iuQKFtLNQUyPAH4/roK7qMEJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8mGcr7ymHHARJch0MHDA9tmvs57e6mjEhnDl8wdspnVJSRyCex09X2JuuNdsSSNYVaRVBP4mrn6QU12w9neO6Z70a75rRNxHEJVNFJN9URzxx/cUJ4zM18VR1gjCG9riBPhgR4a1e+HEia+s1I5FJO7qGFnAQwUtSetztPNU+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JgN/Kq3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgN/Kq3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D83C4CEE3;
	Fri, 21 Mar 2025 16:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742573927;
	bh=DwRKLtbDRxPFh80TV0iuQKFtLNQUyPAH4/roK7qMEJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JgN/Kq3Ml/oM5k8p9EPp7vxpr9XfoeVAlpdfmHtas/sgseXzJ/NoZVJfuVyh11FVB
	 DD+fjMw5bG20j7jSONan0v6UZODfIXucWAgiEHPgp86afAvtL8z0jg+haG4xoRCTAA
	 ZlxqwkN5gnreHTyT5hU+QuhZWDZLenYx6ebNNU/6NRyRqEqu+1tc5rVE1hxpS6lZ1K
	 oO638cNblYA+36tMuLpc9SO0hx5xZQXjU1qMJMe9tnFU0JMLWvEw0pLbavcNQwWGTI
	 102LNKn0Wv1M8JtaoPanvQvjqdUKCqCOeH2o/2FyQ7hiaoYtHKJLA5HuEb80XVgR17
	 Si1ouPD0ouKKA==
Date: Fri, 21 Mar 2025 09:18:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Petr Vorel <pvorel@suse.cz>
Cc: ltp@lists.linux.it, Li Wang <liwang@redhat.com>,
	Cyril Hrubis <chrubis@suse.cz>,
	Andrea Cervesato <andrea.cervesato@suse.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Allison Collins <allison.henderson@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Gao Xiang <hsiangkao@redhat.com>,
	Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] ioctl_ficlone03: Require 5.10 for XFS
Message-ID: <20250321161846.GM2803749@frogsfrogsfrogs>
References: <20250321100320.162107-1-pvorel@suse.cz>
 <20250321152358.GK2803749@frogsfrogsfrogs>
 <20250321160633.GA177324@pevik>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321160633.GA177324@pevik>

On Fri, Mar 21, 2025 at 05:06:33PM +0100, Petr Vorel wrote:
> > On Fri, Mar 21, 2025 at 11:03:20AM +0100, Petr Vorel wrote:
> > > Test fails on XFS on kernel older than 5.10:
> 
> > >     # ./ioctl_ficlone03
> > > 	...
> > >     tst_test.c:1183: TINFO: Mounting /dev/loop0 to /tmp/LTP_ioc6ARHZ7/mnt fstyp=xfs flags=0
> > >     [   10.122070] XFS (loop0): Superblock has unknown incompatible features (0x8) enabled.
> 
> > 0x8 is XFS_SB_FEAT_INCOMPAT_BIGTIME, maybe you need to format with a set
> > of filesystem features compatible with 5.10?
> 
> > # mkfs.xfs -c options=/usr/share/xfsprogs/mkfs/lts_5.10.conf /dev/sda1
> 
> Yes, XFS_SB_FEAT_INCOMPAT_BIGTIME is what is missing for the test. Device is
> formatted with: -m reflink=1 (I'm sorry to not posting this before):

You could remove reflink=1 from the test specification, reflink has been
on by default for quite a while now...

> 
> tst_test.c:1170: TINFO: Formatting /dev/loop0 with xfs opts='-m reflink=1' extra opts=''
> 
> I thought it would imply XFS_SB_FEAT_INCOMPAT_BIGTIME, but when I tried to remove it
> it did not help:
> 
> tst_test.c:1909: TINFO: Tested kernel: 5.0.21-00005-gb6c47615d7bf #211 SMP Fri Mar 21 12:23:18 CET 2025 x86_64
> ...
> tst_test.c:1833: TINFO: === Testing on xfs ===
> tst_cmd.c:281: TINFO: Parsing mkfs.xfs version
> tst_test.c:1170: TINFO: Formatting /dev/loop0 with xfs opts='' extra opts=''
> tst_test.c:1183: TINFO: Mounting /dev[   75.418676] XFS (loop0): Superblock has unknown incompatible features (0x8) enabled.
> /loop0 to /tmp/L[   75.419683] XFS (loop0): Filesystem cannot be safely mounted by this kernel.
> TP_iocO8VAIk/mnt[   75.420629] XFS (loop0): SB validate failed with error -22.
>  fstyp=xfs flags=0
> tst_test.c:1183: TBROK: mount(/dev/loop0, mnt, xfs, 0, (nil)) failed: EINVAL (22)
> 
> Well, I tried with mkfs.xfs from openSUSE Leap 15.6 (tested via rapido-linux),
> probably the defaults add it.
> 
> $ mkfs.xfs -V
> mkfs.xfs version 6.7.0

...but mkfs.xfs 6.7 enables y2038 support by default unless you specify
otherwise, which is why it still won't mount.  Hence my suggestion to
use the config files if they're available.  If not, then either run
xfsprogs 5.10 on kernel 5.10, or create per-kernel xfs opts that
override the defaults to put them back down to whatever were the mkfs
defaults in 5.10.

> Also I noted that test works on our 5.3.18 based SLES15-SP2 with xfsprogs
> 4.15.0. Maybe I'm just wasting your time with wrong patch.

<shrug> QA configuration for a bunch of kernels is irritatingly hard,
we all need to compare notes when we can. :)

--D

> Kind regards,
> Petr
> 
> > --D
> 
> > >     [   10.123035] XFS (loop0): Filesystem cannot be safely mounted by this kernel.
> > >     [   10.123916] XFS (loop0): SB validate failed with error -22.
> > >     tst_test.c:1183: TBROK: mount(/dev/loop0, mnt, xfs, 0, (nil)) failed: EINVAL (22)
> 
> > > This also causes Btrfs testing to be skipped due TBROK on XFS. With increased version we get on 5.4 LTS:
> 
> > >     # ./ioctl_ficlone03
> > >     tst_test.c:1904: TINFO: Tested kernel: 5.4.291 #194 SMP Fri Mar 21 10:18:02 CET 2025 x86_64
> > >     ...
> > >     tst_supported_fs_types.c:49: TINFO: mkfs is not needed for tmpfs
> > >     tst_test.c:1833: TINFO: === Testing on xfs ===
> > >     tst_cmd.c:281: TINFO: Parsing mkfs.xfs version
> > >     tst_test.c:969: TCONF: The test requires kernel 5.10 or newer
> > >     tst_test.c:1833: TINFO: === Testing on btrfs ===
> > >     tst_test.c:1170: TINFO: Formatting /dev/loop0 with btrfs opts='' extra opts=''
> > >     [   30.143670] BTRFS: device fsid 1a6d250c-0636-11f0-850f-c598bdcd84c4 devid 1 transid 6 /dev/loop0
> > >     tst_test.c:1183: TINFO: Mounting /dev/loop0 to /tmp/LTP_iocjwzyal/mnt fstyp=btrfs flags=0
> > >     [   30.156563] BTRFS info (device loop0): using crc32c (crc32c-generic) checksum algorithm
> > >     [   30.157363] BTRFS info (device loop0): flagging fs with big metadata feature
> > >     [   30.158061] BTRFS info (device loop0): using free space tree
> > >     [   30.158620] BTRFS info (device loop0): has skinny extents
> > >     [   30.159911] BTRFS info (device loop0): enabling ssd optimizations
> > >     [   30.160652] BTRFS info (device loop0): checking UUID tree
> > >     ioctl_ficlone03_fix.c:49: TPASS: invalid source : EBADF (9)
> > >     ioctl_ficlone03_fix.c:55: TPASS: invalid source : EBADF (9)
> 
> > > Fixing commit is 29887a2271319 ("xfs: enable big timestamps").
> 
> > > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > > ---
> > > Hi all,
> 
> > > I suppose we aren't covering a test bug with this and test is really
> > > wrong expecting 4.16 would work on XFS. FYI this affects 5.4.291
> > > (latest 5.4 LTS which is still supported) and would not be fixed due a
> > > lot of missing functionality from 5.10.
> 
> > > Kind regards,
> > > Petr
> 
> > >  testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> > > diff --git a/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c b/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
> > > index 6a9d270d9f..e2ab10cba1 100644
> > > --- a/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
> > > +++ b/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
> > > @@ -113,7 +113,7 @@ static struct tst_test test = {
> > >  		{.type = "bcachefs"},
> > >  		{
> > >  			.type = "xfs",
> > > -			.min_kver = "4.16",
> > > +			.min_kver = "5.10",
> > >  			.mkfs_ver = "mkfs.xfs >= 1.5.0",
> > >  			.mkfs_opts = (const char *const []) {"-m", "reflink=1", NULL},
> > >  		},
> > > -- 
> > > 2.47.2
> 
> 
> 
