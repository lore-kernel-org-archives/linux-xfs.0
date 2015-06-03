Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A2B27FD1
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 15:31:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 125DFAC002
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 13:31:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id v4JzOH1l8MdLx2AF for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 13:31:35 -0700 (PDT)
Message-ID: <556F6426.5010002@sandeen.net>
Date: Wed, 03 Jun 2015 15:31:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2 V3] allow UUID changes on V5/CRC filesystems
References: <55525356.1020807@sandeen.net> <556EE18A.1080606@tlinx.org>
In-Reply-To: <556EE18A.1080606@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>, xfs-oss <xfs@oss.sgi.com>

On 6/3/15 6:14 AM, Linda Walsh wrote:
> 
> 
> Eric Sandeen wrote:
>> Final version?  This has been through some degree of testing, by changing
>> the UUID after a CRC mkfs, and re-setting it in between two xfs_repair runs
>> before and after each test in the testsuite.
> ---
>     I think I see my problem.

Oh?  what's that?  ;)

>     Is there some strong technical reason why 'crc' has to be on to get -finobt=1 && ftype=1.  I'd like to try the latter two
> features, but the 'crc' stuff has me a bit bugged -- for unanticipated
> reasons like not being able to set the UUID (I so very often hit
> those corner cases...*lucky-me*).

mkfs.xfs -n ftype=1 will get you ftype w/ no crcs.

But some of the above requirements are just because we can't have an infinite test matrix.  

Look at ext4 - would you like a flex_bg filesystem with bigalloc? what about a no-extents, meta-bg nodelalloc filesystem?  Maybe a 64bit, no-resize-inode ... you get the picture.  There are some very dark corners in a test matrix like that.

So the decision was made that for most new features, they were going to depend on the latest rev of the disk format, to keep the xfs code, developers, and users all relatively sane.   Relatively...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
