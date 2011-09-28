Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8S6uAhQ093158 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 01:56:11 -0500
Received: from mta21.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDEC9160F0A4
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 00:02:11 -0700 (PDT)
Received: from mta21.charter.net (mta21.charter.net [216.33.127.81]) by
	cuda.sgi.com with ESMTP id gxlZjfaUAsN9h04R for
	<xfs@oss.sgi.com>; Wed, 28 Sep 2011 00:02:11 -0700 (PDT)
Received: from imp11 ([10.20.200.11]) by mta21.charter.net
	(InterMail vM.7.09.02.04 201-2219-117-106-20090629) with ESMTP
	id <20110928065609.UUYZ3880.mta21.charter.net@imp11>
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 02:56:09 -0400
Received: from [IPv6:2002:6027:d601:1:21f:c6ff:fed7:f9d5] (unknown
	[IPv6:2002:6027:d601:1:21f:c6ff:fed7:f9d5])
	by cchtml.com (Postfix) with ESMTPSA id B5ACCC0287BED
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 01:56:07 -0500 (CDT)
Message-ID: <4E82C4FC.9040806@cchtml.com>
Date: Wed, 28 Sep 2011 01:55:56 -0500
From: Michael Cronenworth <mike@cchtml.com>
MIME-Version: 1.0
Subject: Re: 64-bit inodes and back again
References: <4E825C25.6050804@cchtml.com> <4E8278D8.9060309@cchtml.com>
	<4E828BE1.8030003@cchtml.com> <201109280748.33889@zmi.at>
In-Reply-To: <201109280748.33889@zmi.at>
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

On 09/28/2011 12:48 AM, Michael Monnerie wrote:
> I guess you'd need to mount with inode64 enabled so you can access the
> files, and after the tool finished to back to 32bit inodes.

No. The xfs_reno manpage specifically says to *not* mount with 64-bit 
inodes enabled. It uses the kernel to generate a new inode.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
