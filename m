Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7HHd54S087009
	for <linux-xfs@oss.sgi.com>; Wed, 17 Aug 2011 12:39:05 -0500
Received: from mailgw1.uni-kl.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DEFD91521127
	for <linux-xfs@oss.sgi.com>; Wed, 17 Aug 2011 10:41:12 -0700 (PDT)
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id vK2mMfAEUNN63hsh for
	<linux-xfs@oss.sgi.com>; Wed, 17 Aug 2011 10:41:12 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id
	p7HHd2N4012854
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Wed, 17 Aug 2011 19:39:02 +0200
Message-ID: <4E4BFCB5.4010808@itwm.fraunhofer.de>
Date: Wed, 17 Aug 2011 19:39:01 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: Deleting files with extended attributes is dead slow
References: <j23qs9$1c3$1@dough.gmane.org>
	<20110812204746.GB30615@infradead.org>
	<20110816161357.GA18201@infradead.org>
	<4E4BBC98.7020501@itwm.fraunhofer.de>
	<20110817170251.GB28650@infradead.org>
In-Reply-To: <20110817170251.GB28650@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-xfs@oss.sgi.com

On 08/17/2011 07:02 PM, Christoph Hellwig wrote:
> On Wed, Aug 17, 2011 at 03:05:28PM +0200, Bernd Schubert wrote:
>>> (squeeze-x86_64)fslab2:~# xfs_bmap -a /mnt/xfs/Bonnie.29243/00000/00000027faJxifNb0n
>>> /mnt/xfs/Bonnie.29243/00000/00000027faJxifNb0n:
>>>         0: [0..7]: 92304..92311
>>
>> (Sorry, I have no idea what "0: [0..7]: 92304..9231" is supposed to
>> tell me).
>
> It means that you are having an extent spanning 8 blocks for xattr
> storage, that map to physical blocks 92304 to 9231 in the filesystem.
>
> It sounds to me like your workload has a lot more than 256 bytes of
> xattrs, or the underlying code is doing something rather stupid.

Well, the workload I described here is a controlled bonnie test, so 
there cannot be more than 256 bytes (unless there is a bug in the code, 
will double check later on).

>
>> Looking at 'top' and 'iostat -x' outout, I noticed we are actually
>> not limited by io to disk, but CPU bound. If you should be
>> interested, I have attached 'perf record -g' and 'perf report -g'
>> outout, of the bonnie file create (create + fsetfattr() ) phase.
>
> It's mostly spending a lot of time on copying things into the CIL
> buffers, which is expected and intentional as that allows for additional
> parallelity.  I you'd switch the workload to multiple intances doing
> the create in parallel you should be able to scale to better numbers.

I just tried to bonnies in parallel and that didn't improve anything. 
FhGFS code has several threads anyway. But it would be good, if the 
underlying file system wouldn't take all the CPU time...

>
>>>      100:256:256/10 37026  91 +++++ +++ 43691  93 35960  92 +++++ +++ 40708  92
>>> Latency              4328us     765us    2960us     527us     440us    1075us
>>> 1.96,1.96,fslab2,1,1313594619,,,,,,,,,,,,,,100,256,256,,10,37026,91,+++++,+++,43691,93,35960,92,+++++,+++,40708,92,,,,,,,4328us,765us,2960us,527us,440us,1075us
>>
>>
>> xfs:
>> mkfs.xfs -f -i size=512 -i maxpct=90  -l lazy-count=1 -n size=64k /dev/sdd
>
> Do 64k dir blocks actually help you with the workload?  They also tend

Also just tested, with or without doesn't improve anything.

> to do a lot of useless memcpys in their current form, although these
> didn't show up on your profile.  Did you try using a larger inode size
> as suggested in my previous mail?

I just tried and now that I understand the xfs_bmap output, it is 
interesting to see, that an xattr size up to 128 byte does not need an 
extent + blocks, but 256 byte do have one extent and 8 blocks even with 
an inode size of 2K. xfs_info tells me that isize=2048 was accepted. I 
didn't test any sizes in between 128 and 256 byte yet.
Now while I can set the data/xattr size for the bonnie test to less than 
256 byte, that is not so easy with our real target FhGFS ;)


Btw, the create() + fsetfattr() reate with 128B xattr data is between 
13000 and 17000, so due to inlining much better than with 256 xattr.


Thanks,
Bernd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
