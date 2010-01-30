Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UG7x9R220564 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 10:07:59 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23C1C19DEBE
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 08:09:05 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id pa85dGa3YcTmNWJB for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 08:09:05 -0800 (PST)
Message-ID: <4B6459A1.4060900@sandeen.net>
Date: Sat, 30 Jan 2010 10:09:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: make 053 and 077 generic
References: <4B621E11.4050609@sandeen.net>
	<20100130102639.GC32695@infradead.org>
In-Reply-To: <20100130102639.GC32695@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Jan 28, 2010 at 05:30:25PM -0600, Eric Sandeen wrote:
>> 053 and 077 can be generic w/ a little tweaking.
>>
>> Also change 077's filler to something more likely
>> to be on a random system under test, and add it
>> to the enospc group.
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>> ---
>>
>> diff --git a/053 b/053
>> index 98644a7..5542885 100755
>> --- a/053
>> +++ b/053
>> @@ -38,18 +38,19 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>>  . ./common.attr
>>  
>>  # real QA test starts here
>> -_supported_fs xfs
>> +_supported_fs generic
>>  _supported_os Linux
>>  
>>  [ ! -x /bin/chacl -a ! -x /usr/bin/chacl ] && _notrun "chacl command not found"
>>  
>>  _require_scratch
>> +_acl_requirements
> 
> _acl_requirements includes the chacl check, so it can be removed.

oh good point :)
 
> Btw, any reason _acl_requirements isn't called _require_acl?

It already existed, I just used it ... renaming is probably a good idea.

>> diff --git a/077 b/077
>> index cdee8da..d23305f 100755
>> --- a/077
>> +++ b/077
>> @@ -31,7 +31,8 @@ here=`pwd`
>>  tmp=/tmp/$$
>>  status=1
>>  #filler=$here/../../linux
>> -filler=/home/fsgqa/isms/2.4.x-xfs
>> +#filler=/home/fsgqa/isms/2.4.x-xfs
>> +filler=/lib/modules/`uname -r`/
> 
> Oooops.  Maybe just use /lib/modules/ to get as much as possible.
> And no need to let the other bits comment out there.  Maybe we need
> to generate the data instead to really be safe - at least for my
> tests under qemu I don't have any modules installed.  But that should
> be left for another patch.

hm, on the other hand some of my machines have so many kernels installed,
picking up all of /lib/modules might slow it down a lot.

So generating might be better, yeah.

> Anyway, patch looks good enough to go in for now, so

thanks, I'll pull the chacl test & the commented lines before that.

-Eric
 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
