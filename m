Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14A6C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFE362184D
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgEIRKP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:10:15 -0400
Received: from verein.lst.de ([213.95.11.211]:57514 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgEIRKP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 May 2020 13:10:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2F21468C7B; Sat,  9 May 2020 19:10:12 +0200 (CEST)
Date:   Sat, 9 May 2020 19:10:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] db: add a comment to agfl_crc_flds
Message-ID: <20200509171011.GA31656@lst.de>
References: <20200509170125.952508-1-hch@lst.de> <20200509170125.952508-4-hch@lst.de> <20200509170712.GQ6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509170712.GQ6714@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 10:07:12AM -0700, Darrick J. Wong wrote:
> On Sat, May 09, 2020 at 07:01:20PM +0200, Christoph Hellwig wrote:
> > Explain the bno field that is not actually part of the structure
> > anymore.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  db/agfl.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/db/agfl.c b/db/agfl.c
> > index 45e4d6f9..ce7a2548 100644
> > --- a/db/agfl.c
> > +++ b/db/agfl.c
> > @@ -47,6 +47,7 @@ const field_t	agfl_crc_flds[] = {
> >  	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
> >  	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
> >  	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
> > +	/* the bno array really is behind the actual structure */
> 
> Er... the bno array comes /after/ the actual structure, right?

Yes.  That's what I mean, but after seems to be less confusing.
