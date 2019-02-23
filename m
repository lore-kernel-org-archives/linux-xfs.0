Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43128 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfBWScB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Feb 2019 13:32:01 -0500
Received: by mail-pl1-f194.google.com with SMTP id m10so2561507plt.10
        for <linux-xfs@vger.kernel.org>; Sat, 23 Feb 2019 10:32:01 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <80675DA8-062B-4A31-ACC9-449AC55D1847@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_87B4C2F2-8451-4D21-B0CF-FBF2A4C6CE5D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Date: Sat, 23 Feb 2019 10:32:37 -0800
In-Reply-To: <20190222190048.GA29624@vader>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard> <20190214231429.GE9819@vader>
 <20190215001657.GY14116@dastard> <20190215065947.GG9819@vader>
 <72A04438-5991-4A60-8AAB-021A41DE6711@dilger.ca>
 <20190218221820.GF14116@dastard> <20190222190048.GA29624@vader>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs <linux-xfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Steve French <sfrench@samba.org>


--Apple-Mail=_87B4C2F2-8451-4D21-B0CF-FBF2A4C6CE5D
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On Feb 22, 2019, at 11:00 AM, Omar Sandoval <osandov@osandov.com> wrote:
> 
> On Tue, Feb 19, 2019 at 09:18:20AM +1100, Dave Chinner wrote:
>> On Sat, Feb 16, 2019 at 06:57:45PM -0700, Andreas Dilger wrote:
>>> While it may be a bit of a stretch to call this "forensic evidence",
>> 
>> We do forensic analysis of corrupt filesystems looking for evidence
>> of what went wrong, not just looking for evidence of what happened
>> on systems that have been broken into.
>> 
>>> making it hard to change from except via total root compromise by a
>>> skilled hacker is very useful.
>> 
>> *nod*.
>> 
>>> If this were to go in (which I'm not in favour of), then there would
>>> need to be a CONFIG and/or runtime knob to turn it off (or better to
>>> only turn it on), similar to how FIPS and other security options can
>>> only go in one direction.
>> 
>> The problem here is that "inode birth time" is being conflated with
>> "user document creation time". These two things are very different.
>> 
>> i.e. One is filesystem internal information and is not related to
>> when the original copy of the data in the file was created, the
>> other is user specified metadata that is related to the file data
>> contents and needs to travel with the data, not the filesystem.
>> 
>> IMO, trying to make one on-disk field hold two different types of
>> information defeats one or the other purpose, and nobody knows which
>> one the field stores for any given file.
>> 
>> I'd suggest that "authored date" should be a generic system xattr so
>> most filesystems support it, not just those that have a birth time
>> field on disk. Sure, modify it through utimesat() and expose it
>> through statx() (as authored time, not birth time), but store it a
>> system xattr rather than an internal filesystem metadata field that
>> requires was never intended to be user modifiable.
> 
> It seems that this is the general consensus, so I'll look into
> implementing this functionality as an xattr.

I would recommend to look at how Samba is storing these attributes
today, and do the same thing, maybe add support into GNU coreutils
to handle this transparently.

Cheers, Andreas






--Apple-Mail=_87B4C2F2-8451-4D21-B0CF-FBF2A4C6CE5D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxxkcUACgkQcqXauRfM
H+C9Xw//X1n0jOmRTE6hBjU23kQZyxxsgJVPhG+wekrSO2IixYt9aKoeRWnL/Umq
4o9LvCkUB0bs40X6kr+r8K/QfjJt9tKlUSxZ80F159ecEPfJAUO9ZOvjPOt1jeA3
hlPoOwPziYNht90m8Sc9WpYN0qmtN1021rcU8hwBbaX31DBs6JEUj4MxO2Oo8XA/
C+eiORtc6EBqsVUF38V8ln3b384C51//1WqG2/HMlWxbzNILK8jkV71slD7xb7Vj
lkgHXcJKK8uDs+908XqNnjtn+qs2HpyJxQ4N46EIEE5PNStbDfSluBHTG7ME4TqH
GB9ezg2wEh1cSjGsg3Vx4jFsKow+esxWAruZYlW36k1MmBucd1ALSSuJ6IfC2WrZ
8iGnpUaLmLvlnlSKeIgv6nkZppYCbY9DHfZFmn5GoOtCDCZvi0QgFo17Nf/SifeD
nP6lp8Mt9Jlymrpc8qTbxfM0e4cO2Zp9gPkzFKIwXrp4sMBBGcnC8+cHRKgIX56h
M/cM49ApzP08XRSf9kClLnkEMOnMxEvf3kXySqd3yyqJnG5X9xotdiGNldQMTcnc
Rq83fqRrMJShOIHwvqFnDmsqGOvPdWN56mBMEjKNbQ2Yj2OPybJMVaRcIURs0iLs
A64oEE8lLjK+PdMkugInBhfu0gSxYVScA1r/CSBIgTKmp21LfTo=
=UOd0
-----END PGP SIGNATURE-----

--Apple-Mail=_87B4C2F2-8451-4D21-B0CF-FBF2A4C6CE5D--
