Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1MIVMRg041465 for <xfs@oss.sgi.com>; Wed, 22 Feb 2012 12:31:22 -0600
Message-ID: <4F45347A.2050204@sgi.com>
Date: Wed, 22 Feb 2012 12:31:22 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore will create orphanage directory when use -t
References: <CAGdb-8fC4-3swyyfP3xO=camgzDjR5GYV3qoaB1w+xAfiNeYPw@mail.gmail.com>	<4F3EBDA6.7070108@sgi.com>
	<CAGdb-8eMcBghwznGbGQha01paF1L+MdB3QsxHCuCh6ZOW=wsag@mail.gmail.com>
In-Reply-To: <CAGdb-8eMcBghwznGbGQha01paF1L+MdB3QsxHCuCh6ZOW=wsag@mail.gmail.com>
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
To: Tommy Wu <wu.tommy@gmail.com>
Cc: xfs <xfs@oss.sgi.com>

On 02/17/2012 06:22 PM, Tommy Wu wrote:
> 2012/2/18 Bill Kendall<wkendall@sgi.com>:
>> On 02/14/2012 11:21 AM, Tommy Wu wrote:
>>>
>>> from the xfsdump man page:
>>> xfsrestore also generates a directory named orphanage in the dest
>>> directory. xfsrestore removes this directory after completing a simple
>>> restore. However, if orphanage is not empty, it is not removed. This
>>> can happen if files present on the dump media are not referenced by
>>> any of the restored directories. The orphanage has an entry for each
>>> such file. The entry name is the file's original inode number, a ".",
>>> and the file's generation count modulo 4096 (only the lower 12 bits of
>>> the generation count are used).
>>>
>>> and the -t option from xfsdump man page:
>>> Displays the contents of the dump, but does not create or modify any
>>> files or directories. It may be desirable to set the verbosity level
>>> to silent when using this option.
>>>
>>> But when we use -t option with xfsrestore, it still create orphanage
>>> directory in current directory (because no dest directory assign).
>>> and if it's not empty, it is not removed.
>>>
>>> This is a bug or it's a feature?
>>
>>
>> I can see code where this would happen, except that it would appear
>> to require both -r and -t to be used, and xfsrestore doesn't allow
>> that.
>>
>> If you send the command line you used I can take another look.
>>
>> Bill
>
> here is the command I used for -t:
> cat var.xfsdump.gz | gzip -dqv | xfsrestore -v silent -p 300 -J -t - |
> grep "^xfsrestore:"
>
> I also test it with only -t option, it also create orphanage folder
> for such dump file (not all dump file has this issue)
> cat var.xfsdump.gz | gzip -dqv | xfsrestore -t - | grep "^xfsrestore:"

I found an issue which is likely the same as what you're seeing. I'll
post a patch shortly, please let me know whether or not it fixes the
problem.

Thanks,
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
