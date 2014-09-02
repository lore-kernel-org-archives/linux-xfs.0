Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA72D7F4E
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 14:16:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56B72AC004
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 12:16:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7rbufw64z0TzcAYm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Sep 2014 12:16:23 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s82JGM6b018512
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 2 Sep 2014 15:16:22 -0400
Received: from laptop.bfoster (vpn-51-136.rdu2.redhat.com [10.10.51.136])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s82JGKZF013899
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 2 Sep 2014 15:16:22 -0400
Date: Tue, 2 Sep 2014 15:16:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/4] clean up collapse range and handle post-eof
	delalloc
Message-ID: <20140902191620.GA5304@laptop.bfoster>
References: <1409344178-44817-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409344178-44817-1-git-send-email-bfoster@redhat.com>
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

On Fri, Aug 29, 2014 at 04:29:34PM -0400, Brian Foster wrote:
> Here's a drop of what I'm testing over the weekend. It passes some quick
> tests, but only lightly tested so far.
> 

fsx has been running for over 3 days without a failure and I've kicked
off a parallel fsstress today that so far hasn't caused any problems.
Given that, I think the patches here help reduce the likelihood of
errors from collapse.

> My biggest question at this point is whether there is any risk to the
> shift of the post-eof extent if the subsequent truncate happens to fail.
> If it's not worth dealing with that, we could just drop patch 3 and
> leave the eofblocks trim permanently.
> 

That said, a test to skip the post-collapse truncate confirms that the
behavior of patch 3 is potentially problematic in the event of failure.
E.g., there is no behavior analogous to the zeroing of prealloc space
for extending truncates.

I think the right thing to do here might be for the collapse to
writeback and invalidate the range following the space that was freed to
EOF and to retain the eofblocks trim.

Brian

> In fact, it might even be a good idea to go back to the original
> [start,-1] writeback in collapse range given that the free file space
> helper could change at some point to only write and punch out the range
> being freed... and then we're left shifting a bunch of extents after the
> freed range that could have dirty data in pagecache, which sounds bad.
> Thoughts?
> 
> Brian
> 
> Brian Foster (4):
>   xfs: track collapse via file offset rather than extent index
>   xfs: refactor xfs_bmap_shift_extents() into multiple functions
>   xfs: allow collapse to handle delalloc extents
>   xfs: remove file writeback and eofblocks trim from collapse range
> 
>  fs/xfs/libxfs/xfs_bmap.c | 302 ++++++++++++++++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_bmap.h |   7 +-
>  fs/xfs/xfs_bmap_util.c   |  32 +----
>  3 files changed, 214 insertions(+), 127 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
