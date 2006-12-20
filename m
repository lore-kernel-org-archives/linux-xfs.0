Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 08:04:10 -0800 (PST)
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBKG45qw012811
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 08:04:05 -0800
Message-ID: <45895EBA.8010208@sgi.com>
Date: Wed, 20 Dec 2006 16:03:06 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] rethink removal of xattr syscall stubs (for now)
References: <1166490658.5572.89.camel@edge>	 <20061219100506.GA22779@infradead.org> <1166571069.5572.117.camel@edge>
In-Reply-To: <1166571069.5572.117.camel@edge>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: Christoph Hellwig <hch@infradead.org>, bnaujok@sgi.com, xfs@oss.sgi.com, agruen@suse.de

Nathan Scott wrote:
> On Tue, 2006-12-19 at 10:05 +0000, Christoph Hellwig wrote:
> | > Please apply as an interim fix to the original problem and to
> | > the accidental new problems its caused, and I'll push through a
> | > new patch in the new year.
> | 
> | There is a way to re-export symbols you imported from another
> | library with symbol versioning.  That how for example libpthread
> | works on recent Solaris versions.  I'll find out how exactly that
> | should be implemented.
> 
> Ah, that sounds ideal - thanks!
> 

Nathan, do you still need your patch applied or will you look into
this new approach instead?

Lachlan
