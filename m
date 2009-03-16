Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GEpTuo097399 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 09:51:49 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ECD3630408B
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 07:51:08 -0700 (PDT)
Message-Id: <97425114-90E3-4421-9737-FD6ABF1860AE@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <49BE5CC9.9000605@renderforce.de>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: Multiple Mounting of one XFS Partition
Date: Mon, 16 Mar 2009 09:38:21 -0500
References: <49BE5CC9.9000605@renderforce.de>
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
To: steffen.knauf@renderforce.de
Cc: xfs@oss.sgi.com

On Mar 16, 2009, at 9:06 AM, Steffen Knauf wrote:

> Hello,
>
> i have 2 Servers which are connected with a raid via FibreChannel.

Unless you have some sort of cluster filesystem, it's not going
to work.

>
> Both of them have mounted the same XFS-Partition. But if i change a  
> Filepermission
> or add some Files at the Partition of server1, the partition of  
> server2 don't show the modifications
> until i remount the Partitions.

The changes done by server1 won't be flushed to disk, where they
could be seen by server2, till much later, or on unmount.

> I don't know how whether it is a cache Option or something else.

That's how any modern filesystem work.

Cheers,
Felix

>
> Perhaps someone have an idea.
> Thanks!
>
> greets
>
> Steffen
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
