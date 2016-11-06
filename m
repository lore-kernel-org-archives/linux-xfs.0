Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36676 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751035AbcKFEe4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Nov 2016 00:34:56 -0400
Date: Sun, 6 Nov 2016 12:34:54 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs/021: filter out detailed array element info from
 xfs_db
Message-ID: <20161106043454.GD27776@eguan.usersys.redhat.com>
References: <1478276170-6618-1-git-send-email-eguan@redhat.com>
 <20161105055111.GW30105@dhcp12-143.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161105055111.GW30105@dhcp12-143.nay.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, Nov 05, 2016 at 01:51:11PM +0800, Zorro Lang wrote:
> On Sat, Nov 05, 2016 at 12:16:10AM +0800, Eryu Guan wrote:
> > Starting from xfsprogs commit 384283555871 ("xfs_db: print one array
> > element per line"), xfs_db prints one array element per line. This
> > breaks the filter in xfs/021, which now fails as:
> > 
> >   hdr.freemap[0-2] = [base,size] [FREEMAP..]
> >  +0:[104,1892]
> >  +1:[0,0]
> >  +2:[0,0]
> 
> Hmm... So [FREEMAP..] was printed in one line, but now every records
> will take one line.
> 
> >   entries[0-2] = [hashval,nameidx,incomplete,root,local] [ENTRIES..]
> > 
> > So we have extra lines that need to be filtered out,
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> >  tests/xfs/021 | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tests/xfs/021 b/tests/xfs/021
> > index 67a4346..b99eff7 100755
> > --- a/tests/xfs/021
> > +++ b/tests/xfs/021
> > @@ -151,7 +151,7 @@ s/^(hdr.info.magic =) 0x3bee/\1 0xfbee/;
> >  s/^(hdr.firstused =) (\d+)/\1 FIRSTUSED/;
> >  s/^(hdr.freemap\[0-2] = \[base,size]).*/\1 [FREEMAP..]/;
> 
> So this line script trys to deal with all freemap things, but now it
> can't deal with multi-lines output. (Same as below)
> 
> >  s/^(entries\[0-2] = \[hashval,nameidx,incomplete,root,local]).*/\1 [ENTRIES..]/;
> > -	print;'
> > +	print unless /^[0-9]/;'
> 
> Filter all lines start with a digit(0~9). It works, but I can't be
> sure that if it'll affect others useful error output, maybe more
> accurate expression will be better?

I think it's fine, we only filter stdout here and if there's any error
it should go to stderr and we can still catch it.

Thanks,
Eryu
