Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 07:13:19 -0800 (PST)
Received: from extgat1.local.navi.pl (ip-83-238-212-180.netia.com.pl [83.238.212.180])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08FDDqw027209
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 07:13:15 -0800
Received: from venus.local.navi.pl (www.local.navi.pl [192.168.1.10])
	by extgat1.local.navi.pl (8.13.1/8.13.1) with ESMTP id l08EobEL003960
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 15:50:37 +0100
Received: from venus.local.navi.pl (venus.local.navi.pl [192.168.1.10])
	by venus.local.navi.pl (8.13.1/8.13.1) with ESMTP id l08Eobxm032566
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 15:50:37 +0100
Subject: Re: What's wrong with XFS?
From: Olaf =?iso-8859-2?Q?Fr=B1czyk?= <olaf@cbk.poznan.pl>
In-Reply-To: <936386.57179.qm@web59111.mail.re1.yahoo.com>
References: <936386.57179.qm@web59111.mail.re1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 08 Jan 2007 15:50:37 +0100
Message-Id: <1168267837.29690.14.camel@venus.local.navi.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, 2007-01-08 at 05:13 -0800, Dave N wrote:
> Hi,
> 
> Can someone enlighten me what the issue is with XFS? I've been hearing a lot of good things on the Net about XFS. How it's lightening fast, how it has features other file systems do not have (like GRIO, real time volumes, allocate on flush, etc), how it scales very well, etc... but what I didn't hear about is how fast XFS screws things up if something wrong happens. Because of the good things I heard about XFS, I too decided to try it out (been using Ext3 or ReiserFS here for most of the time). Now I'm very disappointed in XFS. I live in an area where power outages are common and I do not have an UPS here. I have a few computers all running on XFS and thought that XFS will give me similar data-integrity like Ext3 or ReiserFS. Now, for the past few weeks I've been experiencing "strange behavior" from XFS. One time, I was reading an article on the Net and had only my Firefox browser open. Then we had a power outage for a short period of time, and when I logged in again into
>  KDE, I was surprised to find out that all my desktop icons were messed up all over the place. The other time, again power outage, only this time I was working on a small text file. Booted up again only to find out that the file I was working on contained garbage and I had to start all over again. 
> 
> I also heard that XFS depends heavily on the application side for its data-integrity. XFS "thinks" that the application will use the proper calls when writing to disk. What???? How is it the task of the application to ensure the safety of your files??? IMO, programs are there to provide the tools to be productive, NOT to ensure the data safety of your files, that's the task of the file system. Even MySQL provides me with better data-integrity here. If I'm doing some database transaction and the power fails, I can be pretty sure that *most* of the time, MySQL will be just fine next time I boot up.
> 
> Why oh why such a beautiful file system like XFS is so terrible at data-integrity? Look what Sun Microsystems did with their new ZFS file system... full atomicity, CRC checksumming and other features to ensure data-integrity... why can't XFS have such things?
> 
> Thanks for listening to my preaching here guys
> 
> Cheers!

Hi,

It is nothing wrong with XFS - your expectations are wrong.

You expect data to be journaled, but XFS does journal metadata only, not
data. So, the thing that you get is filesystem integrity not data
integrity.
If you want data integrity you need properly written applications and
__it is__ application's job to care about it's data. It is nothing
unusual here.

If you need data journaling then you need another filesystem - eg. ext3.

I suppose that you find all of it in FAQ.

Regards,

Olaf
-- 
Olaf Frączyk <olaf@cbk.poznan.pl>
