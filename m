Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751376AbdH3O6N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 10:58:13 -0400
Date: Wed, 30 Aug 2017 10:58:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: corrupt xfs log
Message-ID: <20170830145808.GB16641@bfoster.bfoster>
References: <CAHeWggOTqbQUQB7xz1wUjejHU5W14w3wcN-oV-+KJxxyEEQ3TQ@mail.gmail.com>
 <20170818120224.GA27778@redhat.com>
 <20170818121725.GA1665@bfoster.bfoster>
 <CAHeWggM-dGJHRNyyXZrW5aX7v3r-b0t1LTbrbN-OSTLdLzuPhg@mail.gmail.com>
 <20170821155152.GA56278@bfoster.bfoster>
 <CAHeWggPzVSXXGK+35jEf9FD2gM-QcL_3iebaKzjOK7DbRmWDiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <CAHeWggPzVSXXGK+35jEf9FD2gM-QcL_3iebaKzjOK7DbRmWDiA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ingard - <ingard1@gmail.com>
Cc: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 21, 2017 at 10:24:32PM +0200, Ingard - wrote:
> On Mon, Aug 21, 2017 at 5:51 PM, Brian Foster <bfoster@redhat.com> wrote:
> > On Mon, Aug 21, 2017 at 02:08:43PM +0200, Ingard - wrote:
> >> On Fri, Aug 18, 2017 at 2:17 PM, Brian Foster <bfoster@redhat.com> wrote:
> >> > On Fri, Aug 18, 2017 at 07:02:24AM -0500, Bill O'Donnell wrote:
> >> >> On Fri, Aug 18, 2017 at 01:56:31PM +0200, Ingard - wrote:
> >> >> > After a server crash we've encountered a corrupt xfs filesystem. When
> >> >> > trying to mount said filesystem normally the system hangs.
> >> >> > This was initially on a ubuntu trusty server with 3.13 kernel with
> >> >> > xfsprogs 3.1.9
> >> >> >
> >> >> > We've installed a newer kernel (4.4.0-92) and compiled xfsprogs v
> >> >> > 4.12.0 from source. We're still not able to mount the filesystem (and
> >> >> > replay the log) normally.
> >> >> > We are able to mount it -o ro,norecovery, but we're reluctant to do
> >> >> > xfs_repair -L without trying everything we can first. The filesystem
> >> >> > is browsable albeit a few paths which gives an error : "Structure
> >> >> > needs cleaning"
> >> >> >
> >> >> > Does anyone have any advice as to how we might recover/repair the
> >> >> > corrupt log so we can replay it? Or is xfs_repair -L the only way
> >> >> > forward?
> >> >>
> >> >> Can you try xfs_repair -n (only scans the fs and reports what repairs
> >> >> would be made)?
> >> >>
> >> >
> >> > An xfs_metadump of the fs might be useful as well. Then we can see if we
> >> > can reproduce the mount hang on latest kernels and if so, potentially
> >> > try and root cause it.
> >> >
> >> > Brian
> >>
> >> Here is a link for the metadump :
> >> https://www.jottacloud.com/p/ingardme/95ec2e45ba80431d962345981d38bdff
> >
> > This points to a 29GB image file, apparently uncompressed..? Could you
> > upload a compressed file? Thanks.
> 
> Hi. Sorry about that. Didnt realize the output would be compressable.
> Here is a link to the compressed tgz (6G)
> https://www.jottacloud.com/p/ingardme/cac6939649e14b98b928647f5222a2ae
> 

I finally played around with this image a bit. Note that mount does not
hang on latest kernels. Instead, log recovery emits a torn write message
due to a bad crc at the head of the log and then ultimately fails due to
a bad crc at the tail of the log. I ran a couple experiments to skip the
bad crc records and/or to completely ignore all bad crc's and both still
either fail to mount (due to other corruption) or continue to show
corruption in the recovered fs. 

It's not clear to me what would have caused this corruption or log
state. Have you encountered any corruption before? If not, is this kind
of crash or unclean shutdown of the server an uncommon event?

That aside, I think the best course of action is to run 'xfs_repair -L'
on the fs. I ran a v4.12 version against the metadump image and it
successfully repaired the fs. I've attached the repair output for
reference, but I would recommend to first restore your metadump to a
temporary location, attempt to repair that and examine the results
before repairing the original fs. Note that the metadump will not have
any file content, but will represent which files might be cleared, moved
to lost+found, etc.

Brian

> >
> > Brian
> >
> >> And the repair -n output :
> >> https://www.jottacloud.com/p/ingardme/0205c6ca6f7e495ebcda5f255b96f63d
> >>
> >> kind regards
> >> ingard
> >>
> >> >
> >> >> Thanks-
> >> >> Bill
> >> >>
> >> >>
> >> >> >
> >> >> >
> >> >> > Excerpt from kern.log:
> >> >> > 2017-08-17T13:40:41.122121+02:00 dn-238 kernel: [  294.300347] XFS
> >> >> > (sdd1): Mounting V4 filesystem in no-recovery mode. Filesystem will be
> >> >> > inconsistent.
> >> >> >
> >> >> > 2017-08-17T17:04:54.794194+02:00 dn-238 kernel: [12548.400260] XFS
> >> >> > (sdd1): Metadata corruption detected at xfs_inode_buf_verify+0x6f/0xd0
> >> >> > [xfs], xfs_inode block 0x81c9c210
> >> >> > 2017-08-17T17:04:54.794216+02:00 dn-238 kernel: [12548.400342] XFS
> >> >> > (sdd1): Unmount and run xfs_repair
> >> >> > 2017-08-17T17:04:54.794218+02:00 dn-238 kernel: [12548.400374] XFS
> >> >> > (sdd1): First 64 bytes of corrupted metadata buffer:
> >> >> > 2017-08-17T17:04:54.794220+02:00 dn-238 kernel: [12548.400418]
> >> >> > ffff880171fff000: 3f 1a 33 54 5b 55 85 0b 7c f5 c6 d5 cf 51 47 41
> >> >> > ?.3T[U..|....QGA
> >> >> > 2017-08-17T17:04:54.794222+02:00 dn-238 kernel: [12548.400473]
> >> >> > ffff880171fff010: 97 ba ba 03 5c e4 02 7a e6 bc fb 5d f1 72 db c1
> >> >> > ....\..z...].r..
> >> >> > 2017-08-17T17:04:54.794223+02:00 dn-238 kernel: [12548.400527]
> >> >> > ffff880171fff020: c8 ad 3a 76 c7 e4 20 92 88 a2 35 0c 1f 36 cf b5
> >> >> > ..:v.. ...5..6..
> >> >> > 2017-08-17T17:04:54.794226+02:00 dn-238 kernel: [12548.400581]
> >> >> > ffff880171fff030: 8a bc 42 75 86 50 a0 a2 be 2c 2d 99 96 2d e1 ee
> >> >> > ..Bu.P...,-..-..
> >> >> >
> >> >> > kind regards
> >> >> > ingard
> >> >> > --
> >> >> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> >> > the body of a message to majordomo@vger.kernel.org
> >> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ZPt4rx8FFjLCG7dd
Content-Type: application/gzip
Content-Disposition: attachment; filename="xfs_repair.out.gz"
Content-Transfer-Encoding: base64

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
wWp69VmwR9XHCW9f//3/Omhlxv8B+gf4w81vAAA=

--ZPt4rx8FFjLCG7dd--
