Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5I7sqNm261362
	for <linux-xfs@oss.sgi.com>; Thu, 18 Jun 2009 02:54:52 -0500
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 253451287B78
	for <linux-xfs@oss.sgi.com>; Thu, 18 Jun 2009 00:55:16 -0700 (PDT)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id zNm2O4QjB0njaDwX for
	<linux-xfs@oss.sgi.com>; Thu, 18 Jun 2009 00:55:16 -0700 (PDT)
Message-ID: <4A39F2E6.5020205@news-service.com>
Date: Thu, 18 Jun 2009 09:55:18 +0200
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
References: <4A392213.4020200@news-service.com> <4A3960A0.8090707@sandeen.net>
In-Reply-To: <4A3960A0.8090707@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com, Tommy van Leeuwen <tommy@news-service.com>

Eric Sandeen wrote:
> Patrick Schreurs wrote:
>> Hi all,
>>
>> We are experiencing kernel panics on servers running 2.6.29(.1) and 
>> 2.6.30. I've included two attachments to demonstrate.
>>
>> The error is:
>> Kernel panic - not syncing: xfs_fs_destroy_inode: cannot reclaim ...
>>
>> OS is 64bit Debian lenny.
>>
>> Is this a known issue? Any comments on this?
> 
> It's not known to me, was this a recent upgrade?  (IOW, did it start
> with .29(.1)?

We've seen this on 2 separate servers. It probably happened more often, 
but we didn't captured the panic message. One server was running 
2.6.29.1, the other server was running 2.6.30. Currently we've updated 
all similar servers to 2.6.30.

If we can provide you with more details to help fix this issue, please 
let us know.

-Patrick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
