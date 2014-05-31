Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D6C397F7E
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 09:51:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5B5B304051
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 07:51:52 -0700 (PDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	Phg0JiHsQbOMaiZk (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 31 May 2014 07:51:50 -0700 (PDT)
Received: by mail-wi0-f174.google.com with SMTP id r20so2521646wiv.1
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 07:51:49 -0700 (PDT)
Date: Sat, 31 May 2014 16:51:15 +0200
From: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Message-ID: <20140531145114.GA3721@localhost.localdomain>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
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

On Fri, May 30, 2014 at 10:01:24PM +0200, Arnd Bergmann wrote:
> 
> I picked this because it is a fairly isolated problem, as the
> inode time stamps are rarely assigned to any other time values.
> As a byproduct of this work, I documented for each of the file
> systems we support how long the on-disk format can work[1].

Why are some of the time stamp expiration dates marked as "never"?

Thanks,
Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
