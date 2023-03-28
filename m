Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4D3C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Mar 2023 07:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjC1HV2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Mar 2023 03:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjC1HV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2023 03:21:27 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FDA3C0A
        for <linux-xfs@vger.kernel.org>; Tue, 28 Mar 2023 00:21:22 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id m5so8153609uae.11
        for <linux-xfs@vger.kernel.org>; Tue, 28 Mar 2023 00:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679988082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H3Gq+VDS5Un0Ol5dZm67KJ49tE2+SV4G6UJgR6hsyY4=;
        b=MKpmST4FmFh6IM7MTk/2/fEQNwajuHy90nMe+3L+V59n75KNXmUS6NGH7f9fZ2BSzd
         AXvObD6KEtjxaK7Vi0R2MU/HUIJKmlLYFqEX3zBLxF9HHAvz66wnsGr4DGHx4eSZbCts
         Bi5hBnee7sykQL40AQ8865azXea0r83IpcfdFfyj8st2rsTzxDE7ORSxC86QcdqSZhiD
         FkHicZwJr7CDofSHoX0e8flCR8VMfzHdjvmpIYF+4J2Y/DVZDwQ4pgCWNUxn7NuGIgeR
         D+dYkDPiCezbMBzdpUllw+QAMR//PR3Pbu/Q9L3mkTzpYQIntfEEsp8r69GbMel25sEy
         ErKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679988082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H3Gq+VDS5Un0Ol5dZm67KJ49tE2+SV4G6UJgR6hsyY4=;
        b=Qg8dW/7aco83wb57ng+A5CleWRTWPRt9Op5L8lBnpn0vFGuKmgujOgIWee7L/o6kKT
         PpEvCdq7eb+VWPpOI3B9nU5R9gXZuNC5/9/71W2/6PjAXSq5aYKT7ltJB5uBKXy7vTsx
         DLxWib9DcLTx+XmQfHqAHyccq2kU9i2FHY/se6bMXrO3o5urPCup5cIF4vDVjC5XD7Xc
         Ku0Ge9bglNNUi5+Tkjm3d4JLdbJnnoyDblE4ZUco+TH6x4OlduKJOo9KzNY9xxn12Rph
         oj3HOEeHm1jMMrrVVsFRaON+Dd99a/mBXHNvX3GaNtJgm98m/hm0jTMuUTJDXmwA/V4N
         07zg==
X-Gm-Message-State: AAQBX9c9BnggL+/2gKtoDZtx3vic3l3Quw7QUwfa7KA5HgGZT44AwStN
        6kg3ZDauBezV9YoqKWMw3sfq21MzvsdY1YOVHJtao58GyFE=
X-Google-Smtp-Source: AKy350bykEEHlXbNzQ3nFpEsNSLduXQpVPpskdX5AxKG89gBjtxywt4NZzmfhNK6MSBkq3zkzdSFAWCLUglumDth13k=
X-Received: by 2002:a05:6130:c0d:b0:68e:33d7:7e6b with SMTP id
 cg13-20020a0561300c0d00b0068e33d77e6bmr8118599uab.1.1679988081658; Tue, 28
 Mar 2023 00:21:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230316185414.GH11394@frogsfrogsfrogs> <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
 <6e6f7948dfdeac87accb8cd437f0c22d21a2e8e0.camel@oracle.com>
 <CAOQ4uxhVgPt93Wi3Z577gncWSxOE8S0fq5aasLJbffk8Rkg-GQ@mail.gmail.com>
 <20230325170106.GA16180@frogsfrogsfrogs> <CAOQ4uxj4ZwdCps2qFZCn9hTWcEaq1xUSJs=f1N5B4H4stayDPQ@mail.gmail.com>
 <20230328012932.GE16180@frogsfrogsfrogs>
In-Reply-To: <20230328012932.GE16180@frogsfrogsfrogs>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 28 Mar 2023 10:21:10 +0300
Message-ID: <CAOQ4uxg=Gy-s58KkpGmj9sZR1n2qVWxy73_iLcsWLV6+_i8uqw@mail.gmail.com>
Subject: Re: [PATCHSET v10r1d2 00/17] xfs: encode parent pointer name in xattr key
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 28, 2023 at 4:29=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Sun, Mar 26, 2023 at 06:21:17AM +0300, Amir Goldstein wrote:
> > On Sat, Mar 25, 2023 at 8:01=E2=80=AFPM Darrick J. Wong <djwong@kernel.=
org> wrote:
> > >
> > > On Sat, Mar 25, 2023 at 10:59:16AM +0300, Amir Goldstein wrote:
> > > > On Fri, Mar 24, 2023 at 8:19=E2=80=AFPM Allison Henderson
> > > > <allison.henderson@oracle.com> wrote:
> > > > >
> > > > > On Thu, 2023-03-16 at 12:17 -0700, Darrick J. Wong wrote:
> > > > > > Hi all,
> > > > > >
> > > > > > As I've mentioned in past comments on the parent pointers patch=
set,
> > > > > > the
> > > > > > proposed ondisk parent pointer format presents a major difficul=
ty for
> > > > > > online directory repair.  This difficulty derives from encoding=
 the
> > > > > > directory offset of the dirent that the parent pointer is mirro=
ring.
> > > > > > Recall that parent pointers are stored in extended attributes:
> > > > > >
> > > > > >     (parent_ino, parent_gen, diroffset) -> (dirent_name)
> > > > > >
> > > > > > If the directory is rebuilt, the offsets of the new directory e=
ntries
> > > > > > must match the diroffset encoded in the parent pointer, or the
> > > > > > filesystem becomes inconsistent.  There are a few ways to solve=
 this
> > > > > > problem.
> > > > > >
> > > > > > One approach would be to augment the directory addname function=
 to
> > > > > > take
> > > > > > a diroffset and try to create the new entry at that offset.  Th=
is
> > > > > > will
> > > > > > not work if the original directory became corrupt and the paren=
t
> > > > > > pointers were written out with impossible diroffsets (e.g.
> > > > > > overlapping).
> > > > > > Requiring matching diroffsets also prevents reorganization and
> > > > > > compaction of directories.
> > > > > >
> > > > > > This could be remedied by recording the parent pointer diroffse=
t
> > > > > > updates
> > > > > > necessary to retain consistency, and using the logged parent po=
inter
> > > > > > replace function to rewrite parent pointers as necessary.  This=
 is a
> > > > > > poor choice from a performance perspective because the logged x=
attr
> > > > > > updates must be committed in the same transaction that commits =
the
> > > > > > new
> > > > > > directory structure.  If there are a large number of diroffset
> > > > > > updates,
> > > > > > then the directory commit could take an even longer time.
> > > > > >
> > > > > > Worse yet, if the logged xattr updates fill up the transaction,
> > > > > > repair
> > > > > > will have no choice but to roll to a fresh transaction to conti=
nue
> > > > > > logging.  This breaks repair's policy that repairs should commi=
t
> > > > > > atomically.  It may break the filesystem as well, since all fil=
es
> > > > > > involved are pinned until the delayed pptr xattr processing
> > > > > > completes.
> > > > > > This is a completely bad engineering choice.
> > > > > >
> > > > > > Note that the diroffset information is not used anywhere in the
> > > > > > directory lookup code.  Observe that the only information that =
we
> > > > > > require for a parent pointer is the inverse of an pre-ftype dir=
ent,
> > > > > > since this is all we need to reconstruct a directory entry:
> > > > > >
> > > > > >     (parent_ino, dirent_name) -> NULL
> > > > > >
> > > > > > The xattr code supports xattrs with zero-length values, surpris=
ingly.
> > > > > > The parent_gen field makes it easy to export parent handle
> > > > > > information,
> > > > > > so it can be retained:
> > > > > >
> > > > > >     (parent_ino, parent_gen, dirent_name) -> NULL
> > > > > >
> > > > > > Moving the ondisk format to this format is very advantageous fo=
r
> > > > > > repair
> > > > > > code.  Unfortunately, there is one hitch: xattr names cannot ex=
ceed
> > > > > > 255
> > > > > > bytes due to ondisk format limitations.  We don't want to const=
rain
> > > > > > the
> > > > > > length of dirent names, so instead we create a special VLOOKUP =
mode
> > > > > > for
> > > > > > extended attributes that allows parent pointers to require matc=
hing
> > > > > > on
> > > > > > both the name and the value.
> > > > > >
> > > > > > The ondisk format of a parent pointer can then become:
> > > > > >
> > > > > >     (parent_ino, parent_gen, dirent_name[0:242]) ->
> > > > > > (dirent_name[243:255])
> > > >
> > > > With VLOOKUP in place, why is this better than
> > > > (parent_ino, parent_gen) -> (dirent_name)
> > > >
> > > > Is it because the dabtree hash is calculated only on the key
> > > > and changing that would be way more intrusive?
> > >
> > > Yes.  The dabtree hash is calculated on the full attr name, so this i=
s
> > > an attempt to reduce hash collisions during parent pointer lookups by
> > > stuffing as many bytes in the attr name as possible.
> > >
> > > It would be very easy to change the xfs_da_hashname calls inside
> > > xfs_parent.c to use either the full dirent name (i.e. pptr hash match=
es
> > > dirent hash) or use the full parent pointer and not just the attr key=
,
> > > but that would be a major break from the tradition that the da hash i=
s
> > > computed against the attr name only.
> > >
> > > (I'm not opposed to doing that too, but one breaking change at a time=
.
> > > ;))
> > >
> > > > Does that mean that user can create up to 2^12
> > > > parent pointers with the same hash and we are fine with it?
> > >
> > > Yes.  The dabtree can handle an xattr structure where every name hash=
es
> > > to the same value, though performance will be slow as it scans every
> > > attr to find the one it wants.
> > >
> > > The number of parent pointers with the same hash can be much higher
> > > than 2^12 -- I wrote a dumb C program that creates an arbitrary numbe=
r
> > > of attr names with identical hashes.  It's not fast when you get past
> > > 100,000. :P
> > >
> >
> > Right.
> > So how about
> > (parent_ino, parent_gen, dirent_hash) -> (dirent_name)
> >
> > This is not a breaking change and you won't need to do another
> > breaking change later.
> >
> > This could also be internal to VLOOKUP: appended vhash to
> > attr name and limit VLOOKUP name size to  255 - vhashsize.
>
> The original "put the hash in the xattr name" patches did that, but I
> discarded that approach because it increases the size of each parent
> pointer by 4 bytes, and was really easy to make a verrrry slow
> filesystem:
>
> I wrote an xfs_io command to compute lists of names with the same
> dirhash value.  If I created a giant directory with the same file
> hardlinked millions of times where all those dirent names all hash to
> the same value, lookups in the directory gets really slow because the
> dabtree code has to walk (on average) half a million dirents to find the
> matching one.
>
> There were also millions of parent pointer xattrs, all with the same
> attr name and hence the same hash value here too.  Doing that made the
> performance totally awful.  Changing the hash to crc32c and then sha512
> made it much harder to induce collision slowdowns on both ends like
> that, though sha512 added a noticeable performance hit for what it was
> preventing.
>

OK, but this attack is applicable to the dabtree hash itself only with
the proposed dirent_name[0:242] key, is it not?

> Hopefully the fact that the attr name starts with 12 bytes (4 of which
> aren't known to unprivileged userspace) and omits the last 12 bytes of
> the dirent name will make it harder to generate double-collisions.
> Granted there's probably someone who's more math-smart than me who can
> figure this out.

My concern is that generating 7^12 collisions using all the possible
printable suffix dirent_name[243:255] is so simple that even a non-maliciou=
s
but rather unlucky script would end up hitting those collisions:
Report_$ORGANIZATION_$DEPARTEMT_$PRODUCT_$PROJECT_...
$GROUP_$OWNER_$DATE_$TIME_$ID.pdf
You get what I mean...

So my thinking was that the unlucky should not suffer the same penalty
as the malicious.

Thanks,
Amir.
