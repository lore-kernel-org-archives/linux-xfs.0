Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9J9aEBV140260 for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 04:36:15 -0500
Received: from smtprelay03.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DBB8193EDEA
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 02:37:26 -0700 (PDT)
Received: from smtprelay03.ispgateway.de (smtprelay03.ispgateway.de
	[80.67.31.26]) by cuda.sgi.com with ESMTP id LYqyl5YZDngehFvV
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 02:37:26 -0700 (PDT)
Message-ID: <4CBD66D3.8000602@cape-horn-eng.com>
Date: Tue, 19 Oct 2010 11:37:23 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: cannot defrag volume, fragmentation factor 21.73%
References: <4CBC3910.70806@cape-horn-eng.com> <20101018231009.GL29677@dastard>
In-Reply-To: <20101018231009.GL29677@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/19/2010 01:10 AM, Dave Chinner wrote:
> On Mon, Oct 18, 2010 at 02:09:52PM +0200, Richard Ems wrote:
>> Hi all,
>>
>> this is on openSUSE 11.3.
>>
>> # uname -a
>> Linux fs1 2.6.34.7-0.3-default #1 SMP 2010-09-20 15:27:38 +0200
>> x86_64 x86_64 x86_64 GNU/Linux
>>
>> # echo frag | xfs_db -r /dev/disk/by-label/data1
>> xfs_db>  actual 6451844, ideal 5050129, fragmentation factor 21.73%
>>
>> # xfs_db -V
>> xfs_db version 3.1.2
>>
>> # xfs_fsr -V
>> xfs_fsr version 3.1.2
>>
>> # df -h /dev/sdb1
>> Filesystem            Size  Used Avail Use% Mounted on
>> /dev/sdb1              17T   13T  4.3T  75% /data_1
>>
>> The volume is new, 12TB were rsync'ed from another volume, some new
>> files came after the sync.
>>
>> I ran several times xfs_fsr, but the 21.73% factor stays there.
>> There where some busy or modified files on which I started xfs_fsr
>> later again, but this ones where small files and the 21.73% is still
>> there.
>
> Understand your numbers. What frag reports is how many extents there
> are vs a perfect layout. It does not tell you how badly fragmented
> your filesystem is. Extent-based filesystems can have
> "fragmentation" like you see reported above, but not suffer at all
> because the extents are large enough not to affect IO throughput.
>
> e.g. If I have a 100GB file in 100x1GB extents, frag would report an
> ideal of 17 extents and measure 100. That would give a frag factor
> of 83%. Now, is that filesystem fragmented? Theoretically yes.
> Practically, no.
>
> Why? Because extents of 1GB are more than large enough for any IO to
> that file reach full throughput. Therefore, while the file layout is
> not perfect, the "fragmentation" has no impact on performance and
> therefore the filesystem should not be considered fragmented.
>
> So, for 13TB of data, having 20% of your files with two extents
> rather than one is not a problem unless that causes you application
> measurable performance issues...
>
> IOWs, trying to reduce fragmentation without understanding what the
> numbers tell you about the layout of your filesystem can be counter
> productive. Especially as running xfs_fsr when you don't really need
> to can have other side-effects that affect the long-term aging
> characteristics of the filesystem (e.g. causing preamture free space
> fragmentation).
>
> Cheers,
>
> Dave.

Hi Dave,

many thanks for the clarification. I will go again through the XFS =

documentation and try to "understand my numbers" as you wrote.

Thanks again,
Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
