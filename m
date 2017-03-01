Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751470AbdCADv6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:51:58 -0500
Date: Wed, 1 Mar 2017 11:33:16 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 4/4] xfs: stress test xfs_scrub
Message-ID: <20170301033316.GB14226@eguan.usersys.redhat.com>
References: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
 <148798518415.25833.11653991983531432757.stgit@birch.djwong.org>
 <20170228205710.GC26275@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228205710.GC26275@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Feb 28, 2017 at 12:57:10PM -0800, Darrick J. Wong wrote:
> Three new tests:
> 
> - Repair files that are mapped into memory in running programs
> - Run scrub -n concurrently with fsstress
> - Run scrub -y concurrently with fsstress
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix checks for external programs per eryu guan's recommendations
> ---
[snip]
> +
> +killstress() {
> +	sleep $(( 60 * TIME_FACTOR ))
> +	$KILLALL_PROG -q $FSSTRESS_PROG
> +}
> +
> +echo "Concurrent scrub"
> +start=$(date +%s)
> +end=$((start + (60 * LOAD_FACTOR) ))

In 137[67], I think this should be TIME_FACTOR too. I can fix them at
commit time if this change looks OK to you.

Thanks,
Eryu
