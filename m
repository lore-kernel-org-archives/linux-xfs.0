Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3I55pY4174936 for <xfs@oss.sgi.com>; Sat, 18 Apr 2009 00:05:53 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BE00142F448
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2009 22:08:08 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id ijItv6Sr0bRYG5DG for
	<xfs@oss.sgi.com>; Fri, 17 Apr 2009 22:08:08 -0700 (PDT)
Date: Sat, 18 Apr 2009 01:05:44 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] xfs: add more checks to superblock validation
Message-ID: <20090418050544.GQ3709@josefsipek.net>
References: <1240002765-20279-1-git-send-email-felixb@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1240002765-20279-1-git-send-email-felixb@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 17, 2009 at 04:12:45PM -0500, Felix Blyakher wrote:
> From: Olaf Weber <olaf@sgi.com>
> 
> There had been reports where xfs filesystem was randomly
> corrupted with fsfuzzer, and xfs failed to handle it
> gracefully. This patch fixes couple of reported problem
> by providing additional checks in the superblock
> validation routine.
> 
> Signed-off-by: Felix Blyakher <felixb@sgi.com>

Since this patch is from Olaf, shouldn't he have a s-o-b line as well?

I'm not really familiar with this part of the code...but it looks fine to
me.

Josef 'Jeff' Sipek.

-- 
Fact: 29.6% of all statistics are generated randomly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
