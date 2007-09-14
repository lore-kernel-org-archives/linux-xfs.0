Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 02:10:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8E9AX4p001752
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 02:10:35 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id TAA12556 for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 19:10:34 +1000
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id l8E9AXdD18678008
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 19:10:34 +1000 (AEST)
Received: (from dgc@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id l8E9AWAp18677735
	for linux-xfs@oss.sgi.com; Fri, 14 Sep 2007 19:10:32 +1000 (AEST)
Date: Fri, 14 Sep 2007 19:10:32 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [UNSURE] can't remove dir
Message-ID: <20070914091032.GE734179@sgi.com>
References: <20070914080926.GA30150@apartia.fr> <Pine.LNX.4.64.0709140438130.752@p34.internal.lan> <20070914084125.GA31074@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914084125.GA31074@apartia.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Fri, Sep 14, 2007 at 10:41:25AM +0200, Louis-David Mitterrand wrote:
> On Fri, Sep 14, 2007 at 04:38:22AM -0400, Justin Piszcz wrote:
> >
> > On Fri, 14 Sep 2007, Louis-David Mitterrand wrote:
> >>
> >> While cleaning up /lost+found a directory resisted removal:
> >>
> >> 	sylla:/lost+found# rm 1879629858 -rf
> >> 	rm: cannot remove directory `1879629858': Directory not empty
> >>
> >> The directory _is_ empty and "-rf" should remove it anyway, so this
> >> looks like a fs error.
> >>
> >> This is on debian unstable with 2.6.23-rc6.
> >
> > what does "ls -al 1879629858" say?
> >
> 
> I knew someone would ask, and this is slightly insulting ;-)

Well, feel insulted if you want, but it was *exactly* the
right question to ask. :/

Looking at the link count of the directory that can't be removed:

> sylla:/lost+found# ls -al 1879629858
> total 24
> drwxr-xr-x 2 root root   8192 2007-09-14 09:25 ./

Which is correct for an empty directory. So this code in xfs_rmdir:

        ASSERT(cdp->i_d.di_nlink >= 2);
        if (cdp->i_d.di_nlink != 2) {
                error = XFS_ERROR(ENOTEMPTY);
                goto error_return;
        }

is not where the error is coming from.

But, the size indicates that the dirctory is not in shortform
state. An empty directory should look like:

# mkdir empty
# ls -la empty
total 0
drwxrwxr-x 2 root root  6 Sep 14 18:58 ./
                       ^^
drwxrwxr-x 4 root root 28 Sep 14 18:58 ../
#

So that means the error came from:

        if (!xfs_dir_isempty(cdp)) {
                error = XFS_ERROR(ENOTEMPTY);
                goto error_return;
        }

xfs_dir_isempty(
        xfs_inode_t     *dp)
{
        xfs_dir2_sf_t   *sfp;

        ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);
        if (dp->i_d.di_size == 0)       /* might happen during shutdown. */
                return 1;
>>>>>>> if (dp->i_d.di_size > XFS_IFORK_DSIZE(dp))
>>>>>>>         return 0;
        sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
        return !sfp->hdr.count;
}

So, this wasn't a stupid question at all. It indicates that the
source of the problem is a directory that did not get converted
back to short form as the entries were removed and greatly narrows
down teh possible causes of the problem.

Can you tell us the output of 'xfs_info <mntpt>'?

Also, get the inode number of the bad directory (ls -i) and then
run:

# xfs_db -r -c "inode <inode_num>" -c "p" <device of fs>

So we can see what the state of the inode is?

BTW, what problem led you to running xfs_repair in the first
place (i.e.  what led to lost+found getting populated)?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
