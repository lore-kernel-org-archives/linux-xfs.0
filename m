Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56543 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbeC1NVu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 09:21:50 -0400
Date: Wed, 28 Mar 2018 15:21:48 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180328132148.GN9275@dhcp22.suse.cz>
References: <20171123060137.GL2135@magnolia>
 <20180323013037.GA9190@wotan.suse.de>
 <20180323034145.GH4818@magnolia>
 <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia>
 <20180323182302.GB9190@wotan.suse.de>
 <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
 <20180327070637.GX5652@dhcp22.suse.cz>
 <20180327195435.GE9190@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180327195435.GE9190@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Sasha Levin <alexander.levin@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Joerg Roedel <joro@8bytes.org>

On Tue 27-03-18 19:54:35, Luis R. Rodriguez wrote:
> On Tue, Mar 27, 2018 at 09:06:37AM +0200, Michal Hocko wrote:
> > So by no means the MM backports were reviewed by me. And considering how hard
> > it is to get any review for MM patches in general I strongly suspect that
> > others didn't review either.
> > 
> > In general I am quite skeptical about the automagic backports
> > selections, to be honest. MM patches should be reasonably good at
> > selecting stable backports and adding more patches on top just risks
> > regressions. 
> 
> BTW other than suggesting we needing *actual review* of the MM patches, are
> there known unit tests which could be run as well? Thinking long term.

There are some in selftests but most fixes are quite hard to get a
specialized testcase for. Rememeber the MM is a pile of heuristics to
handle large scale of workloads.

-- 
Michal Hocko
SUSE Labs
