Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBDAr6NO183464 for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 04:53:06 -0600
Received: from mx3-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 002241440EDE
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 02:54:57 -0800 (PST)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id 6vXbj1buagX6SEpV for
	<xfs@oss.sgi.com>; Mon, 13 Dec 2010 02:54:57 -0800 (PST)
Date: Mon, 13 Dec 2010 05:54:50 -0500 (EST)
From: Boris Ranto <branto@redhat.com>
Message-ID: <36980345.1112451292237690337.JavaMail.root@zmail01.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1924340607.1111921292237137384.JavaMail.root@zmail01.collab.prod.int.phx2.redhat.com>
Subject: Re: xfstests: ignore absolute address in filename in test case 237
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

----- "Christoph Hellwig" <hch@infradead.org> wrote:

> I don't mind the patch, but what version of getfacl would produce an
> absolute filename?

The behavior was found in acl-2.2.39-6.el5:

* setfacl -m 'user:test:rw' file 
setfacl: /mnt/tests/kernel/filesystems/xfs/xfstests/file: Operation not permitted
* setfacl --version
setfacl 2.2.39

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
