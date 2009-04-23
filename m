Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3N6OYHv256564 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 01:24:34 -0500
Received: from idcmail-mo2no.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 586481CDFA61
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 23:24:31 -0700 (PDT)
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9]) by
	cuda.sgi.com with ESMTP id Avfcr25sNXMWUHji for
	<xfs@oss.sgi.com>; Wed, 22 Apr 2009 23:24:31 -0700 (PDT)
Received: from bender.lan.kevinjamieson.com (bender.lan.kevinjamieson.com
	[192.168.1.110])
	by mail.kevinjamieson.com (Postfix) with ESMTP id EE65820058
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 23:24:29 -0700 (PDT)
Message-ID: <49F0099D.3060004@kevinjamieson.com>
Date: Wed, 22 Apr 2009 23:24:29 -0700
From: Kevin Jamieson <kevin@kevinjamieson.com>
MIME-Version: 1.0
Subject: Re: Oops at xfs_bmbt_get_startoff in SLES 10 2.6.16
References: <64323.24.80.224.145.1236883814.squirrel@squirrel.kevinjamieson.com>	<49B9611F.5040009@sandeen.net>	<58707.24.80.224.145.1236899620.squirrel@squirrel.kevinjamieson.com>
	<53630.24.80.224.145.1240361692.squirrel@squirrel.kevinjamieson.com>
	<49EE7E17.8050006@sandeen.net>
	<B32B0133-B835-4D31-B52A-364F607B9866@sgi.com>
In-Reply-To: <B32B0133-B835-4D31-B52A-364F607B9866@sgi.com>
Reply-To: kevin@kevinjamieson.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Felix Blyakher wrote:

> But I could never reproduce the problem, even with Lachlan's test
> program.

I was not able to reproduce the problem with Lachlan's test program 
either (although I did not experiment much with the parameters).

> Kevin, any idea what kind of io load triggered this problem?

The workload consisted of predominantly (98%) 2-3MB file ingests through 
an NFS share, with a a few (2%) 1GB file ingests, where the issue seemed 
to trigger on the larger files.

Kevin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
