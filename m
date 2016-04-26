Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 936AE7CFB
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 16:33:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 59226304032
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 14:33:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 44gI5AHRLm7l3SxC for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2016 14:33:38 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0DA839E
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 16:33:38 -0500 (CDT)
Subject: Re: development APIs for used/free blocks information
References: <97A4F433DEE099488FE21C1718A641D2139E86F5@wmsexchsvr01.winmagic.local>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <571FDEB1.90701@sandeen.net>
Date: Tue, 26 Apr 2016 16:33:37 -0500
MIME-Version: 1.0
In-Reply-To: <97A4F433DEE099488FE21C1718A641D2139E86F5@wmsexchsvr01.winmagic.local>
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
To: xfs@oss.sgi.com

On 4/26/16 3:51 PM, Benjamin Wirth wrote:
> Hello,
> 
> I was looking for development APIs for XFS. The contents of
> xfsprogs-devel seem to only contain a few IOCTL commands, mostly
> file/inode based operations.
> 
> I need to query free/used blocks of an entire XFS filesystem and was
> hoping to find some user-space APIs for this. I have done the same
> task for EXT filesystem which seemed fairly easy as it provided
> simple open/query/close APIs. I know that XFS is a bit different as
> it manages free extents in two B+ trees per AG, but is this free/used
> block/extent information externalized somehow for developers to use?
> Am I not looking in the right place or these functionalities are
> simply not provided to application developers?
> 
> Any help/pointers would be greatly appreciated.

It's not exported for application developers, no; it's not
generally something applications need, AFAIK.

You could look at how the freesp_f function works in xfs_db, I suppose.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
