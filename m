Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9FKk3UB234698 for <xfs@oss.sgi.com>; Mon, 15 Oct 2012 15:46:03 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jjJa3A7xJNV3Qtq7 for <xfs@oss.sgi.com>;
	Mon, 15 Oct 2012 13:47:39 -0700 (PDT)
Message-ID: <507C766A.3000400@sandeen.net>
Date: Mon, 15 Oct 2012 15:47:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_db
References: <CACBF2D716C5104BAC48A16827DE5B1513576996C6@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN>
In-Reply-To: <CACBF2D716C5104BAC48A16827DE5B1513576996C6@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN>
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
To: Anshul Kundra <anshul.kundra@hcl.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 10/15/12 9:34 AM, Anshul Kundra wrote:
> Suppose in XFS file system I want to corrupt a inode of my choice,
> will it be possible using xfs_db
> 
> Xfs_db blockget < inode number > blocktrash < seed value and type of
> block >
> 
> In the manuals it is written that it takes a random inodes for the
> corruption which it does in actual practice, so can I use any
> specific command to corrupt the inode (131 )

As the manual says, blocktrash trashes random metadata blocks (possibly
of specified type).

You can, however, write whatever you want into various fields of
inode 131 via xfs_db, there's just no built-in random method to
do that.

-Eric

> 
> Thanks & Regards
> 
> Anshul Kundra
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
