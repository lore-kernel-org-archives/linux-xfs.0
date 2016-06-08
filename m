Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 468917CA0
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 07:32:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7963AC004
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 05:32:06 -0700 (PDT)
Received: from mk-outboundfilter-5-a-2.mail.uk.tiscali.com
	(mk-outboundfilter-5-a-2.mail.uk.tiscali.com [212.74.114.4]) by
	cuda.sgi.com with ESMTP id 4SR4JMt0QzGzOtGe for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2016 05:32:03 -0700 (PDT)
Subject: Re: invalid inode numbers ? after drive moved from Linux 2.6.32 to
	Linux 3.16.0 then back again
References: <5757FE7A.8020504@codefaber.co.uk>
	<20160608114907.GC8987@redhat.com>
From: Nigel Tamplin <ntamplin@codefaber.co.uk>
Message-ID: <5758103A.9090103@codefaber.co.uk>
Date: Wed, 8 Jun 2016 13:31:54 +0100
MIME-Version: 1.0
In-Reply-To: <20160608114907.GC8987@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 08/06/16 12:49, Carlos Maiolino wrote:
> On Wed, Jun 08, 2016 at 12:16:10PM +0100, Nigel Tamplin wrote:
>> Hello,
>>
>> I have a drive with a partition containing an XFS file system.
>> This drive normally resides in a Linux 2.6.32 (Debian 6) server, which is
>> also where the file system was created many months ago.
>> Last week I removed this drive from it's usual 2.6.32 server and for a few
>> hours it was attached to an alternative Linux 3.16.0 (Debian 8) server,
>> where the XFS file system was mounted and during this time I created
>> /modified / deleted some files.
>> Later the drive was moved back to the normal Linux 2.6.32.
>>
>
> Linux 3.16 has inode64 mount option enabled by default, which will cause inodes
> to be spread along the whole disk, causing some inodes (those allocated on disk
> blocks beyond 1TB offset) to have 64bit numbers.
>
> 2.6.32 doesn't use inode64 option by default, and so, files with inodes > 2^32
> will not be accessible by the kernel 2.6.32, but, you can use `mount -o inode64`
> mount option in the old system and then be able to access these inodes again.
>

Excellent explanation Carlos.
This exactly explains what had happened, the partition being moved 
between systems is 2TB in size.
As you suggested, remounting on the older systems with option inode64 
resolved it.

Thank you.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
