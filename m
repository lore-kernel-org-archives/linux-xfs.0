Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D6A07F37
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 16:44:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2EBE9304081
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 14:44:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id NloTTzVRdUhMSAix for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 14:44:24 -0700 (PDT)
Message-ID: <51B102B7.5070204@sandeen.net>
Date: Thu, 06 Jun 2013 16:44:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/1] xfs: xfs_inactive fails to cleanup symlinks with
	attributes
References: <20130606161032.753011157@sgi.com> <51B0E03B.3010303@sgi.com>
	<20130606211307.GB29338@dastard> <51B0FF1D.60402@sgi.com>
In-Reply-To: <51B0FF1D.60402@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 6/6/13 4:29 PM, Mark Tinguely wrote:
> On 06/06/13 16:13, Dave Chinner wrote:
>> On Thu, Jun 06, 2013 at 02:17:15PM -0500, Mark Tinguely wrote:
>>> On 06/06/13 11:10, Mark Tinguely wrote:
>>>> Found this bug testing extended attributes.
>>>>
>>>> # make a big symbolic link that is in the inode core and mostly fills it.
>>>> # CRC enabled filesystem will use a 68 byte smaller link in the test.
>>>>
>>>> ln -s 1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/0123456/a a
>>>>
>>>> # the extended attribute will bump the symbolic link to a remote extent
>>>> # I think only one of these attribute is needed, but they are so fun...
>>>> attr  -Rs 1234567890ad a<   /dev/null
>>>> attr  -Rs 1234567890ae a<   /dev/null
>>>> attr  -Rs 1234567890af a<   /dev/null
>>>>
>>>
>>> oops. the following steps are also needed - I took them out because I
>>> thought they were unecessary:
>>>
>>> # remove the attributes:
>>> attr  -Rr 1234567890ad a
>>> attr  -Rr 1234567890ae a
>>> attr  -Rr 1234567890af a
>>>
>>> now we will assert
>>
>> I cannot reproduce this on a current TOT kernel with or without
>> CRCs:
>>
>> # mkfs.xfs -f /dev/vdb
>> meta-data=/dev/vdb               isize=256    agcount=4, agsize=720896 blks
>>           =                       sectsz=512   attr=2, projid32bit=1
>>           =                       crc=0
>> data     =                       bsize=4096   blocks=2883584, imaxpct=25
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal log           bsize=4096   blocks=2560, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> # mount /dev/vdb /mnt/scratch/
>> # cd /mnt/scratch/
>> # ln -s 1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/0123456/a a
>> # attr  -Rs 1234567890ad a<   /dev/null
>> Attribute "1234567890ad" set to a 0 byte value for a:
>>
>> # attr  -Rs 1234567890ae a<   /dev/null
>> Attribute "1234567890ae" set to a 0 byte value for a:
>>
>> # attr  -Rs 1234567890af a<   /dev/null
>> Attribute "1234567890af" set to a 0 byte value for a:
>>
>> # attr  -Rr 1234567890ad a
>> # attr  -Rr 1234567890ae a
>> # attr  -Rr 1234567890af a
>> # sync
>> # cd ~
>> # umount /mnt/scratch
>> #
>>
>> No assert. Can you write an xfstest that reproduces the problem and
>> post the patch?
>>
>> Cheers,
>>
>> Dave.
> 
> Yes, these instructions are for a *256* byte inode with top of tree code.
> 
> A 512 byte inode will need a bigger link. The link must nearly fill the literal area. Patch has been supplied:
> 
>   http://oss.sgi.com/archives/xfs/2013-06/msg00110.html

I think he meant a patch for xfstests ;)

-Eric

> --Mark.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
