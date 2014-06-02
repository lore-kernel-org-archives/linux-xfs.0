Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8FD5029DF8
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 14:05:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 30D00AC004
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 12:05:37 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id JJxKbR3EnECUFhva (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 12:05:35 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <1401735504.6065.227.camel@montana.filmlight.ltd.uk>
Date: Mon, 2 Jun 2014 15:04:27 -0400
Message-Id: <C57EA6CA-236A-4C93-95F8-21F46A3622DA@oracle.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<4178301.j9kWdGCRLC@wuerfel>
	<6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
	<1401735504.6065.227.camel@montana.filmlight.ltd.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, LKML Kernel <linux-kernel@vger.kernel.org>, geert@linux-m68k.org, Christoph Hellwig <hch@infradead.org>, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lftan@altera.com, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com


On Jun 2, 2014, at 2:58 PM, Roger Willcocks <roger@filmlight.ltd.uk> wrote:

> =

> On Mon, 2014-06-02 at 11:04 -0400, Chuck Lever wrote:
> =

>> NFSv2/3 timestamps are a pair of unsigned 32-bit values: one value for
>> seconds since midnight GMT Jan 1, 1970, and one value for nanoseconds.
>> (See the definition of nfstime3 in RFC 1813).
>> =

> =

> nfstime3 could be extended by redefining the otherwise unused
> nanoseconds bits{31,30} as seconds{33,32}, to give a (signed) 34-bit
> seconds field and an unsigned 30-bit nanoseconds field.
> =

> This could represent 1970 +/- 272 years.
> =

> Servers could indicate they can understand the extended time format by
> adding a new FSINFO capability - FSF3_CANSETTIME_EX.
> =

> Clients would use a new SET_TO_CLIENT_TIME_EX time_how enum when sending
> timestamps so old servers would be protected from new clients.

You would have to get the IETF=92s NFSv4 working group to sign off on
this change. Otherwise, Linux would be the only NFSv3 implementation
that supports the extension.

But I suspect the answer you=92d get is =93Use NFSv4.=94

> Old clients don't need to be protected from new servers because the
> on-the-wire bit pattern for dates between 1970 and 2106 stays the same,
> so they're no worse off than they were before.
> =

> Arguably the new server ought to clamp out-of-range timestamps before
> sending them to old clients but that would need per-client state (and
> nfs3 is stateless.)

There=92s no reliable way in NFSv3 for clients and servers to identify
the software running on the peer.

Practically speaking, you should assume that the NFSv3 protocol is never
going to change.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
