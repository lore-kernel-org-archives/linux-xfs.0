Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3JLhKCf010921 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 16:43:20 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89DB11CD0C2D
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 14:43:15 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id 7R03oQR4nBwU96Ir for
	<xfs@oss.sgi.com>; Sun, 19 Apr 2009 14:43:15 -0700 (PDT)
Date: Sun, 19 Apr 2009 17:43:15 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] xfstests: skip dump tests if dump utils not found
Message-ID: <20090419214315.GT3709@josefsipek.net>
References: <49EB8F90.20705@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49EB8F90.20705@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Apr 19, 2009 at 03:54:40PM -0500, Eric Sandeen wrote:
> I was running xfstests on a NAS box which had no xfsdump,
> and any tests which required xfsdump were failing in not-so-nice
> ways:
> 
> > xfsdump not found
> 038      [failed, exit status 1] - output mismatch (see 038.out.bad)
> 
> I think using _notrun is a lot better:
> 
> 038      [not run] xfsdump not found
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Sounds good.

Josef 'Jeff' Sipek.

-- 
Bad pun of the week: The formula 1 control computer suffered from a race
condition

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
