Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F41F7FB1
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 09:03:21 -0500 (CDT)
Date: Thu, 22 Aug 2013 09:03:18 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH] xfs_db: add header to freesp -d output
Message-ID: <20130822140318.GA21265@sgi.com>
References: <521541EF.1000604@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <521541EF.1000604@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Aug 21, 2013 at 05:40:47PM -0500, Eric Sandeen wrote:
| Today, xfs_db's freesp -d command dumps out a bunch of numbers:
| 
| # xfs_db -c "freesp -d" /dev/sdb1
|        0        4        1
|        0        5        1
|        0        6        1
|        0        7        1
|        0       12   174772
| ...
| 
| which are not useful to the non-code-reading user.
| Add some headers:
| 
| # xfs_db -c "freesp -d" /dev/sdb1
|     agno    agbno      len
|        0        4        1
|        0        5        1
|        0        6        1
|        0        7        1
|        0       12   174772
| ...
| 
| so there's at least some context.
| 
| Signed-off-by: Eric Sandeen <sandeen@redhat.com>
| ---
| 
| p.s. - If folks want different strings, I'm game.

The format is consistent with the "dumpflag" format in addtohist().  I
like your choice of strings, except I suggest "length" in place of
"len".  The space is available.


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
