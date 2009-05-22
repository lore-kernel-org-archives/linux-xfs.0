Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4MFn7V1223933 for <xfs@oss.sgi.com>; Fri, 22 May 2009 10:49:07 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A88AFF6F13
	for <xfs@oss.sgi.com>; Fri, 22 May 2009 08:54:47 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id CU0YJA1L8siOgpsI for <xfs@oss.sgi.com>;
	Fri, 22 May 2009 08:54:47 -0700 (PDT)
Message-ID: <4A16C97A.2020909@sandeen.net>
Date: Fri, 22 May 2009 10:49:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: about XFS_IOC_RESVSP
References: <7fe205990905220716v7d06b9bch40fe6136af17e345@mail.gmail.com>
In-Reply-To: <7fe205990905220716v7d06b9bch40fe6136af17e345@mail.gmail.com>
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
To: Joe Hsu <nagual.hsu@gmail.com>
Cc: xfs@oss.sgi.com

Joe Hsu wrote:
>         I pre-allocate blocks for a file. Then I use "open" and "write" system
> calls to generate the content for that file. After the file is really
> written to the disk,
> I want to set all the extent(s) of that file unwritten. Then I will
> write new content to
> the same file. Is that possible? That means:
> I want to dis-care the content just written and use the same allocated blocks.
> In another words, I want to restore the state of the file to the state
> when it was
> first pre-allocated.
> 
>         Why am I doing this? Why not just over-write it? When doing
> partial over-writing,
> some blocks may be read for partial update before they are written
> out. This hurts
> some IO performance and If I can, I would prefer to dis-care old
> content of the file and
> use same (pre)allocated blocks. (In my case, I am doing intensive IO.)
> 
>         Any one can give me some hints? Thanks.
> 

Do you really need the exact same blocks?  What if you just truncate to
0 & re-allocate?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
