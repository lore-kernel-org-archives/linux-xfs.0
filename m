Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-sn1nam02on0134.outbound.protection.outlook.com ([104.47.36.134]:28256
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751773AbeFGWZ6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 18:25:58 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: Re: NULL pointer dereference in xfs_trans_binval() when mounting and
 operating a crafted xfs image
Date: Thu, 7 Jun 2018 22:25:56 +0000
Message-ID: <5627CC54-D26D-4946-BEAD-6770E7D8A883@gatech.edu>
References: <66348561-0B03-4CAE-893A-25161D66D6AF@gatech.edu>
 <fff2a2c8-b607-05ea-e97e-f53f054fb428@sandeen.net>
In-Reply-To: <fff2a2c8-b607-05ea-e97e-f53f054fb428@sandeen.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <393794DAA10E804387FA8B130D384F48@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

I tested the patch that works.

Thanks,
Wen

> On Jun 7, 2018, at 6:01 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> if (bp && (xfs_da_shrink_inode(args, 0, bp) != 0))

