Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 409CC7CD5
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 06:56:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEC3DAC003
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 04:56:24 -0700 (PDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com
	[74.125.82.65]) by cuda.sgi.com with ESMTP id amRJ0IpVBEZl8tG8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2016 04:56:22 -0700 (PDT)
Received: by mail-wm0-f65.google.com with SMTP id n3so4243847wmn.1
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 04:56:22 -0700 (PDT)
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 0/2] scop GFP_NOFS api
Date: Tue, 26 Apr 2016 13:56:10 +0200
Message-Id: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, logfs@logfs.org, cluster-devel@redhat.com, Chris Mason <clm@fb.com>, linux-mtd@lists.infradead.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org

Hi,
we have discussed this topic at LSF/MM this year. There was a general
interest in the scope GFP_NOFS allocation context among some FS
developers. For those who are not aware of the discussion or the issue
I am trying to sort out (or at least start in that direction) please
have a look at patch 1 which adds memalloc_nofs_{save,restore} api
which basically copies what we have for the scope GFP_NOIO allocation
context. I haven't converted any of the FS myself because that is way
beyond my area of expertise but I would be happy to help with further
changes on the MM front as well as in some more generic code paths.

Dave had an idea on how to further improve the reclaim context to be
less all-or-nothing wrt. GFP_NOFS. In short he was suggesting an opaque
and FS specific cookie set in the FS allocation context and consumed
by the FS reclaim context to allow doing some provably save actions
that would be skipped due to GFP_NOFS normally.  I like this idea and
I believe we can go that direction regardless of the approach taken here.
Many filesystems simply need to cleanup their NOFS usage first before
diving into a more complex changes.

The patch 2 is a debugging aid which warns about explicit allocation
requests from the scope context. This is should help to reduce the
direct usage of the NOFS flags to bare minimum in favor of the scope
API. It is not aimed to be merged upstream. I would hope Andrew took it
into mmotm tree to give it linux-next exposure and allow developers to
do further cleanups.  There is a new kernel command line parameter which
has to be used for the debugging to be enabled.

I think the GFP_NOIO should be seeing the same clean up.

Any feedback is highly appreciated.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
