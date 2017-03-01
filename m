Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49511 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbdCAGIN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2017 01:08:13 -0500
Date: Tue, 28 Feb 2017 22:08:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 4/4] xfs: stress test xfs_scrub
Message-ID: <20170301060807.GD26319@birch.djwong.org>
References: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
 <148798518415.25833.11653991983531432757.stgit@birch.djwong.org>
 <20170228205710.GC26275@birch.djwong.org>
 <20170301033316.GB14226@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170301033316.GB14226@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Mar 01, 2017 at 11:33:16AM +0800, Eryu Guan wrote:
> On Tue, Feb 28, 2017 at 12:57:10PM -0800, Darrick J. Wong wrote:
> > Three new tests:
> > 
> > - Repair files that are mapped into memory in running programs
> > - Run scrub -n concurrently with fsstress
> > - Run scrub -y concurrently with fsstress
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: fix checks for external programs per eryu guan's recommendations
> > ---
> [snip]
> > +
> > +killstress() {
> > +	sleep $(( 60 * TIME_FACTOR ))
> > +	$KILLALL_PROG -q $FSSTRESS_PROG
> > +}
> > +
> > +echo "Concurrent scrub"
> > +start=$(date +%s)
> > +end=$((start + (60 * LOAD_FACTOR) ))
> 
> In 137[67], I think this should be TIME_FACTOR too. I can fix them at
> commit time if this change looks OK to you.

Ugh, I thought I fixed those too.  Yes, the change is correct, thank you.

--D

> 
> Thanks,
> Eryu
