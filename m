Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 18:45:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2B1jSeI005781
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 18:45:32 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8B3DF5C581
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 18:45:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ZXkv4SBGRrgRFxx3 for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 18:45:59 -0700 (PDT)
Message-ID: <47D5E455.9090309@sandeen.net>
Date: Mon, 10 Mar 2008 20:45:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: ADD 977766 - mkfs.xfs man page needs the default settings updated.
 [REVIEW TAKE 3]
References: <incident_977766@bugworks.engr.sgi.com> <20080222003514.8D88E2C3@toolshop.engr.sgi.com> <nccskzlzg9f.fsf_-_@sgi.com> <nccablbf8ra.fsf_-_@sgi.com> <20080310060751.GY155407@sgi.com> <416c461f0803092315m7ae6f55ek9b64058c3793aaa7@mail.gmail.com> <20080311011514.GE155407@sgi.com>
In-Reply-To: <20080311011514.GE155407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Niv Sardi <xaiki@cxhome.ath.cx>, Niv Sardi <xaiki@sgi.com>, sgi.bugs.xfs@fido.engr.sgi.com, xfs-dev@sgi.com, xfs@oss.sgi.com

David Chinner wrote:

>> The change was motivated by Eric's comments on OSS that it is not
>> clear why one should pick log v1 or v2, and I believe he is right.
> 
> If you don't understand - use the default. In most cases v2 logs are the
> right thing to use and no amount of text in the man page is going to be
> able to explain the corner cases where you'd want to use v1 logs....

I think the only problem, Dave, is that there are maybe 2 people on the
face of this earth who DO understand ;)  (and I don't count myself among
them).

Just saying that v1 logs are still there for corner cases & specialized
workloads which may perform better is probably fine, don't you think?
That way those people who kill for such things can test both flavors.
Without that, people won't know if v1 is broken, deprecated, dangerous,
or what.

If you say nothing at all about the differences, then don't even bother
to document the log version option at all, IMHO.

-Eric
