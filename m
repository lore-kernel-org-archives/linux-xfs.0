Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2211E7F3F
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 19:14:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE4AF8F8035
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 17:14:11 -0700 (PDT)
Received: from mail.zytor.com ([198.137.202.10]) by cuda.sgi.com with ESMTP id
	aa5BAQ2EoqBEqKks (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jun 2014 17:14:10 -0700 (PDT)
Message-ID: <538FB570.8000502@zytor.com>
Date: Wed, 04 Jun 2014 17:10:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<201406041703.47592.arnd@arndb.de>
	<alpine.LFD.2.11.1406041308300.17310@knanqh.ubzr>
	<8770583.6XeZxCxOY8@wuerfel>
In-Reply-To: <8770583.6XeZxCxOY8@wuerfel>
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
To: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org, "Joseph S. Myers" <joseph@codesourcery.com>, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, logfs@logfs.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lftan@altera.com, ocfs2-devel@oss.oracle.com

On 06/04/2014 12:24 PM, Arnd Bergmann wrote:
> 
> For other timekeeping stuff in the kernel, I agree that using some
> 64-bit representation (nanoseconds, 32/32 unsigned seconds/nanoseconds,
> ...) has advantages, that's exactly the point I was making earlier
> against simply extending the internal time_t/timespec to 64-bit
> seconds for everything.
> 

How much of a performance issue is it to make time_t 64 bits, and for
the bits there are, how hard are they to fix?

	-hpa


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
