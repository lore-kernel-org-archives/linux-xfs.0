Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81ICjVF198483 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 13:13:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 101C3417D89
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 11:13:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QmwgHQfsI8SY7ai6 for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 11:13:41 -0700 (PDT)
Date: Tue, 1 Sep 2009 14:13:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS corruption with power failure
Message-ID: <20090901181341.GC26071@infradead.org>
References: <606994882.2142291250648292843.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<4A8C1E6E.8020405@jquigley.com> <4A9187C7.9010206@jquigley.com>
	<4A9576F0.2060304@jquigley.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A9576F0.2060304@jquigley.com>
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
To: John Quigley <jquigley@jquigley.com>
Cc: XFS Development <xfs@oss.sgi.com>

On Wed, Aug 26, 2009 at 12:54:56PM -0500, John Quigley wrote:
> John Quigley wrote:
>> John Quigley wrote:
>>> We've distilled this into a reproducible environment with a stack of  
>>> NFS + XFS to a local disk + automated sysrq 'b' reboots.  We're  
>>> working on getting this bundled up into a nice little package as a  
>>> VirtualBox vm for your consumption.  Please tell me if this is not  
>>> desirable.
>>
>> The self-contained and reproducible environment can be downloaded from  
>> the following location:
>>
>>  http://www.jquigley.com/tmp/xfsVM.tar.bz2
>
> Has anyone by chance had an opportunity to utilize this?  Any corruption reports?

Looked at it, but it turns virtualbox is a real big pile of junk
including it's own huge kernel module.  Qemu/kvm now has support for the
virtualbox disk images and I will give it a try next.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
