Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3B0D57FA7
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 12:45:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 296C0304051
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 10:45:35 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [71.174.113.7]) by cuda.sgi.com
	with ESMTP id vG1GEfsYKKB8hEyD for <xfs@oss.sgi.com>;
	Fri, 12 Sep 2014 10:45:31 -0700 (PDT)
Date: Fri, 12 Sep 2014 13:45:39 -0400
From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Subject: Re: [RFC] Unicode/UTF-8 support for XFS
Message-ID: <20140912174538.GD978@meili>
References: <20140911203735.GA19952@sgi.com>
 <20140912100230.GB4267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140912100230.GB4267@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

On Fri, Sep 12, 2014 at 08:02:30PM +1000, Dave Chinner wrote:
> On Thu, Sep 11, 2014 at 03:37:35PM -0500, Ben Myers wrote:
...
> > When comparing unicode strings for equality, normalization comes into play:
> > we must compare the normalized forms of strings, not just the raw sequences
> > of bytes. There are a number of defined normalization forms for unicode.
> > We decided on a variant of NFKD we call NFKDI. NFD was chosed over NFC,
> > because calculating NFC requires calculating NFD first, followed by an
> > additional step. NFKD was chosen over NFD because this makes filenames
> > that ought to be equal compare as equal.
> 
> But are they really equal?
> 
> Choosing *compatibility* decomposition over *canonical*
> decomposition means that compound characters and formatting
> distinctions don't affect the hash. i.e. "of'fi'ce", "o'ffi'ce" and
> "office" all hash and compare as the same name, but then they get
> stored on disk unnormalised. So they are the "same" in memory, but
> very different on disk.
> 
> I note that the unicode spec says this for normalised forms
> (11.1):
> 
> "A normalized string is guaranteed to be stable; that is, once
> normalized, a string is normalized according to all future versions
> of Unicode."
> 
> So if we store normalised strings on disk, they are guaranteed to
> be compatible with all future versions of unicode and anything that
> goes to use them. So why wouldn't we store normalised forms on disk?

I've had a very similar discussion about normalization in ZFS.  Sadly, I
can't find where it happened so I can't point you to it.  One interesting
point that I remember is that storing the original form may be less
surprising to an application.  Specifically, the name it reads back is the
same it supplied during the creation.  (Granted, if the file already exists,
the application will read back the new form.)

Just FWIW.

Jeff.

-- 
Only two things are infinite, the universe and human stupidity, and I'm not
sure about the former.
		- Albert Einstein

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
