Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE56C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 15:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiEZPUy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 11:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiEZPUx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 11:20:53 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48EFB0D0E
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 08:20:51 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7616.dip0.t-ipconnect.de [93.221.118.22])
        by mail.itouring.de (Postfix) with ESMTPSA id 0ADC1124EC0;
        Thu, 26 May 2022 17:20:49 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id B06D3F01604;
        Thu, 26 May 2022 17:20:48 +0200 (CEST)
Subject: Re: XFS LTS backport cabal
To:     Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Shirley Ma <shirley.ma@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
References: <Yo6ePjvpC7nhgek+@magnolia> <Yo+WQl3OFsPMUAbl@google.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <6fab1a55-478d-a9bd-daa1-928f24e60389@applied-asynchrony.com>
Date:   Thu, 26 May 2022 17:20:48 +0200
MIME-Version: 1.0
In-Reply-To: <Yo+WQl3OFsPMUAbl@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022-05-26 17:01, Leah Rumancik wrote:
> This thread had good timing :) I have been working on setting up
> some automated testing. Currently, 5.15.y is our priority so I have
> started working on this branch.
> 
> Patches are being selected by simply searching for the “Fixes”
> tag and applying if the commit-to-be-fixed is in the stable branch,
> but AUTOSEL would be nice, so I’ll start playing around with that.
> Amir, it would be nice to sync up the patch selection process. I can
> help share the load, especially for 5.15.
> 
> Selecting just the tagged “Fixes” for 5.15.y for patches through
> 5.17.2, 15 patches were found and applied - if there are no
> complaints about the testing setup, I can go ahead and send out this
> batch:
> 
> c30a0cbd07ec xfs: use kmem_cache_free() for kmem_cache objects
> 5ca5916b6bc9 xfs: punch out data fork delalloc blocks on COW writeback failure
> a1de97fe296c xfs: Fix the free logic of state in xfs_attr_node_hasname
> 1090427bf18f xfs: remove xfs_inew_wait
> 089558bc7ba7 xfs: remove all COW fork extents when remounting readonly
> 7993f1a431bc xfs: only run COW extent recovery when there are no live extents
> 09654ed8a18c xfs: check sb_meta_uuid for dabuf buffer recovery
> f8d92a66e810 xfs: prevent UAF in xfs_log_item_in_current_chkpt
> b97cca3ba909 xfs: only bother with sync_filesystem during readonly remount
> eba0549bc7d1 xfs: don't generate selinux audit messages for capability testing
> e014f37db1a2 xfs: use setattr_copy to set vfs inode attributes
> 70447e0ad978 xfs: async CIL flushes need pending pushes to be made stable
> c8c568259772 xfs: don't include bnobt blocks when reserving free block pool
> cd6f79d1fb32 xfs: run callbacks before waking waiters in xlog_state_shutdown_callbacks
> 919edbadebe1 xfs: drop async cache flushes from CIL commits.

Please include:
9a5280b312e2 xfs: reorder iunlink remove operation in xfs_ifree

Thanks!
