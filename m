Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49855 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751219AbeC0HGl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:06:41 -0400
Date: Tue, 27 Mar 2018 09:06:37 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180327070637.GX5652@dhcp22.suse.cz>
References: <20171123060137.GL2135@magnolia>
 <20180323013037.GA9190@wotan.suse.de>
 <20180323034145.GH4818@magnolia>
 <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia>
 <20180323182302.GB9190@wotan.suse.de>
 <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Sasha Levin <alexander.levin@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Joerg Roedel <joro@8bytes.org>

On Mon 26-03-18 19:54:31, Sasha Levin wrote:
[...]
> About half a year ago. I'm not sure about the no visibility part -
> maintainers and authors would receive at least 3 mails for each patch
> that got in this way, and would have at least a week (usually a lot
> more) to object to the inclusion. Did you not receive any mails from
> me?

Well, I was aware of your emails yet my free time didn't really allow me
to follow those patch bombs. I responded only when some email subject
hit my eyes as being non-stable candidate. So by no means the MM
backports were reviewed by me. And considering how hard it is to get any
review for MM patches in general I strongly suspect that others didn't
review either.

In general I am quite skeptical about the automagic backports
selections, to be honest. MM patches should be reasonably good at
selecting stable backports and adding more patches on top just risks
regressions. 
-- 
Michal Hocko
SUSE Labs
