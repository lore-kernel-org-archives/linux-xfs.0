Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 18:15:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2B1Es9F001444
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 18:14:56 -0700
Date: Tue, 11 Mar 2008 12:15:14 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: ADD 977766 - mkfs.xfs man page needs the default settings updated. [REVIEW TAKE 3]
Message-ID: <20080311011514.GE155407@sgi.com>
References: <incident_977766@bugworks.engr.sgi.com> <20080222003514.8D88E2C3@toolshop.engr.sgi.com> <nccskzlzg9f.fsf_-_@sgi.com> <nccablbf8ra.fsf_-_@sgi.com> <20080310060751.GY155407@sgi.com> <416c461f0803092315m7ae6f55ek9b64058c3793aaa7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <416c461f0803092315m7ae6f55ek9b64058c3793aaa7@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@cxhome.ath.cx>
Cc: David Chinner <dgc@sgi.com>, Niv Sardi <xaiki@sgi.com>, sgi.bugs.xfs@fido.engr.sgi.com, xfs-dev@sgi.com, xfs@oss.sgi.com

On Mon, Mar 10, 2008 at 05:15:04PM +1100, Niv Sardi wrote:
> On Mon, Mar 10, 2008 at 5:07 PM, David Chinner <dgc@sgi.com> wrote:
> >  Secondly, version one logs are not being kept around for backwards
> >  compatibility reasons. It's a valid, supported configuration, and in
> >  some cases performs better than version 2 logs....
> 
> Can you be more specific ?

More specific about which comment?

Re: performance - specSFS.

IIRC, anything that is effectively a synchronous transaction workload
tends to perform slightly better with v1 logs than v2 logs. It's
in the order of a few percent, but some ppl kill for that ;)

> the man page should document when this is
> better supported and I believe you're the one that has the best
> knowledge about that.
> 
> >  Realistically, I see no need for changing this text except to add that
> >  the default is version 2.
> 
> The change was motivated by Eric's comments on OSS that it is not
> clear why one should pick log v1 or v2, and I believe he is right.

If you don't understand - use the default. In most cases v2 logs are the
right thing to use and no amount of text in the man page is going to be
able to explain the corner cases where you'd want to use v1 logs....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
