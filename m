Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34802 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdHaH1y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 03:27:54 -0400
Received: by mail-qk0-f182.google.com with SMTP id a77so37116038qkb.1
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 00:27:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170830145808.GB16641@bfoster.bfoster>
References: <CAHeWggOTqbQUQB7xz1wUjejHU5W14w3wcN-oV-+KJxxyEEQ3TQ@mail.gmail.com>
 <20170818120224.GA27778@redhat.com> <20170818121725.GA1665@bfoster.bfoster>
 <CAHeWggM-dGJHRNyyXZrW5aX7v3r-b0t1LTbrbN-OSTLdLzuPhg@mail.gmail.com>
 <20170821155152.GA56278@bfoster.bfoster> <CAHeWggPzVSXXGK+35jEf9FD2gM-QcL_3iebaKzjOK7DbRmWDiA@mail.gmail.com>
 <20170830145808.GB16641@bfoster.bfoster>
From: Ingard - <ingard1@gmail.com>
Date: Thu, 31 Aug 2017 09:27:52 +0200
Message-ID: <CAHeWggPh-1E8E6f+feZipdM_fQAejnv09r+bLwo6FLGC1pjAeg@mail.gmail.com>
Subject: Re: corrupt xfs log
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 4:58 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Mon, Aug 21, 2017 at 10:24:32PM +0200, Ingard - wrote:
>> On Mon, Aug 21, 2017 at 5:51 PM, Brian Foster <bfoster@redhat.com> wrote:
>> > On Mon, Aug 21, 2017 at 02:08:43PM +0200, Ingard - wrote:
>> >> On Fri, Aug 18, 2017 at 2:17 PM, Brian Foster <bfoster@redhat.com> wrote:
>> >> > On Fri, Aug 18, 2017 at 07:02:24AM -0500, Bill O'Donnell wrote:
>> >> >> On Fri, Aug 18, 2017 at 01:56:31PM +0200, Ingard - wrote:
>> >> >> > After a server crash we've encountered a corrupt xfs filesystem. When
>> >> >> > trying to mount said filesystem normally the system hangs.
>> >> >> > This was initially on a ubuntu trusty server with 3.13 kernel with
>> >> >> > xfsprogs 3.1.9
>> >> >> >
>> >> >> > We've installed a newer kernel (4.4.0-92) and compiled xfsprogs v
>> >> >> > 4.12.0 from source. We're still not able to mount the filesystem (and
>> >> >> > replay the log) normally.
>> >> >> > We are able to mount it -o ro,norecovery, but we're reluctant to do
>> >> >> > xfs_repair -L without trying everything we can first. The filesystem
>> >> >> > is browsable albeit a few paths which gives an error : "Structure
>> >> >> > needs cleaning"
>> >> >> >
>> >> >> > Does anyone have any advice as to how we might recover/repair the
>> >> >> > corrupt log so we can replay it? Or is xfs_repair -L the only way
>> >> >> > forward?
>> >> >>
>> >> >> Can you try xfs_repair -n (only scans the fs and reports what repairs
>> >> >> would be made)?
>> >> >>
>> >> >
>> >> > An xfs_metadump of the fs might be useful as well. Then we can see if we
>> >> > can reproduce the mount hang on latest kernels and if so, potentially
>> >> > try and root cause it.
>> >> >
>> >> > Brian
>> >>
>> >> Here is a link for the metadump :
>> >> https://www.jottacloud.com/p/ingardme/95ec2e45ba80431d962345981d38bdff
>> >
>> > This points to a 29GB image file, apparently uncompressed..? Could you
>> > upload a compressed file? Thanks.
>>
>> Hi. Sorry about that. Didnt realize the output would be compressable.
>> Here is a link to the compressed tgz (6G)
>> https://www.jottacloud.com/p/ingardme/cac6939649e14b98b928647f5222a2ae
>>
>
> I finally played around with this image a bit. Note that mount does not
> hang on latest kernels. Instead, log recovery emits a torn write message
> due to a bad crc at the head of the log and then ultimately fails due to
> a bad crc at the tail of the log. I ran a couple experiments to skip the
> bad crc records and/or to completely ignore all bad crc's and both still
> either fail to mount (due to other corruption) or continue to show
> corruption in the recovered fs.
>
> It's not clear to me what would have caused this corruption or log
> state. Have you encountered any corruption before? If not, is this kind
> of crash or unclean shutdown of the server an uncommon event?
We failed to notice the log messages of corrupt fs at first. After a
few days of these messages the filesystem got shut down due to
excessive? corruption.
At that point we tried to reboot normally, but ended up with having to
do a hard reset of the server.
It is not clear to us either why the corruption happened in the first
place either. The underlying raid has been in optimal state the whole
time

>
> That aside, I think the best course of action is to run 'xfs_repair -L'
> on the fs. I ran a v4.12 version against the metadump image and it
> successfully repaired the fs. I've attached the repair output for
> reference, but I would recommend to first restore your metadump to a
> temporary location, attempt to repair that and examine the results
> before repairing the original fs. Note that the metadump will not have
> any file content, but will represent which files might be cleared, moved
> to lost+found, etc.
Ok. Thanks for looking into it. We'll proceed with the suggested
course of action.

ingard
>
> Brian
>
>> >
>> > Brian
>> >
>> >> And the repair -n output :
>> >> https://www.jottacloud.com/p/ingardme/0205c6ca6f7e495ebcda5f255b96f63d
>> >>
>> >> kind regards
>> >> ingard
>> >>
>> >> >
>> >> >> Thanks-
>> >> >> Bill
>> >> >>
>> >> >>
>> >> >> >
>> >> >> >
>> >> >> > Excerpt from kern.log:
>> >> >> > 2017-08-17T13:40:41.122121+02:00 dn-238 kernel: [  294.300347] XFS
>> >> >> > (sdd1): Mounting V4 filesystem in no-recovery mode. Filesystem will be
>> >> >> > inconsistent.
>> >> >> >
>> >> >> > 2017-08-17T17:04:54.794194+02:00 dn-238 kernel: [12548.400260] XFS
>> >> >> > (sdd1): Metadata corruption detected at xfs_inode_buf_verify+0x6f/0xd0
>> >> >> > [xfs], xfs_inode block 0x81c9c210
>> >> >> > 2017-08-17T17:04:54.794216+02:00 dn-238 kernel: [12548.400342] XFS
>> >> >> > (sdd1): Unmount and run xfs_repair
>> >> >> > 2017-08-17T17:04:54.794218+02:00 dn-238 kernel: [12548.400374] XFS
>> >> >> > (sdd1): First 64 bytes of corrupted metadata buffer:
>> >> >> > 2017-08-17T17:04:54.794220+02:00 dn-238 kernel: [12548.400418]
>> >> >> > ffff880171fff000: 3f 1a 33 54 5b 55 85 0b 7c f5 c6 d5 cf 51 47 41
>> >> >> > ?.3T[U..|....QGA
>> >> >> > 2017-08-17T17:04:54.794222+02:00 dn-238 kernel: [12548.400473]
>> >> >> > ffff880171fff010: 97 ba ba 03 5c e4 02 7a e6 bc fb 5d f1 72 db c1
>> >> >> > ....\..z...].r..
>> >> >> > 2017-08-17T17:04:54.794223+02:00 dn-238 kernel: [12548.400527]
>> >> >> > ffff880171fff020: c8 ad 3a 76 c7 e4 20 92 88 a2 35 0c 1f 36 cf b5
>> >> >> > ..:v.. ...5..6..
>> >> >> > 2017-08-17T17:04:54.794226+02:00 dn-238 kernel: [12548.400581]
>> >> >> > ffff880171fff030: 8a bc 42 75 86 50 a0 a2 be 2c 2d 99 96 2d e1 ee
>> >> >> > ..Bu.P...,-..-..
>> >> >> >
>> >> >> > kind regards
>> >> >> > ingard
>> >> >> > --
>> >> >> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> >> >> > the body of a message to majordomo@vger.kernel.org
>> >> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
