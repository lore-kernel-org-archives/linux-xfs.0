Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E1E617F8B
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 23:45:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 58D2CAC001
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 21:45:14 -0700 (PDT)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id 736dxsMtw8WRm1pd
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 31 May 2014 21:45:12 -0700 (PDT)
Received: by mail-wg0-f43.google.com with SMTP id l18so3603501wgh.2
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 21:45:11 -0700 (PDT)
Date: Sun, 1 Jun 2014 06:44:36 +0200
From: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Message-ID: <20140601044436.GC3722@localhost.localdomain>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<20140531145114.GA3721@localhost.localdomain>
	<6347520.8jMPlVsFjM@wuerfel>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6347520.8jMPlVsFjM@wuerfel>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, hpa@zytor.com, linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org, joseph@codesourcery.com, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, logfs@logfs.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lftan@altera.com, ocfs2-devel@oss.oracle.com

On Sat, May 31, 2014 at 05:23:02PM +0200, Arnd Bergmann wrote:
> On Saturday 31 May 2014 16:51:15 Richard Cochran wrote:
> > 
> > Why are some of the time stamp expiration dates marked as "never"?
> 
> It's an approximation:

Also, the term "never" might mean using arbitrarily long integers
as in ASN.1.

Thanks,
Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
