Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SKp0eR184810 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 15:51:01 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 574F81D50608
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 13:54:09 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with SMTP id TyFpTV6JkotTpFRB for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2011 13:54:09 -0700 (PDT)
Date: Mon, 28 Mar 2011 16:54:09 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.38.1: CPU#0 stuck for 67s! / xfs_ail_splice
In-Reply-To: <20110328205024.GB3008@dastard>
Message-ID: <alpine.DEB.2.02.1103281653270.25113@p34.internal.lan>
References: <alpine.DEB.2.02.1103260927500.21571@p34.internal.lan>
	<20110327232543.GU26611@dastard>
	<alpine.DEB.2.02.1103280406300.25113@p34.internal.lan>
	<20110328205024.GB3008@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Tue, 29 Mar 2011, Dave Chinner wrote:

> On Mon, Mar 28, 2011 at 04:10:11AM -0400, Justin Piszcz wrote:
>>
>>
>> On Mon, 28 Mar 2011, Dave Chinner wrote:
>>
>>> On Sat, Mar 26, 2011 at 09:29:36AM -0400, Justin Piszcz wrote:
>>>> Hi,
>>>>
>>>> When I rm -rf a directory of a few hundred thousand
>>>> files/directories on XFS under 2.6.38.1, I see the following, is
>>>> this normal?
>>>
>>> No. What is you filesystem config (xfs_info) and your mount options?
>>> Is it repeatable? I? the system otherwise stalled or is it still
>>> operating normally? Does it recover and work normally after such a
>>> stall?
>>
>> Hi Dave, default mkfs.xfs options:
>>
>>> What is you filesystem config (xfs_info) and your mount options?
>>
>> # xfs_info /dev/sda1
>> meta-data=/dev/sda1              isize=256    agcount=44, agsize=268435455 blks
>>          =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=11718704640, imaxpct=5
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=521728, version=2
>>          =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> A 44TB filesystem with a 2GB log, right?
A 44TB system yes, 2GB log (default).

>
>> /dev/sda1 on /r1 type xfs (rw,noatime,nobarrier,logbufs=8,logbsize=262144,delaylog,inode64)
>>
>>> Is it repeatable?
>> I've not tried to repeat it as is spews messages over all of my consoles but
>> it has happened more than once.
>
> OK.
>
>>> the system otherwise stalled or is it still operating normally?
>> The console/xterm/ssh etc that is performing the removal does lockup but
>> you are able to access the machine via a separate ssh connection.
>>
>>> Does it recover and work normally after such a stall?
>> Yes, eventually, I believe I started seeing this problem when I added
>> 'delaylog' option to the mount options..
>
> OK, that is what I suspected.
>
> What it sounds like is that there is a checkpoint completing with an
> out-of-order log sequence number so the items in the checkpoint are
> not being inserted at the end of the AIL and that is where the CPU
> usage is coming from. Without delaylog, a single transaction being
> inserted out-of-order is unnoticeable as it's only a few items. A
> delaylog checkpoint can be tens of thousands of items which is where
> the CPU usage would come from.
>
> I'll have to reproduce this locally to confirm this theory (and test
> the fix).
Ok, thanks!

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
