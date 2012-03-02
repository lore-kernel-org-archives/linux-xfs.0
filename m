Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22E1jSL066521 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 08:01:45 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id anpwBVibZs6IwDQk for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 06:01:44 -0800 (PST)
Date: Fri, 2 Mar 2012 14:01:45 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: [XFS] xfs_repair time how long it takes??
Message-ID: <20120302140145.GA11911@nsrc.org>
References: <CABF-5WptGU3vmScFcpHVstd2UZfCAqiY4dGvL=_1+feFvYuS6g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABF-5WptGU3vmScFcpHVstd2UZfCAqiY4dGvL=_1+feFvYuS6g@mail.gmail.com>
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
To: Ryan Lee <ryanlee.lahk@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 02, 2012 at 10:09:56PM +0900, Ryan Lee wrote:
>    The problem is the taking time with xfs_repair like this "]# xfs_repair
>    -P -L /dev/sda2" is to long to wait in our embedded system and for me,
>    so the booing time is increasing around 2 minutes totally.

Why do you feel you need to run xfs_repair on every boot? Regular Linux
systems do not attempt this, the same as they don't force a full "e2fsck -f"
on every boot.

http://linux.die.net/man/8/fsck.xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
