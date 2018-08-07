Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:57300 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbeHHAhr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Aug 2018 20:37:47 -0400
Date: Wed, 8 Aug 2018 00:21:06 +0200
From: Adam Borowski <kilobyte@angband.pl>
Subject: Re: [RESEND][PATCH v5 0/2] vfs: better dedupe permission check
Message-ID: <20180807222106.6qfyrivo6y4pzn6a@angband.pl>
References: <20180807214949.7714-1-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180807214949.7714-1-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mark Fasheh <mfasheh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, David Sterba <dsterba@suse.cz>

On Tue, Aug 07, 2018 at 02:49:47PM -0700, Mark Fasheh wrote:
> Hi Andrew,
> 
> Could I please have these patches upstreamed or at least put in a tree for
> more public testing? They've hit fsdevel a few times now, I have links to
> the discussions in the change log below.

> The first patch expands our check to allow dedupe of a file if the
> user owns it or otherwise would be allowed to write to it.
[...]
> The other problem we have is also related to forcing the user to open
> target files for write - A process trying to exec a file currently
> being deduped gets ETXTBUSY. The answer (as above) is to allow them to
> open the targets ro - root can already do this. There was a patch from
> Adam Borowski to fix this back in 2016

> The 2nd patch fixes our return code for permission denied to be
> EPERM. For some reason we're returning EINVAL - I think that's
> probably my fault. At any rate, we need to be returning something
> descriptive of the actual problem, otherwise callers see EINVAL and
> can't really make a valid determination of what's gone wrong.

Note that the counterpart of these two patches for BTRFS_IOC_DEFRAG, which
fixes the same issues, is included in btrfs' for-next, slated for 4.19. 
While technically dedupe and defrag are independent, there would be somewhat
less confusion if both behave the same in the same kernel version.

Thus, it'd be nice if you would consider taking this.  Should be safe:
even the permission check is paranoid.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ So a Hungarian gypsy mountainman, lumberjack by day job,
⣾⠁⢰⠒⠀⣿⡁ brigand by, uhm, hobby, invented a dish: goulash on potato
⢿⡄⠘⠷⠚⠋⠀ pancakes.  Then the Polish couldn't decide which of his
⠈⠳⣄⠀⠀⠀⠀ adjectives to use for the dish's name.
