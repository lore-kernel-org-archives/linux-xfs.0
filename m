Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 574E67F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 09:33:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4FECAC003
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 07:33:33 -0700 (PDT)
Received: from relay1.mentorg.com ([192.94.38.131]) by cuda.sgi.com with ESMTP
	id ojDchCIeNs7k5nGN (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 07:33:30 -0700 (PDT)
Date: Tue, 3 Jun 2014 14:33:10 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
In-Reply-To: <5011138.W0gbOc20Qp@wuerfel>
Message-ID: <Pine.LNX.4.64.1406031427130.12421@digraph.polyomino.org.uk>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<7175692.dpgYFMbTaP@wuerfel> <538CF346.2070504@zytor.com>
	<5011138.W0gbOc20Qp@wuerfel>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>, logfs@logfs.org, linux-afs@lists.infradead.org, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, lftan@altera.com, linux-btrfs@vger.kernel.org

On Tue, 3 Jun 2014, Arnd Bergmann wrote:

> I think John Stultz and Thomas Gleixner have already started looking
> at how the timekeeping code can be updated. Once that is done, we should
> be able to add a functional 64-bit gettimeofday/settimeofday syscall
> pair. While I definitely agree this is one of the most basic things to
> have, it's also not an area of the kernel that is easy to change.

64-bit clock_gettime / clock_settime instead of gettimeofday / 
settimeofday should avoid the need for the kernel to have a 64-bit version 
of struct timeval.  (Userspace 64-bit gettimeofday / settimeofday would 
need to use a combination of the syscalls if the tz pointer is non-NULL.)

-- 
Joseph S. Myers
joseph@codesourcery.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
