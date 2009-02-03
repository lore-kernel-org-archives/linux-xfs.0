Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n133nEcS031167 for <xfs@oss.sgi.com>; Mon, 2 Feb 2009 21:49:15 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5821C18AB207
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2009 19:48:34 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id v9sTgqSJFgWjN93i for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2009 19:48:34 -0800 (PST)
Message-ID: <4987B673.8030406@sandeen.net>
Date: Mon, 02 Feb 2009 21:13:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_force_shutdown after Raid crash
References: <498376CF.8020806@renderforce.de>	<20090131105712.GA30061@infradead.org>
	<200902030222.47644@zmi.at>
In-Reply-To: <200902030222.47644@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> On Samstag 31 Januar 2009 Christoph Hellwig wrote:
>> This looks like you were running with a write back cache enabled on
>> the controller / disks but without barriers.
> 
> I've read that this is dangerous. How can I tell if I suffer the same? I 
> use an Areca 1680 SAS RAID Controller with 2GB Cache, so there could be 
> a lot of writes in it.
> 
> mfg zmi

you'd need to read the docs for your controller, to find out how to tell
if it has a writeback cache enabled, and whether it is batter-backed or not.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
