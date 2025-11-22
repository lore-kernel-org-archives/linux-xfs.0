Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C380E22B8A9
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 06:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763793578; cv=none; b=UMsb/vtXQc8R/VAgTTskCYBC/4s+Z7P+3tMA2Aa+PS5f3/c8E6Qye0DG1xJw+BLD+FZYuIsewyFwieAtPacSLQw+gnFi/UGn96PgJkguqVqdy/BeHNx8z+JXZFTgwsyFvhPOD5RJ1L/4SoDNr9VKlP5Qn6HBgnHmi90gJWfZFXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763793578; c=relaxed/simple;
	bh=am8ixBoMKhsSF/MdBH5QgyIc0JcOcDSbE9v7y8W7vhY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P5FoYffRFUczVM8C2bQTkBgvLfTJ6QYvRSjY4mkfNqwRvyx/Y9QsRcF/Wjc3G4ri0JPazHcJw8fIKB8l1+syE7zyXbeLnfJk3oBXMMrmU7uoz97rwqK6sLuF8iKB8Z7/09fQ652mhBGhGKMgiQ/rijGfqja5hFBX0Id8rXjEEoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UOsEbks2; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOsEbks2"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4eddfb8c7f5so23140431cf.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 22:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763793576; x=1764398376; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YW35sxUxIlGDrd2+h8IaRlcKG4sa3HfSuqLbLrmJaJI=;
        b=UOsEbks2ETZlpevp2wsBrS95rOb47R4fomatUlx3t7+xWyXKXRr8cSWc0/SdR2wQDG
         6mzUDofKXpdvZwLPVYxas1yYzAqKd4qpyhNMeGNKRNl2PT43y+G7RdeB188W/5XEHDUB
         pugUTavP2UUsT59EXEykWAs1wt2qxITp11DvcU9aAZttXCkHc88pjkizcq/KmcE5rmBr
         /gRNA4Z2HBXWKZLDBdggp0vo0xFo7IpSf+z/ZVidhy645Wbf7lSOc1gj9cH5hYF89pcd
         1XPNtCPivJU3oEqwhWBTqNM7VQqroSuDwNeq2UngWYsHbe+J0WrcJvOf1T2VBq8DLij2
         S0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763793576; x=1764398376;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YW35sxUxIlGDrd2+h8IaRlcKG4sa3HfSuqLbLrmJaJI=;
        b=OvJBZ5HBS5BM/SkPb7FrqmfP4X7CdjYSSpAgP/RWWzQscF+wc2VFRwZNedRGVfCEA9
         VGhtMApYTOP3TSOgN0U6YPuCvLD3/3inoM35M/d7t90Mh+SZAbhs/dqQgM1gSd3pHOyP
         B6Lp77qm0wMEvBgL7RawNZhExtXclQhnrFIL5EQX5Sw2Vfi3k+9gJV8ByP42MbVQYeRn
         flVG8+jhdHbdmdOzfMmrBrgcNwtCEGZkGygOkCOkBsc4wKPF6L7H4U/dW5Poj1wFFEqZ
         JeQdEc/sPsQyFHX5LbUnZpb7RnST0OOxUgTxupEmuc1wPEuxehKeWHrFvw4DfeU7PSZ8
         4SPg==
X-Forwarded-Encrypted: i=1; AJvYcCXFh3zGAjHmz0c1YnwekSOz3Bu9WBzDsVk+9tI2tDHoS2Fgtum8IJBkp2UjmxqZF1o0rlecLFL0OZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDhC0qRmiB2AgpFAWdRH/BuRiY/C5XlTZ2tvqS58O2LlwUxfPA
	aFUyw4Xo6ZAJefiJALDak8giTe8tfqweyFJnNRCQSsorjYNbV4Z1WqUyiFTjhCJgT6plAaiWi4D
	ynt0jN99vGR1afasQI8wrbn0ca8s6sjw=
X-Gm-Gg: ASbGncuQTzlwnso6dSNvOrTXDCSsHDCkXdZtpfUzp98cgY4pfiQO33xDkLvcpwwKUaC
	PS8C2W/P354fY3ZlVd6fspNZ1Nmb6hFlNLAiSt21am1P8c+/gVHs6lOqYN2QGAQfhdkUtmAeopv
	WV6ki2JeyIbsPw4JuJTe5hwr/i9aGEDqH1YzlpbjzXN9OZFo876uvdkQ3ymoDD1qvZM100P9j14
	YDPAC3XJwt74jFDRrTVhYwZxWGHR/SIvAx1A/6KuwYqBZL07uzYhk0hYhA0lzufeqcmZUE=
X-Google-Smtp-Source: AGHT+IF0DYx/ezSpM3sNXuPI7QGPPd1MKz4pLJ0a0/6OoiZEU9FOe4XHHmix0YrH/Vv9iTIapqMIoP7P9dG70k4KHUQ=
X-Received: by 2002:a05:622a:409:b0:4ee:84c:20c9 with SMTP id
 d75a77b69052e-4ee588cb648mr53122111cf.65.1763793575672; Fri, 21 Nov 2025
 22:39:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn> <aSBA4xc9WgxkVIUh@infradead.org>
In-Reply-To: <aSBA4xc9WgxkVIUh@infradead.org>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 22 Nov 2025 14:38:59 +0800
X-Gm-Features: AWmQ_bmXTJbUJAhOvzCNFWsbGJVgzknSUgPoO-O5XzpCN3-HI1wRpjG5vYjbcM0
Message-ID: <CANubcdVjXbKc88G6gzHAoJCwwxxHUYTzexqH+GaWAhEVrwr6Dg@mail.gmail.com>
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO Chain Handling
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B411=E6=9C=8821=
=E6=97=A5=E5=91=A8=E4=BA=94 18:37=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 21, 2025 at 04:17:39PM +0800, zhangshida wrote:
> > We have captured four instances of this corruption in our production
> > environment.
> > In each case, we observed a distinct pattern:
> >     The corruption starts at an offset that aligns with the beginning o=
f
> >     an XFS extent.
> >     The corruption ends at an offset that is aligned to the system's
> >     `PAGE_SIZE` (64KB in our case).
> >
> > Corruption Instances:
> > 1.  Start:`0x73be000`, **End:** `0x73c0000` (Length: 8KB)
> > 2.  Start:`0x10791a000`, **End:** `0x107920000` (Length: 24KB)
> > 3.  Start:`0x14535a000`, **End:** `0x145b70000` (Length: 8280KB)
> > 4.  Start:`0x370d000`, **End:** `0x3710000` (Length: 12KB)
>
> Do you have a somwhat isolate reproducer for this?
>
=3D=3D=3D=3D=3DThe background=3D=3D=3D=3D=3D
Sorry, We do not have a consistent way to reproduce this issue, as the
data was collected from a production environment run by database
providers. However, the I/O model is straightforward:

t0:A -> B
About 100 minutes later...
t1:A -> C

A, B, and C are three separate physical machines.

A is the primary writer. It runs a MySQL instance where a single thread
appends data to a log file.
B is a reader. At time t0, this server concurrently reads the log file from
A to perform a CRC check for backup purposes. The CRC check confirms
that the data on both A and B is identical and correct.
C is another reader. At time t1 (about 100 minutes after the A -> B backup
completed), this server also reads the log file from A for a CRC check.
However, this check on C indicates that the data is corrupt.

The most unusual part is that upon investigation, the data on the primary
server A was also found to be corrupt at this later time, differing from th=
e
correct state it was in at t0.

Another factor to consider is that memory reclamation is active, as the
environment uses cgroups to restrict resources, including memory.

After inspecting the corrupted data, we believe it did not originate from
any existing file. Instead, it appears to be raw data that was on the disk
before the intended I/O write was successfully completed.

This raises the question: how could a write I/O fail to make it to the disk=
?

A hardware problem seems unlikely, as different RAID cards and disks
are in use across the systems.
Most importantly, the corruption exhibits a distinct pattern:

It starts at an offset that aligns with the beginning of an XFS extent.
It ends at an offset that aligns with the system's PAGE_SIZE.

The starting address of an extent is an internal concept within the
filesystem, transparent to both user-space applications and lower-level
kernel modules. This makes it highly suspicious that the corruption
always begins at this specific boundary. This suggests a potential bug in
the XFS logic for handling append-writes to a file.

All we can do now is to do some desperate code analysis to see if we
can catch the bug.

=3D=3D=3D=3D=3D=3Dcode analysis=3D=3D=3D=3D=3D=3D
In kernel version 4.19, XFS handles extent I/O using the ioend structure,
which appears to represent a block of I/O to a continuous disk space.
This is broken down into multiple bio structures, as a single bio cannot
handle a very large I/O range:
| page 1| page 2 | ...| page N |
|<-------------ioend-------------->|
| bio 1      |  bio 2        | bio 3  |

To manage a large write, a chain of bio structures is used:
bio 1 -> bio 2 -> bio 3
All bios in this chain share a single end_io callback, which should only
be triggered after all I/O operations in the chain have completed.

The kernel uses the bi_remaining atomic counter on the first bio in the
chain to track completion, like:
1 -> 2 -> 2
if bio 1 completes, it will become:
1 -> 1 -> 2
if bio 2 completes:
1 -> 1 -> 1
if bio 3 completes:
1 -> 1 -> 0
So it is time to trigger the end io callback since all io is done.

But how does it handle a series of out-of-order completions?
if bio 3 completes first, it will become:
1 -> 2 -> 1
if bio 2 completes, since it seems forget to CHECK IF THE
FIRST BIO REACH 0 and go to next bio directly,
---c code----
static struct bio *__bio_chain_endio(struct bio *bio)
{
        struct bio *parent =3D bio->bi_private;

        if (bio->bi_status && !parent->bi_status)
                parent->bi_status =3D bio->bi_status;
        bio_put(bio);
        return parent;
}

static void bio_chain_endio(struct bio *bio)
{
        bio_endio(__bio_chain_endio(bio));
}
----c code----

it will become:
1 -> 2 -> 0
So it is time to trigger the end io callback since all io is done, which is
not actually the case. but bio 1 is still in an unknown state.



> > After analysis, we believe the root cause is in the handling of chained
> > bios, specifically related to out-of-order io completion.
> >
> > Consider a bio chain where `bi_remaining` is decremented as each bio in
> > the chain completes.
> > For example,
> > if a chain consists of three bios (bio1 -> bio2 -> bio3) with
> > bi_remaining count:
> > 1->2->2
> > if the bio completes in the reverse order, there will be a problem.
> > if bio 3 completes first, it will become:
> > 1->2->1
> > then bio 2 completes:
> > 1->1->0
> >
> > Because `bi_remaining` has reached zero, the final `end_io` callback
> > for the entire chain is triggered, even though not all bios in the
> > chain have actually finished processing. This premature completion can
> > lead to stale data being exposed, as seen in our case.
>
> It sounds like there is a problem because bi_remaining is only
> incremented after already submittin a bio.  Which code path do you
> see this with?  iomap doesn't chain bios, so is this the buffer cache
> or log code?  Or is there a remapping driver involved?
>

Yep. The commit below:

commit ae5535efd8c445ad6033ac0d5da0197897b148ea
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Dec 7 08:27:05 2023 +0100

    iomap: don't chain bios

changes the logic. Since there are still many code paths that use
bio_chain, I am including these cleanups with the fix. This provides a reas=
on
to CC all related communities. That way, developers who are monitoring
this can help identify similar problems if someone asks for help in the fut=
ure,
if that is the right analysis and fix.


Thanks,
Shida
