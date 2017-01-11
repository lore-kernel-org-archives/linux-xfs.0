Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:21673 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759053AbdAKRyS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 12:54:18 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0BHrna8018877
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 17:53:49 GMT
Date: Wed, 11 Jan 2017 09:52:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Reading about CoW architecture / Performance Limits
Message-ID: <20170111175211.GU14038@birch.djwong.org>
References: <BC894F29-47E7-47A3-93FB-3E4EEE1DCDD5@flyingcircus.io>
 <20170110074524.GI14038@birch.djwong.org>
 <C97BB12C-3C30-493B-BE9A-9E8C7CB5D1A4@flyingcircus.io>
 <9713E613-6953-4AD3-89B1-C0EF639E771C@flyingcircus.io>
 <20170111080544.GB5883@birch.djwong.org>
 <20170111091011.GA29454@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170111091011.GA29454@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Christian Theune <ct@flyingcircus.io>, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 01:10:11AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 11, 2017 at 12:05:44AM -0800, Darrick J. Wong wrote:
> > > 3. There appears to be code that allows retroactively creating CoW for
> > > two files that existed separately before. Is that (planned to be)
> > > exposed to userland?
> > 
> > No plans for that at the moment.  There used to be a debugging knob, but
> > it was ripped out before upstreaming the code.
> 
> I think he's asking for the dedup ioctl, which is supported.

Ah, that could be the case.  If you were asking about deduplication,
then yes, XFS supports that too.  duperemove supports XFS since August.
Some of the newer dedup tools that also want the space map (bees) might
support XFS once we get GETFSMAP working.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
