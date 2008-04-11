Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 13:22:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3BKLiuN019567
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 13:21:45 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 164D812914B9
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 13:22:21 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id ukDKDc57msZlFGDn for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 13:22:21 -0700 (PDT)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam Firewall) with ESMTP id B2822538E81
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2008 05:47:54 +1000 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.3.1]) by postoffice2.aconex.com with ESMTP id CHCFR55sx6GWv1lw for <xfs@oss.sgi.com>; Sat, 12 Apr 2008 05:47:54 +1000 (EST)
Received: from mail.aconex.com (castle.yarra.acx [192.168.3.3])
	by postoffice.aconex.com (Postfix) with ESMTP id A315692C2AB
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2008 05:47:54 +1000 (EST)
Message-ID: <59537.192.168.3.1.1207943274.squirrel@mail.aconex.com>
In-Reply-To: <20080411164044.GA6928@ou.uhercice.ipv6ia.org>
References: <20080409184103.GD20142@album.bayer.ipv6ia.org>
    <20080409185445.GA30834@infradead.org> <47FF7D47.40007@thebarn.com>
    <20080411164044.GA6928@ou.uhercice.ipv6ia.org>
Date: Sat, 12 Apr 2008 05:47:54 +1000 (EST)
Subject: Re: Portability of libattr
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

> On Fri, Apr 11, 2008 at 10:01:27AM -0500, Russell Cattelan wrote:
>> I have not looked closely at the FreeBSD EA stuff so I don't know how
>> different things are. I can't imagine they are that far off?
>>
> Unfortunatelly, I have no FreeBSD machine available now, but as I found in
> its
> manual pages, they have splitted the names space and the rest of the EA
> name.
> The namespaces are enumerated. So you can't just call

This part (at least) is the same as the IRIX API (on IRIX the namespaces
are also enumerated).

> getxattr("user.mime_type', ...). Also they support reading EA from any
> arbitrarry offset like Darwin. (Linux reads from first byte always).
> FreeBSD
> API is little more rich.

Hmm, supporting that is a bit of an issue (do you need to?) - neither
IRIX nor Linux allow offsets for attrs.

>> I thought the libattr code does compile on IRIX. There was an effort at

libattr is providing a mapping between Linux (and potential other APIs)
and the IRIX libc API - so, there is no need for it to compile on IRIX.

> Great. Could you tell me which of these two APIs are the standard
> interface?

libattr exports the IRIX interface.  There are no standards here.

> I'm a little confused about all the Linux code in libattr (like syscall
> numbers) because glibc-2.6.1 has already syscall wrappers. So If added

libattr predates the libc interfaces.

> support
> for Darwin of FreeBSD into libattr, which level should I implement?
> attr_get(3) or getxattr(2/3) which is still parto of libattr? In other
> words:
> Should I implement IRIX-styled API or the Linux-styled one?

I'd suggest IRIX style, since I expect that will be closer to other
platforms,
and was the original intent with libattr.  I imagine the biggest problem will
be the list operation, that is by far the most complex (and wierd, on IRIX).

cheers.

--
Nathan
