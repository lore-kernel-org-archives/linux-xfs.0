Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 65D2029DF8
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 13:58:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 324FA30404E
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 11:58:27 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id 45lOjsVy6UWjNWnG for
	<xfs@oss.sgi.com>; Mon, 02 Jun 2014 11:58:25 -0700 (PDT)
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<4178301.j9kWdGCRLC@wuerfel>
	<6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
Date: Mon, 02 Jun 2014 19:58:24 +0100
Message-Id: <1401735504.6065.227.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, LKML Kernel <linux-kernel@vger.kernel.org>, geert@linux-m68k.org, Christoph Hellwig <hch@infradead.org>, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lftan@altera.com, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com


On Mon, 2014-06-02 at 11:04 -0400, Chuck Lever wrote:

> NFSv2/3 timestamps are a pair of unsigned 32-bit values: one value for
> seconds since midnight GMT Jan 1, 1970, and one value for nanoseconds.
> (See the definition of nfstime3 in RFC 1813).
> 

nfstime3 could be extended by redefining the otherwise unused
nanoseconds bits{31,30} as seconds{33,32}, to give a (signed) 34-bit
seconds field and an unsigned 30-bit nanoseconds field.

This could represent 1970 +/- 272 years.

Servers could indicate they can understand the extended time format by
adding a new FSINFO capability - FSF3_CANSETTIME_EX.

Clients would use a new SET_TO_CLIENT_TIME_EX time_how enum when sending
timestamps so old servers would be protected from new clients.

Old clients don't need to be protected from new servers because the
on-the-wire bit pattern for dates between 1970 and 2106 stays the same,
so they're no worse off than they were before.

Arguably the new server ought to clamp out-of-range timestamps before
sending them to old clients but that would need per-client state (and
nfs3 is stateless.)

--
Roger


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
