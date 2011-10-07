Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p978eH7M228353 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 03:40:18 -0500
Received: from nm7.bullet.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id D3FBB144B587
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 01:47:07 -0700 (PDT)
Received: from nm7.bullet.mail.sg1.yahoo.com (nm7.bullet.mail.sg1.yahoo.com
	[115.178.12.209]) by cuda.sgi.com with SMTP id MbOdjhGEsTXqYNhl
	for <xfs@oss.sgi.com>; Fri, 07 Oct 2011 01:47:07 -0700 (PDT)
Message-ID: <1317976813.82044.YahooMailClassic@web77716.mail.sg1.yahoo.com>
Date: Fri, 7 Oct 2011 16:40:13 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: Re: Premature "No Space left on device" on XFS
In-Reply-To: <20111007013711.GW3159@dastard>
MIME-Version: 1.0
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
To: Bernhard Schmidt <berni@birkenwald.de>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,


> 
> As it is, your problem is most likely fragmented free space
> (an
> aging problem). Inodes are allocated in chunks of 64, so
> require an
> -aligned- contiguous 16k extent for the default 256 byte
> inode size.
> If you have no aligned contiguous 16k extents free then
> inode
> allocation will fail.
> 

I understand from the mkfs.xfs man page "The  XFS  inode  contains a fixed-size part and a variable-size part."

1) Do you mean inodes are allocated in units of 64 at one go?
2) What is the size of the fixed-size part?
3) Are the fixed-size parts of inodes also allocated in units of 64 at one go?
4) Where are the fixed-size parts located?  On special extents just like the variable-size part?
5) What about the locality of the variable and fixed size parts of the inodes?  Can they be any distance apart?

Thanks!


GL

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
