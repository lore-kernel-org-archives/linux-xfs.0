Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A25267F55
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 08:54:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 808D88F804B
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 06:54:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GuJxtnZWrQ4DjfcY for <xfs@oss.sgi.com>;
	Mon, 09 Sep 2013 06:54:43 -0700 (PDT)
Message-ID: <522DD321.1010201@sandeen.net>
Date: Mon, 09 Sep 2013 08:54:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] [RFC] xfs: increase inode cluster size for v5 filesystems
References: <1378715664-19969-1-git-send-email-david@fromorbit.com>
	<20130909133254.GA14778@infradead.org>
In-Reply-To: <20130909133254.GA14778@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 9/9/13 8:32 AM, Christoph Hellwig wrote:
> I can't see anything v5 format specific here, as 512 byte inodes can be
> created with v4 filesystems as well.

Good point - why is this uniquely needed for V5 filesystems?
If it wasn't a problem w/ larger inodes before, why is it now?

This makes the dreaded test matrix go a bit more wonky...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
