Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0ULMvQf135418 for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 15:22:57 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id s1zpeGIJznMstPEw for <xfs@oss.sgi.com>;
	Mon, 30 Jan 2012 13:22:55 -0800 (PST)
Message-ID: <4F270A2F.10601@sandeen.net>
Date: Mon, 30 Jan 2012 15:22:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Question on xfstest 274
References: <4F230E62.8020004@sandeen.net> <4F2603CC.9080807@cn.fujitsu.com>
In-Reply-To: <4F2603CC.9080807@cn.fujitsu.com>
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
To: WuBo <wu.bo@cn.fujitsu.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 1/29/12 8:43 PM, WuBo wrote:
> On 01/28/2012 04:51 AM, Eric Sandeen wrote:
>> Hi, I was wondering if you could describe your intent for 274 just a little more.
>>
>> The test says:
>>
>> # preallocation test
>>
>> but that is the only comment other than copyright.  ;)
> 
> Maybe the comment is too simple :)
> 
>>
>> I see that it does:
>>
>> # Make a 1G fs
>> # Create a single 4k file
>> # Allocate 1M past the EOF on that file
>> # Completely fill remaining space, using 2 other files
>> # Write 8k past EOF on the original file which has blocks past EOF
>>
>> but I am not certain what you are testing.  I presume that
>> you are testing the fact that the 1M past EOF should be truncated,
>> freeing up space, and allowing the 8k write to succeed?
>> Is that right?
> 
> Actually I write 8K at the end of 4K(seek=1), and what I want to test
> is the 8K-write should be succeed because the preallocation 1M. At the
> mean while, the file should not be truncated.

Ah, right - I missed the conv=notrunc sorry.  Ok, that all makes
sense.  I think I will try to clean up the test just a bit.

Thanks,
-Eric

> Thanks,
> wubo
> 
>>
>> However, at least on ext4 I noticed that the "fill the fs"
>> stage does not succeed; perhaps that should be tested as well.
>>
>> I can do some similar work on this like I did for 275, but I need
>> to be sure I understand your original intent for the test, first.
>>
>> Thanks,
>> -Eric
>>
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
