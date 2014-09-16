Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D8767F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 18:53:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B0F28F8039
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 16:53:11 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1XvInlUuvB4UAzIK for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 16:53:09 -0700 (PDT)
Date: Wed, 17 Sep 2014 09:52:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2 V2] xfs_db: add crc manipulation commands
Message-ID: <20140916235228.GQ4322@dastard>
References: <540B4399.4020804@sandeen.net> <5418574A.8040102@sandeen.net>
	<5418B459.1010204@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5418B459.1010204@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 16, 2014 at 05:06:17PM -0500, Eric Sandeen wrote:
> On 9/16/14 10:29 AM, Eric Sandeen wrote:
> > This adds a new "crc" command to xfs_db for CRC-enabled filesystems.
> > 
> > If a structure has a CRC field, we can validate it, invalidate/corrupt
> > it, or revalidate/rewrite it:
> > 
> > xfs_db> sb 0
> > xfs_db> crc -v
> > crc = 0x796c814f (correct)
> > xfs_db> crc -i
> > Metadata CRC error detected at block 0x0/0x200
> > crc = 0x796c8150 (bad)
> > xfs_db> crc -r
> > crc = 0x796c814f (correct)
> 
> On reflection, do you think these should be more verbose, something like:
> 
> xfs_db> sb 0
> xfs_db> crc -v
> Validating crc:
> crc = 0x796c814f (correct)
> xfs_db> crc -i
> Invalidating CRC:
> Metadata CRC error detected at block 0x0/0x200
> crc = 0x796c8150 (bad)
> xfs_db> crc -r
> Rewriting CRC:
> crc = 0x796c814f (correct)

Seems like a good idea to me. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
