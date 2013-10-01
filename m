Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1605C7F54
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 15:19:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02D2530406B
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 13:19:16 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	AYoSBmKCBQ42ItZ7 for <xfs@oss.sgi.com>;
	Tue, 01 Oct 2013 13:19:13 -0700 (PDT)
Date: Wed, 2 Oct 2013 06:19:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair segfault
Message-ID: <20131001201909.GR12541@dastard>
References: <CAGa4098ZKd2KQfWMgNXYgLr9LJF8r-MpFgQAn3G-W+ovDGHTAw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGa4098ZKd2KQfWMgNXYgLr9LJF8r-MpFgQAn3G-W+ovDGHTAw@mail.gmail.com>
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
To: Viet Nguyen <vietnguyen@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 01, 2013 at 12:57:42PM -0700, Viet Nguyen wrote:
> Hi,
> 
> I have a corrupted xfs partition that segfaults when I run xfs_repair, at
> the same place every time.
> 
> I'm using the latest version of xfs_repair that I am aware of: xfs_repair
> version 3.2.0-alpha1
> 
> I simply run it as so: xfs_repair -P /dev/sda1
> 
> Here's a sample of the last few lines that are spit out:
> correcting nextents for inode 8637985
> correcting nblocks for inode 8637985, was 198 - counted 0
> correcting nextents for inode 8637985, was 1 - counted 0
> data fork in regular inode 8637987 claims used block 7847452695
> correcting nextents for inode 8637987
> correcting nblocks for inode 8637987, was 198 - counted 0
> correcting nextents for inode 8637987, was 1 - counted 0
> data fork in regular inode 8637999 claims used block 11068974204
> correcting nextents for inode 8637999
> correcting nblocks for inode 8637999, was 200 - counted 0
> correcting nextents for inode 8637999, was 1 - counted 0
> data fork in regular inode 8638002 claims used block 11873152787
> correcting nextents for inode 8638002
> correcting nblocks for inode 8638002, was 201 - counted 0
> correcting nextents for inode 8638002, was 1 - counted 0
> imap claims a free inode 8638005 is in use, correcting imap and clearing
> inode
> cleared inode 8638005
> imap claims a free inode 8638011 is in use, correcting imap and clearing
> inode
> cleared inode 8638011
> Segmentation fault (core dumped)
> 
> It crashes after attempting to clear that same inode every time.
> 
> Any advice you can give me on this?

Can you run it under gdb and send the stack trace that tells us
where it crashed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
