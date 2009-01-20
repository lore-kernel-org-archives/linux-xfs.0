Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KAinOq005411 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 04:44:50 -0600
Received: from mail-bw0-f13.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6279B10A81A7
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 02:44:45 -0800 (PST)
Received: from mail-bw0-f13.google.com (mail-bw0-f13.google.com
	[209.85.218.13]) by cuda.sgi.com with ESMTP id r2aUdq4Sfn5FAwdX
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 02:44:45 -0800 (PST)
Received: by bwz6 with SMTP id 6so28196bwz.20
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 02:44:44 -0800 (PST)
Message-ID: <4975AAAF.4040804@gmail.com>
Date: Tue, 20 Jan 2009 11:42:55 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
MIME-Version: 1.0
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net>
	<49759844.5080405@gmail.com>
In-Reply-To: <49759844.5080405@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: hch@infradead.org, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Jacek Luczak pisze:
> Eric Sandeen pisze:
>> Jacek Luczak wrote:
>>> Hi All,
>>>
>>> I've stepped into XFS issue/bug. Yesterday I've compiled 2.6.29-rc2 and no
>>> didn't found errors. Today I've booted my notebook and XFS bug have occurred.
>>> System reboot didn't helped, same error appeared.
>>>
>>> Some info:
>>> [1] config: http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2.config
>>> [2] kernel logs:
>>> http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2_XFS-bug.log
>>> [3] most interesting part of log below.
>> so this happens every mount?  Reproducible is good.  How large is the
>> filesystem (too large to extract elsewhere for analysis...?) (plus I
>> suppose it'll be hard to get to it when you can't even boot....)
>>
>> -Eric
>>
> 
> Hi Eric,
> 
> funny or sad thing is that this happens while mounting only one of partitions
> (/home) which is:
> $ df -h | grep /home
> /dev/sda5              20G   14G  6,0G  69% /home
> 
> This bug is quite strange, as I mentioned, first boot on new kernel went OK,
> next two resulted in such behavior. Now I'm running 2.6.29-rc2-12097-gf3b8436
> and no bug here. Nevertheless I'm not fully happy, as it was seen before, the
> bug might still happen (will boot few times to test it and report back to you).
> 
> First yesterday buggy but went unnoticed so I've started fluxbox and firefox
> (errors seen in log), as usual, then found that sth is wrong. Second boot was
> also buggy than I've returned to old kernel where everything was OK ... nearly
> everything, cause firefox suddenly ,,forgot'' all configuration.
> 
> I will boot my notebook on all those 2.6.29-* kernel few times and maybe be able
> to reproduce that bug.
> 

I've made some tests. Basically umount + mount (with time measurement):

$ for i in $(seq -s ' ' 1 20) ; do echo "[=> umount [$MNT]: $i" ; time umount
$MNT ; [ $? -eq 0 ] && echo "[=> mount [$MNT]: $i" && time mount $MNT || break ;
done 2>&1 | tee ~/${MNT##*/}_mount_git.log

where MNT was set to three different partitions (all with XFS). Both on rc2 and
git version, no bug appeared. If someone is interested (I've seen some delays in
mounting before), some time results here:
http://pin.if.uz.zgora.pl/~difrost/linux-next/mount_logs/

I will still mess around so maybe it will appear once more than will try do some
more tests (suggestions are welcome).

-Jacek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
