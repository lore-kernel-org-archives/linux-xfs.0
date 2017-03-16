Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34014 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752220AbdCPXkE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 19:40:04 -0400
Date: Fri, 17 Mar 2017 00:38:45 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 00/22] mkfs.xfs: Make stronger conflict checks
Message-ID: <20170316233845.GY28800@wotan.suse.de>
References: <20170315160017.27805-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170315160017.27805-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org, "Luis R . Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>

On Wed, Mar 15, 2017 at 04:59:55PM +0100, Jan Tulak wrote:
> This set is a follow-up of some old discussions and further attempts to untangle
> the spaghetti in options parsing. In short, this patchset allows to define
> cross-option conflicts and makes the conflicts detection more robust.

This series is pretty large. There are quite a bit of patches which just rename
something, or just shove code from one place to another. Can you group up
non-functional changes together first, and send a small series of simple stuff
with no functional changes first?

That should reduce the size of the functional patch set, and make it clearer
which patches require much careful eyeballing. It should also put out of your
queue tons of changes which are trivial and can go in rather sooner.

> Config file patches addendum:
> 
> (Thread: http://www.spinics.net/lists/linux-xfs/msg04703.html)
> 
> I read through the changes, but decided to don't take anything from it.

The last 2 patches of my config series are really the functional change there,
the rest is fluff to account for the insanity we have now.

> I think it is time to do something and adding further changes would just
> push it down again. Nevertheless, the other patchset contains some changes
> (like splitting the main opts loop) that I wanted to add in some later patch
> too.

OK.

> I suggest that we first merge these patches I'm sending, and once it solves
> some of the issues Luis hit too, we can look again on the config file thing
> and even if the main idea fell out of favor for some reason, there are still
> other useful changes.

Sure, I'm fine with this, do you have a git tree ? Once you rev and post new
series if you can provide a git URL that'd be great as then I can just work
off of that.

> PS: I'm traveling at Vault next week, so if you are there too, we can open it
> there.

I'm up for beers there.

  Luis
