Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UMvXHo219832 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 17:57:43 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8CDD58F80BB
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 15:57:10 -0700 (PDT)
Message-Id: <7FC08527-82CE-4D3F-A1C6-76FAAE4389AB@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <49D14120.8040804@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: Mystery solved?  files not written for days...
Date: Mon, 30 Mar 2009 17:30:54 -0500
References: <49D14120.8040804@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>


On Mar 30, 2009, at 5:01 PM, Eric Sandeen wrote:

> On LKML:
>
> [PATCH] writeback: guard against jiffies wraparound on
> inode->dirtied_when checks

The "jiffies wraparound" sounds very familiar, but I
thought it's been fixed ages ago.

> When a file is continually dirtied, the check in sync_sb_inodes:
>
>        /* Was this inode dirtied after sync_sb_inodes was called? */
>        if (time_after(inode->dirtied_when, start))
>                break;
>
> may have large windows where this trips on the first
> (continually-dirtied) inode on the list when the time_after check has
> wrapped, causing the nothing to be written out for that superblock,
> potentially for days.
>
> Could this be the reason for those various "hey, my file disappeared
> after a crash and I hadn't written to it for *days*" reports we got  
> now
> and then, leaving us all scratching our heads?

The "jiffies wraparound" could definitely cause this.

Felix

>
>
> -Eric
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
