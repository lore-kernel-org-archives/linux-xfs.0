Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E17027F50
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2015 19:13:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6D673AC001
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2015 17:13:08 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PSlSOjKMyfCKX3QI for <xfs@oss.sgi.com>;
	Sun, 12 Jul 2015 17:13:05 -0700 (PDT)
Date: Mon, 13 Jul 2015 10:13:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issue with RHEL6 mkfs.xfs (3.1.1+), HP P420 RAID, and MySQL
	replication
Message-ID: <20150713001303.GH7943@dastard>
References: <110866563.1804043.1436463170539.JavaMail.yahoo@mail.yahoo.com>
	<20150709230222.GD7943@dastard>
	<1741803883.2585541.1436543988567.JavaMail.yahoo@mail.yahoo.com>
	<20150710224231.GL3902@dastard>
	<1598282205.117137.1436570104177.JavaMail.yahoo@mail.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1598282205.117137.1436570104177.JavaMail.yahoo@mail.yahoo.com>
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
To: Hogan Whittall <whittalh@yahoo-inc.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jul 10, 2015 at 11:15:04PM +0000, Hogan Whittall wrote:
> As for the noalign option, that would be great to have but it does
> not exist in version 3.1.1 which RHEL6 uses.  It sounds like not

$ gl -n 1 63a6384
commit 63a63844f8a02f34cbb724086a1f0bac492f25b3
Author: Nathan Scott <nathans@sgi.com>
Date:   Wed Mar 23 02:56:17 2005 +0000

    Add noalign suboptions to -d and -r to allow auto-stripe-alignment to be switched off.
    Merge of master-melb:xfs-cmds:21924a by kenmcd.
$

The noalign option has been in mkfs since 2005, so it's most
certainly supported on RHEL6.

Looking at the man page history, I forgot that it wasn't documented
until 2013 and hence is missing from the RHEL6 man page, so I can
understand why you might be saying this.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
