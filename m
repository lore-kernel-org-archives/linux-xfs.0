Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753100AbdKXKiT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Nov 2017 05:38:19 -0500
Date: Fri, 24 Nov 2017 11:38:14 +0100
From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH v4] fstests: filter readonly mount error messages
Message-ID: <20171124103814.gfvxw3ethkcvm6xa@ws.net.home>
References: <20171123111031.6550-4-eguan@redhat.com>
 <20171124050144.23549-1-eguan@redhat.com>
 <CAOQ4uxgxRxByGHhePr3b4H+W1zEGxUX6Emj9PBzZpEKEs2iHog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgxRxByGHhePr3b4H+W1zEGxUX6Emj9PBzZpEKEs2iHog@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 24, 2017 at 10:04:33AM +0200, Amir Goldstein wrote:
> [cc: Karel Zak]
> 
> On Fri, Nov 24, 2017 at 7:01 AM, Eryu Guan <eguan@redhat.com> wrote:
> > util-linux commit 6dede2f2f7c5 ("libmount: support MS_RDONLY on
> > write-protected devices") changed the error message on read-only
> > block device, and in the failure case printed one line message
> > instead of two (for details please see comments in common/filter),
> > and this change broke generic/050 and overlay/035.
> >
> > Fix it by adding more filter rules to _filter_ro_mount and updating
> > associated .out files to unify the output from both old and new
> > util-linux versions.
> >
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> > v4 (also passed with both old & new util-linux):
> > - add more comments to explain the output differences between util-linux
> >   versions
> > - print out message directly instead of using perl variables
> > - add word "device" to failed ro mount message
> 
> 
> Eryu,
> 
> This looks good and you can take it as an ACK on the series.
> 
> I've CC'ed Karel, so maybe he thinks about us fstests guys before making
> these sort of changes again...

Frankly, we have never promised that things like warning messages (or
another messages) are stable interface. It's fragile to depend on this
stuff...

> Thinking out loud, does xfstest even need to use mount program from
> util-linux? Do we ever need anything other than the bare libc mount(2)?
> We need it for -o loop, but that is the exception to the rule.

Well, I don't think that create a parallel universe is the best
solution.

> For fs that have mount helpers (cifs,nfs), we could use mount.$FSTYP
> directly (what error formats are reported from the helpers??). For all other
> fs we can write a simple t_mount program to wrap libc mount(2) and not be
> dependent on util-linux error message formats.
> Maybe we can consider it next time util-linux changes..
> 
> Another idea to through in the air in the direction of Karel -
> Maybe it makes sense for util-linux to check some env variable
> and then print all error messages in a unified machine format, e.g.:
> fprintf("%s: errno=%d\n", progname, errno);

This is good idea, I can try to implement it into libmount. 

 Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
