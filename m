Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAPMSaq2012357 for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 16:28:36 -0600
Received: from mail-bw0-f217.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBC6BD830B3
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 14:29:02 -0800 (PST)
Received: from mail-bw0-f217.google.com (mail-bw0-f217.google.com
	[209.85.218.217]) by cuda.sgi.com with ESMTP id
	7Ab0DiAUBoGx3uwn for <xfs@oss.sgi.com>;
	Wed, 25 Nov 2009 14:29:02 -0800 (PST)
Received: by bwz9 with SMTP id 9so149999bwz.12
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 14:29:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091125210611.GA12150@infradead.org>
References: <14274282.01258546868484.JavaMail.root@wombat>
	<4B041AEE.4040506@sandeen.net>
	<EE71107DF0D1F24FA2D95041E64AB9E8985A59F17F@IL-MB01.marvell.com>
	<4B096C6E.8010508@sandeen.net>
	<EE71107DF0D1F24FA2D95041E64AB9E8985A59F31F@IL-MB01.marvell.com>
	<alpine.DEB.2.00.0911251025490.28890@andydesk>
	<20091125210611.GA12150@infradead.org>
Date: Wed, 25 Nov 2009 14:29:00 -0800
Message-ID: <46b8a8850911251429g1fbd0036v129deb4f6cc7ab56@mail.gmail.com>
Subject: Re: XFS support for ARMv5
From: Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Andy Poling <andy@realbig.com>, Ofer Heifetz <oferh@marvell.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Nov 25, 2009 at 1:06 PM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> On Wed, Nov 25, 2009 at 10:30:09AM -0600, Andy Poling wrote:
>> On Mon, 23 Nov 2009, Ofer Heifetz wrote:
>>> Here is the dmesg I got for mount /dev/sda3 /mnt/usb:
>>> SGI XFS with ACLs, security attributes, large block/inode numbers, no d=
ebug enabled
>>> XFS mounting filesystem sda3
>>> Starting XFS recovery on filesystem: sda3 (logdev: internal)
>>> XFS: xlog_recover_process_data: bad clientid
>>> XFS: log mount/recovery failed: error 5
>>> XFS: log mount failed
>>
>> See this thread in the archives for a patch that may fix this:
>>
>> =A0 =A0 =A0 http://oss.sgi.com/pipermail/xfs/2009-October/042805.html
>
> I don't think it's the case you found, although the symptoms are the
> same. =A0I'd rather guess this is a case of an architecture with virtually
> indexed caches (can anyone confirm the cache architecture?) which

The Marvell 78xx series uses a VIVT cache. I will have to consult the
documentation about the 6281 (I think that was it).

> doesn't cope too well with the way we use vmap to write into a buffer
> through virtually mapped linear addresses, but then do block I/O using
> the physical addresses of the individual pages. =A0James Bottomley has a
> patchset to fix this issue by introducing APIs that allow the
> architecture specific memory management to cope with it. =A0He're a
> version I could quickly find, although newer ones have been posted
> since:
>
> =A0 =A0 =A0 =A0http://thread.gmane.org/gmane.linux.kernel.cross-arch/4364
>
> The patchset is planned to get merged into Linux 2.6.33.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



-- =

Regards,
Richard Sharpe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
