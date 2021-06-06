Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E492C4743E
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 18:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B70A6136D
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 18:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhFFSG7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 14:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhFFSG7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Jun 2021 14:06:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B05306139A;
        Sun,  6 Jun 2021 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623002709;
        bh=eA65rCkKZ0o8UvPjxxfm8K5PmUThmbuVaE4s1m3vGz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZfUTu9BtQLwcZ46dWpfQnUkPtula+CzHAvEUsuBeO/jAakrRqkTCncvf/yC6ddIOX
         5XO8s6138hXKsb/1RgjP3e3zPTr7xmA5ZaCoyWp1o+goZ8iNkwRPINt093M4lY2wF8
         BKZAFqzI0oRpdzQHjdi2vZXdQBX4pxgsb7Dcya/mWbgvIza+5rCO9U3N4/eJivOcCv
         yLuKMc0yr8jmoG1faLrJcomVHOmybyJwg2qX3ub+n+IrXJKg0KG87vdtUAQBv5CxOo
         yKtj5M7KLzEcIqeLxmfnw0ujZRgggRhZhZZVICJGoFaaUBai+y2FE233jdaO+wSRUU
         ep43xu0hPZ5Sw==
Date:   Sun, 6 Jun 2021 11:05:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCHSET RFC 00/10] fstests: move test group lists into test
 files
Message-ID: <20210606180509.GE2945738@locust>
References: <162199360248.3744214.17042613373014687643.stgit@locust>
 <YLzfV9Xx1ynZQau+@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLzfV9Xx1ynZQau+@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 06, 2021 at 10:44:39PM +0800, Eryu Guan wrote:
> On Tue, May 25, 2021 at 06:46:42PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Test group files (e.g. tests/generic/group) are a pain to keep up.
> > Every week I rebase on Eryu's latest upstream, and every week I have to
> > slog through dozens of trivial merge conflicts because of the
> > groupfiles.  Moving tests is annoying because we have to maintain all
> > this code to move the group associations from one /group file to
> > another.
> 
> Thanks for doing this! It looks find overall from a quick look. Mind
> adding some words in README file as well?

Ok.

> > It doesn't need to be this way -- we could move each test's group
> > information into the test itself, and automatically generate the group
> > files as part of the make process.  This series does exactly that.
> > 
> > The first few patches add some convenient anchors for the new
> > per-testfile group tagging and a conversion script to migrate existing
> > test files.  Next there's a huge patch that is the results of running
> > the conversion script, followed by cleanup of the golden outputs.  After
> > that comes the build infrastructure to generate group files and other
> 
> The group files are auto-generated correctly upon "make", but "make
> group" printed tons of errors like:
> 
> [root@fedoravm xfstests]# make group
>  [GROUP] /root/workspace/xfstests/group
> /root/workspace/xfstests/tests/btrfs/001: line 9: ./common/test_names: No such file or directory
> /root/workspace/xfstests/tests/btrfs/001: line 10: _set_seq_and_groups: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 21: ./common/rc: No such file or directory
> /root/workspace/xfstests/tests/btrfs/001: line 22: ./common/filter: No such file or directory
> /root/workspace/xfstests/tests/btrfs/001: line 23: ./common/filter.btrfs: No such file or directory
> /root/workspace/xfstests/tests/btrfs/001: line 26: _supported_fs: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 27: _require_scratch: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 30: _scratch_mount: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 38: _filter_scratch: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 38: subvolume: command not found
> ls: cannot access '/snap': No such file or directory
> ls: cannot access '/snap': No such file or directory
> /root/workspace/xfstests/tests/btrfs/001: line 50: _filter_scratch: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 50: subvolume: command not found
> ls: cannot access '/subvol': No such file or directory
> /root/workspace/xfstests/tests/btrfs/001: line 60: _btrfs_get_subvolid: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 61: _filter_scratch: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 61: subvolume: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 62: _scratch_cycle_mount: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 65: _scratch_unmount: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 67: _scratch_mount: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 71: _filter_scratch: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 71: subvolume: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 72: _scratch_cycle_mount: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 78: subvolume: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 81: _filter_btrfs_subvol_delete: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 81: subvolume: command not found
> /root/workspace/xfstests/tests/btrfs/001: line 84: _scratch_cycle_mount: command not found
> 
> I think it's better to let 'make group' work as well, it might be easier
> to re-generated just group files.

Yikes.  I will investigate this before reposting.

> > tweaks to the existing maintainer scripts to use the new infrastructure.
> > Finally, remove the group files themselves and the (now unnecessary)
> > code that maintained them.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=autogenerate-groupfiles
> 
> I noticed that your patches are based on your internal base, and this
> branch couldn't be pulled into current master branch. But this is fine
> for RFC patches I think :)

Yep.  Since this is a treewide change I'll put this in a special branch
and rebase my dev tree after it lands.

--D

> 
> Thanks,
> Eryu
