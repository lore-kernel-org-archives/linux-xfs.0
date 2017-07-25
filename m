Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51907 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750861AbdGYNnl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2017 09:43:41 -0400
Date: Tue, 25 Jul 2017 06:43:34 -0700
From: Greg KH <greg@kroah.com>
Subject: Re: request for inclusion of 04197b341f23 ("xfs: don't BUG() on
 mixed direct and mapped I/O")
Message-ID: <20170725134334.GC19075@kroah.com>
References: <5bcfc94b-ecb9-468b-78f3-ae5de53f62a0@suse.com>
 <666c5faf-cbee-f83b-90bf-279284f0600b@applied-asynchrony.com>
 <18dc98f7-abd8-4925-a303-7ae4c1e46db5@suse.com>
 <20170725134221.GB19075@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170725134221.GB19075@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>, stable@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Tue, Jul 25, 2017 at 06:42:21AM -0700, Greg KH wrote:
> On Tue, Jul 25, 2017 at 01:44:30PM +0300, Nikolay Borisov wrote:
> > 
> > 
> > On 25.07.2017 13:43, Holger Hoffstätte wrote:
> > > On 07/25/17 08:47, Nikolay Borisov wrote:
> > >> I'd like to request the aforementioned patch to be included into stable
> > >> kernels. I've attached the 4.4 backport, the patch got introduced in
> > >> 4.10 so for 4.9 it will likely be able to apply cleanly, for 4.4 it
> > >> needed a bit of adjustment.
> > > 
> > > It has been in 4.9-stable since January, see:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/fs/xfs?h=linux-4.9.y&id=3978c5bb004312fd267aed7279fe64b119e126b0
> > > 
> > 
> > Strange, it's missing a stable tag
> 
> What does that have to do with anything?  Lots of patches get asked to
> be included that don't have stable tags, just like you just did :)
> 
> Also, please always include the original git commit id of the patch you
> wish to have included with your request so that I don't have to turn
> around and ask for it...

Ah nevermind, it was in the subject, I haven't had my morning coffee
yet...
