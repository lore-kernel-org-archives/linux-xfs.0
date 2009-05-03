Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n431lsLe078312 for <xfs@oss.sgi.com>; Sat, 2 May 2009 20:47:54 -0500
Received: from mail001.aei.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 451F41D06B63
	for <xfs@oss.sgi.com>; Sat,  2 May 2009 18:47:55 -0700 (PDT)
Received: from mail001.aei.ca (mail001.aei.ca [206.123.6.130]) by cuda.sgi.com
	with ESMTP id qlF1u51IIKv3g9G0 for <xfs@oss.sgi.com>;
	Sat, 02 May 2009 18:47:55 -0700 (PDT)
From: Ed Tomlinson <edt@aei.ca>
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
Date: Sat, 2 May 2009 21:47:51 -0400
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
	<a4423d670905021159k51e91b12h96189005980b5e73@mail.gmail.com>
	<49FCA988.2050600@sandeen.net>
In-Reply-To: <49FCA988.2050600@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905022147.52216.edt@aei.ca>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, Kernel Testers List <kernel-testers@vger.kernel.org>, linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>, Heinz Diehl <htd@fancy-poultry.org>

On Saturday 02 May 2009 16:14:00 Eric Sandeen wrote:
> Alexander Beregalov wrote:
> > 2009/5/2 Eric Sandeen <sandeen@sandeen.net>:
> >> Alexander Beregalov wrote:
> >>> 2009/5/2 Heinz Diehl <htd@fancy-poultry.org>:
> >>>> On 01.05.2009, Alexander Beregalov wrote:
> >>>>
> >>>>> # xfs_db -r /dev/sdc1
> >>>>> xfs_db> frag
> >>>>> actual 23805, ideal 22890, fragmentation factor 3.84%
> >>>>> # xfs_fsr -v /dev/sdc1
> >>>>> /mnt/c start inode=0
> >>>>> ino=158
> >>>>> extents before:3 after:1 DONE ino=158
> >>>>>
> >>>>>  then it hangs
> >>>> I can't confirm this here on my systems:
> >>>>
> >>>> liesel:~ # uname -a
> >>>> Linux liesel 2.6.30-rc4 #1 SMP PREEMPT Sat May 2 11:49:13 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux
> >>> I have this problem on two x86_32 hosts.
> >>> It runs for about a minute and then hangs.
> >> echo w > /proc/sysrq-trigger
> >> dmesg
> >>
> >> would show all the sleeping processes...
> > It is the same as I posted already:
> 
> hum, only 1 thread, interesting...
 
I have also had strange stalls with rc4 (but not with rc3).  In one case sysrq would just print the title of commands no
data would follow.  Do not know if this is related but it may be that this is not just an xfs issue.

Ed Tomlinson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
