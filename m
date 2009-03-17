Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2H2IS0f128566 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 21:18:49 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E60081C49EFB
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 19:17:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id qLziALAqDSObAayT for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2009 19:17:46 -0700 (PDT)
Message-ID: <49BF0848.1050909@sandeen.net>
Date: Mon, 16 Mar 2009 21:17:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Multiple Mounting of one XFS Partition
References: <49BE5CC9.9000605@renderforce.de>
In-Reply-To: <49BE5CC9.9000605@renderforce.de>
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
To: steffen.knauf@renderforce.de
Cc: xfs@oss.sgi.com

Steffen Knauf wrote:
> Hello,
> 
> i have 2 Servers which are connected with a raid via FibreChannel.
> Both of them have mounted the same XFS-Partition. But if i change a 
> Filepermission
> or add some Files at the Partition of server1, the partition of server2 
> don't show the modifications
> until i remount the Partitions. I don't know how whether it is a cache 
> Option or something else.
> Perhaps someone have an idea.
> Thanks!
> 
> greets

You can't do this.  It will corrupt your filesystem; there is *nothing*
which will give you coherency between the nodes.

This is what SGI sells CXFS for (for big $$$)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
