Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 22:35:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A5ZS15007281
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 22:35:31 -0700
Date: Thu, 10 Apr 2008 15:36:01 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW XFSQA test out xfs_attr_shortform_bytesfit attr2/attr1 fix
Message-ID: <20080410053601.GK108924158@sgi.com>
References: <47FC79FC.5020803@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FC79FC.5020803@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>, asg-qa <asgqa@sgi.com>

On Wed, Apr 09, 2008 at 06:10:36PM +1000, Timothy Shimmin wrote:
> Hi there,
> 
> A test to test out Eric's fix for xfs_attr_shortform_bytesfit
> bug when going from attr2 to attr1.
> 
> With TOT kernel, without patch, one can see the corrupted inline
> dirents. With patch, all is well.
> 
> The 186.out _should_ be output'ing ATTR2 for the db version
> command but I'm awaiting Barry's xfsprogs checkin to fix that one -
> and then I will regenerate it.

Really? I'm seeing it fail with ATTR2 in the xfs_db output...

dgc@budgie:~/xfstests$ sudo ./check 186
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ia64 budgie 2.6.25-rc3-dgc-xfs
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb6
MOUNT_OPTIONS -- /dev/sdb6 /mnt/scratch

186      - output mismatch (see 186.out.bad)
13a14
> ATTR2
98a100
> ATTR2
Failures: 186
Failed 1 of 1 tests
dgc@budgie:~/xfstests$

So the first is supposed to be there, but the second shows:

....
=================================
ATTR
ATTR2
core.forkoff = 47
....

Are both supposed to be present?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
