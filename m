Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D34EE7F4E
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 16:26:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B30D58F8033
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 14:26:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7H0tln9dnRv5QS78 for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 14:26:10 -0700 (PDT)
Message-ID: <540CCD71.4020507@sandeen.net>
Date: Sun, 07 Sep 2014 16:26:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] xfs_repair: set proper ftype when moving to lost+found
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
	<1410108065-18156-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1410108065-18156-6-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 9/7/14 11:41 AM, Eric Sandeen wrote:
> When we move files to lost+found, we're setting the
> filetype to UNKNOWN.  This leaves an inconsistency which
> is discovered on a subsequent repair:
>
>   would fix ftype mismatch (0/1) in directory/child inode 5838/5839
>
> Setting the proper ftype at the time of the move
> resolves this:

Ah, arekm points out that Jan already sent a patch to do this:

[PATCH] repair: Set ftype for entries in lost+found

http://oss.sgi.com/archives/xfs/2014-07/msg00314.html

Sorry, missed that.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
