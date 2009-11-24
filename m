Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAO31EoD079076 for <xfs@oss.sgi.com>; Mon, 23 Nov 2009 21:01:15 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1495D564C1
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2009 19:01:38 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id mSEgA3ET6TENd2DX for
	<xfs@oss.sgi.com>; Mon, 23 Nov 2009 19:01:38 -0800 (PST)
Message-ID: <4B0B4C90.809@sandeen.net>
Date: Mon, 23 Nov 2009 21:01:36 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can convert XFS log version from 1 to 2 ?
References: <5335cda50911231138u45e828afn5c30da531fbb4c09@mail.gmail.com>
In-Reply-To: <5335cda50911231138u45e828afn5c30da531fbb4c09@mail.gmail.com>
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
To: akira matsumoto <ryo.mtmt@gmail.com>
Cc: xfs@oss.sgi.com

akira matsumoto wrote:
> Hi. I'm using XFS on CentOS 5.4 now.
> 
> and I want to convert XFS log version from 1 to 2.(maybe default version is 1 )

xfs_admin -j:

       -j     Enables version 2 log format (journal format supporting larger log buffers).

works since xfsprogs 2.8.0

> XFS have any convert methods ? like "ext3 to XFS"
> 
> or Only could mkfs.xfs command ?

not within xfs; you could look at "convertfs" but dump & restore is probably better/safer.
 
> thanks.

No problem!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
