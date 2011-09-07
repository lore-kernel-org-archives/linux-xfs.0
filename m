Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p876Zjer136220 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 01:35:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97BBB1E86E95
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2011 23:35:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	4LypiyfzSvaa3rNZ for <xfs@oss.sgi.com>;
	Tue, 06 Sep 2011 23:35:44 -0700 (PDT)
Date: Wed, 7 Sep 2011 02:35:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS frozen when moving file from one project quota to another
Message-ID: <20110907063542.GA12064@infradead.org>
References: <OF62081B23.59A4BF92-ONC1257903.003AB613-C1257903.003D9151@LocalDomain>
	<OFA406DB9E.729FBB28-ONC1257903.006155C9-C1257903.00672FA2@grpldc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <OFA406DB9E.729FBB28-ONC1257903.006155C9-C1257903.00672FA2@grpldc.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Boris.SANEGRE@agis-sa.fr
Cc: debian-user-french@lists.debian.org, debian-user@lists.debian.org, Salokine Terata <salokine.terata@free.fr>, xfs@oss.sgi.com

On Tue, Sep 06, 2011 at 08:47:04PM +0200, Boris.SANEGRE@agis-sa.fr wrote:
> 
> Hi,
> 
> I'm under Debian/Linux 5.0.8. I'm trying to move a file from one project
> quota to another one.

Which isn't allowed, but old kernels indeed did hang instead of properly
rejecting it.

Try backporting commit 6a0775a991d5597ce98f1e15373288ea133cc793

	[XFS] Fix hang after disallowed rename across directory quota domains

which went into Linux 2.6.30 (which is almost three years old)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
