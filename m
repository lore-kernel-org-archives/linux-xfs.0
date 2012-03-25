Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2PIKevS175166 for <xfs@oss.sgi.com>; Sun, 25 Mar 2012 13:20:40 -0500
Received: from mail.windriver.com (mail.windriver.com [147.11.1.11]) by
	cuda.sgi.com with ESMTP id WwMg1jcbN3DScZ4o (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 25 Mar 2012 11:20:38 -0700 (PDT)
Message-ID: <4F6F61F3.40903@windriver.com>
Date: Sun, 25 Mar 2012 14:20:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
MIME-Version: 1.0
Subject: Building tilegx defconfig gets init/exit section errors in xfs.
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
To: xfs@oss.sgi.com
Cc: linux-next@vger.kernel.org, cmetcalf@tilera.com

Hi All,

Recently the tilegx defconfig was added to the linux-next build
coverage, which exposed this.
 
LD      .tmp_vmlinux1
`xfs_qm_exit' referenced in section `.init.text' of fs/built-in.o:
 defined in discarded section `.exit.text' of fs/built-in.o
make[1]: *** [.tmp_vmlinux1] Error 1

http://kisskb.ellerman.id.au/kisskb/buildresult/5941293/

It seemed odd to me, since I didn't think there was anything arch
specific in the init/exit sectioning, so I thought I'd mention it
here, just in case it hasn't been brought up before.

Thanks,
Paul.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
