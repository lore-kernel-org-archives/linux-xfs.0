Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B7CC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 16:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344606AbjKIQlm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344754AbjKIQkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 11:40:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F184220
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 08:38:56 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D44C433C9;
        Thu,  9 Nov 2023 16:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699547936;
        bh=bkdMTVjQse1cJXkwlSeNrJqtIRuV61o2Whlzq2oeE+Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s3+xz+5ul0Jj/Lh+TRvXzZR8fl7Joi2xybHVBz4kCxHVi+cadXR+dkOb9l0F8oHPg
         1CWv/fBoCE8eEcggDkvQkvkQ/BzLIdU+WpSu58xtqMcqsOPMwwALpuqvioF2XW9+m5
         xwXyEqSKGC6JRQQx1ha+OqR0KH6qXJ2vMbkWwquYCfdHbS3F7PAvbg8dekjKVQ5qzQ
         xtsLzcSZvEBw3k7+uYsjhSueqDHAcryd+pu9rDLJY6OiUglInF0uiXRu1oyFFeCTnT
         84t1/97BMtaGROE8TDNHdE3p/3LYjjaRUVYaOnl7IYlx2TZOqF+6ppVHAulv594EG2
         z6QR36lGul8dw==
Date:   Thu, 9 Nov 2023 08:38:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Chandan Babu R <chandanbabu@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        catherine.hoang@oracle.com, cheng.lin130@zte.com.cn,
        dchinner@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, osandov@fb.com
Subject: Re: [GIT PULL] xfs: new code for 6.7
Message-ID: <20231109163856.GG1205143@frogsfrogsfrogs>
References: <87fs1g1rac.fsf@debian-BULLSEYE-live-builder-AMD64>
 <CAHk-=wj3oM3d-Hw2vvxys3KCZ9De+gBN7Gxr2jf96OTisL9udw@mail.gmail.com>
 <20231108225200.GY1205143@frogsfrogsfrogs>
 <20231109045150.GB28458@lst.de>
 <20231109073945.GE1205143@frogsfrogsfrogs>
 <20231109144614.GA31340@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109144614.GA31340@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 03:46:14PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 08, 2023 at 11:39:45PM -0800, Darrick J. Wong wrote:
> > Dave and I started looking at this too, and came up with: For rtgroups
> > filesystems, what if rtpick simply rotored the rtgroups?  And what if we
> > didn't bother persisting the rotor value, which would make this casting
> > nightmare go away in the long run.  It's not like we persist the agi
> > rotors.
> 
> Yep.  We should still fix the cast and replace it with a proper union
> or other means for pre-RTG file systems given that they will be around
> for while.

<nod> Linus' fixup stuffs the seq value in tv_sec.  That's not great
since the inode writeout code then truncates the upper 32 bits, but
that's what the kernel has been doing for 5+ years now.

Dave suggested that we might restore the pre-4.6 behavior by explicitly
encoding what we used to do:

	inode->i_atime.tv_sec = seq & 0xFFFFFFFF;
	inode->i_atime.tv_nsec = seq >> 32;

(There's a helper in 6.7 for this, apparently.)

But then I pointed out that the entire rtpick sequence counter thing
merely provides a *starting point* for rtbitmap searches.  So it's not
like garbled values result in metadata inconsistency.  IOWs, it's
apparently benign.

IOWs, how much does anyone care about improving on Linus' fixup?

--D
