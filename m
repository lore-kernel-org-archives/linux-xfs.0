Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1CAA7F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 15:05:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B4BCF8F8039
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 13:05:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VHGXgd9sbwXHTXe9 for
	<xfs@oss.sgi.com>; Thu, 30 May 2013 13:05:05 -0700 (PDT)
Message-ID: <51A7B0EE.1010300@redhat.com>
Date: Thu, 30 May 2013 15:05:02 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] 285: Test offsets over 4GB
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
	<1369917939-22660-3-git-send-email-jack@suse.cz>
	<51A758A8.80502@redhat.com> <20130530200118.GC586@quack.suse.cz>
In-Reply-To: <20130530200118.GC586@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 5/30/13 3:01 PM, Jan Kara wrote:
> On Thu 30-05-13 08:48:24, Eric Sandeen wrote:
>> On 5/30/13 7:45 AM, Jan Kara wrote:
>>> Test whether SEEK_HOLE and SEEK_DATA works correctly with offsets over
>>> 4GB.
>>
>>
>> Hm, should we add 2T as well while we're at it?
>>
>> (and does this cause any new failures?)
>   Yes, ext4 is broken. I've sent fixes for it yesterday. I'm not sure what

Argh, sorry I forgot that.  I just want to be careful about more rigorous
tests making it look like we have regressions in the code.

> exactly would overflow at 2T ... block counts if signed int is used and
> blocksize is 1KB?

Hum ok, where'd I come up with 2T?  :)  never mind that maybe, unless
there are other potential trouble points we should add (8T? 16T for
filesystems that can handle it?)

-Eric

> 								Honza
> 
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>> ---
>>>  src/seek_sanity_test.c | 38 ++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 38 insertions(+)
>>>
>>> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
>>> index 7d5868b..55e7ed6 100644
>>> --- a/src/seek_sanity_test.c
>>> +++ b/src/seek_sanity_test.c
>>> @@ -18,6 +18,7 @@
>>>   */
>>>  
>>>  #define _XOPEN_SOURCE 500
>>> +#define _FILE_OFFSET_BITS 64
>>>  #include <sys/types.h>
>>>  #include <sys/stat.h>
>>>  #include <sys/vfs.h>
>>> @@ -191,6 +192,42 @@ static int do_lseek(int testnum, int subtest, int fd, int filsz, int origin,
>>>  	return ret;
>>>  }
>>>  
>>> +/* test a huge file to check for 4G overflows */
>>> +static int test10(int fd, int testnum)
>>> +{
>>> +	char *buf = NULL;
>>> +	int bufsz = alloc_size;
>>> +	off_t filsz = 8ULL << 30;	/* 8G */
>>> +	off_t off = filsz - 2*bufsz;
>>> +	int ret = -1;
>>> +
>>> +	buf = do_malloc(bufsz);
>>> +	if (!buf)
>>> +		goto out;
>>> +	memset(buf, 'a', bufsz);
>>> +
>>> +	ret = do_pwrite(fd, buf, bufsz, 0);
>>> +	if (ret)
>>> +		goto out;
>>> +	ret = do_pwrite(fd, buf, bufsz, off);
>>> +	if (ret)
>>> +		goto out;
>>> +
>>> +	/* offset at the beginning */
>>> +	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, bufsz);
>>> +	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, bufsz);
>>> +	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, 0);
>>> +	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, 1);
>>> +
>>> +	/* offset around eof */
>>> +	ret += do_lseek(testnum,  5, fd, filsz, SEEK_HOLE, off, off + bufsz);
>>> +	ret += do_lseek(testnum,  6, fd, filsz, SEEK_DATA, off, off);
>>> +	ret += do_lseek(testnum,  7, fd, filsz, SEEK_DATA, off + 1, off + 1);
>>> +
>>> +out:
>>> +	do_free(buf);
>>> +	return ret;
>>> +}
>>>  /*
>>>   * test file with unwritten extents, have both dirty and
>>>   * writeback pages in page cache.
>>> @@ -577,6 +614,7 @@ struct testrec seek_tests[] = {
>>>         {  7, test07, "Test file with unwritten extents, only have dirty pages" },
>>>         {  8, test08, "Test file with unwritten extents, only have unwritten pages" },
>>>         {  9, test09, "Test file with unwritten extents, have both dirty && unwritten pages" },
>>> +       { 10, test10, "Test a huge file" },
>>>  };
>>>  
>>>  static int run_test(struct testrec *tr)
>>>
>>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
