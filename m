Return-Path: <SRS0=f2ny=WU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8851BC3A59E
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 18:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 540242146E
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 18:22:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K7wA1TIe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfHXSWV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Aug 2019 14:22:21 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38377 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfHXSWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Aug 2019 14:22:20 -0400
Received: by mail-ed1-f68.google.com with SMTP id r12so19267202edo.5
        for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2019 11:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/EhXhtaUxzf4oseLQfvfYW4uzgJmnnz0WaI2yCRiIoc=;
        b=K7wA1TIed3iZFGrlZQslNqwLx5DPbp5xRGcbkpoK/2noewuQmO/7KgdKmBUET+UQ+T
         F//6r3W0kCv5cmwhGKFdWFoJIXWWX4wxGYJKKfxn444BMo7QmeNUtHzWEf+iV9GtOBW1
         FfOo7wSGrH2nYWV74Fx7mc8rnExiIFnwNA+SxwtEs7BFcSYnsuJgtfnGt3GeTHLt06UC
         PeJcPUUq/EH1AnQw+te98hHj2xXF23TTwBTkiLDUMnzLs2ySz3EeeaWOLmFa+1prtmCS
         QaI2vRWeWWFgUNc5i0JmGPap69hMpU6MtcHj14SX3uKUV1on8WA+D4uvymQKWVRVZHn9
         isgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=/EhXhtaUxzf4oseLQfvfYW4uzgJmnnz0WaI2yCRiIoc=;
        b=DubrpuYSqMaqUGh0Oj6Y8VOl4IasHCZvwyznfh0VgF82hSXy5uRjAZQAnZU3ppJFKu
         xlljsSs6n47v4DyN9uGmy32xRu6DEGeDEpTzQikwn+AwmUlcU2Yz2YA0+vOod5cKSfpP
         yimqZfxpXBEStA5k+pYT7S8FjOcGGjqyOVOsLPR6XfDkixksO9H7QgSHB14o9YMgapH5
         6Q73107BKRslzwjpBPib96uxdm08LHCU2YsmIAv2Xz4M6I0938jjxK5XaJRXOiCr//8t
         bEUfqpboxkccVGfkWm7UtY/z75TbSd6gAqpio0eBMgU/KTJKqllHvUAeKwmYZuhR/2ef
         sQow==
X-Gm-Message-State: APjAAAWVY0WT2AUAorbnRTHfDqIzno2CvPWTyMOY8U9qFBkagbIMXIVH
        smZcsUiEu9GD3+VSEybpSdrr+8buDrE=
X-Google-Smtp-Source: APXvYqyySD+DOyHLuK3VLyIIHvO0XQUwCG5QGtccItxh3xWs3xyTIQ0A7snXhVVAE37HYMjVx8pgag==
X-Received: by 2002:a50:94cc:: with SMTP id t12mr10773187eda.274.1566670939054;
        Sat, 24 Aug 2019 11:22:19 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id ch24sm1397990ejb.3.2019.08.24.11.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2019 11:22:16 -0700 (PDT)
Date:   Sat, 24 Aug 2019 20:22:14 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix missing ILOCK unlock when xfs_setattr_nonsize
 fails due to EDQUOT
Message-ID: <20190824182214.GA5343@eldamar.local>
References: <20190823035528.GH1037422@magnolia>
 <CAHk-=wiE1zyj89=gpoCn8L0hy8WpS68s+13GOsHQ5Eq3DPWqEw@mail.gmail.com>
 <20190823192612.GB8736@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823192612.GB8736@eldamar.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Fri, Aug 23, 2019 at 09:26:12PM +0200, Salvatore Bonaccorso wrote:
> Hi Linus,
> 
> On Fri, Aug 23, 2019 at 09:28:42AM -0700, Linus Torvalds wrote:
> > On Thu, Aug 22, 2019 at 8:55 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > ...which is clearly caused by xfs_setattr_nonsize failing to unlock the
> > > ILOCK after the xfs_qm_vop_chown_reserve call fails.  Add the missing
> > > unlock.
> > 
> > Thanks for the quick fix.
> > 
> > I assume there's no real embargo on this, and we can just add it asap
> > to the xfs tree and mark it for stable, rather than do anything
> > outside the usual development path?
> > 
> > The security list rules do allow for a 5-working-day delay, but this
> > being "just" a local DoS thing I expect nobody really will argue for
> > it.
> > 
> > Anybody?
> 
> Agreed, there is no real embargo on this, it is public anyway on the
> xfs list and actually we just wanted to be on the safe side by asking
> or bringing it to security@k.o.
> 
> Thanks for the quick fix.

Not changing my mind on the above, given the fixing commit is public.

But thinking a bit more on it, I guess this should not considered
local DoS only. If the filesystem is exosed then a remote user might
trigger it serverside.

The issue could be reproduced on a NFS exported XFS as well. Just
export the filesystem rw to another host via NFS and mount it there. A
local user on the client could then trigger the issue on the server as
well.

Regards,
Salvatore
