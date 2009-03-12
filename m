Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CDBmDM077403 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 08:12:09 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 156FE18F2EF
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 06:11:04 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id X9MHCdyi7pfw6dEc for <xfs@oss.sgi.com>;
	Thu, 12 Mar 2009 06:11:04 -0700 (PDT)
Message-ID: <49B909CC.7080402@sandeen.net>
Date: Thu, 12 Mar 2009 08:10:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: LWN article: 4K disk sectors
References: <200903121258.51497@zmi.at>
In-Reply-To: <200903121258.51497@zmi.at>
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
> http://lwn.net/SubscriberLink/322777/16380cde8af0a37e/
> 
> 4K disk sectors coming 2011, might be interesting for devs to prepare 
> supporting it.

Take a look at the mkfs.xfs man page:

       -s sector_size
              This option specifies the fundamental  sector  size  of
              the filesystem.  The sector_size is specified either as
              a value in bytes with size=value or as a base two loga-
              rithm value with log=value.  The default sector_size is
              512 bytes. The minimum value for sector  size  is  512;
              the  maximum is 32768 (32 KiB). The sector_size must be
              a power of 2 size and cannot be made  larger  than  the
              filesystem block size.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
