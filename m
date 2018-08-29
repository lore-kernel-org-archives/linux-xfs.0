Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:52868 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbeH2GfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Aug 2018 02:35:01 -0400
Date: Tue, 28 Aug 2018 19:40:25 -0700
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Trying to write to read-only block-device from XFS
Message-ID: <20180829024013.ptprd7o3h3o6j2m2@two.firstfloor.org>
References: <20180824233756.kkvmkmm5mdlx77je@two.firstfloor.org>
 <a4d32107-abc0-60d3-8306-b091fbffefd8@sandeen.net>
 <20180825140951.a3dsz3efwnjsj2pz@two.firstfloor.org>
 <c6bcbef0-0c5b-a7a1-adb6-38085db98ce9@sandeen.net>
 <20180827081254.zat4lvxqviwgd4zn@odin.usersys.redhat.com>
 <20180827164342.4vlg3zaehkzcj6od@two.firstfloor.org>
 <20180828075420.5zcww22du3kqkvmq@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180828075420.5zcww22du3kqkvmq@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Aug 28, 2018 at 09:54:20AM +0200, Carlos Maiolino wrote:
> > 
> > Ok, so the blame is assigned, but the question is still how to avoid the
> > warning:
> 
> I'd say, unless you are using a volume manager that is doing something weird,
> which essentially LVM did by keep writing to RO volumes for snapshots, you

I don't use any snapshots.

> should avoid the warning by checking why your device went into RO mode and
> fix it.

You seem to be very confused about the purpose of kernel warnings.

Users should never be able to cause warnings by any action. 
It's always a software bug of some sort.

-Andi
