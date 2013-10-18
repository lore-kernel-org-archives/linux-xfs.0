Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6724E7F53
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 22:57:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2155A8F8050
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 20:57:48 -0700 (PDT)
Received: from bash.esri.com (Redlands.esri.com [198.102.62.250]) by
	cuda.sgi.com with ESMTP id HG1EAqcSnsO3FeBK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Oct 2013 20:57:47 -0700 (PDT)
Received: from bash.esri.com (localhost [127.0.0.1])
	by bash.esri.com (8.14.4/8.14.4) with ESMTP id r9I3vlQg031352
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 20:57:47 -0700
Received: (from ray5147@localhost)
	by bash.esri.com (8.14.4/8.14.4/Submit) id r9I3vl86031350
	for xfs@oss.sgi.com; Thu, 17 Oct 2013 20:57:47 -0700
Date: Thu, 17 Oct 2013 20:57:47 -0700
From: Ray Van Dolson <rvandolson@esri.com>
Subject: Input on Potential XFs-based Design
Message-ID: <20131018035746.GA31020@esri.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all;

Am considering going with XFS for a project requiring a fair amount of
parallel (SMB network-sourced) throughput along with capacity.

We'll have ~10 writers outputing sequential data in the form of
300MB-3GB files via SMB v2.x (via Samba -- the writers will be running
Windows).  Needing approximately 100TB of usable space (we'll likely
only fill up to 70TB at any given time).  Also will be using 3-4TB 7.2K
drives in Dell hardware (R series server attached to either JBODs or an
MD3K controller) and probably use RHEL6 as our base (yes, reaching out
to Red Hat for advice as well).

Each "writer" will likely have 10GbE connections.  I've rarely seen a
single SMB TCP connection get more than ~2-3Gbps -- even with jumbo
frames on, so am looking to do a 2x10GbE LACP link on the XFS server
side to hopefully be able to handle the bulk of the traffic.

XFS sounds like the right option for us given its strength with
parallel writes, but have a few questions that are likely important for
us to understand the ansswers for prior to moving forward:

(1) XFS Allocation Groups.  My understanding is that XFS will write
files within a common directory using a single allocation group.
Writes to files in different directories will go to another allocation
group.  These allocation groups can be aligned with my individual LUNs,
so if I plan out where my files are being written to I stand the best
chance of getting maximum throughput.

Right now, the software generating the output just throws everything in
the same top-level directory.  Likely a trivial thing to change, but
it's another team completely, so I'm wondering if I'll still be able to
take advantage of XFs's parallelization and multiple allocatoin groups
even if all my writes are streaming to files which live under the same
parent directory.

(2) RAID design.  I'm looking for max throughput, and although writes
from each "writer" should be sequential, all of these streams hitting
at once I guess could be considered random reads.  I'm debating with
going either with Linux MD RAID striping a whole slew of 4-disk RAID10
LUNS presented by either our PERC RAID cards or by an MD3K head unit.
Another approach would be MD striping HW RAID5/RAID6 with enough RAID
groups to drive max throughput and get a bit mor capcity..

(3) Log Device.  Considering using a couple of SSD's in the head unit
as a dedicated log device.  The files we're writing are fairly big and
there's not too many of them, so this may not be needed (fewer metadata
operatoins) but also may not hurt.

Other approaches would be some sort of an appliance (more costly) or
using Windows (maybe better SMB performance, but unsure if I would want
to test NTFS much larger than 20TB).

Also not sure how RAM hungry XFS is.  Stuffing as much in as I can
probably won't hurt things (this is what we do for ZFS), but any rule
of thumb here?  

Thoughts appreciated!

Thanks,
Ray

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
