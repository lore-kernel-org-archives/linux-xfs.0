Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 06:54:51 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08Eshqw023908
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 06:54:44 -0800
Message-ID: <45A25800.6060603@gmx.net>
Date: Mon, 08 Jan 2007 15:41:04 +0100
From: Klaus Strebel <klaus.strebel@gmx.net>
MIME-Version: 1.0
Subject: Re: What's wrong with XFS?
References: <936386.57179.qm@web59111.mail.re1.yahoo.com>
In-Reply-To: <936386.57179.qm@web59111.mail.re1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave N <mutex1@yahoo.com>
Cc: xfs@oss.sgi.com

Dave N schrieb:
> Hi,
> 
> Even MySQL provides me with better data-integrity here. If I'm doing some database transaction and the power fails, I can be pretty sure that *most* of the time, MySQL will be just fine next time I boot up.
Hallo Dave, MySQL is an application which takes care of data-integrity (
which XFS depends on, as you stated yourself ;-) ). XFS takes care of
the filesystem-integrity, to enable your MySQL to find the files it's
caring of it's content-integrity ( as an application, you see ;-) )
> 
> Why oh why such a beautiful file system like XFS is so terrible at data-integrity? Look what Sun Microsystems did with their new ZFS file system... full atomicity, CRC checksumming and other features to ensure data-integrity... why can't XFS have such things?
To mount multi-gigabyte filesystems after some kind of desaster in
minutes, not in hours or days ;-). It's only caring for meta-data, not
the data.

> 
> Thanks for listening to my preaching here guys
> 
> Cheers!


-- 
Mit freundlichen Grüssen / best regards

Klaus Strebel, Dipl.-Inform. (FH), mailto:klaus.strebel@gmx.net

/"\
\ /     ASCII RIBBON CAMPAIGN
 X        AGAINST HTML MAIL
/ \
