Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A492BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 14:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiCQOvs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 10:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbiCQOvr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 10:51:47 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10858202144
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 07:50:29 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 22HEoKwb006508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 10:50:20 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 1F70315C3EA9; Thu, 17 Mar 2022 10:50:20 -0400 (EDT)
Date:   Thu, 17 Mar 2022 10:50:20 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        "Spraul Manfred (XC/QMM21-CT)" <Manfred.Spraul@de.bosch.com>
Subject: Re: Metadata CRC error detected at
 xfs_dir3_block_read_verify+0x9e/0xc0 [xfs], xfs_dir3_block block 0x86f58
Message-ID: <YjNKrGcR3++izffK@mit.edu>
References: <613af505-7646-366c-428a-b64659e1f7cf@colorfullife.com>
 <20220313224624.GJ3927073@dread.disaster.area>
 <8024317e-07be-aa3d-9aa3-2f835aaa1278@colorfullife.com>
 <3242ad20-0039-2579-b125-b7a9447a7230@colorfullife.com>
 <20220317024705.GY3927073@dread.disaster.area>
 <20220317030828.GZ3927073@dread.disaster.area>
 <21c13283-2a9f-4978-25e4-228e44ab74e6@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21c13283-2a9f-4978-25e4-228e44ab74e6@colorfullife.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 07:49:02AM +0100, Manfred Spraul wrote:
> 
> > > BTRFS and ZFS can also detect torn writes, and if you use the
> > > (non-default) ext4 option "metadata_csum" it will also detect torn
> > Correction - metadata_csum is ienabled by default, I just ran the
> > wrong mkfs command when I tested it a few moments ago.
> 
> For ext4, I have seen so far only corrupted commit blocks that cause mount
> failures.
> 
> https://lore.kernel.org/all/8fe067d0-6d57-9dd7-2c10-5a2c34037ee1@colorfullife.com/

Ext4 uses FUA writes (if available) to write out the commit block.  If
a FUA write can result in torn writes, in my opinion that's a bug with
the storage device, or if eMMC devices don't respect FUA writes
correctly, then we should just disable FUA writes entirely.

In the absence of FUA, ext4 does assume that we can write out the
commit block as a 4k write, and then issue a cache flush.  If your
simulator assumes that the 4k write can be torn, on the assumption
that there is a narrow race between the issuance of the 4k write, the
device writing 1-3 512 byte sectors, and then due to a power failure,
the cache flush doesn't complete and the result is a torn write ---
quite frankly, I'm not sure how any system using checksums can deal
with that situation.  I think we can only assume that that case is in
reality quite rare, even if it's technically allowed by the spec.

	      	    	    	 - Ted
