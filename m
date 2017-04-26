Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41829 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1434417AbdDZBnr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 21:43:47 -0400
Date: Wed, 26 Apr 2017 03:43:46 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 06/12] mkfs: create get/set functions for opts table
Message-ID: <20170426014346.GT28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-7-jtulak@redhat.com>
 <20170425034055.GJ28800@wotan.suse.de>
 <CACj3i71hapihKEMet5Z_wxqEA-OLh064g0wncaet8=XrwADUTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i71hapihKEMet5Z_wxqEA-OLh064g0wncaet8=XrwADUTw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 10:11:06AM +0200, Jan Tulak wrote:
> On Tue, Apr 25, 2017 at 5:40 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > On Sun, Apr 23, 2017 at 08:54:57PM +0200, Jan Tulak wrote:
> >> Add functions that can be used to get/set values to opts table.
> >>
> >> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> >>
> >> ---
> >>  mkfs/xfs_mkfs.c | 32 ++++++++++++++++++++++++++++++++
> >>  1 file changed, 32 insertions(+)
> >>
> >> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> >> index c2ffd91..4caf93c 100644
> >> --- a/mkfs/xfs_mkfs.c
> >> +++ b/mkfs/xfs_mkfs.c
> >> @@ -786,6 +786,38 @@ get_conf_raw(int opt, int subopt)
> >>       return opts[opt].subopt_params[subopt].raw_input;
> >>  }
> >>
> >> +static uint64_t getnum(const char *str, struct opt_params *opts, int index);
> >
> > Why not just move getnum() above here. Forward declarations IMHO should not be
> > needed unless we have odd inclusion issues and I don't think that's the case
> > here ?
> 
> Getnum requires set_conf_raw and illegal_option, but it seems that
> they could be moved too. I think there is no circle dependency, I just
> didn't want to move so many lines when I can do one declaration. But
> if the declaration is an issue, I can shuffle the ~80 lines the three
> functions takes.

If we can avoid it I don't see why not, the forward declarations, if not needed
IMHO just leads to lazy code practices. The shift of code up above could /
should be a separate atomic patch as it would be easier to review later.

  Luis
