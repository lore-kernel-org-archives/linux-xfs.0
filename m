Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22EkiMC077887 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 08:46:44 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id p9g60zb8O45dI7MF for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 06:46:42 -0800 (PST)
Received: from smtp.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 97D567AC4
	for <xfs@oss.sgi.com>; Fri,  2 Mar 2012 09:46:41 -0500 (EST)
Received: from b-pb-sasl-quonix.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 8F17A7AC3
	for <xfs@oss.sgi.com>; Fri,  2 Mar 2012 09:46:41 -0500 (EST)
Received: from Brians-MacBook-Air.local (unknown [87.114.42.104]) (using
	TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client
	certificate
	requested) by b-sasl-quonix.pobox.com (Postfix) with ESMTPSA id
	215427AC1 for
	<xfs@oss.sgi.com>; Fri,  2 Mar 2012 09:46:41 -0500 (EST)
Received: from brian by Brians-MacBook-Air.local with local (Exim 4.77)
	(envelope-from <b.candler@pobox.com>) id M09IDU-0009B9-FJ for
	xfs@oss.sgi.com; Fri, 02 Mar 2012 14:46:42 +0000
Resent-Message-ID: <20120302144642.GA12059@nsrc.org>
Resent-To: xfs@oss.sgi.com
Subject: Re: [XFS] xfs_repair time how long it takes??
References: <CABF-5WptGU3vmScFcpHVstd2UZfCAqiY4dGvL=_1+feFvYuS6g@mail.gmail.com>
	<20120302140145.GA11911@nsrc.org>
From: Ryan <ryanlee.lahk@gmail.com>
In-Reply-To: <20120302140145.GA11911@nsrc.org>
Message-Id: <37B5727D-1E3B-4A96-BF7F-4CA6DAF9B63C@gmail.com>
Date: Fri, 2 Mar 2012 23:26:30 +0900
Mime-Version: 1.0 (1.0)
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
To: Brian Candler <B.Candler@pobox.com>


How about the dirty log. I use the xfs_repair because the dirty log must be removed when i mount HDD.

As you know xfs filesystem doen't repair the dirty log so i couldn't mount the HDD after when i do cold reset during writing the HDD. How i can solve this problem? 

Sent from my iPhone.



On Mar 2, 2012, at 11:01 PM, Brian Candler <B.Candler@pobox.com> wrote:

> On Fri, Mar 02, 2012 at 10:09:56PM +0900, Ryan Lee wrote:
>>   The problem is the taking time with xfs_repair like this "]# xfs_repair
>>   -P -L /dev/sda2" is to long to wait in our embedded system and for me,
>>   so the booing time is increasing around 2 minutes totally.
> 
> Why do you feel you need to run xfs_repair on every boot? Regular Linux
> systems do not attempt this, the same as they don't force a full "e2fsck -f"
> on every boot.
> 
> http://linux.die.net/man/8/fsck.xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
