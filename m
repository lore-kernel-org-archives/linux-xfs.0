Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5EIg2uf116672 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 13:42:03 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74A551EDAD4A
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 11:42:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5gXqy4G9LmZUhwp4 for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2011 11:42:01 -0700 (PDT)
Message-ID: <4DF7AB76.8030701@redhat.com>
Date: Tue, 14 Jun 2011 14:41:58 -0400
From: Josef Bacik <josef@redhat.com>
MIME-Version: 1.0
Subject: Re: xfstests 252 failure
References: <4DF78127.40505@linux.vnet.ibm.com> <4DF78716.4040605@redhat.com>
In-Reply-To: <4DF78716.4040605@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, Allison Henderson <achender@linux.vnet.ibm.com>

On 06/14/2011 12:06 PM, Eric Sandeen wrote:
> On 6/14/11 10:41 AM, Allison Henderson wrote:
>> Hi all,
>>
>> I just wanted to get some ideas moving on this question before too
>> much time goes by. Ext4 is currently failing xfstest 252, test number
>> 12. Currently test 12 is:
>>
>>     $XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
>>         -c "$alloc_cmd 0 20k" \   
>>         -c "pwrite 8k 4k" -c "fsync" \       
>>         -c "$zero_cmd 4k 12k" \
>>         -c "$map_cmd -v" $testfile | $filter_cmd
>>     [ $? -ne 0 ]&&  die_now
> 
> so the file should go through these steps:
> (H=hole, P=prealloc, D=data)
> 
> 0k                       20k
> |  H |  H |  H |  H |  H | (truncate)
> |  P |  P |  P |  P |  P | (alloc_cmd)
> |  P |  P |  D |  P |  P | (pwrite)
> <fsync>                    (fsync)
> |  P |  H |  H |  H |  P | (punch)
>  
>> and the output is:
>>
>>         12. unwritten -> data -> unwritten
>> 0: [0..7]: unwritten
>> 1: [8..31]: hole
>> 2: [32..39]: unwritten
>>
>> Ext4 gets data extents here instead of unwritten extents. 
> 
> so it's like this?
> 
> 0: [0..7]: data
> 1: [8..31]: hole
> 2: [32..39]: data
> 
>> I did some
>> investigating and it looks like the fsync command causes the extents
>> to be written out before the punch hole operation starts. It looks
>> like what happens is that when an unwritten extent gets written to,
>> it doesnt always split the extent. If the extent is small enough,
>> then it just zeros out the portions that are not written to, and the
>> whole extent becomes a written extent. Im not sure if that is
>> incorrect or if we need to change the test to not compare the extent
>> types.
> 
> Yes, it does do that IIRC.
> 
> I probably need to look closer, but any test which expects exact
> layouts from a filesystem after a series of operations is probably
> expecting too much...
> 
> From a data integrity perspective, written zeros is as good as a hole is
> as good as preallocated space, so I suppose those should all be acceptable,
> though I guess "punch" should result in holes exactly as requested.
> 
>> It looks to me that the code in ext4 that does this is supposed to be
>> an optimization to help reduce fragmentation. We could change the
>> filters to print just "extent" instead of "unwritten" or "data", but
>> I realize that probably makes the test a lot less effective for xfs.
>> If anyone can think of some more elegant fixes, please let me know.
>> Thx!
> 
> Josef, what do you think?  It's your test originally.  :)
> 

Yes, a test that was really only meant to test the block based fiemap
since they all act in a dumb and easy to verify way.  I think if we want
to keep this test we should probably have it just recognize these little
optimizations so it doesn't freak out.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
