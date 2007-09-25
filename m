Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 22:53:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8P5rFQ3029973
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 22:53:21 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA14293; Tue, 25 Sep 2007 15:53:11 +1000
Message-ID: <46F8A247.4070607@sgi.com>
Date: Tue, 25 Sep 2007 15:53:11 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsidbg: kill vnode leftovers
References: <20070924180732.GA17635@lst.de>
In-Reply-To: <20070924180732.GA17635@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> While we're at fixing up xfsidbg I have this little gem:
> 
> Kill the kdbm_vn, kdbm_vnode and xi2vnode xfsidbg commands.
> 
> The last one just printed a Linux inode (despite it's description)
> and that is much better done by the inode command in
> kdb/modules/kdbm_pg.c.  The latter two both print the vnode (nothing
> left here) and the inode and again that is better done using the
> inode command.  Interestingly those latter two did exactly the
> same despite their quite different descriptions which weren't
> correct for either command.
> 

Thanks Christoph, its good to remove the cruft.
78 commands in there at the moment. Any we can get rid of make it easier to use.

Don
