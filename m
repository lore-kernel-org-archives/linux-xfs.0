Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:57978 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfBVGUp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Feb 2019 01:20:45 -0500
Date: Fri, 22 Feb 2019 11:15:32 +0500
From: Roman Mamedov <rm@romanrm.net>
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190222111532.4ead81dc@natsu>
In-Reply-To: <yq17edsil17.fsf@oracle.com>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
        <20190217210948.GB14116@dastard>
        <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
        <20190220234723.GA5999@localhost.localdomain>
        <45c27fea-6d74-2adc-fe9d-e314ce4f3672@suse.com>
        <yq17edsil17.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Keith Busch <keith.busch@intel.com>, Ric Wheeler <ricwheeler@gmail.com>, Dave Chinner <david@fromorbit.com>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org

On Thu, 21 Feb 2019 22:01:24 -0500
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> Consequently, many of the modern devices that claim to support discard
> to make us software folks happy (or to satisfy a purchase order
> requirements) complete the commands without doing anything at all.
> We're simply wasting queue slots.

Any example of such devices? Let alone "many"? Where you would issue a
full-device blkdiscard, but then just read back old data.

I know only one model(PLEXTOR PX-512M6M) of dozens tested, which is peculiar
that it ignores trim specifically for the 1st sector of the entire disk. But
implying there are "many" which no-op it entirely, seems like imagining the
world already works like you would assume it to.

-- 
With respect,
Roman
