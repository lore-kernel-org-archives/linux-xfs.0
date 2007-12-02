Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Dec 2007 15:39:39 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB2NdT88008780
	for <xfs@oss.sgi.com>; Sun, 2 Dec 2007 15:39:32 -0800
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA07548; Mon, 3 Dec 2007 10:23:25 +1100
Message-ID: <47533E6E.1010508@sgi.com>
Date: Mon, 03 Dec 2007 10:23:26 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: current cvs doesn't compile
References: <20071130101153.GA4150@lst.de> <20071130101824.GA4419@lst.de>
In-Reply-To: <20071130101824.GA4419@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Nov 30, 2007 at 11:11:53AM +0100, Christoph Hellwig wrote:
>> xfs_mark_inode_dirty_sync is used in xfs_inode_item_format but isn't
>> actually declared anywhere.
> 
> Sorry, this was due to me having some old patch applied still.
> 
>> Btw, we also still have the bug that fs/xfs/Kbuild exists as an empty
>> files and without removing it nothing is recompiled at all.
> 
> But this is still a real issue..

Hi Christoph,

http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/xfs/
Doesn't snow fs/xfs/Kbuild (except in the archives). I also did a fresh
cvs checkout of linux-2.6-xfs and its not there ether. Seems like this
is only happening when updating an existing workarea.

There could be a stale entry in fs/xfs/CVS/Entries that is not
being removed by an update/checkout. Could you send us your Entries
file so we can figure out whats happening?

Don
