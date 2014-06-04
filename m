Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 09F707F3F
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 10:06:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E36BA30406B
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 08:06:41 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	by cuda.sgi.com with ESMTP id ImLb3CHALbSNSMOC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jun 2014 08:06:40 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Wed, 4 Jun 2014 17:05:27 +0200
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<4233989.Saca0ocOUr@wuerfel>
	<Pine.LNX.4.64.1406022044090.27099@digraph.polyomino.org.uk>
In-Reply-To: <Pine.LNX.4.64.1406022044090.27099@digraph.polyomino.org.uk>
MIME-Version: 1.0
Message-Id: <201406041705.27599.arnd@arndb.de>
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

On Monday 02 June 2014, Joseph S. Myers wrote:
> On Mon, 2 Jun 2014, Arnd Bergmann wrote:
> 
> > Ok. Sorry about missing linux-api, I confused it with linux-arch, which
> > may not be as relevant here, except for the one question whether we
> > actually want to have the new ABI on all 32-bit architectures or only
> > as an opt-in for those that expect to stay around for another 24 years.
> 
> For glibc I think it will make the most sense to add the support for 
> 64-bit time_t across all architectures that currently have 32-bit time_t 
> (with the new interfaces having fallback support to implementation in 
> terms of the 32-bit kernel interfaces, if the 64-bit syscalls are 
> unavailable either at runtime or in the kernel headers against which glibc 
> is compiled - this fallback code will of course need to check for overflow 
> when passing a time value to the kernel, hopefully with error handling 
> consistent with whatever the kernel ends up doing when a filesystem can't 
> support a timestamp).  If some architectures don't provide the new 
> interfaces in the kernel then that will mean the fallback code in glibc 
> can't be removed until glibc support for those architectures is removed 
> (as opposed to removing it when glibc no longer supports kernels predating 
> the kernel support).

Ok, that's a good reason to just provide the new interfaces on all
architectures right away. Thanks for the insight!

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
