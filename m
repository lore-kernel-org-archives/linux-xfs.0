Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1434425AbdDZBrf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 21:47:35 -0400
Date: Wed, 26 Apr 2017 03:47:33 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 07/12] mkfs: save user input values into opts
Message-ID: <20170426014733.GV28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-8-jtulak@redhat.com>
 <20170425051913.GK28800@wotan.suse.de>
 <CACj3i73=LaHiDk+YcB6MU3xH5UDQiD2EhNfR_VRjXcncQCNJuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i73=LaHiDk+YcB6MU3xH5UDQiD2EhNfR_VRjXcncQCNJuA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 10:16:13AM +0200, Jan Tulak wrote:
> On Tue, Apr 25, 2017 at 7:19 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > On Sun, Apr 23, 2017 at 08:54:58PM +0200, Jan Tulak wrote:
> >> Save the parsed values from users into the opts table.
> >>
> >> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> >> ---
> >>  mkfs/xfs_mkfs.c | 260 +++++++++++++++++++++++++++++++++++---------------------
> >>  1 file changed, 165 insertions(+), 95 deletions(-)
> >>
> >> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> >> index 4caf93c..362c9b4 100644
> >> --- a/mkfs/xfs_mkfs.c
> >> +++ b/mkfs/xfs_mkfs.c
> >> @@ -1636,16 +1636,19 @@ main(
> >>
> >>                               switch (getsubopt(&p, subopts, &value)) {
> >>                               case B_LOG:
> >> -                                     blocklog = getnum(value, &opts[OPT_B],
> >> -                                                             B_LOG);
> >> +                                     blocklog = parse_conf_val(OPT_B, B_LOG,
> >> +                                                               value);
> >>                                       blocksize = 1 << blocklog;
> >>                                       blflag = 1;
> >> +                                     set_conf_val(OPT_B, B_SIZE, blocksize);
> >>                                       break;
> >>                               case B_SIZE:
> >> -                                     blocksize = getnum(value, &opts[OPT_B],
> >> -                                                        B_SIZE);
> >> +                                     blocksize = parse_conf_val(OPT_B,
> >> +                                                                B_SIZE,
> >> +                                                                value);
> >>                                       blocklog = libxfs_highbit32(blocksize);
> >>                                       bsflag = 1;
> >> +                                     set_conf_val(OPT_B, B_LOG, blocklog);
> >>                                       break;
> >>                               default:
> >>                                       unknown('b', value);
> >
> > This still means that users of parse_conf_val() must copy the same code
> > in each case in the above to handle collateral values: if blocklog was
> > passed we update blocklog *and* blocksize *and* bsflag. Likewise if blocksize
> > was passed we must update blocksize *and* blocklog *and* blflag. What I had
> > done on the mkfs.xfs.conf series is put all this functionality into a helper,
> > and to do this move all needed vars into a struct. You are moving all possible
> > user params to a option specific table, however the collateral parameters are
> > kept inside main().
> >
> > I'll need to do the same again: move the logic above to a helper and move
> > collateral parameters to a struct, or this could be done in your series by
> > having parse_conf_val() handle all the needed logic provided say an extra
> > struct param is passed -- or though some other means.
> >
> > Duplicating the functionality I'm sure is not desirable, how we handle this
> > subjective so I'll leave it up to you to advise how you'd like to proceed,
> > but let me know if the above consideration is clear.
> >
> >   Luis
> 
> This is something I want to do, but let's get there step by step.
> First make the table working, then remove pieces from the main. If I
> try to do everything at once, it won't be ever finished. ;-)

Sure, it was not clear if this work was just it, thanks for the clarification.
Will review further patches with this in mind!

  Luis
