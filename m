Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750721AbdDKEby (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 00:31:54 -0400
Date: Tue, 11 Apr 2017 12:31:52 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH v3] repair: handle reading superblock from image on
 larger sector size filesystem
Message-ID: <20170411043152.GQ21915@dhcp12-143.nay.redhat.com>
References: <1491480320-6511-1-git-send-email-zlang@redhat.com>
 <47d79267-118f-1b27-94e2-bbfcba98cd41@sandeen.net>
 <20170411032541.GO21915@dhcp12-143.nay.redhat.com>
 <f8caee4a-d8aa-1aa5-bb17-b8c7142bf17d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8caee4a-d8aa-1aa5-bb17-b8c7142bf17d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 10, 2017 at 10:57:11PM -0500, Eric Sandeen wrote:
> On 4/10/17 10:25 PM, Zorro Lang wrote:
> > On Mon, Apr 10, 2017 at 12:16:41PM -0500, Eric Sandeen wrote:
> >> On 4/6/17 7:05 AM, Zorro Lang wrote:
> >>> Due to xfs_repair uses direct IO, sometimes it can't read superblock
> >>> from an image file has smaller sector size than host filesystem.
> >>> Especially that superblock doesn't align with host filesystem's
> >>> sector size.
> >>>
> >>> Fortunately, xfsprogs already has code to do isa_file and geometry
> >>> check in xfs_repair.c, it turns off O_DIRECT after phase1() if the
> >>> sector size is less than the host filesystem's geometry. So move
> >>> the isa_file auto detection over up the phase1(), and try to do
> >>> once geometry check before phase1() if get_sb() return OK.
> >>
> >> Zorro, can you do a quick test for me - does a filesystem which fails
> >> repair without this patch also fail xfs_copy if the source and/or
> >> destination of the copy is on this same filesystem/device as the image
> >> file in your xfs_repair test?
> > 
> > Sure, the xfs_copy has similar problem. I'm writting a xfstests case to
> > do xfs_repair and xfs_copy a file image likes this. Do you have any other
> > related suggestions which I can write them together?
> 
> Any userspace which needs to read a filesystem image probably has the same
> issue.

I've already tested xfs_repair, xfs_copy, xfs_metadump, xfs_mdrestore and
xfs_db -c "sb $i". Only xfs_repair and xfs_copy failed.

And I noticed that xfs_copy open source file with O_DIRECT on purpose:
        if (source_is_file && platform_test_xfs_fd(source_fd))  {
                if (fcntl(source_fd, F_SETFL, open_flags | O_DIRECT) < 0)  {
                        do_log(_("%s: Cannot set direct I/O flag on \"%s\".\n"),
                                progname, source_name);
                        die_perror();
                }

I don't learn about the reason so much, maybe we shouldn't turn off
its O_DIRECT ?

Thanks,
Zorro

> 
> I'm wondering if all of this handling should somehow be factored out and
> re-used across the utilities...
> 
> -Eric
