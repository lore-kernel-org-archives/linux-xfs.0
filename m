Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n382kpFQ055664 for <xfs@oss.sgi.com>; Tue, 7 Apr 2009 21:47:01 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC21B1F8CE7
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2009 19:46:31 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id EEKiAL6xmUSCMhTl for
	<xfs@oss.sgi.com>; Tue, 07 Apr 2009 19:46:31 -0700 (PDT)
Date: Wed, 8 Apr 2009 12:46:24 +1000 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <732332763.3161411239158784001.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20090408100545.2354f572.thomas@nchc.org.tw>
Subject: Re: Build xfs 3.0 deb problem
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
To: Thomas Tsai <thomas@nchc.org.tw>
Cc: xfs@oss.sgi.com


----- "Thomas Tsai" <thomas@nchc.org.tw> wrote:

> Hello xfs,
> 
> I get the source tarball and easy run Makepkgs debian
> The build result look fine but lose some library files like
> libxfs.a....
> 
> I really need libxfs-dev to build my package.
> Please give me a hand, tkx.

What is your package, and what libxfs calls does it make?
libxfs.a was never intended as a published API, and nothing
outside xfsprogs should be using it.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
