Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEE91487FE
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 05:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737523312; cv=none; b=dR16w/P6/R2giBkt68iBRg1FptQb9ZDnZafb9phtg50V7NPopolXN/uuoNdkKBAeHdpF45QlW9p54oEZ4tawwz3vmxhafSnOSI+adBkvghnJuuwsCLl9QAJKtiUb+2aFpoMKHmTcKYTnlc/U0dOHzK7jnTjeOkvHUt3HhDohVv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737523312; c=relaxed/simple;
	bh=UTWz/bmCZZYU1LZ5ZRhUUvhP/HBZNLGpxFRpB0lxiEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvsvWBV4IAuk1JeAsd8AhkKlD8lO42LS+Zp6lGj7/qB2XP+ZPaBx1JmjbNqBq8byvayMnCluAf8y6day6Kytntvn7V27TeMWflNgkZZep8sjit8Jhuu2FJIud0LRWoKaV9XOIm1Z+J8+tBtWtG9pHrqumTcisuiy8YHTJDywB/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=VeXyLt5j; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="VeXyLt5j"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2156e078563so85341715ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 21:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737523310; x=1738128110; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HWK2P/XHD1Mf2BaG5j25AIwyCS/6y2CV9rzh02z6IvQ=;
        b=VeXyLt5jT92mv/tUBFEjnvmNHID3DExtEVYNMwdv5j5jdHnk1z3XSsjMf8FIZ+6hcp
         SMdHQaK9SX1W1fQ3ur4aNhq76xnxG+l/LjOXjPrVCTuKWLWv+pg+LXOEsnhthRhIYUSI
         adZQpcETP8b8OxG5Sj8d8/ViW3IQw+1VYse2OwhEQtyTwMJvDVyGsbjEMrR3aMFg4/xI
         wo7/8h6ZtG1SlmwGXTWmEvoC88zaJL2X8xzPuKRUdyMfb/ovIaP6yVdop6g8EXIcfyZn
         0H72DliHgheZqpCR8xPPJf5hWj4m/qDi7HuBZ15sgbvc/RjC32oX8bLbB/nwiO+zX9zc
         41Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737523310; x=1738128110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HWK2P/XHD1Mf2BaG5j25AIwyCS/6y2CV9rzh02z6IvQ=;
        b=I/8pGBHvIElyrLQxRnI74MwMKWGNZvdRcOrikYSAFJzmajszr6KzrkDwiC4qLXRoRt
         KKvR99nyOM0QLLrTcWEZBPIetJfPO02DPHse5bA0Z3h0zVqtxdlf9P2dFVcepdTgyJc6
         11BLNfEw2oRHIonnZ0e+C4mXCjHVnVnxksNTD8ycpV9NrrQfJppKkFnyLiYz420KElbz
         j2CnnflV/J7Unx8ex94qYjYc91Gz4ge4JoSOXt+Z8l9dxoGrMwiNDnsXsN6I+qTORKtZ
         U0yNhtcctXGpZFRpe3E+EorMXNnzKrrdvdf24+N3dv1jbygbF4kTtNazVFmgz3P3K9kz
         cktg==
X-Forwarded-Encrypted: i=1; AJvYcCVH3+WEMcwSKccXxCv60dNPkYscoNdR9SlY3sD0AO91C2+kIy7WYyT3QmbBiRLU3qdVkpl4D1lOeVs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6pNKKo5ML+8KwdqF76VG7yIkgML/vrKw5+42r7+Glr0nLBKvm
	VObeRuyHsNJT/1zyZgOeSiCuDjc4wM+zleLaN8GLsfnwfda5MhR7glbKQ3QAG5KTOvMwuU3DDvE
	G
X-Gm-Gg: ASbGncvy2j3trFSBxeXJr7SteKYFuUH3L2duEsoQKoOaoYMd6O6jOpNCoAXRp1AXFNG
	Wzb0OixLX31G0sJVZJ3FyzEHD545oJr/Xd4bCrjT3/L2oofB537/54jHGLzabcHPlcfsQTwqhko
	lE+XNgF07XJ+S9xNsZF+1Dg2ttxbn+WEvcyGsknGX74tDZ8BEdhheXAQ8QT/IU8uRcy0eKojfGI
	a9B18FLudfVa4o6UyqguGRwDlE3HoZJWmqN2XCs5yQ6b5qGi4qe9j+S2DWrFcUDSvBis0Ly+kjC
	rBZTS3ZKqu0eS1SfWcuhGkdEdCJyJPQlQ20O0cCxO86yww==
X-Google-Smtp-Source: AGHT+IH5R7pj8qLDenAoga+QJkWuqr4FgKHgan+NZCtM4+EprtmjwkKltMGWrn6lPQVE8Nw/9oijbg==
X-Received: by 2002:a17:902:d501:b0:20c:9821:6998 with SMTP id d9443c01a7336-21c352c798emr356015375ad.10.1737523309911;
        Tue, 21 Jan 2025 21:21:49 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2cea0531sm88261955ad.24.2025.01.21.21.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 21:21:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1taTBS-00000008xQR-3036;
	Wed, 22 Jan 2025 16:21:46 +1100
Date: Wed, 22 Jan 2025 16:21:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/23] common/xfs: find loop devices for non-blockdevs
 passed to _prepare_for_eio_shutdown
Message-ID: <Z5CAaq-SN96RSvfZ@dread.disaster.area>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974243.1927324.9105721327110864014.stgit@frogsfrogsfrogs>
 <Z48kffpLwUr1xMmT@dread.disaster.area>
 <20250122040542.GV1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122040542.GV1611770@frogsfrogsfrogs>

On Tue, Jan 21, 2025 at 08:05:42PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 21, 2025 at 03:37:17PM +1100, Dave Chinner wrote:
> > On Thu, Jan 16, 2025 at 03:28:02PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > xfs/336 does this somewhat sketchy thing where it mdrestores into a
> > > regular file, and then does this to validate the restored metadata:
> > > 
> > > SCRATCH_DEV=$TEST_DIR/image _scratch_mount
> > 
> > That's a canonical example of what is called "stepping on a
> > landmine".
> 
> 60% of fstests is written in bash, all of it is a friggin land mine
> because bash totally lets us do variable substitution at any time, and
> any time you make a change you have to exhaustively test the whole mess
> to make sure nothing broke...

Yes, I know, which is why the moment I saw xfs/336 I called it out -
it has never run on my machines, ever...

> (Yeah, I hate bash)

Not a great fan of it myself. But it's no worse than other scripting
languages that use JIT based syntax checking from the "if it wasn't
run it ain't tested" perspective.

> > We validate that the SCRATCH_DEV is a block device at the start of
> > check and each section it reads and runs (via common/config), and
> > then make the assumption in all the infrastructure that SCRATCH_DEV
> > always points to a valid block device.
> 
> We do?

fstests configurations for block based filesystems have always been
based on block devices and mount points, not image files. 

Yes, you can pass an image file to XFS utilities and they will do
the right thing, but not all filesystems or all the infrastructure
in fstests can handle an image file masquerading as a device.

I certainly didn't expect it.....

> Can you point me to the sentence in doc/ that says this
> explicitly? 

fstests is woefully under-documented - especially when it comes to
configuration constraints and behaviours - so I doubt it is actually
specified anywhere. AFAIA it has never been raised in discussion
for a long time (not since we added network filesystem support a
long time ago, IIRC)

However, the code is pretty explicit - common/config is responsible
for setting up and validating the runtime config before any test can
run. All test and scratch devices are passed through this
validation:

_check_device()
{
        local name=$1
        local dev_needed=$2
        local dev=$3

        if [ -z "$dev" ]; then
                if [ "$dev_needed" == "required" ]; then
                        _fatal "common/config: $name is required but not defined!"
                fi
                return 0
        fi

        if [ -b "$dev" ] || ( echo $dev | grep -qE ":|//" ); then
                # block device or a network url
                return 0
	fi

	case "$FSTYP" in
        9p|fuse|tmpfs|virtiofs|afs)
	.....
	*)
                _fatal "common/config: $name ($dev) is not a block device or a network filesystem"
        esac
}
....

Basically, it says that all the test and scratch devices (including
the external ones) must be either a block device, a network URL, or
a string that the specific filesystem under test must recognise and
accept (e.g. a directory for overlay filesystems). Otherwise fstests
will fail to run with an explicit error message that says:

	<device> is not a block device or network filesystem

Nowhere in this config validation process does fstests consider
image files as a valid device configuration for a block based
filesystem.

If we need to do stuff with a image files, we have the
infrastructure to create loop devices and then operate directly on
that dynamic loop device(s) (e.g. _mkfs_dev, _mount, _unmount,
_check_xfs_filesystem, etc) that are created.

> There's nothing I can find in the any docs and
> _try_scratch_mount does not check SCRATCH_DEV is a bdev for XFS.

That's because it's validated before we start running tests and the
assumption is that nobody is screwing with SCRATCH_DEV in a way
that makes it behave vastly differently.

Consider what it means to have to do runtime checking of the
device validity in common code before we do anything with the
device. We'd have to sprinkle _check_device calls -everywhere-.

We'd also have to check logdev and rtdev variables if USE_EXTERNAL
is set, too.

That's not a viable development strategy, nor is it a maintainable
solution to the issue at hand. It's far simpler to fix one test not
to use this trick than it is to declare "nobody can trust TEST_DEV
or SCRATCH_DEV to be a valid block device" and have to handle that
everywhere those variables are used...

> That needs to be documented.

Sure.

> > > Fix this by detecting non-bdevs and finding (we hope) the loop device
> > > that was created to handle the mount. 
> > 
> > What loop device? xfs/336 doesn't use loop devices at all.
> > 
> > Oh, this is assuming that mount will silently do a loopback mount
> > when passed a file rather than a block device. IOWs, it's relying on
> > some third party to do the loop device creation and hence allow it
> > to be mounted.
> > 
> > IOWs, this change is addressing a landmine by adding another
> > landmine.
> 
> Some would say that mount adding the ability to set up a loop dev was
> itself *avoiding* a landmine from 90s era util-linux.

True.

But in the case of fstests we explicitly create loop
devices so that we don't have to play whacky games to find the
random loop device that mount magically creates when you pass it a
file.

Making all the image file and loop device usage consistent across
all of fstests was part of the infrastructure changes in my initial
check-parallel patchset. This was necessary because killing tests
with ctrl-c would randomly leave dangling mounts and loop devices
because many tests did not have _cleanup routines to tear down
mounts that auto-created loop devices or clean up loop
devices they created themselves properly.

Part of those changes was fixing up the mess in some XFS tests
where that mixed loop device and image file based operations
interchangably. I didn't notice x/336 because it wasn't
running on my test system and so didn't attempt to fix it at the
same time...

> > I really think that xfs/336 needs to be fixed - one off test hacks
> > like this, while they may work, only make modifying and maintaining
> > the fstests infrastructure that much harder....
> 
> Yeah, it'll get cleaned up for the rtrmap fstests merge.

Thanks!

-Dave.

-- 
Dave Chinner
david@fromorbit.com
