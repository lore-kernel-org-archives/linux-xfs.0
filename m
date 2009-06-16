Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5GMIook181969
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 17:18:50 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39BBE91D52C
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 15:26:57 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.221.174]) by cuda.sgi.com with ESMTP id
	Xg879Ash1yySx9UL for <linux-xfs@oss.sgi.com>;
	Tue, 16 Jun 2009 15:26:57 -0700 (PDT)
Received: by qyk4 with SMTP id 4so6364683qyk.20
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 15:19:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8770d98c0906161442t634467bxe8b0f5c32b49502e@mail.gmail.com>
References: <24042506.post@talk.nabble.com> <4A3712BF.7030101@sandeen.net>
	<8770d98c0906152344p185533a9rc144a5667d13d2de@mail.gmail.com>
	<4A37B744.9030301@sandeen.net>
	<0B774481-16A5-42FC-89C3-91096E59E861@sgi.com>
	<8770d98c0906161028j1cc5cbadl49d30092fddf3dbe@mail.gmail.com>
	<B7C1A222-58C5-4858-80B4-F871BF088DB1@sgi.com>
	<8770d98c0906161442t634467bxe8b0f5c32b49502e@mail.gmail.com>
Date: Tue, 16 Jun 2009 15:19:12 -0700
Message-ID: <8770d98c0906161519x41e15d02l8a933f3164755b77@mail.gmail.com>
Subject: Re: XFS Preallocate using ALLOCSP
From: Smit Shah <getsmit@gmail.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: linux-xfs@oss.sgi.com

On 6/16/09, Smit Shah <getsmit@gmail.com> wrote:
> On 6/16/09, Felix Blyakher <felixb@sgi.com> wrote:
>>
>> On Jun 16, 2009, at 12:28 PM, Smit Shah wrote:
>>
>>> Yeah rite what i meant to say was that posix_fallocate uses ftruncate
>>> which in turn just updates the i_size and then posix_fallocate zeros
>>> out the whole thing
>>
>> I didn't look at the libc implementation, but it seems
>> strange to use ftruncate here at all. Is it more efficient
>> to write zeros into a hole than appending to a file?
> I havent seen in detail but i had just scanned through the
> posix_fallocate code in libc sometime back and it seemed to be doing
> that but i can confirm that later.
>
Yeah it simply write's zero's, i had seen the ftruncate used in the
posix_fallocate implimentation and hence got confused. It is used when
the prealloc length is zero and total file size is less than offset
specified.
My bad.

>> [snip]
>>
>>> Just to see if preallocation using fallocate helps reducing the
>>> fragmentation and increases the throughput.  I guess it wll help
>>> reduce the fragmentation
>>
>> ... and as result read performance on such files.
>>
>>> but the write performance is going to suffer.
>>
>> It's not clear why it should. Not doing preallocation doesn't
>> mean that there is no inode updates with every write. Why
>> would extent conversion be more expensive that creating the
>> space (extent) and updating the inode size for every write?
>> It'd interesting to reproduce your results. Any details on
>> your tests and the iometer usage?
>
> Since fallocate uses the RESVSP cmd for xfs. And as given given for
> RESVSP in man page for xfsctl
> If the  XFS filesystem  is  configured to flag unwritten file extents,
> performance will be negatively affected when writing to preallocated
> space, since extra filesystem transactions are required to convert
> extent  flags  on  the  range  of  the  file  written.
>
>>
>> Thanks,
>> Felix
>>
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
