Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752294AbdK0Kya (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 05:54:30 -0500
Date: Mon, 27 Nov 2017 11:54:25 +0100
From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH v4] fstests: filter readonly mount error messages
Message-ID: <20171127105425.zxcgjo5eju6azj5u@ws.net.home>
References: <20171123111031.6550-4-eguan@redhat.com>
 <20171124050144.23549-1-eguan@redhat.com>
 <CAOQ4uxgxRxByGHhePr3b4H+W1zEGxUX6Emj9PBzZpEKEs2iHog@mail.gmail.com>
 <20171124103814.gfvxw3ethkcvm6xa@ws.net.home>
 <CAOQ4uxjbnrgJG3PLVV6TvAS-Fjgskms_jWc5-b4DVmLhbVUdFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjbnrgJG3PLVV6TvAS-Fjgskms_jWc5-b4DVmLhbVUdFg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Nov 26, 2017 at 10:56:40AM +0200, Amir Goldstein wrote:
> >> Thinking out loud, does xfstest even need to use mount program from
> >> util-linux? Do we ever need anything other than the bare libc mount(2)?
> >> We need it for -o loop, but that is the exception to the rule.
> >
> > Well, I don't think that create a parallel universe is the best
> > solution.
> >
> 
> I agree. However, xfstest uses 'mount' is a very particular way:
> - User has to provide both block device and mount point
> - xfstests already checks that those block device and mount point
>   are not in use in /proc/mounts *before* calling 'mount'

OK, I see, than the wrapper is not so bad idea (if you're able to keep
it simple and stupid:-)

> So I prefer the 'machine output format' solution going forward, but
> since xfstests will need to continue supporting old util-linux installations
> it might be less clumsy to use a simple C wrapper to mount(2), then
> to carry these error format filters.
> xfstests can also check for availability of the new machine format in
> 'mount' and if it doesn't exist fall back to using its private mount helper.

If you want to implement the wrapper than it's probably better use it
in all cases and then you can remove all the backward compatibility
filters. In thins case it seems better to depend on the wrapper only.
So, the unified messages maintained by unit-linux mount(8) will be
unnecessary.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
