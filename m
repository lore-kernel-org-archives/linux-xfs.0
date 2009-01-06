Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n069Rlpk002741 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 03:27:47 -0600
Received: from parsec.stupidest.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A3F317AFCBB
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 01:27:46 -0800 (PST)
Received: from parsec.stupidest.org (splinter.f00f.org [216.75.21.205]) by
	cuda.sgi.com with ESMTP id ENVZs06B3BR9HKok for
	<xfs@oss.sgi.com>; Tue, 06 Jan 2009 01:27:46 -0800 (PST)
Date: Tue, 6 Jan 2009 01:27:45 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: need help to repair XFS partition
Message-ID: <20090106092745.GA118462@puku.stupidest.org>
References: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Gergely Soos <sogerc1@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 06, 2009 at 11:11:07AM +0200, Gergely Soos wrote:

> Please help me restore the partition, It contains lots of programmes
> I wrote over the years and some of them are not backed up, some of
> them are, but only an older version. I also have personal stuff on
> it like my bill records that I cannot recover from anywhere else.

dd the entire image in it's current form to somewhere safe, that way
if all else fails you can grovel over the raw data looking for the
data you care about (xfs is fairly good and avoiding fragmentation for
files so there is a good change if you find a block of data you care
about the others will be there too)

> I would also attach the output of xfs_metadump which I created after
> I corrected the three inode numbers in the superblock but even
> bzip-ed it is more than 3MB and the administrator of this list does
> not accept it.

so xfs_repair found the secondary SBs?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
