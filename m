Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C37EE7F92
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 10:39:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5D3AFAC003
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 08:39:35 -0700 (PDT)
Received: from mail-we0-f170.google.com (mail-we0-f170.google.com
	[74.125.82.170]) by cuda.sgi.com with ESMTP id 8OcVQnYnBKyAvzr0
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 17 Mar 2014 08:39:33 -0700 (PDT)
Received: by mail-we0-f170.google.com with SMTP id w61so4765222wes.29
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 08:39:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ea0e10e64a65dbd39cd71a826e18985e@zbfmail.de>
References: <ea0e10e64a65dbd39cd71a826e18985e@zbfmail.de>
Date: Mon, 17 Mar 2014 16:39:31 +0100
Message-ID: <CAFLt3pg256f7iNnYtZVu6dfQ=Z5rq3Aum_zWjGk571fHA4By-w@mail.gmail.com>
Subject: Re: elevator question
From: Grozdan <neutrino8@gmail.com>
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
To: weber@zbfmail.de
Cc: Xfs <xfs@oss.sgi.com>

On Mon, Mar 17, 2014 at 4:35 PM, Marko Weber|8000 <weber@zbfmail.de> wrote:
>
> hello list,
> in the xfs faq i read elevator=noop is best when using ssd.
> i have the gentoo system on a ssd, but the larger data storage partition on
> softraid with some sata disks.
> is elevator=noop in this combo still best?
>
> thx for any cunstructive answer
>
> marko

noop and deadline are best for SSDs. deadline is best for spinning
disks with XFS, especially in RAID. Stay away from CFQ as it kills
parallelism in XFS

>
>
>
> --
> zbfmail - Mittendrin statt nur Datei!
>
> OpenDKIM, SPF, DSPAM, Greylisting, POSTSCREEN, AMAVIS, Mailgateways
> Mailfiltering, SMTP Service, Spam Abwehr, MX-Backup, Mailserver Backup
> Redundante Mailgateways, HA Mailserver, Secure Mailserver
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



-- 
Yours truly

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
