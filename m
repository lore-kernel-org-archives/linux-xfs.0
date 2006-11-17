Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Nov 2006 16:18:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAI0IIaG014039
	for <xfs@oss.sgi.com>; Fri, 17 Nov 2006 16:18:20 -0800
Message-ID: <455E4A79.5090103@sandeen.net>
Date: Fri, 17 Nov 2006 17:49:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
References: <455CB54F.8080901@sandeen.net>
In-Reply-To: <455CB54F.8080901@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> see also https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=212201

ok so the padding was a red herring w.r.t. the corruption.

What I have found is that the bmap btree block -is- in the inode, and
the attribute extents -are- in the inode, but they are not properly placed.

If you reset the forkoff to 13, you'll get proper answers for the btree
block.  If you set it to 15, you get proper answers for the attribute
extents.  But not both at the same time.  Something set the forkoff, or
the location of the btree block, or the location of the attr extents, at
the wrong place in the inode.

Getting closer...

-Eric
