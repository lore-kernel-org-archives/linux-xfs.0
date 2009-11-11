Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nABMHLrC186248
	for <linux-xfs@oss.sgi.com>; Wed, 11 Nov 2009 16:17:21 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA347185FAD1
	for <linux-xfs@oss.sgi.com>; Wed, 11 Nov 2009 14:17:38 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id u5giLS2UiXvh2Q08 for
	<linux-xfs@oss.sgi.com>; Wed, 11 Nov 2009 14:17:38 -0800 (PST)
Date: Thu, 12 Nov 2009 09:17:31 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <475457384.356771257977851793.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <200911111631.56993@zmi.at>
Subject: Re: xfs_repair question: "wrong" order of AG checks OK?
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: linux-xfs@oss.sgi.com


----- "Michael Monnerie" <michael.monnerie@is.it-management.at> wrote:

> I did an xfs_repair now, and everything was OK. But strange was, in
> Phase 4 the AGs were not checked in order:
> AG 2
> AG 1
> AG 0
> AG 3
> AG 4
> AG 5
> 
> Is that normal?

Could be xfs_repair running with multiple threads in parallel?

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
