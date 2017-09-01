Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752005AbdIAQ0o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Sep 2017 12:26:44 -0400
Date: Fri, 1 Sep 2017 12:26:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: corrupt xfs log
Message-ID: <20170901162639.GB29225@bfoster.bfoster>
References: <20170818121725.GA1665@bfoster.bfoster>
 <CAHeWggM-dGJHRNyyXZrW5aX7v3r-b0t1LTbrbN-OSTLdLzuPhg@mail.gmail.com>
 <20170821155152.GA56278@bfoster.bfoster>
 <CAHeWggPzVSXXGK+35jEf9FD2gM-QcL_3iebaKzjOK7DbRmWDiA@mail.gmail.com>
 <20170830145808.GB16641@bfoster.bfoster>
 <CAHeWggPh-1E8E6f+feZipdM_fQAejnv09r+bLwo6FLGC1pjAeg@mail.gmail.com>
 <20170831102008.GA21508@bfoster.bfoster>
 <CAHeWggM2-Pv28Fg09iL43n0msDfoni=Qeza7n0XL6YzPYQ3E3g@mail.gmail.com>
 <20170901113306.GE28241@bfoster.bfoster>
 <20170901151119.GX3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901151119.GX3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ingard - <ingard1@gmail.com>, Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Sep 01, 2017 at 08:11:19AM -0700, Darrick J. Wong wrote:
> On Fri, Sep 01, 2017 at 07:33:07AM -0400, Brian Foster wrote:
> > On Fri, Sep 01, 2017 at 08:48:03AM +0200, Ingard - wrote:
> > > On Thu, Aug 31, 2017 at 12:20 PM, Brian Foster <bfoster@redhat.com> wrote:
> > > > On Thu, Aug 31, 2017 at 09:27:52AM +0200, Ingard - wrote:
> > > >> On Wed, Aug 30, 2017 at 4:58 PM, Brian Foster <bfoster@redhat.com> wrote:
> > > >> > On Mon, Aug 21, 2017 at 10:24:32PM +0200, Ingard - wrote:
> > > >> >> On Mon, Aug 21, 2017 at 5:51 PM, Brian Foster <bfoster@redhat.com> wrote:
> > > >> >> > On Mon, Aug 21, 2017 at 02:08:43PM +0200, Ingard - wrote:
> > > >> >> >> On Fri, Aug 18, 2017 at 2:17 PM, Brian Foster <bfoster@redhat.com> wrote:
> > > >> >> >> > On Fri, Aug 18, 2017 at 07:02:24AM -0500, Bill O'Donnell wrote:
> > > >> >> >> >> On Fri, Aug 18, 2017 at 01:56:31PM +0200, Ingard - wrote:
> > > >> >> >> >> > After a server crash we've encountered a corrupt xfs filesystem. When
> > > >> >> >> >> > trying to mount said filesystem normally the system hangs.
> > > >> >> >> >> > This was initially on a ubuntu trusty server with 3.13 kernel with
> > > >> >> >> >> > xfsprogs 3.1.9
> > > >> >> >> >> >
> > > >> >> >> >> > We've installed a newer kernel (4.4.0-92) and compiled xfsprogs v
> > > >> >> >> >> > 4.12.0 from source. We're still not able to mount the filesystem (and
> > > >> >> >> >> > replay the log) normally.
> > > >> >> >> >> > We are able to mount it -o ro,norecovery, but we're reluctant to do
> > > >> >> >> >> > xfs_repair -L without trying everything we can first. The filesystem
> > > >> >> >> >> > is browsable albeit a few paths which gives an error : "Structure
> > > >> >> >> >> > needs cleaning"
> > > >> >> >> >> >
> > > >> >> >> >> > Does anyone have any advice as to how we might recover/repair the
> > > >> >> >> >> > corrupt log so we can replay it? Or is xfs_repair -L the only way
> > > >> >> >> >> > forward?
> > > >> >> >> >>
> > > >> >> >> >> Can you try xfs_repair -n (only scans the fs and reports what repairs
> > > >> >> >> >> would be made)?
> > > >> >> >> >>
> > > >> >> >> >
> > > >> >> >> > An xfs_metadump of the fs might be useful as well. Then we can see if we
> > > >> >> >> > can reproduce the mount hang on latest kernels and if so, potentially
> > > >> >> >> > try and root cause it.
> > > >> >> >> >
> > > >> >> >> > Brian
> > > >> >> >>
> > > >> >> >> Here is a link for the metadump :
> > > >> >> >> https://www.jottacloud.com/p/ingardme/95ec2e45ba80431d962345981d38bdff
> > > >> >> >
> > > >> >> > This points to a 29GB image file, apparently uncompressed..? Could you
> > > >> >> > upload a compressed file? Thanks.
> > > >> >>
> > > >> >> Hi. Sorry about that. Didnt realize the output would be compressable.
> > > >> >> Here is a link to the compressed tgz (6G)
> > > >> >> https://www.jottacloud.com/p/ingardme/cac6939649e14b98b928647f5222a2ae
> > > >> >>
> > > >> >
> > > >> > I finally played around with this image a bit. Note that mount does not
> > > >> > hang on latest kernels. Instead, log recovery emits a torn write message
> > > >> > due to a bad crc at the head of the log and then ultimately fails due to
> > > >> > a bad crc at the tail of the log. I ran a couple experiments to skip the
> > > >> > bad crc records and/or to completely ignore all bad crc's and both still
> > > >> > either fail to mount (due to other corruption) or continue to show
> > > >> > corruption in the recovered fs.
> > > >> >
> > > >> > It's not clear to me what would have caused this corruption or log
> > > >> > state. Have you encountered any corruption before? If not, is this kind
> > > >> > of crash or unclean shutdown of the server an uncommon event?
> > > >> We failed to notice the log messages of corrupt fs at first. After a
> > > >> few days of these messages the filesystem got shut down due to
> > > >> excessive? corruption.
> > > >> At that point we tried to reboot normally, but ended up with having to
> > > >> do a hard reset of the server.
> > > >> It is not clear to us either why the corruption happened in the first
> > > >> place either. The underlying raid has been in optimal state the whole
> > > >> time
> > > >>
> > > >
> > > > Ok, so corruption was the first problem. If the filesystem shutdown with
> > > > something other than a log I/O error, chances are the log was flushed at
> > > > that time. It is strange that log records end up corrupted, though not
> > > > terribly out of the ordinary for the mount to ultimately fail if
> > > > recovery stumbled over existing on-disk corruption, for instance.
> > > > An xfs_repair was probably a foregone conclusion given the corruption
> > > > started on disk, anyways.
> > > 
> > > Out of curiosity, how long did the xfs_mdrestore command run ? I'm
> > > pushing 20ish hours now and noticed the following in kern.log :
> > > 2017-09-01T08:47:23.414139+02:00 dn-238 kernel: [1278740.983304] XFS:
> > > xfs_mdrestore(5176) possible memory allocation deadlock size 37136 in
> > > kmem_alloc (mode:0x2400240)
> > > 
> > 
> > Heh. It certainly wasn't quick since it had to restore ~30GB or so of
> > metadata, but it didn't take that long. If I had to guess, I'd say it
> > restored within an hour.
> > 
> > It seems like you're running into the in-core extent list problem, which
> > causes pain for highly sparse or fragmented files because we store the
> > entire extent list in memory. An fiemap of the restored image I have
> > lying around shows over 1.5m extents. :/ You may need a box with more
> > RAM (I had 32GB) or otherwise find another large enough block device to
> > use the metadump. :/ If you had to bypass that step, you could at least
> > run 'xfs_repair -n' on the original fs to see whether repair runs to
> > completion in your environment.
> 
> /me wonders if it'd help if mdrestore had a command line arg to
> fallocate the target file beforehand (lots of wasted space but fewer
> extents) or set an extent size hint (only useful if metadata isn't
> fragmented) but yes we should fix the incore extent cache memory usage
> problem.
> 

That's an interesting idea. I suppose one could set a really large
extent size hint on the directory to try and achieve a similar outcome
as an initial fallocate.

Eh, though looking at the restored image, the original fs is 88TB (with
only 4TB free space), so that might not be so useful in this particular
case. Heh, I have another metadump lying around of a significantly
smaller fs with what looks like about double the amount of metadata
based on the metadump size and extent count. :P There may be a middle
ground here where an fallocate could be useful.

Brian

> --D
> 
> > 
> > Brian
> > 
> > > ingard
> > > 
> > > >
> > > > Brian
> > > >
> > > >> >
> > > >> > That aside, I think the best course of action is to run 'xfs_repair -L'
> > > >> > on the fs. I ran a v4.12 version against the metadump image and it
> > > >> > successfully repaired the fs. I've attached the repair output for
> > > >> > reference, but I would recommend to first restore your metadump to a
> > > >> > temporary location, attempt to repair that and examine the results
> > > >> > before repairing the original fs. Note that the metadump will not have
> > > >> > any file content, but will represent which files might be cleared, moved
> > > >> > to lost+found, etc.
> > > >> Ok. Thanks for looking into it. We'll proceed with the suggested
> > > >> course of action.
> > > >>
> > > >> ingard
> > > >> >
> > > >> > Brian
> > > >> >
> > > >> >> >
> > > >> >> > Brian
> > > >> >> >
> > > >> >> >> And the repair -n output :
> > > >> >> >> https://www.jottacloud.com/p/ingardme/0205c6ca6f7e495ebcda5f255b96f63d
> > > >> >> >>
> > > >> >> >> kind regards
> > > >> >> >> ingard
> > > >> >> >>
> > > >> >> >> >
> > > >> >> >> >> Thanks-
> > > >> >> >> >> Bill
> > > >> >> >> >>
> > > >> >> >> >>
> > > >> >> >> >> >
> > > >> >> >> >> >
> > > >> >> >> >> > Excerpt from kern.log:
> > > >> >> >> >> > 2017-08-17T13:40:41.122121+02:00 dn-238 kernel: [  294.300347] XFS
> > > >> >> >> >> > (sdd1): Mounting V4 filesystem in no-recovery mode. Filesystem will be
> > > >> >> >> >> > inconsistent.
> > > >> >> >> >> >
> > > >> >> >> >> > 2017-08-17T17:04:54.794194+02:00 dn-238 kernel: [12548.400260] XFS
> > > >> >> >> >> > (sdd1): Metadata corruption detected at xfs_inode_buf_verify+0x6f/0xd0
> > > >> >> >> >> > [xfs], xfs_inode block 0x81c9c210
> > > >> >> >> >> > 2017-08-17T17:04:54.794216+02:00 dn-238 kernel: [12548.400342] XFS
> > > >> >> >> >> > (sdd1): Unmount and run xfs_repair
> > > >> >> >> >> > 2017-08-17T17:04:54.794218+02:00 dn-238 kernel: [12548.400374] XFS
> > > >> >> >> >> > (sdd1): First 64 bytes of corrupted metadata buffer:
> > > >> >> >> >> > 2017-08-17T17:04:54.794220+02:00 dn-238 kernel: [12548.400418]
> > > >> >> >> >> > ffff880171fff000: 3f 1a 33 54 5b 55 85 0b 7c f5 c6 d5 cf 51 47 41
> > > >> >> >> >> > ?.3T[U..|....QGA
> > > >> >> >> >> > 2017-08-17T17:04:54.794222+02:00 dn-238 kernel: [12548.400473]
> > > >> >> >> >> > ffff880171fff010: 97 ba ba 03 5c e4 02 7a e6 bc fb 5d f1 72 db c1
> > > >> >> >> >> > ....\..z...].r..
> > > >> >> >> >> > 2017-08-17T17:04:54.794223+02:00 dn-238 kernel: [12548.400527]
> > > >> >> >> >> > ffff880171fff020: c8 ad 3a 76 c7 e4 20 92 88 a2 35 0c 1f 36 cf b5
> > > >> >> >> >> > ..:v.. ...5..6..
> > > >> >> >> >> > 2017-08-17T17:04:54.794226+02:00 dn-238 kernel: [12548.400581]
> > > >> >> >> >> > ffff880171fff030: 8a bc 42 75 86 50 a0 a2 be 2c 2d 99 96 2d e1 ee
> > > >> >> >> >> > ..Bu.P...,-..-..
> > > >> >> >> >> >
> > > >> >> >> >> > kind regards
> > > >> >> >> >> > ingard
> > > >> >> >> >> > --
> > > >> >> >> >> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > >> >> >> >> > the body of a message to majordomo@vger.kernel.org
> > > >> >> >> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >> >> >> >> --
> > > >> >> >> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > >> >> >> >> the body of a message to majordomo@vger.kernel.org
> > > >> >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >> >> >> --
> > > >> >> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > >> >> >> the body of a message to majordomo@vger.kernel.org
> > > >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >> >> --
> > > >> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > >> >> the body of a message to majordomo@vger.kernel.org
> > > >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >> --
> > > >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > >> the body of a message to majordomo@vger.kernel.org
> > > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
