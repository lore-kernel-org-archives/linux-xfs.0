Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34646 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752983AbdHJVNC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 17:13:02 -0400
Date: Thu, 10 Aug 2017 14:12:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] fiemap: Allow to specify range to fiemap
Message-ID: <20170810211208.GY24087@magnolia>
References: <20170810120439.GO21024@dastard>
 <1502368241-8928-1-git-send-email-nborisov@suse.com>
 <20170810161322.GV24087@magnolia>
 <c254f712-e2bd-502b-515f-5ba20097bffd@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c254f712-e2bd-502b-515f-5ba20097bffd@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, sandeen@redhat.com

On Thu, Aug 10, 2017 at 07:46:35PM +0300, Nikolay Borisov wrote:
> 
> 
> On 10.08.2017 19:13, Darrick J. Wong wrote:
> > We don't decrement len each time through the ioctl loop?  Doesn't that
> > cause us to request and retrieve rows for ranges we don't want?
> 
> Hm, you are right, I believe on every iteration we should do:
> 
> len -= last_logical - start_offset

start_offset doesn't change, right?

I would think len -= last_logical - fiemap->fm_start.

Or just calculate end_offset = start_offset + length and set
fiemap->fm_length = end_offset - last_logical... 

...though now that I look at that file even closer I wonder what is
going on with that outer while loop counting extents?  Does -n exist to
let users cap the number of records to print, even if that means we
don't make it to the end of the range requested?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
