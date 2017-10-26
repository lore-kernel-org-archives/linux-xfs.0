Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:12487 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751305AbdJZXFT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 19:05:19 -0400
Date: Thu, 26 Oct 2017 17:09:58 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH] xfsprogs: Issue smaller discards at mkfs
Message-ID: <20171026230958.GB30535@localhost.localdomain>
References: <20171026144131.26885-1-keith.busch@intel.com>
 <20171026162518.GW5483@magnolia>
 <3ad1751a-a4df-b0ee-d2c5-d1ac4deb5b46@sandeen.net>
 <0d50ca3b-0b27-8ac1-c102-9ea656f3f926@sandeen.net>
 <20171026183216.GA27317@localhost.localdomain>
 <20171026195923.GB5483@magnolia>
 <20171026212414.GA30535@localhost.localdomain>
 <20171026222450.GD3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026222450.GD3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Fri, Oct 27, 2017 at 09:24:50AM +1100, Dave Chinner wrote:
> And that's just broken when it comes to requests that might take
> several seconds to run.  This is a problem the kernel needs to fix -
> it's not something we should be working around in userspace.

Yeah, I agree that'd be a better thing to do, and achieve the desired
impact for every user. We currently don't have an indicator the kernel
can react to for this scenario, but I'll reinvestigate from the driver
and kernel side for more options.
