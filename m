Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF2987F6F
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 04:57:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CBF5F8F8068
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 02:57:16 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
	by cuda.sgi.com with ESMTP id ZAVnBqhxmhYqWsHq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Jun 2014 02:57:14 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Tue, 10 Jun 2014 11:54:14 +0200
Message-ID: <10173877.4plnjUiyX8@wuerfel>
In-Reply-To: <538FB570.8000502@zytor.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8770583.6XeZxCxOY8@wuerfel> <538FB570.8000502@zytor.com>
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
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, hch@infradead.org, linux-mtd@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org, "Joseph S. Myers" <joseph@codesourcery.com>, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, logfs@logfs.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lftan@altera.com, ocfs2-devel@oss.oracle.com

On Wednesday 04 June 2014 17:10:24 H. Peter Anvin wrote:
> On 06/04/2014 12:24 PM, Arnd Bergmann wrote:
> > 
> > For other timekeeping stuff in the kernel, I agree that using some
> > 64-bit representation (nanoseconds, 32/32 unsigned seconds/nanoseconds,
> > ...) has advantages, that's exactly the point I was making earlier
> > against simply extending the internal time_t/timespec to 64-bit
> > seconds for everything.
> > 
> 
> How much of a performance issue is it to make time_t 64 bits, and for
> the bits there are, how hard are they to fix?

Probably very little overhead for most uses, it's more the regression
potential in the less common parts of the kernel I'm worried about.

There is a significant but not overwhelming number of uses of the
main problematic types in the kernel:

arnd@wuerfel:~/arm-soc$ git grep -wl time_t | wc
    188     188    5566
arnd@wuerfel:~/arm-soc$ git grep -wl timeval | wc
    320     320   10353
arnd@wuerfel:~/arm-soc$ git grep -wl timespec | wc
    406     406   10886

I believe we have to audit all of them anyway if we want to change
the kernel to less problematic types and introduce new user
interfaces.

IMHO this work is helped if we change the uses to a new type
as we find the problems. This lets us do the work one subsystem
at a time and avoid accidental ABI changes. I don't care much what
type that will be, and having a 96-bit type will certainly work
well in a lot of cases, but I don't see a strong reason to use
that over other types, especially when they can be more efficient.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
