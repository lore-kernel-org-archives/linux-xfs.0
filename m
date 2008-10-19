Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 09:21:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9JGL2Oq029941
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 09:21:04 -0700
Received: from xi.wantstofly.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C6D6AC759A
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 09:22:46 -0700 (PDT)
Received: from xi.wantstofly.org (xi.wantstofly.org [83.160.184.112]) by cuda.sgi.com with ESMTP id 8I82uRa9ShPx5O2U for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 09:22:46 -0700 (PDT)
Date: Sun, 19 Oct 2008 18:22:44 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081019162244.GF4129@xi.wantstofly.org>
References: <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <48F89E0F.6030307@sandeen.net> <20081018085752.GS25834@deprecation.cyrius.com> <20081019014830.GI31761@disturbed> <48FAA445.9050800@sandeen.net> <20081019090702.GA1925@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081019090702.GA1925@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Martin Michlmayr <tbm@cyrius.com>, Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com, Hiroki KUMAGAI <hiroki.kumagai@toshiba.co.jp>

On Sun, Oct 19, 2008 at 05:07:02AM -0400, Christoph Hellwig wrote:

> > This is probably the vmap cache aliasing problem that we paid a bit of
> > attention to a few months ago, no?
> 
> Shouldn't the cachepolicy switch take care of that?

Setting cachepolicy=uncached should make aliasing issues disappear.
If you're still seeing issues with cachepolicy=uncached, it's likely
some other issue.
