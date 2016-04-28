Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41D367D19
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2016 03:18:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7F6630404E
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2016 01:18:04 -0700 (PDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com
	[74.125.82.68]) by cuda.sgi.com with ESMTP id iqktnj5uhJdjjQuU
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Apr 2016 01:18:02 -0700 (PDT)
Received: by mail-wm0-f68.google.com with SMTP id e201so20528680wme.2
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2016 01:18:02 -0700 (PDT)
Date: Thu, 28 Apr 2016 10:17:59 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm, debug: report when GFP_NO{FS,IO} is used
	explicitly from memalloc_no{fs,io}_{save,restore} context
Message-ID: <20160428081759.GA31489@dhcp22.suse.cz>
References: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
	<1461671772-1269-3-git-send-email-mhocko@kernel.org>
	<20160426225845.GF26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160426225845.GF26977@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

[Trim the CC list]
On Wed 27-04-16 08:58:45, Dave Chinner wrote:
[...]
> Often these are to silence lockdep warnings (e.g. commit b17cb36
> ("xfs: fix missing KM_NOFS tags to keep lockdep happy")) because
> lockdep gets very unhappy about the same functions being called with
> different reclaim contexts. e.g.  directory block mapping might
> occur from readdir (no transaction context) or within transactions
> (create/unlink). hence paths like this are tagged with GFP_NOFS to
> stop lockdep emitting false positive warnings....

As already said in other email, I have tried to revert the above
commit and tried to run it with some fs workloads but didn't manage
to hit any lockdep splats (after I fixed my bug in the patch 1.2). I
have tried to find reports which led to this commit but didn't succeed
much. Everything is from much earlier or later. Do you happen to
remember which loads triggered them, what they looked like or have an
idea what to try to reproduce them? So far I was trying heavy parallel
fs_mark, kernbench inside a tiny virtual machine so any of those have
triggered direct reclaim all the time.

Thanks!
-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
