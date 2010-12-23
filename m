Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN9fSUj142175 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 03:41:29 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13ED521AA58
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 01:43:26 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id cYKAdxIaFzH85ltC for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 01:43:26 -0800 (PST)
Date: Thu, 23 Dec 2010 04:43:26 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
In-Reply-To: <20101223005630.GJ4907@dastard>
Message-ID: <alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
	<20101223005630.GJ4907@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1901294152-1293097406=:7452"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1901294152-1293097406=:7452
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 23 Dec 2010, Dave Chinner wrote:

> On Wed, Dec 22, 2010 at 07:28:29PM -0500, Justin Piszcz wrote:
>>
>>
>> On Thu, 23 Dec 2010, Emmanuel Florac wrote:
>>
>>> Le Wed, 22 Dec 2010 13:03:13 -0600 vous =E9criviez:
>>>
>>>> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_=
for_.3Csomething.3E
>>>>
>>>> which mentions getting your geometry right if it's hardware raid
>>>> that can't be detected automatically.
>>>
>>> Just as a side note : I tried several times to manually set the
>>> filesystem layout to precisely match the underlying hardware RAID
>>> with sunit and swidth but didn't find that it made a noticeable
>>> difference. On my 39.9 TB systems, the default agcount is 39, while the
>>> optimum would be (theorically at least)  42.
>>
>> Hi, I concur, for hardware raid (at least on 3ware cards) I have
>> found it makes no difference, thanks for confirming.
>
> I'd constrain that statement to "no difference for the workloads
> and hardware tested".
>
> Indeed, testing an empty filesystem will often show no difference in
> performance, because typically problems don't show up until you've
> started to age the filesystem significantly. When the filesystem has
> started to age, the difference between having done lots of stripe
> unit/width aligned allocation vs none can be very significant....
>
> Hence don't assume that because you can't see any difference on a
> brand new, empty filesystem there never will be a difference over
> the life of the filesytem...
>
> Cheers,
>
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

Hi Dave,

So for an 18 disk raid-6 with 256k stripe you would recommend:

mkfs.xfs with su=3D256k,sw=3D16 for optimal performance with inode64 mount=
=20
option?

Justin.
--655872-1901294152-1293097406=:7452
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--655872-1901294152-1293097406=:7452--
