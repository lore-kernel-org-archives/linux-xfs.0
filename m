Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53008 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753720AbeDSUBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Apr 2018 16:01:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3JK0rZQ022548
        for <linux-xfs@vger.kernel.org>; Thu, 19 Apr 2018 20:01:33 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2hdrxp1pm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 19 Apr 2018 20:01:33 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3JK1WGd024474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 19 Apr 2018 20:01:33 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3JK1WTE025043
        for <linux-xfs@vger.kernel.org>; Thu, 19 Apr 2018 20:01:32 GMT
Date: Thu, 19 Apr 2018 13:01:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] db: Stop core dumping on attr3 if block header is
 not recognized
Message-ID: <20180419200126.GB24738@magnolia>
References: <20180418094935.12495-1-cmaiolino@redhat.com>
 <20180418154435.GQ24738@magnolia>
 <20180419091302.coz4clrmr5ubdku2@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419091302.coz4clrmr5ubdku2@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Thu, Apr 19, 2018 at 11:13:02AM +0200, Carlos Maiolino wrote:
> On Wed, Apr 18, 2018 at 08:44:35AM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 18, 2018 at 11:49:35AM +0200, Carlos Maiolino wrote:
> > 
> > There are two possible magics for attr3 blocks -- this one, which is for
> > remote attr value blocks, and the xfs_da3_blkinfo magic for the attr
> > leaf and da node blocks.  Can you please fish out the second magic and
> > print that too?
> > 
> > Looks otherwise reasonable, and certainly better than the ASSERT.
> > 
> > --D
> > 
> 
> What do you think about this output. Using attr3 type trying to print a
> directory's leaf block.
> 
> xfs_db> type attr3
> Unknown attribute buffer type!
> xfs_db> p
> Unrecognized attr3 block, attempting to print magic numbers and/or blkinfo:
> Unrecognized attr3 block, attempting to print magic numbers and/or blkinfo:
> hdr.magic = 0
> hdr.info.hdr.forw = 0
> hdr.info.hdr.back = 0
> hdr.info.hdr.magic = 0x3df1

I like it better, though on further thought I think I like better the
idea of printing the contents of all potential magic numbers:

For a block starting with:

0xDE 0xAD 0xBE 0xEF 0xCA 0xFE 0xF0 0x0D 0xBA 0xAD...

xfs_db> p
Unrecognized attr3 block, attempting to print magic numbers and/or blkinfo:
unknown.blockhdr.magic = 0xDEADBEEF
unknown.da_blkinfo.magic = 0xBAAD
unknown.inode.magic = 0xDEAD

--D

> hdr.info.crc = 0x72e2e910 (correct)
> hdr.info.bno = 64
> hdr.info.lsn = 0x300002833
> hdr.info.uuid = 2b21796f-7f81-4cec-b583-968c55b7f4bb
> hdr.info.owner = 99
> xfs_db> 
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
