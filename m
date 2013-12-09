Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE9D57F56
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 03:47:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 453F3AC001
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 01:47:41 -0800 (PST)
Received: from volubilis.easter-eggs.com (volubilis.easter-eggs.com
	[37.9.136.135]) by cuda.sgi.com with ESMTP id 1ZhZlTVZ4OhhvdXI
	for <xfs@oss.sgi.com>; Mon, 09 Dec 2013 01:47:16 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by volubilis.easter-eggs.com (Postfix) with ESMTP id E562515E05
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 10:47:15 +0100 (CET)
Received: from datura.easter-eggs.fr (coquelicot-s.easter-eggs.com
	[109.190.110.196])
	by volubilis.easter-eggs.com (Postfix) with ESMTPSA id BFDA815DFB
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 10:47:15 +0100 (CET)
Date: Mon, 9 Dec 2013 10:47:15 +0100
From: Emmanuel Lacour <elacour@easter-eggs.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
	(mode:0x250)
Message-ID: <20131209094715.GC5821@easter-eggs.com>
References: <20131128091322.GC5337@easter-eggs.com>
	<20131128100521.GO10988@dastard>
	<20131203095357.GC5405@easter-eggs.com>
	<20131203125057.GU10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131203125057.GU10988@dastard>
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

On Tue, Dec 03, 2013 at 11:50:57PM +1100, Dave Chinner wrote:
> 


thanks very much for your quick and detailled answer!

> OK, 32GB RAM, no obvious shortage, no dirty or writeback data.
> 2TB SATA drives, 32AGs, only unusual setting is 64k directory block
> size.
> 

yes, the 64k was taken from a too quickly read of advice, I don't think
it's of any help on a ceph cluster but I'm not an FS guru. Is there a
way to lower it at runtime?

> Yup, there's your problem:
> 

[...]

> Which, I think, is pretty easy to do. Yup, barely smoke tested patch
> below that demonstrates the fix. Beware - patch may eat babies and
> ask for more. Use it at your own risk!
> 


unfortunatly I cannot test this patch because:

- it's a production cluster and it's currently hard for me to reboot
  nodes (not enough nodes ;))
- just after hiting this problem I saw a kernel 3.11 available on Debian
  backports and decided to upgrade the whole cluster.

since this upgrade, there is no problems anymore ... I cross my fingers
;)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
