Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3O61aA3064355 for <xfs@oss.sgi.com>; Fri, 24 Apr 2009 01:01:37 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87A7E238B76
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 23:01:33 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id FsXqLbZffJ9Twge2 for
	<xfs@oss.sgi.com>; Thu, 23 Apr 2009 23:01:33 -0700 (PDT)
Date: Fri, 24 Apr 2009 02:01:33 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] xfstests: fix 130, 132 for inifinitely-fast disks
Message-ID: <20090424060133.GH3709@josefsipek.net>
References: <49F0B379.2060309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49F0B379.2060309@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Thu, Apr 23, 2009 at 01:29:13PM -0500, Eric Sandeen wrote:
> Due to the new quantum/holographic storage I'm testing, my 
> disks go infinitely fast, thereby breaking some filters:

If you want, send me those drives, and I'll test them for you ;)

> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +3 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 
> I'm no regexp expert but I think the below change will fix it.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Yep, that'll do it.

Josef 'Jeff' Sipek.

-- 
What is the difference between Mechanical Engineers and Civil Engineers?
Mechanical Engineers build weapons, Civil Engineers build targets.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
