Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:39387 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbeDSJNH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Apr 2018 05:13:07 -0400
Received: by mail-wr0-f176.google.com with SMTP id q3-v6so1945605wrj.6
        for <linux-xfs@vger.kernel.org>; Thu, 19 Apr 2018 02:13:06 -0700 (PDT)
Date: Thu, 19 Apr 2018 11:13:02 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC PATCH] db: Stop core dumping on attr3 if block header is
 not recognized
Message-ID: <20180419091302.coz4clrmr5ubdku2@odin.usersys.redhat.com>
References: <20180418094935.12495-1-cmaiolino@redhat.com>
 <20180418154435.GQ24738@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418154435.GQ24738@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 18, 2018 at 08:44:35AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 18, 2018 at 11:49:35AM +0200, Carlos Maiolino wrote:
> 
> There are two possible magics for attr3 blocks -- this one, which is for
> remote attr value blocks, and the xfs_da3_blkinfo magic for the attr
> leaf and da node blocks.  Can you please fish out the second magic and
> print that too?
> 
> Looks otherwise reasonable, and certainly better than the ASSERT.
> 
> --D
> 

What do you think about this output. Using attr3 type trying to print a
directory's leaf block.

xfs_db> type attr3
Unknown attribute buffer type!
xfs_db> p
Unrecognized attr3 block, attempting to print magic numbers and/or blkinfo:
Unrecognized attr3 block, attempting to print magic numbers and/or blkinfo:
hdr.magic = 0
hdr.info.hdr.forw = 0
hdr.info.hdr.back = 0
hdr.info.hdr.magic = 0x3df1
hdr.info.crc = 0x72e2e910 (correct)
hdr.info.bno = 64
hdr.info.lsn = 0x300002833
hdr.info.uuid = 2b21796f-7f81-4cec-b583-968c55b7f4bb
hdr.info.owner = 99
xfs_db> 

-- 
Carlos
