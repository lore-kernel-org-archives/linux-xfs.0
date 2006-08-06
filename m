Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Aug 2006 15:26:17 -0700 (PDT)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k76MQ3DW014627
	for <xfs@oss.sgi.com>; Sun, 6 Aug 2006 15:26:03 -0700
Date: Sun, 6 Aug 2006 23:22:11 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: XFS null files
Message-ID: <20060806212211.GA2154@teal.hq.k1024.org>
References: <83d59530608061232r21feab01j456c7d1fec742958@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83d59530608061232r21feab01j456c7d1fec742958@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Briggs <ephemeral.elusive@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Aug 06, 2006 at 08:32:49PM +0100, Jeff Briggs wrote:
> Hello.
> 
> I've just lost data to XFS, with the files full of nulls. I've found
> posts dating back over two years about such data losses. I'm using
> linux 2.6.17 with xfsprogs 2.8.10.
FWIW, I've never lost files since disabling write cache on disks.
> 
> emacs claims to fsync on write, yet still I lost data, the faq
> suggests I should not have if this is so?
Have you disabled the write cache of your storage, or is your storage
battery-backed?

Iustin Pop
