Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9GFPlQF110598 for <xfs@oss.sgi.com>; Fri, 16 Oct 2009 10:25:47 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C0E11798408
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2009 08:27:17 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 1T5zbdOBNGTXrKhw for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2009 08:27:17 -0700 (PDT)
Message-ID: <4AD890D1.4010208@sandeen.net>
Date: Fri, 16 Oct 2009 10:27:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS mount failuer on RAID5
References: <389deec70910152009i7656aaf2s9d929b8b68e4e740@mail.gmail.com>
	<200910161019.10286@zmi.at>
In-Reply-To: <200910161019.10286@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> On Freitag 16 Oktober 2009 hank peng wrote:
>> I don't know when "-ssize=4k" option is added, what is difference?
> 
> You can set the *sector* size to 4k only when your drives have 4k sector 
> size. Normal disks so far always have 512 Bytes/sector.
> 
> mfg zmi

Actually -ssize=4k is just fine even on 512 sector disks.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
