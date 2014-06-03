Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EE5127F4E
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 09:50:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 869EFAC008
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 07:50:11 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13]) by
	cuda.sgi.com with ESMTP id kgGkOQCIarjdxy3c (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 07:50:10 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Tue, 03 Jun 2014 16:37:46 +0200
Message-ID: <18158267.ZX0ZMPkVDT@wuerfel>
In-Reply-To: <Pine.LNX.4.64.1406031427130.12421@digraph.polyomino.org.uk>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<5011138.W0gbOc20Qp@wuerfel>
	<Pine.LNX.4.64.1406031427130.12421@digraph.polyomino.org.uk>
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
To: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>, logfs@logfs.org, linux-afs@lists.infradead.org, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, lftan@altera.com, linux-btrfs@vger.kernel.org

On Tuesday 03 June 2014 14:33:10 Joseph S. Myers wrote:
> On Tue, 3 Jun 2014, Arnd Bergmann wrote:
> 
> > I think John Stultz and Thomas Gleixner have already started looking
> > at how the timekeeping code can be updated. Once that is done, we should
> > be able to add a functional 64-bit gettimeofday/settimeofday syscall
> > pair. While I definitely agree this is one of the most basic things to
> > have, it's also not an area of the kernel that is easy to change.
> 
> 64-bit clock_gettime / clock_settime instead of gettimeofday / 
> settimeofday should avoid the need for the kernel to have a 64-bit version 
> of struct timeval.  (Userspace 64-bit gettimeofday / settimeofday would 
> need to use a combination of the syscalls if the tz pointer is non-NULL.)

Yes, that's what I meant.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
