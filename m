Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbdGYTWn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 15:22:43 -0400
Date: Tue, 25 Jul 2017 15:22:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170725192240.GA57022@bfoster.bfoster>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
 <20170706232803.GF17762@dastard>
 <20170707135009.68c22182@harpe.intellique.com>
 <20170707153633.GG4103@magnolia>
 <20170711152340.4cd5dff9@harpe.intellique.com>
 <20170717171129.GA57771@bfoster.bfoster>
 <20170724162728.2a77797a@harpe.intellique.com>
 <20170724145125.GA12097@bfoster.bfoster>
 <20170725191604.43a3691e@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170725191604.43a3691e@harpe.intellique.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

On Tue, Jul 25, 2017 at 07:16:04PM +0200, Emmanuel Florac wrote:
> Le Mon, 24 Jul 2017 10:51:25 -0400
> Brian Foster <bfoster@redhat.com> écrivait:
> 
> > There are several fixes in-flight for the issues uncovered by this
> > metadump. I think you'll want to include the following 3 patches to
> > xfsprogs:
> > 
> > http://marc.info/?l=linux-xfs&m=150047977108174&w=2
> > http://marc.info/?l=linux-xfs&m=150040481220074&w=2
> > http://marc.info/?l=linux-xfs&m=150040481820076&w=2
> > 
> 
> BTW to which branch do these apply?
> 
> For some reason I've tried xfs_repair 4.12 on another image I had tried
> 4.7 and 4.9 on, and... it seems to have repaired it. I'm trying to
> understand how that happened... 

I believe these should apply to for-next. FWIW, the error in your
previous mail looks like the one that is fixed by the latter two patches
above.

Brian

> 
> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------


