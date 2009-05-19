Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4JD9x4T045352 for <xfs@oss.sgi.com>; Tue, 19 May 2009 08:10:01 -0500
Received: from mail.gware.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 958B319E4C3A
	for <xfs@oss.sgi.com>; Tue, 19 May 2009 06:10:04 -0700 (PDT)
Received: from mail.gware.it ([80.94.126.121]) by cuda.sgi.com with SMTP id
	wziRkgPHrHm0mnY4 for <xfs@oss.sgi.com>;
	Tue, 19 May 2009 06:10:04 -0700 (PDT)
Message-ID: <005601c9d883$1f378f20$ae00a8c0@ferroamd64>
From: "Alessandro Ferrari" <alexferro@tiscali.it>
References: <005e01c9d856$7a89d450$ae00a8c0@ferroamd64>
	<alpine.DEB.2.01.0905190256030.8681@bogon.housecafe.de>
Subject: Re: compilation error xfs_fsr.c:33:23 sys/xattr.h: No such file
	ordirectory
Date: Tue, 19 May 2009 15:10:03 +0200
MIME-Version: 1.0
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

Hi Chtistian!

>
> sys/xattr.h should be part of a libc6-dev (or glibc-headers) package your
> distribution provides, I think.
>
> Christian.
> -- 
> SHA = "Schneier has access"

I searched xattr.h and I founded it into:

- /usr/src/linux/include/linux/xattr.h dated 02/Dec/2008 09:01 (when I 
compiled my kernel 2.4.37)
- /usr/include/linux/xattr.h dated 07/Mar/2002
- /usr/include/attr/xattr.h dated 18/May/2009 21:16 (when I compiled and 
installed attr_2.4.43-1 tarball)

I am very confused?!?!

Which is xattr.h correct for <sys/xattr.h> in xfs_fsr.c file ?

Alessandro 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
