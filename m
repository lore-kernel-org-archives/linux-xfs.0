Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 614D47F47
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 11:19:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 90357AC010
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 09:19:06 -0700 (PDT)
Received: from mail-qc0-f179.google.com (mail-qc0-f179.google.com
	[209.85.216.179]) by cuda.sgi.com with ESMTP id
	LjroDx8dK3lx3tEW (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 09:19:05 -0700 (PDT)
Received: by mail-qc0-f179.google.com with SMTP id x3so495409qcv.38
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 09:19:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53A9A295.8030302@sandeen.net>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<53A9A295.8030302@sandeen.net>
Date: Tue, 24 Jun 2014 18:19:04 +0200
Message-ID: <CA+o=1OXJZk2XjZhtEORQesDjb3VGzM1Ddk6DGXwuLhHJUEbjPQ@mail.gmail.com>
Subject: Re: Metadata CRC error upon unclean unmount
From: Fanael Linithien <fanael4@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

2014-06-24 18:08 GMT+02:00 Eric Sandeen <sandeen@sandeen.net>:
> Do you have any kind of reproducer for this?

The closest thing to a reliable reproducer I found is:
dd if=/dev/urandom of=some.file
<VM reset while dd is still running>

> Any chance you created an xfs_metadump before the xfs_repair?

I still have the broken FS, but the dump is 225 MB. Will it be OK if I
repro it on a clean FS?

> What constitutes an "unclean unmount" in your case; a VM reset?  A host
> crash?

A VM reset.

> (This is a VM, right?)

Right.

> What sort of block device configuration does it have?

What do you mean?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
