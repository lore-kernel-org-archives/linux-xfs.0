Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C762AC072A2
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Nov 2023 13:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjKSNi5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Nov 2023 08:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjKSNi4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Nov 2023 08:38:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95D583
        for <linux-xfs@vger.kernel.org>; Sun, 19 Nov 2023 05:38:53 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCACDC433C8;
        Sun, 19 Nov 2023 13:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700401133;
        bh=jfjgB/r0hnM+zDFTIkW9ALTStYyWaMSCgI96dZyVNws=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=UE4SncIdxVXwX05TNo7Xt7g8qedCWOqq/ihB+AXR32bIe6sOScmS11g04/rREmI30
         LngyDo7Mv+gV2x8l0WwRucVYqEUiKwwlJc9uHa5ZBfl9vPPz+IcM6zREjr0hGpnTu5
         BqHlrNjGzXVMmUkxk3GSWBw+xRCVpnRyTK0gyw/hUqg7Orh+jx02YmIt5BWJquY3D+
         4yBhHOQQIOwsKBwO+FDcpZIlqwb/f/YU44YT2kx65MDEODkMtfVBJeDjPGAs9fpv7a
         lY377qxqtCGpFomtDjvLkfKYwZNMpG0MlzNSnefOXizP8tItaGxYmcBqunxrt27ROY
         6ndjh+4aP50ww==
References: <87zfzb31yl.fsf@debian-BULLSEYE-live-builder-AMD64>
 <CAHk-=wgC_nn_6d=G0ABjco5qMMZELGrUyCVQN3zB8+Yo5F8Drw@mail.gmail.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ailiop@suse.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de, holger@applied-asynchrony.com, leah.rumancik@gmail.com,
        leo.lilong@huawei.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, osandov@fb.com, willy@infradead.org
Subject: Re: [GIT PULL] xfs: bug fixes for 6.7
Date:   Sun, 19 Nov 2023 19:05:09 +0530
In-reply-to: <CAHk-=wgC_nn_6d=G0ABjco5qMMZELGrUyCVQN3zB8+Yo5F8Drw@mail.gmail.com>
Message-ID: <87r0klg8wl.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 18, 2023 at 11:41:36 AM -0800, Linus Torvalds wrote:
> On Sat, 18 Nov 2023 at 00:22, Chandan Babu R <chandanbabu@kernel.org> wrote:
>>
>> Matthew Wilcox (Oracle) (1):
>>       XFS: Update MAINTAINERS to catch all XFS documentation
>
> I have no complaints about this change, but I did have a reaction:
> should that "Documentation/filesystems" directory hierarchy maybe be
> cleaned up a bit?
>
> IOW, instead of the "xfs-*" pattern, just do subdirectories for
> filesystems that have enough documentation that they do multiple
> files?
>
> I see that ext4, smb and spufs already do exactly that. And a few
> other filesystems maybe should move that way, and xfs would seem to be
> the obvious next one.
>
> Not a big deal, but that file pattern change did make me go "humm".
>
> So particularly if somebody ends up (for example) splitting that big
> online fsck doc up some day, please just give xfs a subdirectory of
> its own at the same time?

I agree with your suggestion. I will make sure that new files documenting XFS
will be created in a new directory that is specific to XFS and existing
documentation will be moved under the new directory.

-- 
Chandan
