Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBEIaAgF011689
	for <linux-xfs@oss.sgi.com>; Sun, 14 Dec 2008 12:36:10 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 717591DF9F
	for <linux-xfs@oss.sgi.com>; Sun, 14 Dec 2008 10:36:09 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id uZX9nvVcxpgNNBSN for
	<linux-xfs@oss.sgi.com>; Sun, 14 Dec 2008 10:36:09 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Sun, 14 Dec 2008 19:35:36 +0100
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<1229225480.16555.152.camel@localhost>
	<18757.4606.966139.10342@tree.ty.sabi.co.uk>
	(sfid-20081214_183524_928808_CA8411E0)
In-Reply-To: <18757.4606.966139.10342@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812141935.36744.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com
Cc: Linux RAID <linux-raid@vger.kernel.org>

Am Sonntag 14 Dezember 2008 schrieb Peter Grandi:
> First of all, why are you people sending TWO copies to the XFS
> mailing list? (to both linux-xfs@oss.sgi.com and xfs@oss.sgi.com).
[...]
> > So its really more of an expectation that wc+barriers on,
> > performs better than wc+barriers off :)
>
> This is of course a misstatement: perhaps you intended to write
> that ''wc on+barriers on'' would perform better than ''wc off +
> barriers off'.

I think Redeeman said exactly that ;-). Either both on or both off.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
