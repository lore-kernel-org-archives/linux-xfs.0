Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCBE20ADC7
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 11:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739359014; cv=none; b=AjB+/m5mrBB5aPphav6zTkamybXQ7wksPehMmGjUYBKZvZpwAMU7Nde+nILFiCJv1OvxAXS3av6awvWdufQ+UMJ/6UW0aMB1RHSS9teZwXaEtSenuBrg9aOM0FpHFDQcarxbDU/58lRR3cTGiXPzXYjhV2QMppdsCPQ9hClKE9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739359014; c=relaxed/simple;
	bh=/Hmic873PViIBmjbX3eJTmSLd/0IuCygH3adUr7rNXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YyNoSmQizdqCInLTRiFex0Q5UYP8+48BnHp6vS85Ac0/cncYcT6q9X7SKSNfVQkLf5G4Gi+incRXpXm4bXVeetUvbp27ga/VujH6DRHg1vkcJsHEQ9vPGvbhk0YyMauBZMof+Hh5FoaXnpvCHqD5GJ5XyPfC7roie7hVUVuq/rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hcA1CEIz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hcA1CEIz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739359012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awFjy1hx2p7IODKUb+VcKnx6TZ3CdIOmyYRqbfcJGNc=;
	b=hcA1CEIz2oXkZBQ+4BLsaM9nmJh0jrvQVW8nbrQJv3B3EQLLK0RgCK2FCDiBRYGiy2dHrz
	8olgDjT6JDt5Twf3i9EdnaG3fmaaOrkClf+tcQXfXMtCZuIMdu6NJ/2d+exWvn31nikbbC
	IoJfZn9XzJsplL0vXuE9PIfTLxE2VAA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-OiJlS0XtMjmytCam18FaQg-1; Wed, 12 Feb 2025 06:16:50 -0500
X-MC-Unique: OiJlS0XtMjmytCam18FaQg-1
X-Mimecast-MFC-AGG-ID: OiJlS0XtMjmytCam18FaQg
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5d90b88322aso5996771a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 03:16:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739359009; x=1739963809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=awFjy1hx2p7IODKUb+VcKnx6TZ3CdIOmyYRqbfcJGNc=;
        b=hLjnMzonANoNIAVKz3HOJ63vl+Yjopm7AAC/yzGWQ7kWYNI29EvtJpBfJyrV7z0kH5
         3nxVSxBdnZPTqCfU0FTDca+rGUt/Wbz0Hc1eXiVqmfXx4gZ5MTcGs1TLKQiI/LfeJygJ
         JosipdhhCAu+ewec2LaGkRKWcxEz5oh134SoIiSU4UFIhV4zF3tcl+f1Xn2eQn7h0Clk
         LnQKB7bnc+LN0kdQb2dcsZhxgHgjpdKRAXgmjdcGPvj2aetP8ISwSDT8IAo4jkLu+mLI
         6OmVC7wwKSwjlKwBLOiIqSy/HATwk9ivFq2yrt8sgpHE8yHLXNXB8v/H2KpHm9j1yImf
         CyMg==
X-Gm-Message-State: AOJu0YzQw1PtygGiN1YGeYyapW4H0iIVKTCmALts/usUVJA92YnOAMlG
	1mMQqqJPjYQIPNT0DcbUBFeGBR8PL5D2sYG7BDMUVmub5BhWTdfec0M4cDO9S/eVP6VtGH7ihXT
	rjxtuB2PV3Fcqtm57XWAV8DnON/1ZLrzOpJWYWyXRvxmouDar6nbNt5G+1IlwdoW9xtY=
X-Gm-Gg: ASbGncv51WHQDaYDMTxEMKZxmydu/tvc/tJmUUhVqu0SN7ePi/Zx9pzopx81H/m+wxS
	0IHLgOdRRTtPMOf7kZpPt5ahRqoH7of5xoM4w8dLPXbX1AN+D5iTzyqxgGMhVM/GwVMtICEq25k
	tGecFWZelqAJx/QWXpNj9bOQiRG4PnOlbdu3iMxLPq3bF//J9GuMG0zDkz6DN4h1QzjMdmn8syA
	8ENMkDCjjuP/m5tspZgerfoUEFQJg1GSrMKdTN9d2ustVtFZ7fwzBIVA3YlfoazYuCSMG7X5z9X
	h5PuUicfUsHRhK/2MmSJ8rDT
X-Received: by 2002:a05:6402:2106:b0:5dc:5e4b:3e21 with SMTP id 4fb4d7f45d1cf-5deadda3237mr2304023a12.9.1739359009130;
        Wed, 12 Feb 2025 03:16:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGWIl514/xcDZXaCA3zGOlKRX5JYu4L2Cn7MQ6IRSpFLthoJD0920tbRuX4xivfGKeeAjRgkw==
X-Received: by 2002:a05:6402:2106:b0:5dc:5e4b:3e21 with SMTP id 4fb4d7f45d1cf-5deadda3237mr2304000a12.9.1739359008625;
        Wed, 12 Feb 2025 03:16:48 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dcf1b734e5sm11486017a12.5.2025.02.12.03.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 03:16:48 -0800 (PST)
Date: Wed, 12 Feb 2025 12:16:46 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v3 5/8] Add git-contributors script to notify about merges
Message-ID: <rzlzwjixwg7i442ohupcovrtol4awuhwusdm6uwx36jphf4sqy@2qx3yccpkqba>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
 <20250211-update-release-v3-5-7b80ae52c61f@kernel.org>
 <20250211185804.GD21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211185804.GD21808@frogsfrogsfrogs>

On 2025-02-11 10:58:04, Darrick J. Wong wrote:
> On Tue, Feb 11, 2025 at 06:26:57PM +0100, Andrey Albershteyn wrote:
> > Add python script used to collect emails over all changes merged in
> > the next release.
> > 
> > CC: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  tools/git-contributors.py | 94 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 94 insertions(+)
> > 
> > diff --git a/tools/git-contributors.py b/tools/git-contributors.py
> > new file mode 100755
> > index 0000000000000000000000000000000000000000..83bbe8ce0ee1dcbd591c6d3016d553fac2a7d286
> > --- /dev/null
> > +++ b/tools/git-contributors.py
> > @@ -0,0 +1,94 @@
> > +#!/usr/bin/python3
> > +
> > +# List all contributors to a series of git commits.
> > +# Copyright(C) 2025 Oracle, All Rights Reserved.
> > +# Licensed under GPL 2.0 or later
> > +
> > +import re
> > +import subprocess
> > +import io
> > +import sys
> > +import argparse
> > +import email.utils
> > +
> > +DEBUG = False
> > +
> > +def backtick(args):
> > +    '''Generator function that yields lines of a program's stdout.'''
> > +    if DEBUG:
> > +        print(' '.join(args))
> > +    p = subprocess.Popen(args, stdout = subprocess.PIPE)
> > +    for line in io.TextIOWrapper(p.stdout, encoding="utf-8"):
> > +        yield line
> > +
> > +class find_developers(object):
> > +    def __init__(self):
> > +        tags = '%s|%s|%s|%s|%s|%s|%s|%s' % (
> > +            'signed-off-by',
> > +            'acked-by',
> > +            'cc',
> > +            'reviewed-by',
> > +            'reported-by',
> > +            'tested-by',
> > +            'suggested-by',
> > +            'reported-and-tested-by')
> > +        # some tag, a colon, a space, and everything after that
> > +        regex1 = r'^(%s):\s+(.+)$' % tags
> > +
> > +        self.r1 = re.compile(regex1, re.I)
> > +
> > +    def run(self, lines):
> > +        addr_list = []
> > +
> > +        for line in lines:
> > +            l = line.strip()
> > +
> > +            # emailutils can handle abominations like:
> > +            #
> > +            # Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
> > +            # Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
> > +            # Reviewed-by: bogus@simpson.com
> > +            # Cc: <stable@vger.kernel.org> # v6.9
> > +            # Tested-by: Moo Cow <foo@bar.com> # powerpc
> > +            m = self.r1.match(l)
> > +            if not m:
> > +                continue
> > +            (name, addr) = email.utils.parseaddr(m.expand(r'\g<2>'))
> > +
> > +            # This last split removes anything after a hash mark,
> > +            # because someone could have provided an improperly
> > +            # formatted email address:
> > +            #
> > +            # Cc: stable@vger.kernel.org # v6.19+
> > +            #
> > +            # emailutils doesn't seem to catch this, and I can't
> > +            # fully tell from RFC2822 that this isn't allowed.  I
> > +            # think it is because dtext doesn't forbid spaces or
> > +            # hash marks.
> > +            addr_list.append(addr.split('#')[0])
> 
> I think it's the case that the canonical stable cc tag format for kernel
> patches as provided by the stable kernel process rules document:
> 
> Cc: <stable@vger.kernel.org> # vX.Y
> 
> is not actually actually rfc5322 compliant, so strings like that break
> Python's emailutils parsers.  parseaddr() completely chokes on this, and
> retuns name=='' and addr=='', because the only thing that can come after
> the address portion are whitespace, EOL, or a comma followed by more
> email addresses.  There's definitely not supposed to be an octothorpe
> followed by even more text.
> 
> In the end I let myself be nerdsniped with even more string parsing bs,
> and this loop body is the result:
> 
> 		l = line.strip()
> 
> 		# First, does this line match any of the headers we
> 		# know about?
> 		m = self.r1.match(l)
> 		if not m:
> 			continue
> 
> 		# The split removes everything after an octothorpe
> 		# (hash mark), because someone could have provided an
> 		# improperly formatted email address:
> 		#
> 		# Cc: stable@vger.kernel.org # v6.19+
> 		#
> 		# This, according to my reading of RFC5322, is allowed
> 		# because octothorpes can be part of atom text.
> 		# However, it is interepreted as if there weren't any
> 		# whitespace ("stable@vger.kernel.org#v6.19+").  The
> 		# grammar allows for this form, even though this is not
> 		# a correct Internet domain name.
> 		#
> 		# Worse, if you follow the format specified in the
> 		# kernel's SubmittingPatches file:
> 		#
> 		# Cc: <stable@vger.kernel.org> # v6.9
> 		#
> 		# emailutils will not know how to parse this, and
> 		# returns empty strings.  I think this is because the
> 		# angle-addr specification allows only whitespace
> 		# between the closing angle bracket and the CRLF.
> 		#
> 		# Hack around both problems by ignoring everything
> 		# after an octothorpe, no matter where it occurs in the
> 		# string.  If someone has one in their name or the
> 		# email address, too bad.
> 		a = m.expand(r'\g<2>').split('#')[0]
> 
> 		# emailutils can extract email addresses from headers
> 		# that roughly follow the destination address field
> 		# format:
> 		#
> 		# Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
> 		# Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
> 		# Reviewed-by: bogus@simpson.com
> 		# Tested-by: Moo Cow <foo@bar.com>
> 		#
> 		# Use it to extract the email address, because we don't
> 		# care about the display name.
> 		(name, addr) = email.utils.parseaddr(a)
> 		addr_list.append(addr)
> 
> <shrug> but maybe we should try that on a few branches first before
> committing to this string parsing mess ... ?  Not that this is any less
> stupid than the previous version I shared out. :(

Can we just drop anything with 'stable@'? These are patches from
libxfs syncs, do they have any value for stable@ list?

But the change is still make sense if anyone uses hash mark for
something else, I will apply your change.

-- 
- Andrey

