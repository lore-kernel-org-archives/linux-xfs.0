Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5C9237F51
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 09:45:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F03A1AC005
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 07:45:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zJB9SGETN5bcOkCi for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 07:45:47 -0700 (PDT)
Message-ID: <5420361C.1090500@sandeen.net>
Date: Mon, 22 Sep 2014 09:45:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: validate & fix inode CRCs
References: <5418AC01.30006@redhat.com>
	<20140922131855.GA29156@bfoster.bfoster>
In-Reply-To: <20140922131855.GA29156@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 9/22/14 8:18 AM, Brian Foster wrote:

> So we verify each inode first in process_inode_chunk() and then follow
> on with process_dinode(). There's a comment further up in
> process_dinode_int() that indicates we explicitly do not check the crc
> at that point, presumably considering verify_mode. I only see one call
> to each of verify_inode() and process_dinode() (in that order). The
> other process_dinode_int() caller is verify_uncertain_dinode(), which
> looks like it occurs ultimately from process_uncertain_aginodes() in
> phase 3.
> 
> I suppose that logic makes sense, but it's not totally clear tbh. We do
> fix up the crc in the caller if the inode is marked dirty. It also seems
> like it's possible to modify the inode before this point where we check
> the crc. Given that, it seems like we could just add an "if
> (!verify_mode)" hunk to the preexisting hascrc() hunk further up in the
> function..?

Ugh, I am not sure how I missed that we could have already modified it.
Ok, that throws the whole thing out, I'll take another look.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
