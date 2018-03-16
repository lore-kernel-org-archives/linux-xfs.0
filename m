Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51508 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964911AbeCPPjQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Mar 2018 11:39:16 -0400
Date: Fri, 16 Mar 2018 08:39:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2 v4] fsck.xfs: allow forced repairs using xfs_repair
Message-ID: <20180316153912.GC1757@magnolia>
References: <20180315175026.34779-1-jtulak@redhat.com>
 <20180315182850.36783-1-jtulak@redhat.com>
 <20180315184925.GC4865@magnolia>
 <CACj3i71yGDXq0SrpsM-VNwVwf=fZUcQi+1ve5kn_wdBmgt7KSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i71yGDXq0SrpsM-VNwVwf=fZUcQi+1ve5kn_wdBmgt7KSA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 16, 2018 at 11:19:50AM +0100, Jan Tulak wrote:
> On Thu, Mar 15, 2018 at 7:49 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Thu, Mar 15, 2018 at 07:28:50PM +0100, Jan Tulak wrote:
> >> +
> >> +# get the right return code for fsck
> >> +function repair2fsck_code() {
> >> +     case $1 in
> >> +     0)  return 0 # everything is ok
> >> +             ;;
> >> +     1)  echo "$NAME error: xfs_repair could not fix the filesystem." 1>&2
> >> +             return 4 # errors left uncorrected
> >> +             ;;
> >> +     2)  echo "$NAME error: The filesystem to be checked must not be mounted." 1>&2
> >> +             return 4 # it should not me mounted during boot, something is wrong
> >
> > Sorry I missed this on the first go-round, but repair status 2 means the
> > log is dirty, so the admin must mount the fs to try to replay the log or
> > run xfs_repair -L to dump the log.  It does not mean that the fs is
> > already mounted.
> >
> > "$NAME error: The filesystem log is dirty, either mount it to recover
> > the log.  If that fails, run xfs_repair -L to clear the log."
> >
> 
> Right, thanks for spotting it. But I wonder if telling the user to
> blindly use -L is safe. Maybe something like "run xfs_repair -L (can
> be dangerous, refer to manual pages)" would be better.

Yes.  "The filesystem log is dirty, please mount the filesystem to
recover the log.  If that fails, refer to the section DIRTY LOGS in the
xfs_repair manual page." ?

--D

> Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
