Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4FKIeiH211549 for <xfs@oss.sgi.com>; Tue, 15 May 2012 15:18:41 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id xE1hrXNCS3aeqdRy for <xfs@oss.sgi.com>;
	Tue, 15 May 2012 13:18:39 -0700 (PDT)
Message-ID: <4FB2BA1F.40603@sandeen.net>
Date: Tue, 15 May 2012 15:18:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Test 274 in xfstests
References: <20120515180521.GE26579@quack.suse.cz>
	<4FB29C85.5000603@sandeen.net>
	<20120515201645.GF26579@quack.suse.cz>
In-Reply-To: <20120515201645.GF26579@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: wu.bo@cn.fujitsu.com, xfs@oss.sgi.com

On 5/15/12 3:16 PM, Jan Kara wrote:
> On Tue 15-05-12 13:12:21, Eric Sandeen wrote:
>> On 5/15/12 1:05 PM, Jan Kara wrote:
>>>   Hello,
>>>
>>>   test 274 fails e.g. for ext3 because it does not support fallocate(). So
>>> I would think the best way to fix the is to add to the test
>>>   _require_xfs_io_falloc()
>>> so that the test is run only for filesystems which do support fallocate.
>>> But with that is connected one slightly related question - why does the
>>> test use fallocate(1) binary instead of "xfs_io falloc" command which is
>>> more common in xfstests?
>>>
>>> 								Honza
>>
>> Argh I'm behind.  I had:
>>
>> [PATCH V2] xfstests: several 274 fixups
>>
>> on the list way too long ago.
>>
>> Want to test that out?  It has 1 review on the list, I'll merge it
>> soon - if you want to give it a quick test first, go for it :)
>   Yup, the patch works for me (since I'm mostly interested in ext3 not
> being tested ;). I also reviewed your patch and it looks OK so feel free to
> add:
>   Reviewed-by: Jan Kara <jack@suse.cz>
> 
>   Just one comment. Messages like:
> echo "Fill fs with 1M IOs; EIO expected" >> $seq.full
>   should probably speak of ENOSPC, not EIO, shouldn't they?

Oh, yeah, whoops.  thanks.

-Eric

> 								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
