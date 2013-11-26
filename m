Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4EB257F3F
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 02:03:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DAA5BAC002
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 00:03:28 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 9ZujSde9DdW5ljFy
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 00:03:27 -0800 (PST)
Message-ID: <529455CB.6050907@hardwarefreak.com>
Date: Tue, 26 Nov 2013 02:03:23 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: ARC-1120 and MD very sloooow
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>	<1385369796.2076.16.camel@bews002.euractiv.com>	<5293EF32.9090301@hardwarefreak.com>	<20131126025210.GL8803@dastard>	<52941C5D.1000305@hardwarefreak.com>
	<20131126061458.GM8803@dastard>
In-Reply-To: <20131126061458.GM8803@dastard>
Reply-To: stan@hardwarefreak.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jimmy Thrasibule <thrasibule.jimmy@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/26/2013 12:14 AM, Dave Chinner wrote:
> On Mon, Nov 25, 2013 at 09:58:21PM -0600, Stan Hoeppner wrote:
>> On 11/25/2013 8:52 PM, Dave Chinner wrote:
>> ...
>>> sunit/swidth is in filesystem blocks, not sectors. Hence
>>> sunit is 1MB, swidth = 2MB. While it's not quite correct
>>> (su=512k,sw=1m), it's not actually a problem...
>>
>> Well that's what I thought as well, and I was puzzled by the 8 blocks
>> value for the log sunit.  So I double checked before posting, and 'man
>> mkfs.xfs' told me
>>
>> 	sunit=value
>>               This is used to specify the stripe unit for a RAID device
>>               or a logical volume. The  value  has  to  be specified in
>>               512-byte block units.
>>
>> So apparently the units of 'sunit' are different depending on which XFS
>> tool one is using. 
> 
> No they don't. sunit as a mkfs input value is determined by 512 byte
> units. The output is given in units of "blks" i.e. the log block
> size:

Yes.  That's pretty clear now.  And I've figured out why this is...

> $ mkfs.xfs -N -l sunit=64 /dev/vdb
> ....
> log      =internal log           bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> 
> Which is given by the "bsize=4096" variable and so are, in this
> case, 4k in size.  input = 64 * 512 bytes = 8 * 4096 bytes = output
> 
> Remember, you can specify su rather than sunit, and they are
> specified in sectors, filesystem blocks or bytes, and the output is
> still in units of log block size:

I never used IRIX.  But I've deduced that this made sense then due to
variable filesystem block size selection during mkfs.  But in Linux the
filesystem block size is static, at 4KB, equal to page size, and from
everything I've read the page size isn't going to change any time soon.
 Thus for Linux only users, this exercise of using creation values in
512 byte blocks, or bytes, or multiples of the fs block size, can be
very confusing, when the output is always a multiple of filesystem
blocks, always a multiple of 4KB.

> # mkfs.xfs -N -b size=4096 -l su=8b /dev/vdb
                                ^^^^^
I never noticed this until now because I've never used an external log,
nor needed an internal log with different geometry than the data section.

But why do we have different input values for su in the data (bytes) and
log (blocks) sections?  I hope to learn something from your answer, as I
usually do. :)

> ....
> log      =internal log           bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> 
> # mkfs.xfs -N -l su=32k /dev/vdb
> ....
> log      =internal log           bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> 
> IOws, the input units can vary, but the output units are always the
> same.
> 
>> That's a bit confusing.  And 'man xfs_info'
>> (xfs_growfs) doesn't tell us that sunit is given in filesystem blocks.
>> I'm using xfsprogs 3.1.4 so maybe these have been corrected since.
> 
> It might seem confusing at first, but it's actually quite
> consistent...

At first?  Dang Dave, you've been mentoring me for something like 3+
years now. :)  I don't deal with alignment issues very often, but this
isn't my first rodeo.  I had my answer based on 4KB blocks, and went to
the docs to verify it before posting.  That's the logical thing to do.
In this case, the docs led me astray.  That shouldn't happen.

It won't happen to me again, but if it did once, after using the
software and documentation for over 4 years, it may likely happen to
someone else.  So I'm thinking a short caveat/note might be in order in
mkfs.xfs(8).  Something like

"Note: During filesystem creation, data section stripe alignment values
(sunit/swidth/su/sw) are specified in units other than filesystem
blocks.  After creation, sunit/swidth values are referenced in multiples
of filesystem blocks by the xfsprogs tools."

>>> Again, lsunit is in filesystem blocks, so it is 32k, not 4k. And
>>> yes, the default lsunit when the sunit > 256k is 32k. So, nothing
>>> wrong there, either.
>>
>> So where should I have looked to confirm sunit reported by xfs_info is
>> in fs block (4KB) multiples, not the in the 512B multiples of mkfs.xfs?
> 
> Explained above.

Thanks Dave.  Hopefully others learn from this as well.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
