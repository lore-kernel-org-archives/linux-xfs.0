Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 14:58:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m37LwSvl002118
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 14:58:31 -0700
Date: Tue, 8 Apr 2008 07:58:55 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Does XFS prevent disk spindown?
Message-ID: <20080407215855.GE108924158@sgi.com>
References: <m2tzimbvif.fsf@getmail.no> <20080401003005.GJ103491721@sgi.com> <47F1CF6D.2040103@sandeen.net> <m2d4p9o2sc.fsf@getmail.no> <m2y77smmdj.fsf@getmail.no> <47F9735E.8020900@sgi.com> <m2wsn9qub4.fsf@getmail.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2wsn9qub4.fsf@getmail.no>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thor Kristoffersen <thorkr@gmail.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Mon, Apr 07, 2008 at 10:33:19PM +0200, Thor Kristoffersen wrote:
> Timothy Shimmin <tes@sgi.com> writes:
> > Thor Kristoffersen wrote:
> >>> Use blktrace, or echo 1 > /proc/sys/vm/block_dump to see what block and
> >>> who's writing it...  it's probably the superblock?  what kernel?
> >>
> >> This is kernel version 2.6.24.  More specifically it's a Debian kernel from
> >> package linux-image-2.6.24-1-686 (2.6.24-4).
> >>
> >> I put the system in runlevel 1 and executed the test as you suggested.  On
> >> /dev/sda3 I have mounted (with noatime) an XFS filesystem that contains
> >> data that is not supposed to be accessed by any process.  In the output
> >> below I have filtered out all accesses to other partitions.  (BTW, this is
> >> not actually the disk that I wanted to spin down, but I think the log
> >> proves my point.)
> >>
> >>
> > I'm wondering if that is writing to the xfs ondisk log/journal in those cases.
> > What does 'xfs_logprint -t' show in these "idle" states
> > after these writes?
> 
> xfs_logprint produces output like the one shown below, so it does indeed
> look like it's writing to the journal.  But why should it need to keep
> writing to the journal when there have been no updates to any files on that
> partition recently?

Are you using lazy-count=1? (i.e. output of 'xfs_info <mtpt>', please).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
