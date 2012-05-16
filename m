Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4G2UqX0243323 for <xfs@oss.sgi.com>; Tue, 15 May 2012 21:30:52 -0500
Received: from boosthardware.localdomain (boosthardware.com [88.198.122.139])
	by cuda.sgi.com with ESMTP id uNF21AI6CXCI42Cs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 May 2012 19:30:51 -0700 (PDT)
Message-ID: <56000.110.174.53.110.1337135447.squirrel@boosthardware.com>
In-Reply-To: <20120515151331.GG16099@sgi.com>
References: <51509.110.174.53.110.1336699622.squirrel@boosthardware.com>
	<20120511165012.GC16099@sgi.com>
	<59946.110.174.53.110.1336959906.squirrel@boosthardware.com>
	<20120514142948.GS3963@sgi.com>
	<64776.110.174.53.110.1337043522.squirrel@boosthardware.com>
	<20120515151331.GG16099@sgi.com>
Date: Wed, 16 May 2012 04:30:47 +0200 (CEST)
Subject: Re: file corruption issue
From: "Patrick Shirkey" <pshirkey@boosthardware.com>
MIME-Version: 1.0
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com


On Tue, May 15, 2012 5:13 pm, Ben Myers wrote:
>
> On Tue, May 15, 2012 at 02:58:42AM +0200, Patrick Shirkey wrote:
>> Unfortunately I cannot unmount the partition/s to run xfs_metadump
>> because
>> they are in use.
>>
>> I have found some files that were truncated on a recent crash. Is there
>> any tool I can run on those files to get info that might be useful?
>
> Hrm.. xfs_bmap output could be helpful so we can see the block map.  Do
> you
> know how big they are supposed to be?  How much was truncated?
>

The files that we have as examples were originally 28bytes but are now 0byte.

Running xfs_bmap on the 0 byte file returns "no extent".

ex.

These files are located next to each other in the same folder.

- 28 byte file:
 EXT: FILE-OFFSET      BLOCK-RANGE              AG AG-OFFSET             
TOTAL
   0: [0..7]:          28230136440..28230136447 13 (312849120..312849127) 
   8

- 0 byte file: no extents


> Unfortunately since you don't know which database will have the
> corruption...
> you'll need to get xfs_bmap output for all of them, and then after a crash
> get
> the 'after'.  Is that a possibility?
>

I'll try to get some more data.

- Separately I was able to run xfs_metadump against one of our partitions.
The resulting file is 1.4 GB and it also has some potentially sensitive
information in it so I am not sure about posting it to a public location.
Is there anything that I can look for that might be useful.

I have some data from xfs_bmap on specific files located in the same
partition as the metadump was generated from. I'm not sure if that will
actually give us any details that can help though as this data is all post
crash atm.

- A few more details that may be relevant.

1: We are running openvz and LVM on these machines. Are there any known
issue/s with file corruption after a hard reset with openvz/LVM running?

2: We have observed that while there is no obvious pattern in the data
corruption is does happen in chunks. It appears to be random chunks of
files that are corrupted after a crash->reset sequence.





--
Patrick Shirkey
Boost Hardware Ltd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
