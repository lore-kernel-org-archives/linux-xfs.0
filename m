Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8FFnk8n170630 for <xfs@oss.sgi.com>; Tue, 15 Sep 2009 10:49:46 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2580B3C020
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2009 08:50:59 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id 8WFcinamOEnJNYqc for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2009 08:50:59 -0700 (PDT)
Message-ID: <4AAFB7E2.9010902@jquigley.com>
Date: Tue, 15 Sep 2009 10:50:58 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: Re: XFS corruption with power failure
References: <606994882.2142291250648292843.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>	<4A8C1E6E.8020405@jquigley.com>
	<4A9187C7.9010206@jquigley.com>	<4A9576F0.2060304@jquigley.com>
	<20090901181341.GC26071@infradead.org>
In-Reply-To: <20090901181341.GC26071@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: XFS Development <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Aug 26, 2009 at 12:54:56PM -0500, John Quigley wrote:
>> John Quigley wrote:
>>> John Quigley wrote:
>>>> We've distilled this into a reproducible environment with a stack of  
>>>> NFS + XFS to a local disk + automated sysrq 'b' reboots.  We're  
>>>> working on getting this bundled up into a nice little package as a  
>>>> VirtualBox vm for your consumption.  Please tell me if this is not  
>>>> desirable.
>>> The self-contained and reproducible environment can be downloaded from  
>>> the following location:
>>>
>>>  http://www.jquigley.com/tmp/xfsVM.tar.bz2
>> Has anyone by chance had an opportunity to utilize this?  Any corruption reports?
> 
> Looked at it, but it turns virtualbox is a real big pile of junk
> including it's own huge kernel module.  Qemu/kvm now has support for the
> virtualbox disk images and I will give it a try next.

Ping ... sorry to be a bother.  I've finally gotten some time allocated 
to look at this at the code level, but I'm unfamiliar with the XFS 
implementation, and I believe this problem arises as an interaction 
between XFS and NFS, which causes me heartburn.  I'll report here if I 
discover anything meaningful.

- John Quigley

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
