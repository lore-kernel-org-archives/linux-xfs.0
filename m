Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q91EbTFi133827 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 09:37:29 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id TABGwYkTkxCHrYbE for <xfs@oss.sgi.com>;
	Mon, 01 Oct 2012 07:38:52 -0700 (PDT)
Message-ID: <5069AB05.3090901@sandeen.net>
Date: Mon, 01 Oct 2012 09:39:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: creating a new 80 TB XFS
References: <4F478818.4050803@cape-horn-eng.com> <4F47AA24.8010209@sandeen.net>
	<5069A8A1.4080404@cape-horn-eng.com>
In-Reply-To: <5069A8A1.4080404@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On 10/1/12 9:28 AM, Richard Ems wrote:
> On 02/24/2012 04:17 PM, Eric Sandeen wrote:
>>> *MKFS*
>>>> We also heavily use ACLs for almost all of our files. Christoph Hellwig
>>>> suggested in a previous mail to use "-i size=512" on XFS creation, so my
>>>> mkfs.xfs would look something like:
>>>>
>>>> mkfs.xfs -i size=512 -d su=stripe_size,sw=28 -L Backup_2 /dev/sdX1
>> Be sure the stripe geometry matches the way the raid controller is
>> set up.
>>
>> You know the size of your acls, so you can probably do some testing
>> to find out how well 512-byte inodes keep ACLs in-line.
> 
> 
> Hi Eric,
> 
> This is a reply to an email from you sent 7 months ago ...
> 
> How could I do the testing you were proposing? How can I find out if my
> 512-byte inodes keep our ACLs in-line?
> 
> I am going to create a similar new RAID set, and wanted to check this
> before on the one already in production.

you can use the xfs_bmap tool to map the attribute fork by using the "-a" option.

If it lists any block numbers, then it's outside the inode.

If you have varying sizes of acls, you'd just iterate over the fs to see what you've got.

-Eric

> Thanks,
> Richard
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
