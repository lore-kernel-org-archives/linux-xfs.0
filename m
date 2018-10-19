Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:38488 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727170AbeJSUSL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Oct 2018 16:18:11 -0400
Date: Fri, 19 Oct 2018 23:12:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [QUESTION] multiple fsync() vs single sync()
Message-ID: <20181019121217.GN6311@dastard>
References: <6A65F394-C1BA-4339-AC9B-051885D12F65@corp.ovh.com>
 <20181017011624.GB6311@dastard>
 <0C4E81C1-739F-432E-88A3-C2B1E4B1A310@corp.ovh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0C4E81C1-739F-432E-88A3-C2B1E4B1A310@corp.ovh.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Romain Le Disez <romain.le-disez@corp.ovh.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Fri, Oct 19, 2018 at 08:16:27AM +0000, Romain Le Disez wrote:
> Thanks all for your answers, it is really helpful, I have now a clearer vision of how it works.
> 
> I have one last question.
> 
> If I’m in the process of creating 1000 files this way, but the server crashes before the syncfs() function was called, what will happen to the files that were already rename()/linkat()?

files up to a certain point will be there in order, data in those
files is likely to be missing. What files are there and what files
have data will be completely random.

i.e. you'll have a mess to clean up.

> Do they follow the same ordering, so I’m sure they are either complete (all data/xattr + xfs metadata) or not in the destination directory?
> 
> Or, is syncfs() the only way to ensure this ordering?

syncfs is like a bulk checkpoint. Until it completes, there are no
guarantees about anything. Only way to guarantee per file data
integrity and ordering is to use fsync.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
