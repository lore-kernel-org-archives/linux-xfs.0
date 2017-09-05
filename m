Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42344 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751238AbdIELdd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 07:33:33 -0400
Date: Tue, 5 Sep 2017 19:33:31 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 09/14] fsx: add support for -g filldata
Message-ID: <20170905113331.GH8034@eguan.usersys.redhat.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <1504104706-11965-10-git-send-email-amir73il@gmail.com>
 <20170905105025.GB8034@eguan.usersys.redhat.com>
 <CAOQ4uxhSRn_-_ZHy8MJWOheZnSUuN9DZuJb_ygD5qwnEEV39LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhSRn_-_ZHy8MJWOheZnSUuN9DZuJb_ygD5qwnEEV39LQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 05, 2017 at 02:29:35PM +0300, Amir Goldstein wrote:
> On Tue, Sep 5, 2017 at 1:50 PM, Eryu Guan <eguan@redhat.com> wrote:
> > On Wed, Aug 30, 2017 at 05:51:41PM +0300, Amir Goldstein wrote:
> >> -g X: write character X instead of random generated data
> >>
> >> This is useful to compare holes between good and bad buffer.
> >>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > This seems useful, but I don't see this option gets used in this
> > patchset. Perhaps introduce it when it gets used in the test?
> 
> I used it for debugging, to compare hexdump of good and bad files
> when I suspected that checksum errors were due to different zeroed
> ranges.

That's fine, mentioning the debug purpose in commit log would be good :)

> 
> 
> >
> >> ---
> >>  ltp/fsx.c | 11 +++++++++--
> >>  1 file changed, 9 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/ltp/fsx.c b/ltp/fsx.c
> >> index dd6b637..a75bc55 100644
> >> --- a/ltp/fsx.c
> >> +++ b/ltp/fsx.c
> >> @@ -132,6 +132,7 @@ unsigned long     simulatedopcount = 0;   /* -b flag */
> >>  int  closeprob = 0;                  /* -c flag */
> >>  int  debug = 0;                      /* -d flag */
> >>  unsigned long        debugstart = 0;         /* -D flag */
> >> +char filldata = 0;                   /* -g flag */
> >>  int  logid = 0;                      /* -j flag */
> >>  int  flush = 0;                      /* -f flag */
> >>  int  do_fsync = 0;                   /* -y flag */
> >> @@ -817,6 +818,8 @@ gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
> >>               good_buf[offset] = testcalls % 256;
> >>               if (offset % 2)
> >>                       good_buf[offset] += original_buf[offset];
> >> +             if (filldata)
> >> +                     good_buf[offset] = filldata;
> >
> > If filldata is not null, we're wasting cycles setting good_buf[offset]
> > and overwriting it with filldata. Use a if-else switch? e.g.
> >
> 
> considering this is a debugging option that is not meant to optimize
> performance, I don't think that's critical, but I can fix that.

Thanks!

Eryu
