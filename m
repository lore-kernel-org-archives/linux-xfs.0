Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3AFB77F8B
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 23:46:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E6B5C304039
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 21:46:44 -0700 (PDT)
Received: from mail-we0-f175.google.com (mail-we0-f175.google.com
	[74.125.82.175]) by cuda.sgi.com with ESMTP id mvlf7pELkGeq3xmu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 31 May 2014 21:46:43 -0700 (PDT)
Received: by mail-we0-f175.google.com with SMTP id p10so3646084wes.20
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 21:46:41 -0700 (PDT)
Date: Sun, 1 Jun 2014 06:46:09 +0200
From: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Message-ID: <20140601044609.GD3722@localhost.localdomain>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<20140531145114.GA3721@localhost.localdomain>
	<6347520.8jMPlVsFjM@wuerfel>
	<20140531182237.GA5382@localhost.localdomain>
	<57071155-5a08-4579-9189-92d442cd65e7@email.android.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57071155-5a08-4579-9189-92d442cd65e7@email.android.com>
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
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org, joseph@codesourcery.com, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, codalist@TELEMANN.coda.cs.cmu.edu, Arnd Bergmann <arnd@arndb.de>, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, logfs@logfs.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lftan@altera.com, ocfs2-devel@oss.oracle.com

On Sat, May 31, 2014 at 12:34:12PM -0700, H. Peter Anvin wrote:
> Typically they are using 64-bit signed seconds.

Okay, that is what I wanted to know.

Thanks,
Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
