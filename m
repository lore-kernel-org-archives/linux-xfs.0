Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C849E7CA0
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 10:49:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B817304032
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 08:49:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kMKF5L7FgnVW1XNp for <xfs@oss.sgi.com>;
	Mon, 13 Jun 2016 08:49:03 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 74890B55
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 10:49:03 -0500 (CDT)
Subject: Re: Metadata corruption
References: <7494383b-a153-7a79-b872-42ac6506ac9e@gmail.com>
	<20160613112738.GA4730@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <eac741bb-72d4-8f73-1d7d-2db456768fe9@sandeen.net>
Date: Mon, 13 Jun 2016 10:49:02 -0500
MIME-Version: 1.0
In-Reply-To: <20160613112738.GA4730@bfoster.bfoster>
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



On 6/13/16 6:27 AM, Brian Foster wrote:
> On Mon, Jun 13, 2016 at 09:27:57AM +0300, Martin Aleksov wrote:
>> HiThere,
>>
>> I'm using XFS on Arch linux.Each 2 days I'm receiving this error:
>>
>>
>> Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
>>
>> while doing this:
>>
>>
>> [martin@marto ~]$ sudo xfs_db -c frag -r /dev/sda2
> 
> sda2 is your root filesystem.. so I assume the filesystem is mounted
> when you run this? If so, this type of thing could be expected. Do you
> see errors in the logs otherwise? If not, I'd suggest to repeat this
> from a ramdisk or boot/recovery disk where the filesystem isn't mounted
> to confirm.

That's probably it.  In addition, I would suggest not
running the frag command, as it is largely useless:

http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
