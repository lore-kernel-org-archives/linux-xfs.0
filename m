Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 05:40:59 -0800 (PST)
Received: from web59111.mail.re1.yahoo.com (web59111.mail.re1.yahoo.com [66.196.101.22])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l08Deqqw009792
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 05:40:54 -0800
Date: Mon, 8 Jan 2007 05:13:12 -0800 (PST)
From: Dave N <mutex1@yahoo.com>
Subject: What's wrong with XFS?
MIME-Version: 1.0
Message-ID: <936386.57179.qm@web59111.mail.re1.yahoo.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

Can someone enlighten me what the issue is with XFS? I've been hearing a lot of good things on the Net about XFS. How it's lightening fast, how it has features other file systems do not have (like GRIO, real time volumes, allocate on flush, etc), how it scales very well, etc... but what I didn't hear about is how fast XFS screws things up if something wrong happens. Because of the good things I heard about XFS, I too decided to try it out (been using Ext3 or ReiserFS here for most of the time). Now I'm very disappointed in XFS. I live in an area where power outages are common and I do not have an UPS here. I have a few computers all running on XFS and thought that XFS will give me similar data-integrity like Ext3 or ReiserFS. Now, for the past few weeks I've been experiencing "strange behavior" from XFS. One time, I was reading an article on the Net and had only my Firefox browser open. Then we had a power outage for a short period of time, and when I logged in again into
 KDE, I was surprised to find out that all my desktop icons were messed up all over the place. The other time, again power outage, only this time I was working on a small text file. Booted up again only to find out that the file I was working on contained garbage and I had to start all over again. 

I also heard that XFS depends heavily on the application side for its data-integrity. XFS "thinks" that the application will use the proper calls when writing to disk. What???? How is it the task of the application to ensure the safety of your files??? IMO, programs are there to provide the tools to be productive, NOT to ensure the data safety of your files, that's the task of the file system. Even MySQL provides me with better data-integrity here. If I'm doing some database transaction and the power fails, I can be pretty sure that *most* of the time, MySQL will be just fine next time I boot up.

Why oh why such a beautiful file system like XFS is so terrible at data-integrity? Look what Sun Microsystems did with their new ZFS file system... full atomicity, CRC checksumming and other features to ensure data-integrity... why can't XFS have such things?

Thanks for listening to my preaching here guys

Cheers!

 __________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 

[[HTML alternate version deleted]]
