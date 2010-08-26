Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7QDQF3j030164 for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 08:26:15 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CD691E53AB5
	for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 06:26:49 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id WiMRGgX3X1R8hzGX for
	<xfs@oss.sgi.com>; Thu, 26 Aug 2010 06:26:49 -0700 (PDT)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam & Virus Firewall) with ESMTP id
	5A80A2CAFD4
	for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 23:26:46 +1000 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.102.1]) by
	postoffice2.aconex.com with ESMTP id MSjfCVu35B2lb0ge for
	<xfs@oss.sgi.com>; Thu, 26 Aug 2010 23:26:46 +1000 (EST)
Received: from gatekeeper.aconex.com (gatekeeper.yarra.acx [192.168.102.10])
	by postoffice.aconex.com (Postfix) with ESMTP id 49AC6A50296
	for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 23:26:46 +1000 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by gatekeeper.aconex.com (Postfix) with ESMTP id 3D8CD9D0002
	for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 23:26:46 +1000 (EST)
Received: from gatekeeper.aconex.com ([127.0.0.1])
	by localhost (gatekeeper.aconex.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 27TSC2ewSwh3 for <xfs@oss.sgi.com>;
	Thu, 26 Aug 2010 23:26:41 +1000 (EST)
Received: from mail-au.aconex.com (mail-au.aconex.com [192.168.102.12])
	by gatekeeper.aconex.com (Postfix) with ESMTP id D3CF49D0001
	for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 23:26:41 +1000 (EST)
Received: from mail-au.aconex.com (mail-au.aconex.com [192.168.102.12])
	by mail-au.aconex.com (Postfix) with ESMTP id CF18964B8659
	for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 23:26:41 +1000 (EST)
Date: Thu, 26 Aug 2010 23:26:41 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <239606566.371721282829201737.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20100819121153.GB16045@infradead.org>
Subject: Re: Review: xfsprogs with libblkid enabled for Debian
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
To: xfs <xfs@oss.sgi.com>


----- "Christoph Hellwig" <hch@infradead.org> wrote:

> I'm fine with pushing out a new 3.1.3 release as it's time anyway,
> but
> can we also include Dave's patch to add XFS_IOC_ZERO_RANGE support to
> xfs_io and the xfsctl manpage first?
> 
> Next week also has Alex back from vacation, so I'd suggest waiting if
> he has any input on this.

As discussed on IRC, I made the changes and push out a new release.sh
tagged git update to kernel.org.  I pushed the src tarball to oss also,
and libblkid enabled packages will be uploaded to Debian shortly.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
