Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 23:21:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2A6KxLf014393
	for <xfs@oss.sgi.com>; Sun, 9 Mar 2008 23:21:00 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15A7167A1B0
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2008 23:21:28 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.168]) by cuda.sgi.com with ESMTP id HHfr6ISTZXaqLIyt for <xfs@oss.sgi.com>; Sun, 09 Mar 2008 23:21:28 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 29so1745821wff.32
        for <xfs@oss.sgi.com>; Sun, 09 Mar 2008 23:21:27 -0700 (PDT)
Message-ID: <416c461f0803092315m7ae6f55ek9b64058c3793aaa7@mail.gmail.com>
Date: Mon, 10 Mar 2008 17:15:04 +1100
From: "Niv Sardi" <xaiki@cxhome.ath.cx>
Subject: Re: ADD 977766 - mkfs.xfs man page needs the default settings updated. [REVIEW TAKE 3]
In-Reply-To: <20080310060751.GY155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <incident_977766@bugworks.engr.sgi.com>
	 <20080222003514.8D88E2C3@toolshop.engr.sgi.com>
	 <nccskzlzg9f.fsf_-_@sgi.com> <nccablbf8ra.fsf_-_@sgi.com>
	 <20080310060751.GY155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Niv Sardi <xaiki@sgi.com>, sgi.bugs.xfs@fido.engr.sgi.com, xfs-dev@sgi.com, xfs@oss.sgi.com

On Mon, Mar 10, 2008 at 5:07 PM, David Chinner <dgc@sgi.com> wrote:
> On Fri, Mar 07, 2008 at 03:39:05PM +1100, Niv Sardi wrote:
>  > Incorporated Eric's changes, last call does it look good to everyone
>
>  > @@ -387,17 +399,13 @@ With some combinations of filesystem block size, inode size,
>  >  and directory block size, the minimum log size is larger than 512 blocks.
>  >  .TP
>  >  .BI version= value
>  > -This specifies the version of the log. The
>  > -.I value
>  > -is either 1 or 2. Specifying
>  > -.B version=2
>  > -enables the
>  > -.B sunit
>  > -suboption, and allows the logbsize to be increased beyond 32K.
>  > -Version 2 logs are automatically selected if a log stripe unit
>  > -is specified.  See
>  > -.BR sunit " and " su
>  > -suboptions, below.
>  > +This specifies the version of the log. The current default is 2,
>  > +which allows for larger log buffer sizes, as well as supporting
>  > +stripe-aligned log writes (see the sunit and su options, below).
>  > +.IP
>  > +The previous version 1, which is limited to 32k log buffers and does
>  > +not support stripe-aligned writes, is kept for backwards compatibility
>  > +with very old 2.4 kernels.

>  I don't like this change. You're removing specific references to the
>  commands needed to set sunit, or how to set the version number, and what
>  the default behaviour on stripe aligned filesystems are.

Right that should be added back.

>  Secondly, version one logs are not being kept around for backwards
>  compatibility reasons. It's a valid, supported configuration, and in
>  some cases performs better than version 2 logs....

Can you be more specific ? the man page should document when this is
better supported and I believe you're the one that has the best
knowledge about that.

>  Realistically, I see no need for changing this text except to add that
>  the default is version 2.

The change was motivated by Eric's comments on OSS that it is not
clear why one should pick log v1 or v2, and I believe he is right.

Cheers,
--
Niv Sardi
