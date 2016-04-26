Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E282F7CF8
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 17:51:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2B83304032
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 15:51:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id juWbBDOgDJYDMv0d for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2016 15:51:34 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 933619E
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 17:51:34 -0500 (CDT)
Subject: Re: development APIs for used/free blocks information
References: <97A4F433DEE099488FE21C1718A641D2139E86F5@wmsexchsvr01.winmagic.local>
	<20160426222129.GD26977@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <571FF0F6.2030202@sandeen.net>
Date: Tue, 26 Apr 2016 17:51:34 -0500
MIME-Version: 1.0
In-Reply-To: <20160426222129.GD26977@dastard>
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



On 4/26/16 5:21 PM, Dave Chinner wrote:
> On Tue, Apr 26, 2016 at 08:51:10PM +0000, Benjamin Wirth wrote:
>> Hello,
>>
>> I was looking for development APIs for XFS. The contents of
>> xfsprogs-devel seem to only contain a few IOCTL commands, mostly
>> file/inode based operations.
>>
>> I need to query free/used blocks of an entire XFS filesystem and
>> was hoping to find some user-space APIs for this.
> 
> $ man 2 statvfs

I was assuming that he was interested in the actual used/free block
locations, not just the total count.  But maybe I was wrong!

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
