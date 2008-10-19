Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 02:05:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9J95rlL018997
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 02:05:53 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1195E7136D
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 02:07:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id IuNROHBIPP48jhpL for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 02:07:35 -0700 (PDT)
Date: Sun, 19 Oct 2008 05:07:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081019090702.GA1925@infradead.org>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <48F89E0F.6030307@sandeen.net> <20081018085752.GS25834@deprecation.cyrius.com> <20081019014830.GI31761@disturbed> <48FAA445.9050800@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FAA445.9050800@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Martin Michlmayr <tbm@cyrius.com>, Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com, kernel@wantstofly.org, Hiroki KUMAGAI <hiroki.kumagai@toshiba.co.jp>

On Sat, Oct 18, 2008 at 10:06:45PM -0500, Eric Sandeen wrote:
> This is probably the vmap cache aliasing problem that we paid a bit of
> attention to a few months ago, no?

Shouldn't the cachepolicy switch take care of that?  But yes, there
are various problems with I/O on vmap regions with virtually indexed
caches, see:

	http://www.spinics.net/lists/linux-arch/msg04301.html

	http://tree.celinuxforum.org/CelfPubWiki/JapanTechnicalJamboree21?action=AttachFile&do=get&target=celf_discussions.pdf

Actually, looking again at the second document it shows exactly the
symptoms you're seeing.


> 
> -Eric
> 
> 
---end quoted text---
