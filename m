Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACNOas0171608 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:24:36 -0600
Subject: Re: [PATCH v2 0/9] xfsrestore dirent limitations and scaling issues
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101105163500.747192954@sgi.com>
References: <20101105163500.747192954@sgi.com>
Date: Fri, 12 Nov 2010 17:25:50 -0600
Message-ID: <1289604350.2315.912.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Fri, 2010-11-05 at 11:35 -0500, wkendall@sgi.com wrote:
> The first two patches in this series remove dirent limitations that
> exist in the current xfsrestore, allowing restore to now handle 4
> billion directory entries. Restore would map 200 GB of memory to do
> so, so don't go thinking this is a good idea. :)  (These two patches
> were previously submitted to the list but I've made some changes to
> them as suggested by Alex Elder.)
> 
> The remaining patches mostly deal with improving restore
> performance, most noticeably on dumps containing upwards of 10
> million inodes/dirents.  This resulted in a 50% improvement in the
> time required to build restore's node table (a mmap'd representation
> of the dump's directory structure), so for interactive restores and
> restoring sub-directories this is very helpful. For full restores
> with millions of files the overall restore time is dominated by
> creating inodes and laying down the data, so the improvements here
> would be less noticeable.
> 
> For dumps with lots of hard links, these changes fix a bug that was
> causing xfsrestore to constantly have to map and unmap segments of
> the node table, leading to horrible performance.
> 
> Several of these patches modify the on-disk state information that
> xfsrestore leaves around for resuming restores. The final patch adds
> versioning information to the on-disk state to detect cases where
> the user tries to resume a restore with an incompatible version of
> xfsrstore (or an incompatible system).

I've reviewed most of these but I'll have to return
to the rest next week.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
