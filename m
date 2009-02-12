Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CIgrrF074569 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 12:42:54 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 389691923C35
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 10:42:17 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 3sJ34QDVaEB5Hpl4 for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2009 10:42:17 -0800 (PST)
Message-ID: <49946D7A.6070806@sandeen.net>
Date: Thu, 12 Feb 2009 12:42:02 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 12/13] xfs: add version 3 inode format with CRCs
References: <20090210202241.546501000@bombadil.infradead.org>	<20090210202941.455393000@bombadil.infradead.org>
	<20090212063836.GB824@josefsipek.net>
In-Reply-To: <20090212063836.GB824@josefsipek.net>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Josef 'Jeff' Sipek wrote:
> On Tue, Feb 10, 2009 at 03:22:53PM -0500, Christoph Hellwig wrote:
> ...
>> Index: xfs/fs/xfs/xfs_dinode.h
>> ===================================================================
>> --- xfs.orig/fs/xfs/xfs_dinode.h	2009-02-10 19:45:51.939069576 +0100
>> +++ xfs/fs/xfs/xfs_dinode.h	2009-02-10 19:45:59.195068745 +0100
>> @@ -69,11 +69,32 @@ typedef struct xfs_dinode {
>>  
>>  	/* di_next_unlinked is the only non-core field in the old dinode */
>>  	__be32		di_next_unlinked;/* agi unlinked list ptr */
>> -} __attribute__((packed)) xfs_dinode_t;
>> +
>> +	/* start of the extended dinode, writable fields */
>> +	__be32		di_crc;		/* CRC of the inode */
>> +	__be64		di_changecount;	/* number of attribute changes */
>> +	__u8		di_pad2[16];	/* more padding for future expansion */
>> +
>> +	/* fields only written to during inode creation */
>> +	xfs_timestamp_t	di_crtime;	/* time created */
>> +	__be64		di_ino;		/* inode number */
>> +	uuid_t		di_uuid;	/* UUID of the filesystem */
>> +} xfs_dinode_t;
> 
> Hrm...removing the packed attribute... Eric, do you remember the ARM ABI
> alignment rules? Regardless of ARM, are those fields aligned nicely? (From a
> quick glance at the code looks ok.)

I'll just have to just test it again I suppose.  Removing packed is
good, as long as the padding makes it all come out right.

-=Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
