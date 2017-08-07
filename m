Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:54682 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751523AbdHGOE4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Aug 2017 10:04:56 -0400
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: Metadata corruption at xfs_attr3_leaf_write_verify()
Date: Mon, 07 Aug 2017 15:55:30 +0200
Message-ID: <4655939.aPg9oOrUOo@libor-nb>
In-Reply-To: <7AF4FEF16E034B868577B3ED535D5C41@alyakaslap>
References: <d161b07cad6536b0baf285328cf99500@mail.gmail.com> <20170801231839.GQ17762@dastard> <7AF4FEF16E034B868577B3ED535D5C41@alyakaslap>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Shyam Kaushik <shyam@zadarastorage.com>, bfoster@redhat.com, dchinner@redhat.com

Hello,
can this be related to our problems on 4.9.x kernel, we have started to see 
after starting to use ACL?

I have several crashes in this thread, it bites us usually once per month:
https://www.spinics.net/lists/linux-xfs/msg07058.html

Metadata buffer dump seems to be the same

Thanks,
Libor

On středa 2. srpna 2017 11:38:36 CEST Alex Lyakas wrote:
> Hello Dave,
> 
> Thank you for your analysis. It sounds like this issue exists in recent 
> kernels as well.
> 
> We are reviewing some of the paths that operate xfs_buf's, but still we 
> don't have enough understanding on how to properly lock out the xfs_buf from 
> AIL grabbing it. Can you please point us at similar flows, where such 
> locking is done?
> 
> Or otherwise, should you propose a patch to fix this, we can test it. If 
> possible, making the patch applicable to kernel 3.18.19 would be 
> appreciated. I realize that this is an EOL kernel, but still it used to be a 
> long-term kernel.
> 
> Thanks,
> Alex.
> 
> 
> 
> -----Original Message----- 
> From: Dave Chinner
> Sent: Wednesday, August 02, 2017 2:18 AM
> To: Alex Lyakas
> Cc: linux-xfs@vger.kernel.org ; Shyam Kaushik ; bfoster@redhat.com ; 
> dchinner@redhat.com
> Subject: Re: Metadata corruption at xfs_attr3_leaf_write_verify()
> 
> On Tue, Aug 01, 2017 at 08:30:31PM +0300, Alex Lyakas wrote:
> > Greetings XFS developers, David, Brian,
> >
> > We did additional debugging on this issue. The problematic flow
> > happens to be the following:
> >
> > - New inode (regular file) is being created.
> > - As part of creation, due to parent directory having a default ACL,
> > initial ACL is applied to the inode.
> > - This ACL is applied as an extended attribute with name
> > "SGI_ACL_FILE" and value length of 100 bytes.
> > - XFS tries to add this attribute into the inline inode attribute
> > fork area (AKA shortform).
> > - But 100 bytes is too large for the shortform, so XFS creates an
> > empty shortform and then calls xfs_attr_shortform_to_leaf()
> > - This calls xfs_attr3_leaf_create() and creates a leaf with zero
> > attributes.
> > - Before XFS is able to add the attribute to the leaf, the xfsaild
> > thread wants to write this leaf to disk, and trips over the assert
> > in xfs_attr3_leaf_verify, that ichdr.count should not be 0
> 
> Ok, this makes it pretty obvious as to what's going on here. The new
> attribute leaf buffer is not held locked across the transaction roll
> between the shortform->leaf modification and the addition of the new
> entry. As a result the attribute buffer modification being made is
> not atomic from an operational perspective. Hence the AIL push can
> grab it in the transient state of "just created" after the initial
> transaction is rolled because the buffer has been released.
> 
> Cheers,
> 
> Dave.
> 


--------
[1] mailto:libor.klepac@bcom.cz
[2] tel:+420377457676
[3] http://www.bcom.cz

