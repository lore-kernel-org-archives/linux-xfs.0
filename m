Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 07:25:24 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.171])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08FPHqw029952
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 07:25:18 -0800
Message-ID: <45A26227.2080907@gmx.net>
Date: Mon, 08 Jan 2007 16:24:23 +0100
From: Klaus Strebel <klaus.strebel@gmx.net>
MIME-Version: 1.0
Subject: Re: What's wrong with XFS?
References: <936386.57179.qm@web59111.mail.re1.yahoo.com> <20070108144549.GA12073@tuatara.stupidest.org>
In-Reply-To: <20070108144549.GA12073@tuatara.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave N <mutex1@yahoo.com>
Cc: xfs@oss.sgi.com

Chris Wedgwood schrieb:
> On Mon, Jan 08, 2007 at 05:13:12AM -0800, Dave N wrote:
> 
>>  KDE, I was surprised to find out that all my desktop icons were
>>  messed up all over the place.
> 
> KDE made assumptions which are not only not true on linux but not true
> elsewhere either.  Last I checked KDE dealt with the common cases that
> were problematic much better now.
> 
>>  The other time, again power outage, only this time I was working on
>>  a small text file. Booted up again only to find out that the file I
>>  was working on contained garbage and I had to start all over again.
> 
> The file should not have contained garbage.  Also, if you
> open+truncate+write a file it should be flushed very soon after close
> these days, the window is fairly small now.
> 
>> I also heard that XFS depends heavily on the application side for
>> its data-integrity.  XFS "thinks" that the application will use the
>> proper calls when writing to disk. What???? How is it the task of
>> the application to ensure the safety of your files???
> 
> It's always been that way, for many many years, even before Linux
> existed.  If you want your applictions to be portable and reliable
> then you have to do do it right.
> 
> MTAs are a good example of applications which typically get this right
> because people case about lost email and the authors typically take
> some effort into make sure it's right.
> 
>> IMO, programs are there to provide the tools to be productive, NOT
>> to ensure the data safety of your files, that's the task of the file
>> system. Even MySQL provides me with better data-integrity here.
> 
> Does MySQL allow me to read or write 100s of MB/s continuously on
> cheap hardware (for not so cheap hardware I could ask 7GB/s).
> 
>> Why oh why such a beautiful file system like XFS is so terrible at
>> data-integrity?
> 
> There is a cost to full data journalling.  Personally even with ext3 I
> find the impact of this high enough I don't use it.
> 
>> Look what Sun Microsystems did with their new ZFS file
>> system... full atomicity, CRC checksumming and other features to
>> ensure data-integrity...
> 
> You could argue XFS is showing it's age, it's far from a new
> filesystem these days.
> 
> ZFS is a very different animal to most traditional filesystems.
> 
>> why can't XFS have such things?
> 
> Because the realities of life sometime collide with what people want
> ideally.
> 
> Linux can't have ZFS for licensing reasons but you can have Solaris
> with ZFS:  http://opensolaris.org/os/downloads/on/
> 
> 
FYI,

just found this <http://developer.berlios.de/projects/zfs-fuse/>

;-)

Klaus

-- 
Mit freundlichen Grüssen / best regards

Klaus Strebel, Dipl.-Inform. (FH), mailto:klaus.strebel@gmx.net

/"\
\ /     ASCII RIBBON CAMPAIGN
 X        AGAINST HTML MAIL
/ \
