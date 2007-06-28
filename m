Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 10:58:01 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SHvotL013859
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 10:57:52 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5SHvp3r014116
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 13:57:51 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5SHvp0g551106
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 13:57:51 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5SHvoXx026453
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 13:57:51 -0400
Date: Thu, 28 Jun 2007 23:27:57 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Message-ID: <20070628175757.GA1674@amitarora.in.ibm.com>
References: <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070628025543.9467216f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628025543.9467216f.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Thu, Jun 28, 2007 at 02:55:43AM -0700, Andrew Morton wrote:
> On Mon, 25 Jun 2007 18:58:10 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> 
> > N O T E: 
> > -------
> > 1) Only Patches 4/7 and 7/7 are NEW. Rest of them are _already_ part
> >    of ext4 patch queue git tree hosted by Ted.
> 
> Why the heck are replacements for these things being sent out again when
> they're already in -mm and they're already in Ted's queue (from which I
> need to diligently drop them each time I remerge)?
> 
> Are we all supposed to re-review the entire patchset (or at least #4 and
> #7) again?

As I mentioned in the note above, only patches #4 and #7 were new and
thus these needed to be reviewed. Other patches are _not_ replacements
of any of the patches which are already part of -mm and/or in Ted's
patch queue. They were posted again as just "placeholders" so that the
two new patches (#4 & #7) could be reviewed. Sorry for any confusion.
 
> Please drop the non-ext4 patches from the ext4 tree and send incremental
> patches against the (non-ext4) fallocate patches in -mm.

Please let us know what you think of Mingming's suggestion of posting
all the fallocate patches including the ext4 ones as incremental ones
against the -mm.

--
Regards,
Amit Arora
