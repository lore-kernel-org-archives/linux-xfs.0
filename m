Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5340B29DF8
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 14:21:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EA679AC003
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 12:21:46 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	by cuda.sgi.com with ESMTP id eYbLiBP1FjClYlzr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 12:21:44 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Mon, 02 Jun 2014 21:19:55 +0200
Message-ID: <4233989.Saca0ocOUr@wuerfel>
In-Reply-To: <Pine.LNX.4.64.1406021350030.19591@digraph.polyomino.org.uk>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<Pine.LNX.4.64.1406021350030.19591@digraph.polyomino.org.uk>
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
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, hpa@zytor.com, logfs@logfs.org, linux-afs@lists.infradead.org, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, lftan@altera.com, linux-btrfs@vger.kernel.org

On Monday 02 June 2014 13:52:19 Joseph S. Myers wrote:
> On Fri, 30 May 2014, Arnd Bergmann wrote:
> 
> > a) is this the right approach in general? The previous discussion
> >    pointed this way, but there may be other opinions.
> 
> The syscall changes seem like the sort of thing I'd expect, although 
> patches adding new syscalls or otherwise affecting the kernel/userspace 
> interface (as opposed to those relating to an individual filesystem) 
> should go to linux-api as well as other relevant lists.

Ok. Sorry about missing linux-api, I confused it with linux-arch, which
may not be as relevant here, except for the one question whether we
actually want to have the new ABI on all 32-bit architectures or only
as an opt-in for those that expect to stay around for another 24 years.

Two more questions for you:

- are you (and others) happy with adding this type of stat syscall
  (fstatat64/fstat64) as opposed to the more generic xstat that has
  been discussed in the past and that never made it through the bike-
  shedding discussion?

- once we have enough buy-in from reviewers to merge this initial
  series, should we proceed to define rest of the syscall ABI
  (minus driver ioctls) so glibc and kernel can do the conversion
  on top of that, or should we better try to do things one syscall
  family at a time and actually get the kernel to handle them
  correctly internally?

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
