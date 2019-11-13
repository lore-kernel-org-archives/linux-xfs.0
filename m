Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14A5C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88BC3222C9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:42:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qIWVhL0u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfKMEmX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:42:23 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:38540 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbfKMEmW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 23:42:22 -0500
Received: by mail-yw1-f65.google.com with SMTP id m196so291474ywd.5
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2019 20:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sXNqFbGFBYDrS6Ul1KD7pFXoYTFZiykAq5eH5UmT01w=;
        b=qIWVhL0u75rk+lRGfiJeuv44OsmfDgVwUrS7DPI7HFLp1qC9hLrojaGiMCxWwQcivW
         oaJDGlGgFKUYKotemLf9vhqUKOxeGmpizv27FHa/E1Qs7157zyLmOfyxyyvyb0EfENF0
         nLtWxxxS+FAoFDbCspYPzfbReNHBSo1mNdxfMOXIPugrowVcxPVP3LCgyO+zm98Y6VF3
         1C7faSTQKGBJ5ZX99TI9rxvV4PB8BuUHboABJSasgmhFiPq1bf0NPRmwaWVB1BudUoRv
         GoXJ6MCecmHPBODCGkCfzkm97ftN1Ss0BOkL+yTxwFPB7FLsfyS0n6U2Ctv31UAqEbzf
         51Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sXNqFbGFBYDrS6Ul1KD7pFXoYTFZiykAq5eH5UmT01w=;
        b=NbcJKSMGSUbamCSV3gYx1d95DknTfHmcCpgAX2xCzO0Z/92vU4n0NNxg2NXuVmawRq
         NoIxxtxauN+53qQa42DIMl6hp0v7f14Z+22UKh4Dl2O5sbxWqtREJcZtCXPkz48ChAGa
         rLEp6SEyDlWlGQ9Cg1rcxDSLVKNP+Qu3vUYmau+W3hwfseg0kJkgE5v2YOTKAJ8K/84L
         esZoQJGDnzZst7gLCqpJa8CExloIEYF+uhJebRqjY6CxgFJaxCTN3sARn0OOmP8Wxvgl
         QpPbb+7rLAJbyn0g5g0wVUiYW7EgqwJR/5DuwIH+iGk9JkNi5t6woSd0XBrzJUDTMd/i
         w5eQ==
X-Gm-Message-State: APjAAAXM3QNBy4amGLJ4BhMzOXooDqh/dOzACUr1zBqhJWUd49beCbG3
        89MHb6m1niTZMydYbjKHD3vlZ9GRIOGvSYXPxCU=
X-Google-Smtp-Source: APXvYqwTuQETwSjHtqHpOglKsZHb77n0yClOfsYACZiEZqFpn+YQvzdNjQJjp4hrhdhmEVTkreuIjhD3Kw3BtDsIC9A=
X-Received: by 2002:a0d:f305:: with SMTP id c5mr958093ywf.31.1573620140984;
 Tue, 12 Nov 2019 20:42:20 -0800 (PST)
MIME-Version: 1.0
References: <20191111213630.14680-1-amir73il@gmail.com> <20191111223508.GS6219@magnolia>
 <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
 <20191112211153.GO4614@dread.disaster.area> <20191113035611.GE6219@magnolia>
In-Reply-To: <20191113035611.GE6219@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 13 Nov 2019 06:42:09 +0200
Message-ID: <CAOQ4uxi9vzR4c3T0B4N=bM6DxCwj_TbqiOxyOQLrurknnyw+oA@mail.gmail.com>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[CC:Arnd,Deepa]

On Wed, Nov 13, 2019 at 5:56 AM Darrick J. Wong <darrick.wong@oracle.com> w=
rote:
>
> On Wed, Nov 13, 2019 at 08:11:53AM +1100, Dave Chinner wrote:
> > On Tue, Nov 12, 2019 at 06:00:19AM +0200, Amir Goldstein wrote:
> > > On Tue, Nov 12, 2019 at 12:35 AM Darrick J. Wong
> > > <darrick.wong@oracle.com> wrote:
> > > >
> > > > On Mon, Nov 11, 2019 at 11:36:30PM +0200, Amir Goldstein wrote:
> > > > > Use similar on-disk encoding for timestamps as ext4 to push back
> > > > > the y2038 deadline to 2446.
> > > > >
> > > > > The encoding uses the 2 free MSB in 32bit nsec field to extend th=
e
> > > > > seconds field storage size to 34bit.
> > > > >
> > > > > Those 2 bits should be zero on existing xfs inodes, so the extend=
ed
> > > > > timestamp range feature is declared read-only compatible with old
> > > > > on-disk format.
> > > >
> > > > What do you think about making the timestamp field a uint64_t count=
ing
> > > > nanoseconds since Dec 14 09:15:53 UTC 1901 (a.k.a. the minimum date=
time
> > > > we support with the existing encoding scheme)?  Instead of using th=
e
> > > > upper 2 bits of the nsec field for an epoch encoding, which ext4 sc=
rewed
> > > > up years ago and has not fully fixed?
> > >
> > > The advantage of the ext4 scheme is that it is more backward compatib=
le.
> >
> > Darrick an I had a long discussion about this on #xfs a few weeks
> > ago (22nd october).
> >
> > Discussion went like this:
> >
> >  <djwong>   btw, dchinner, were one to try to solve the y2038 problem o=
n xfs, how would one do it?
> >  <djwong>   1) write tests to make sure we can store/retrieve the extre=
me ends of the existing timestamps; then
> >  <djwong>   2) use empty di_pad bytes to extend each timestamp field wi=
dth; then
> >  <djwong>   3) figure out what the values of the extra byte are (epochs=
 moving forward from the unix epoch; and we don't care about supporting dat=
es before 1900); then
> >  <djwong>   4) expand test to cover new intervals?
> >  <dchinner> djwong: pretty much
> >  <dchinner> the epoch extending patch I originally proposed is here: ht=
tps://lore.kernel.org/linux-xfs/20140602002822.GQ14410@dastard/
> >  <djwong>   also it occurred to me that one could use the top two bits =
of the nsec fields to make it a 10-bit extension of the seconds fields
> >  <dchinner> I've probably got a more recent version somewhere in a stac=
k somewhere around here
> >  <dchinner> didn't ext4 use part of the nsec field like that?
> >  <djwong>   yeah, they have 34 bit dates now
> >  <dchinner> ISTR it's got some horrifically complex encoding of the tim=
estamp
> >  <djwong>   yes, it does
> >  <djwong>   they did epochs rolling forward from the current one
> >  <dchinner> we could just do the 34 bit second time in a sane way
> >  <dchinner> because all the timestamps are contiguous on disk
> >  <dchinner> i.e. if a SB flag is set, the timestamp on disk is an opaqu=
e 64 bit field
> >  <dchinner> upper 30 bits are the nsec field, lower 34 bits are the sec=
onds field
> >  <dchinner> similar to how we encode BMBT extent records
> >  <dchinner> always unsigned, so we don't support dates before 1970 at a=
ll....
> >  <djwong>   hmm, with that scheme (uint t_sec:34; uint t_nsec: 30;} I g=
uess that gets us to the year 2514
> >  <djwong>   and provided nobody cares about pre-1970 dates or the abili=
ty to store negative t_nsec
> >  <dchinner> djwong: if XFS is still in use in 2514, then I'm not going =
to care about it :)
> >  <djwong>   [narrator] But what Dave doesn't know is that the three XFS=
 maintainers will be uploaded into the Cloud in 2046 to maintain XFS in per=
petuity.... :D
> >  <dchinner> The current Dave doesn't care about that :)
> >  <djwong>   hmm even if we did {signed int t_sec:34;} that would still =
get us to 2242
> >  <dchinner> djwong: I just don't see the point of having signed timesta=
mps
> >  <djwong>   admittedly, we don't need timestamps dating back to the 170=
0s
> >  <djwong>   but then, what if we set the new epoch to 1993?
> >  <djwong>   (or, heck, 2000?)
> >  <djwong>   i mean, i guess it doesn't matter if we have dates going to=
 2514 or 2544
> >  <dchinner> what, have an on-disk epoch that is different to the unix e=
poch?
> >  <djwong>   yes :D
> >  <djwong>   "In the year 2525, if XFS is still alive..." =E2=99=AA=E2=
=99=AA
> >  <dchinner> then we definitely have unsigned timestamps on disk
> >  <dchinner> set the epoch to ~1900, and we handle the legacy negative 3=
2-bit int timestamp range as well.
> >  <djwong>   that could also work
> >  <djwong>   I don't anticipate being around in 2444
> >
> > Basically, we've both looked at what ext4 has done and don't want to
> > do that - it's an awful, complex hack and it's had quite a few bugs
> > in it since it was introduced that went a long time before being
> > noticed.
>
> When that conversation happened, I was still thinking of using the top
> 34 bits for seconds and the bottom 30 bits for nsec, which is not where
> my brain went this month.
>
> I've since moved on to a u64 nsec counter, which gets us to 2486, which
> is a whole forty more years past ext4!!!
>

I didn't get why you dropped the di_pad idea (Arnd's and Dave's patches).
Is it to save the pad for another rainy day?

> > > I would like to have an upgrade procedure that is simple and I don't =
like
> > > the idea of having two completely different time encodings in the cod=
e
> > > (and on disk) if I can help it.
> >
> > Backwards comaptible in-place upgrades are largely a myth: we don't
> > allow changes to the on-disk format without feature bits that limit
> > what old kernels can do with new formats. In this case it requires
> > an incompat bit because the moment an upper bit in the ns field is
> > set then the timestamps go bad on old kernels. Hence it's not a
> > compatible change and filesytems with this format cannot be mounted
> > on kernels that don't support it.
> >
> > So, an in-place upgrade process is a one-way operation - once you
> > start converting and have >2038 dates, there is no going back
> > without an offline admin operation. That means there's no real need
> > to try to retain the old format at all. IOWs, for in-place upgrade,
> > all we need is an inode flag to indicate what format the timestamp
> > is in once the superblock incompat flag is set. Eventually the SB
> > flag becomes the mkfs default, and then eventually it becomes the
> > only supported format. This is what we've done before for things
> > like NLINK, ATTR2, etc.
>
> /me is confused, are you advocating for an upgrade path that is: (1)
> admin sets incompat feature; (2) as people try to store dates beyond
> 2038 we set an inode flag and write the timestamp in the new format?
>
> I guess we could do that.  I'd kinda thought that we'd just set an
> incompat flag and users simply have to backup, reformat, and reinstall.
> OTOH it's a fairly minor update so maybe we can support one way upgrade.
>

That is not very sympathetic to users. Please go have lunch with one of
the filed engineers in your organization.

y2038 support is not something that *some* users will need to migrate to.
It is going to be a major pain for IT departments I see our duty as develop=
ers
to do our best to minimize that pain -
Certainly when it is quite easy to do - go offline, set an incompat
flag, go online
downtime has been minimized.
The concept of backup/restore as a means to upgrade should not be on the ta=
ble
for this sort of upgrade that everyone will be mandated to go through -
not unless you are looking for people to stop using xfs - y2038 problem sol=
ved!

> > > IIUC, you are implying that the ext4 scheme is more prone to human
> > > programming errors? that should be addressed with proper unit testing
> > > IMO and besides, we can learn from ext4 past bugs (not sure that my
> > > implementation did), so those could be listed also in the pros column=
.
>
> Well... Ted added a comment to ext4 about how the encoding had been
> screwed up, along with some #if'd out code that would some day take its
> place and do the encoding correctly... but Christoph later ripped it out
> since it's basically an incompat format change...
>
> > We're not implying anything - there's been several actual bugs in
> > the encoding scheme that weren't noticed or fixed for quite a long
> > time. What we've learnt from this is that complexity in timestamp
> > encoding only leads to bugs, so given the choice we should really do
> > something simpler.
>
> ...so yes, let's try for something simpler.
>

I'm all for simple. It's a completely new scheme that makes me nervous.
See you can say that the ext4 bugs are due to a "complex" encoding,
but I say it is due to "something completely new".
So yes, nanosec since 1900 is simple, but it's yet another standard, so
makes me unease, but I will get through it.

> > > One thing I wasn't certain about is that it seems that xfs (and xfs_r=
epair)
> > > allows for negative nsec value. Not sure if that is intentional and w=
hy.
> > > I suppose it is an oversight? That is something that xfs_repair would
> > > need to check and fix before upgrade if we do go with the epoch bits.
> >
> > It's not an oversight - it's somethign the on-disk format allowed.
> > Who knows if it ever got used (or how it got used), but it's
> > somethign we can only fix by changing the on-disk format (as you can
> > see from the discussion above).
>
> The disk format allows it; scrub warns about it, and the kernel at least
> in theory clamps the nsec value to 0...1e9.
>
> > IOWs, we pretty much decided on a new 64 bit encoding format using a
> > epoch of 1900 and a unsigned 64bit nanosecond counter to get us a
> > range of almost 600 years from year 1900-2500. It's simple, easy to
> > encode/decode, and very easy to validate. It's also trivially easy
> > to do in-place upgrades with an inode flag....
> >

All right, so how do we proceed?
Arnd, do you want to re-work your series according to this scheme?
Is there any core xfs developer that was going to tackle this?

I'm here, so if you need my help moving things forward let me know.

Thanks,
Amir.
