Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42045207DE3
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 11:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739360273; cv=none; b=TqVKYJu6f8wvKFVOIwYvL8Xv+TGs454KRhqO230X5K45ZvsEn/eEvTpsiOIEVEm5f50YVaozaJ71D/1zQZAtsa+vBxfDTTSZ08U3sY/RZ/OKTpMHtEDP3O+SrPhZCrOcR7GwALfgcNkpB47PFgXGCMG3440ndDGalqskGHAiDSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739360273; c=relaxed/simple;
	bh=seozW3Nu/y25MBEDtJOtA5Ax58jRZ5GGRSzo92iQ680=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=InCosQ20mxk9F9s+mYP8pSMEDiPjq/JWmQwXpT6BUEiB57z7QdPGVQtC0VBY2HuzRK0KrV8IL/y/vbleVThGXBLjcKmQMlT9+2SAp7jJTG6X8j2KplGVhgN+TXfXfTyYvuWGL88PyaogDZ+gBhnMa9l4oasXGXjIlvJNnzPgg4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3a78nfA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3a78nfA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739360269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0k1xauZI5iVkdS757B5lDWH6SF5u+krvwShUjpcCmZk=;
	b=P3a78nfANURJbrEkNtb6WsyElFqy3UKTF5qqH+FJFPzU1SA5k797TTGGPvcjHwiQUFsRJ4
	/8+7uNsGEn6OvhY0WMmXvYI0c/aUbhWUMpC5VKS+9ZtqOP+C2zZefJ06X++0osasWUiZhB
	7GENpFwK+acdiGURZTX+cPRp+UcC+bY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-VXje0gElPFuU5t4hdY48fw-1; Wed, 12 Feb 2025 06:37:48 -0500
X-MC-Unique: VXje0gElPFuU5t4hdY48fw-1
X-Mimecast-MFC-AGG-ID: VXje0gElPFuU5t4hdY48fw_1739360267
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5de909cf05dso2713103a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 03:37:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739360267; x=1739965067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0k1xauZI5iVkdS757B5lDWH6SF5u+krvwShUjpcCmZk=;
        b=gQ/T564OFIIrIcadQmUn21A8VgNKNpIEqp4r1hNyNqIaF54rGupyIHLSynwgN5gzFV
         0QoBXR8Erq8pZsKk+h+e1sdeTULxlB1c9kA2VPYSxp8gZe27q3iLK9IIg1deyY1PA7xv
         JVTLJPIM8ucKRHjaVaZHa7MnsoNEp9DtJ+UDPO1HncAL9K5UhkBOBR8rKFFcEnyja3Ht
         8yQaDqMklAVK5c8Xn603Q7apOIt01zX2VkPhPHbk/txVcY+D2hjelwqg6bSpxeqmC6PX
         qu0kJPE5v4xVBy1x12mbkNO8I0hVYtSIKrSqaWYZU80QLTbAHf5uO/80ewWhg3HjRKo7
         YkGw==
X-Gm-Message-State: AOJu0YzWg3gnskQo9b/oZ1G8pYu2YwNaBTvnH+l8wR+FV2ZSpDvBjNHj
	Fnoh8U7KrTEEdVbl7znqRrXkZGhExCFxjHJmyaVJq9FmXHIaEY8aSitfv1DJiKyF5YFb0WkjilH
	fJ60c3lWdSkN4ZRVDKS3YT0C1aE54kqsX0Q/tzoiTVr1UUp2KEQIQ2HC7
X-Gm-Gg: ASbGncvSbK5DQpBk1t3oRY3qWT68d2hj1Jfk4xE1iDY9jDphkJKxPPS+udmFU79+/uQ
	4HF8F8LPglpIytXLW9Cqtii0l6WIIVUumXH2OxMnNXmbQGp2PpT3jeqLV3w/rfWiOT0XA7L8Bvw
	XoI+MwtJEv1d4S46d/Ncn/oZa7ytnSwXAtAQQpVkXSnKFdhcGi7sLPn8DJYqotZ1qIGG9pwDmwF
	wNRVutf6Z8/N2aukr2HaLeBiAlWH8pAE0qgfjd7frCftonSdsevkmtMaYueMEWMR0WQt72KacXn
	2LozQwJJDSFR2JhiHhYTR/q2
X-Received: by 2002:a17:907:7207:b0:aa6:7933:8b26 with SMTP id a640c23a62f3a-ab7f3365a6amr214039266b.9.1739360267207;
        Wed, 12 Feb 2025 03:37:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHGRdPcsTRuf2pLLaeeSgb1EFpOsdpqDM91M6R0W0M5LThlsjw3i1ID/dxkJq90mlOIoQgo5w==
X-Received: by 2002:a17:907:7207:b0:aa6:7933:8b26 with SMTP id a640c23a62f3a-ab7f3365a6amr214037966b.9.1739360266777;
        Wed, 12 Feb 2025 03:37:46 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7c4da47f5sm571012466b.70.2025.02.12.03.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 03:37:46 -0800 (PST)
Date: Wed, 12 Feb 2025 12:37:45 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v3 5/8] Add git-contributors script to notify about merges
Message-ID: <okfajiswjiwtarmobpkjuce7wjyyccr44mzghryehtb7w6iqp4@wj6j54wsmxxk>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
 <20250211-update-release-v3-5-7b80ae52c61f@kernel.org>
 <20250211185804.GD21808@frogsfrogsfrogs>
 <rzlzwjixwg7i442ohupcovrtol4awuhwusdm6uwx36jphf4sqy@2qx3yccpkqba>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rzlzwjixwg7i442ohupcovrtol4awuhwusdm6uwx36jphf4sqy@2qx3yccpkqba>

On 2025-02-12 12:16:46, Andrey Albershteyn wrote:
> On 2025-02-11 10:58:04, Darrick J. Wong wrote:
> > On Tue, Feb 11, 2025 at 06:26:57PM +0100, Andrey Albershteyn wrote:
> > > Add python script used to collect emails over all changes merged in
> > > the next release.
> > > 
> > > CC: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > ---
> > >  tools/git-contributors.py | 94 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 94 insertions(+)
> > > 
> > > diff --git a/tools/git-contributors.py b/tools/git-contributors.py
> > > new file mode 100755
> > > index 0000000000000000000000000000000000000000..83bbe8ce0ee1dcbd591c6d3016d553fac2a7d286
> > > --- /dev/null
> > > +++ b/tools/git-contributors.py
> > > @@ -0,0 +1,94 @@
> > > +#!/usr/bin/python3
> > > +
> > > +# List all contributors to a series of git commits.
> > > +# Copyright(C) 2025 Oracle, All Rights Reserved.
> > > +# Licensed under GPL 2.0 or later
> > > +
> > > +import re
> > > +import subprocess
> > > +import io
> > > +import sys
> > > +import argparse
> > > +import email.utils
> > > +
> > > +DEBUG = False
> > > +
> > > +def backtick(args):
> > > +    '''Generator function that yields lines of a program's stdout.'''
> > > +    if DEBUG:
> > > +        print(' '.join(args))
> > > +    p = subprocess.Popen(args, stdout = subprocess.PIPE)
> > > +    for line in io.TextIOWrapper(p.stdout, encoding="utf-8"):
> > > +        yield line
> > > +
> > > +class find_developers(object):
> > > +    def __init__(self):
> > > +        tags = '%s|%s|%s|%s|%s|%s|%s|%s' % (
> > > +            'signed-off-by',
> > > +            'acked-by',
> > > +            'cc',
> > > +            'reviewed-by',
> > > +            'reported-by',
> > > +            'tested-by',
> > > +            'suggested-by',
> > > +            'reported-and-tested-by')
> > > +        # some tag, a colon, a space, and everything after that
> > > +        regex1 = r'^(%s):\s+(.+)$' % tags
> > > +
> > > +        self.r1 = re.compile(regex1, re.I)
> > > +
> > > +    def run(self, lines):
> > > +        addr_list = []
> > > +
> > > +        for line in lines:
> > > +            l = line.strip()
> > > +
> > > +            # emailutils can handle abominations like:
> > > +            #
> > > +            # Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
> > > +            # Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
> > > +            # Reviewed-by: bogus@simpson.com
> > > +            # Cc: <stable@vger.kernel.org> # v6.9
> > > +            # Tested-by: Moo Cow <foo@bar.com> # powerpc
> > > +            m = self.r1.match(l)
> > > +            if not m:
> > > +                continue
> > > +            (name, addr) = email.utils.parseaddr(m.expand(r'\g<2>'))
> > > +
> > > +            # This last split removes anything after a hash mark,
> > > +            # because someone could have provided an improperly
> > > +            # formatted email address:
> > > +            #
> > > +            # Cc: stable@vger.kernel.org # v6.19+
> > > +            #
> > > +            # emailutils doesn't seem to catch this, and I can't
> > > +            # fully tell from RFC2822 that this isn't allowed.  I
> > > +            # think it is because dtext doesn't forbid spaces or
> > > +            # hash marks.
> > > +            addr_list.append(addr.split('#')[0])
> > 
> > I think it's the case that the canonical stable cc tag format for kernel
> > patches as provided by the stable kernel process rules document:
> > 
> > Cc: <stable@vger.kernel.org> # vX.Y
> > 
> > is not actually actually rfc5322 compliant, so strings like that break
> > Python's emailutils parsers.  parseaddr() completely chokes on this, and
> > retuns name=='' and addr=='', because the only thing that can come after
> > the address portion are whitespace, EOL, or a comma followed by more
> > email addresses.  There's definitely not supposed to be an octothorpe
> > followed by even more text.
> > 
> > In the end I let myself be nerdsniped with even more string parsing bs,
> > and this loop body is the result:
> > 
> > 		l = line.strip()
> > 
> > 		# First, does this line match any of the headers we
> > 		# know about?
> > 		m = self.r1.match(l)
> > 		if not m:
> > 			continue
> > 
> > 		# The split removes everything after an octothorpe
> > 		# (hash mark), because someone could have provided an
> > 		# improperly formatted email address:
> > 		#
> > 		# Cc: stable@vger.kernel.org # v6.19+
> > 		#
> > 		# This, according to my reading of RFC5322, is allowed
> > 		# because octothorpes can be part of atom text.
> > 		# However, it is interepreted as if there weren't any
> > 		# whitespace ("stable@vger.kernel.org#v6.19+").  The
> > 		# grammar allows for this form, even though this is not
> > 		# a correct Internet domain name.
> > 		#
> > 		# Worse, if you follow the format specified in the
> > 		# kernel's SubmittingPatches file:
> > 		#
> > 		# Cc: <stable@vger.kernel.org> # v6.9
> > 		#
> > 		# emailutils will not know how to parse this, and
> > 		# returns empty strings.  I think this is because the
> > 		# angle-addr specification allows only whitespace
> > 		# between the closing angle bracket and the CRLF.
> > 		#
> > 		# Hack around both problems by ignoring everything
> > 		# after an octothorpe, no matter where it occurs in the
> > 		# string.  If someone has one in their name or the
> > 		# email address, too bad.
> > 		a = m.expand(r'\g<2>').split('#')[0]
> > 
> > 		# emailutils can extract email addresses from headers
> > 		# that roughly follow the destination address field
> > 		# format:
> > 		#
> > 		# Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
> > 		# Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
> > 		# Reviewed-by: bogus@simpson.com
> > 		# Tested-by: Moo Cow <foo@bar.com>
> > 		#
> > 		# Use it to extract the email address, because we don't
> > 		# care about the display name.
> > 		(name, addr) = email.utils.parseaddr(a)
> > 		addr_list.append(addr)
> > 
> > <shrug> but maybe we should try that on a few branches first before
> > committing to this string parsing mess ... ?  Not that this is any less
> > stupid than the previous version I shared out. :(
> 
> Can we just drop anything with 'stable@'? These are patches from
> libxfs syncs, do they have any value for stable@ list?
> 
> But the change is still make sense if anyone uses hash mark for
> something else, I will apply your change.
> 

Hmm, there's seems to be more cases to handle:

Cc: 1000974@bugs.debian.org, gustavoars@kernel.org, keescook@chromium.org
Reported-by: Xu, Wen <wen.xu@gatech.edu>

Both fail to parse, the first one as it need to be split and second
one due to comma

-- 
- Andrey

