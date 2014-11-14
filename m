Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B9607F3F
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 07:24:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09C2CAC006
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 05:24:07 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1UkY68QwXBFnk2FV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 05:24:03 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAEDO1vM009339
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 08:24:02 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sAEDO164000338
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 08:24:01 -0500
Date: Fri, 14 Nov 2014 08:24:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Wrong d_type presented by xfs_io
Message-ID: <20141114132359.GA36731@bfoster.bfoster>
References: <20141114124807.GA2240@hades.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141114124807.GA2240@hades.localdomain>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Fri, Nov 14, 2014 at 10:48:10AM -0200, Carlos Maiolino wrote:
> Hi guys,
> 
> I've been looking through an issue raised by Brian, regarding my RENAME_EXCHANGE
> patchset, where, apparently, the d_type of some files are reseted during the
> exchange. Brian presented an example here:
> 
> http://oss.sgi.com/archives/xfs/2014-11/msg00170.html
> 
> When trying to debug it, I've been trying to create and rename some FS objects
> to try to reproduce the issue, but, all the files I've been creating are shown
> as DT_UNKNOWN type:
> 

Hi Carlos,

I suspect you aren't using a v5 superblock. You can do that by passing
'-m crc=1' to mkfs. Does d_type work once you're on v5?

Brian

> ex:
> 
> /dev/vdb2 on /xfs/scratch type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
> 
> [root@localhost scratch]# mkdir /xfs/scratch/dir1
> 
> [root@localhost scratch]# xfs_io -c "readdir -v" /xfs/scratch/
> 
> 00000006: d_ino: 0x00000083 d_off: 0x00000200 d_reclen: 0x18 d_type: DT_UNKNOWN
> d_name: dir1
> 
> 
> [root@localhost scratch]# mknod /xfs/scratch/mybdev b 253 19
> 
> 00000008: d_ino: 0x00000084 d_off: 0x00000200 d_reclen: 0x20 d_type: DT_UNKNOWN
> d_name: mybdev
> 
> 
> 
> 
> So, anyone knows if is there any problem with xfs_io, or, if I'm doing something
> wrong here?
> 
> [root@localhost scratch]# xfs_io -V
> xfs_io version 3.2.1
> 
> 
> or maybe, we have a bug somewhere else.
> 
> 
> Cheers
> 
> -- 
> Carlos
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
