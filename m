Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4JGk6WV055937 for <xfs@oss.sgi.com>; Tue, 19 May 2009 11:46:07 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8FB3FCFA63
	for <xfs@oss.sgi.com>; Tue, 19 May 2009 09:51:28 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	vywvFOHsBoLkLHeE for <xfs@oss.sgi.com>;
	Tue, 19 May 2009 09:51:28 -0700 (PDT)
Date: Tue, 19 May 2009 09:46:14 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: compilation error xfs_fsr.c:33:23 sys/xattr.h: No such file
	ordirectory
In-Reply-To: <005601c9d883$1f378f20$ae00a8c0@ferroamd64>
Message-ID: <alpine.DEB.2.01.0905190938370.8681@bogon.housecafe.de>
References: <005e01c9d856$7a89d450$ae00a8c0@ferroamd64>
	<alpine.DEB.2.01.0905190256030.8681@bogon.housecafe.de>
	<005601c9d883$1f378f20$ae00a8c0@ferroamd64>
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
To: Alessandro Ferrari <alexferro@tiscali.it>
Cc: xfs@oss.sgi.com

On Tue, 19 May 2009, Alessandro Ferrari wrote:
> I searched xattr.h and I founded it into:

Apparently there's no sys/xattr.h on your system. What distribution do 
you have? You'll need to install either the libc6-dev or glibc-headers 
package, depending on which package of your distribution provides this 
file.

Christian.
-- 
Vs lbh nfxrq Oehpr Fpuarvre gb qrpelcg guvf, ur'q pehfu lbhe fxhyy jvgu uvf
ynhtu.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
